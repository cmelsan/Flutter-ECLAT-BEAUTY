-- ============================================================
-- FIX: Pedidos admin + descuento de stock tras compra
-- Ejecutar en Supabase → SQL Editor
-- ============================================================

-- ============================================================
-- 1. FIX: decrease_product_stock_atomic → SECURITY DEFINER
--    Sin esto, la RLS de products bloquea el UPDATE cuando
--    un cliente (no admin) llama a esta función tras pagar.
-- ============================================================
CREATE OR REPLACE FUNCTION decrease_product_stock_atomic(
  p_product_id UUID,
  p_quantity INT
) RETURNS jsonb AS $$
DECLARE
  v_product RECORD;
  v_new_stock INT;
BEGIN
  SELECT id, stock, name
  INTO v_product
  FROM products
  WHERE id = p_product_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RETURN jsonb_build_object('success', false, 'error', 'Product not found', 'product_id', p_product_id);
  END IF;

  IF p_quantity <= 0 THEN
    RETURN jsonb_build_object('success', false, 'error', 'Invalid quantity', 'quantity', p_quantity);
  END IF;

  IF v_product.stock < p_quantity THEN
    RETURN jsonb_build_object(
      'success', false,
      'error', 'Insufficient stock',
      'product_name', v_product.name,
      'available', v_product.stock,
      'requested', p_quantity
    );
  END IF;

  v_new_stock := v_product.stock - p_quantity;

  UPDATE products
  SET stock = v_new_stock,
      updated_at = NOW()
  WHERE id = p_product_id;

  RETURN jsonb_build_object(
    'success', true,
    'product_id', p_product_id,
    'product_name', v_product.name,
    'new_stock', v_new_stock,
    'quantity_deducted', p_quantity
  );
END;
$$ LANGUAGE plpgsql
SECURITY DEFINER            -- ← clave: bypass RLS, corre con permisos del owner
SET search_path = public;

GRANT EXECUTE ON FUNCTION decrease_product_stock_atomic(UUID, INT) TO authenticated;
GRANT EXECUTE ON FUNCTION decrease_product_stock_atomic(UUID, INT) TO anon;


-- ============================================================
-- 2. FIX: orders RLS — admin ve todos los pedidos
--    La política anterior solo mostraba user_id = auth.uid().
--    Ahora el admin también puede ver todos.
-- ============================================================
ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "orders_select_own" ON public.orders;
CREATE POLICY "orders_select_own"
  ON public.orders FOR SELECT
  TO authenticated
  USING (
    user_id = auth.uid()
    OR EXISTS (
      SELECT 1 FROM public.profiles
      WHERE id = auth.uid() AND is_admin = true
    )
  );

-- Admin puede actualizar cualquier pedido
DROP POLICY IF EXISTS "orders_update_admin" ON public.orders;
CREATE POLICY "orders_update_admin"
  ON public.orders FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles
      WHERE id = auth.uid() AND is_admin = true
    )
  );


-- ============================================================
-- 3. FIX: order_items RLS — admin ve todos los items
-- ============================================================
ALTER TABLE public.order_items ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "order_items_select_own" ON public.order_items;
CREATE POLICY "order_items_select_own"
  ON public.order_items FOR SELECT
  TO authenticated
  USING (
    order_id IN (
      SELECT id FROM public.orders WHERE user_id = auth.uid()
    )
    OR EXISTS (
      SELECT 1 FROM public.profiles
      WHERE id = auth.uid() AND is_admin = true
    )
  );


-- ============================================================
-- 4. Verificar los cambios
-- ============================================================
-- Ver políticas activas:
SELECT tablename, policyname, cmd, qual
FROM pg_policies
WHERE tablename IN ('orders', 'order_items', 'products')
ORDER BY tablename, cmd;

-- Ver si decrease_product_stock_atomic es SECURITY DEFINER:
SELECT proname, prosecdef
FROM pg_proc
WHERE proname = 'decrease_product_stock_atomic';
-- prosecdef = true → correcto ✓
