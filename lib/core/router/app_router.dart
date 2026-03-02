import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/admin/presentation/screens/admin_dashboard_screen.dart';
import '../../features/admin/presentation/screens/admin_orders_screen.dart';
import '../../features/admin/presentation/screens/admin_products_screen.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/admin_login_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/cart/presentation/screens/cart_screen.dart';
import '../../features/catalog/presentation/screens/category_screen.dart';
import '../../features/catalog/presentation/screens/home_screen.dart';
import '../../features/catalog/presentation/screens/search_screen.dart';
import '../../features/checkout/presentation/screens/checkout_screen.dart';
import '../../features/checkout/presentation/screens/checkout_success_screen.dart';
import '../../features/checkout/presentation/screens/stripe_webview_screen.dart';
import '../../features/orders/presentation/screens/order_detail_screen.dart';
import '../../features/orders/presentation/screens/invoice_detail_screen.dart';
import '../../features/orders/presentation/screens/orders_screen.dart';
import '../../features/catalog/presentation/screens/products_list_screen.dart';
import '../../features/product_detail/presentation/screens/product_detail_screen.dart';
import '../../features/wishlist/presentation/screens/wishlist_screen.dart';
import '../../features/account/presentation/screens/account_screen.dart';
import '../../features/offers/presentation/screens/offers_screen.dart';
import '../../features/account/presentation/screens/addresses_screen.dart';
import '../../features/account/presentation/screens/edit_profile_screen.dart';
import '../shell/main_shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isAuthenticated = authState.status == AuthStatus.authenticated;
      final isAdmin = authState.user?.isAdmin ?? false;
      final path = state.uri.path;

      // Admin routes require authenticated admin
      if (path.startsWith('/admin')) {
        // Allow admin login page without authentication
        if (path == '/admin/login') return null;
        if (!isAuthenticated) return '/admin/login';
        if (!isAdmin) return '/';
        return null;
      }

      // Protected routes requiring authentication
      final protectedPaths = ['/pedidos', '/mi-cuenta', '/direcciones', '/editar-perfil'];
      if ((protectedPaths.contains(path) || path.startsWith('/factura/') || path.startsWith('/pedido/')) && !isAuthenticated) {
        return '/login';
      }

      // Already authenticated? Don't show login/register
      if (isAuthenticated && (path == '/login' || path == '/registro')) {
        return '/';
      }

      return null;
    },
    routes: [
      // Main shell with bottom navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeScreen(),
            ),
          ),
          GoRoute(
            path: '/busqueda',
            name: 'search',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SearchScreen(),
            ),
          ),
          GoRoute(
            path: '/carrito',
            name: 'cart',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: CartScreen(),
            ),
          ),
          GoRoute(
            path: '/favoritos',
            name: 'wishlist',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: WishlistScreen(),
            ),
          ),
          GoRoute(
            path: '/mi-cuenta',
            name: 'account',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: AccountScreen(),
            ),
          ),
        ],
      ),

      // Full-screen routes (no bottom nav)
      GoRoute(
        path: '/login',
        name: 'login',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/registro',
        name: 'register',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/recuperar-contrasena',
        name: 'forgotPassword',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/admin/login',
        name: 'adminLogin',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AdminLoginScreen(),
      ),
      GoRoute(
        path: '/ofertas',
        name: 'offers',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const OffersScreen(),
      ),
      GoRoute(
        path: '/productos',
        name: 'products',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => ProductsListScreen(
          brandSlug: state.uri.queryParameters['brand'],
          categorySlug: state.uri.queryParameters['category'],
        ),
      ),
      GoRoute(
        path: '/categoria/:slug',
        name: 'category',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => CategoryScreen(
          categorySlug: state.pathParameters['slug']!,
          categoryName: state.uri.queryParameters['name'] ?? '',
        ),
      ),
      GoRoute(
        path: '/producto/:slug',
        name: 'product',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => ProductDetailScreen(
          productSlug: state.pathParameters['slug']!,
        ),
      ),
      GoRoute(
        path: '/checkout',
        name: 'checkout',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CheckoutScreen(),
        routes: [
          GoRoute(
            path: 'stripe',
            name: 'checkoutStripe',
            builder: (context, state) {
              final checkoutUrl = state.uri.queryParameters['url'] ?? '';
              final successUrl = state.uri.queryParameters['success'] ?? '';
              final cancelUrl = state.uri.queryParameters['cancel'] ?? '';
              
              return StripeWebViewScreen(
                checkoutUrl: checkoutUrl,
                successUrl: successUrl,
                cancelUrl: cancelUrl,
              );
            },
          ),
          GoRoute(
            path: 'success',
            name: 'checkoutSuccess',
            builder: (context, state) => const CheckoutSuccessScreen(),
          ),
          GoRoute(
            path: 'cancel',
            name: 'checkoutCancel',
            builder: (context, state) => Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: const Text('Pago cancelado'),
                backgroundColor: Colors.white,
              ),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cancel_outlined,
                        size: 80,
                        color: Colors.orange.shade700,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Pago cancelado',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Tu pago ha sido cancelado. Puedes intentarlo de nuevo cuando quieras.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: FilledButton(
                          onPressed: () {
                            // Navigate to checkout to try again
                            // Use context from builder
                            Navigator.of(context).pop();
                          },
                          child: const Text('VOLVER AL CHECKOUT'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/pedidos',
        name: 'orders',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const OrdersScreen(),
      ),
      GoRoute(
        path: '/pedido/:id',
        name: 'orderDetail',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => OrderDetailScreen(
          orderId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/factura/:id',
        name: 'invoiceDetail',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => InvoiceDetailScreen(
          invoiceId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/direcciones',
        name: 'addresses',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AddressesScreen(),
      ),
      GoRoute(
        path: '/editar-perfil',
        name: 'editProfile',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const EditProfileScreen(),
      ),

      // Admin routes
      GoRoute(
        path: '/admin',
        name: 'admin',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AdminDashboardScreen(),
        routes: [
          GoRoute(
            path: 'pedidos',
            name: 'adminOrders',
            builder: (context, state) => const AdminOrdersScreen(),
          ),
          GoRoute(
            path: 'productos',
            name: 'adminProducts',
            builder: (context, state) => const AdminProductsScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Página no encontrada')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('Página no encontrada'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.go('/'),
              child: const Text('Volver al inicio'),
            ),
          ],
        ),
      ),
    ),
  );
});
