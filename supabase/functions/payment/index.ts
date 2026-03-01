
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.21.0"
import Stripe from "https://esm.sh/stripe@12.0.0?target=deno"

const stripe = new Stripe(Deno.env.get('STRIPE_SECRET_KEY') ?? '', {
  apiVersion: '2022-11-15',
  httpClient: Stripe.createFetchHttpClient(),
})

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const supabaseClient = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_ANON_KEY') ?? '',
      { global: { headers: { Authorization: req.headers.get('Authorization')! } } }
    )

    // Create a Supabase client with the SERVICE_ROLE key to access private tables if needed (like reading secure product data)
    // However, the original code uses the client context. Here we use service role for backend logic to ensure RLS doesn't block reading ALL products.
    const supabaseAdmin = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    )

    const { items, orderId, email, discountAmount, couponId } = await req.json()

    if (!items || !orderId) {
        throw new Error('Missing required parameters')
    }

    // validate orderId format
    const UUID_REGEX = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
    if (!UUID_REGEX.test(orderId)) {
         throw new Error('Invalid orderId')
    }

    // 1. Fetch products to validate prices
    const productIds = items.map((item: any) => item.product.id);
    const { data: dbProducts, error: productsError } = await supabaseAdmin
        .from('products')
        .select('id, name, price, stock, images, is_flash_sale, flash_sale_discount, flash_sale_end_time')
        .in('id', productIds);

    if (productsError || !dbProducts) {
        throw new Error('Failed to validate products: ' + productsError?.message);
    }

    // 2. Fetch featured offers
    const { data: offersData } = await supabaseAdmin
        .from('app_settings')
        .select('value')
        .eq('key', 'featured_offers')
        .single();
    
    const featuredOffersMap: Record<string, number> = {};
    if (offersData?.value && Array.isArray(offersData.value)) {
        for (const offer of offersData.value) {
            if (offer.id && offer.discount > 0) {
                featuredOffersMap[offer.id] = offer.discount;
            }
        }
    }

    // 3. Calculate line items total
    let calculatedSubtotal = 0;
    
    // Check stock and calculate price per item
    for (const item of items) {
        const dbProduct = dbProducts.find(p => p.id === item.product.id);
        if (!dbProduct) throw new Error(`Product not found: ${item.product.id}`);

        if (item.quantity > dbProduct.stock) {
             throw new Error(`Insufficient stock for ${dbProduct.name}. Available: ${dbProduct.stock}`);
        }

        const now = new Date();
        const isFlashSaleActive =
            dbProduct.is_flash_sale &&
            dbProduct.flash_sale_discount > 0 &&
            (!dbProduct.flash_sale_end_time || new Date(dbProduct.flash_sale_end_time) > now);

        const flashSalePrice = isFlashSaleActive
            ? Math.round(dbProduct.price * (1 - dbProduct.flash_sale_discount / 100))
            : dbProduct.price;

        const featuredDiscount = featuredOffersMap[dbProduct.id] || 0;
        const featuredOfferPrice = featuredDiscount > 0
            ? Math.round(dbProduct.price * (1 - featuredDiscount / 100))
            : dbProduct.price;

        // Lowest price wins
        const unitAmount = Math.min(flashSalePrice, featuredOfferPrice);
        
        calculatedSubtotal += unitAmount * item.quantity;
    }

    // 4. Apply Discount
    // Ensure discount amount doesn't exceed subtotal
    const validDiscountAmount = discountAmount && discountAmount > 0
        ? Math.min(Math.round(discountAmount), calculatedSubtotal)
        : 0;

    const finalAmount = Math.max(0, calculatedSubtotal - validDiscountAmount);

    // 5. Create PaymentIntent
    // Note: Stripe requires minimum amount for some currencies (e.g. 50 cents). 
    // Here assuming basic validation passes or Stripe will throw error. 
    
    // Get distinct customer from Stripe if possible, or create new.
    // Ideally we search by email.
    let customerId;
    const existingCustomers = await stripe.customers.list({ email: email, limit: 1 });
    if (existingCustomers.data.length > 0) {
        customerId = existingCustomers.data[0].id;
    } else {
        const newCustomer = await stripe.customers.create({ email: email });
        customerId = newCustomer.id;
    }

    const ephemeralKey = await stripe.ephemeralKeys.create(
      { customer: customerId },
      { apiVersion: '2022-11-15' }
    );

    const paymentIntent = await stripe.paymentIntents.create({
      amount: finalAmount,
      currency: 'eur',
      customer: customerId,
      automatic_payment_methods: {
        enabled: true,
      },
      metadata: {
        orderId: orderId,
        couponId: couponId ?? '',
        discountAmount: validDiscountAmount,
      }
    })

    return new Response(
      JSON.stringify({
        paymentIntent: paymentIntent.client_secret,
        ephemeralKey: ephemeralKey.secret,
        customer: customerId,
        publishableKey: Deno.env.get('STRIPE_PUBLISHABLE_KEY') ?? '',
        amount: finalAmount
      }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } },
    )
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 400,
    })
  }
})
