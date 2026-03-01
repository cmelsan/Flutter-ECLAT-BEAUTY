import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_utils.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/admin_provider.dart';

import 'admin_orders_screen.dart';
import 'admin_products_screen.dart';
import 'admin_coupons_screen.dart';
import 'admin_returns_screen.dart';
import 'admin_flash_sales_screen.dart';
import '../../../offers/presentation/screens/admin_offers_screen.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(adminDashboardProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel Admin'),
      ),
      body: statsAsync.when(
        data: (stats) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats grid
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.5,
                children: [
                  _StatCard(
                    icon: Icons.receipt_long,
                    label: 'Pedidos',
                    value: '${stats['totalOrders'] ?? 0}',
                    color: AppColors.statusPaid,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AdminOrdersScreen()),
                    ),
                  ),
                  _StatCard(
                    icon: Icons.pending_actions,
                    label: 'Pendientes',
                    value: '${stats['pendingOrders'] ?? 0}',
                    color: AppColors.statusPending,
                    onTap: () {
                      // Set filter to Paid for "pending to ship" or similar logic
                      // For now just open orders screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AdminOrdersScreen()),
                      );
                    },
                  ),
                  _StatCard(
                    icon: Icons.inventory_2,
                    label: 'Productos',
                    value: '${stats['totalProducts'] ?? 0}',
                    color: AppColors.primary,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AdminProductsScreen()),
                    ),
                  ),
                  _StatCard(
                    icon: Icons.euro,
                    label: 'Ingresos',
                    value: AppUtils.formatPrice(
                      stats['totalRevenue'] as int? ?? 0,
                    ),
                    color: AppColors.success,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Quick actions
              Text(
                'Gestión',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),

              _AdminMenuItem(
                icon: Icons.receipt_long_outlined,
                title: 'Pedidos',
                subtitle: 'Ver y gestionar pedidos',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const AdminOrdersScreen()),
                  );
                },
              ),
              _AdminMenuItem(
                icon: Icons.inventory_2_outlined,
                title: 'Productos',
                subtitle: 'Añadir, editar y eliminar',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const AdminProductsScreen()),
                  );
                },
              ),
              _AdminMenuItem(
                icon: Icons.local_offer_outlined,
                title: 'Cupones',
                subtitle: 'Gestionar descuentos',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const AdminCouponsScreen()),
                  );
                },
              ),
              _AdminMenuItem(
                icon: Icons.assignment_return_outlined,
                title: 'Devoluciones',
                subtitle: 'Solicitudes de devolución',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const AdminReturnsScreen()),
                  );
                },
              ),
              _AdminMenuItem(
                icon: Icons.flash_on_outlined,
                title: 'Ofertas Flash',
                subtitle: 'Descuentos temporales',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const AdminFlashSalesScreen()),
                  );
                },
              ),
              _AdminMenuItem(
                icon: Icons.local_offer_outlined,
                title: 'Rebajas',
                subtitle: 'Ofertas destacadas',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const AdminOffersScreen()),
                  );
                },
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final VoidCallback? onTap;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 24),
              const Spacer(),
              Text(
                value,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdminMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _AdminMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias, // Ensures ink splash is clipped to card
      margin: const EdgeInsets.only(bottom: 12), // Slightly more spacing
      child: Padding(
        padding: const EdgeInsets.all(4.0), // Padding for the visual touch area
        child: ListTile(
          onTap: onTap,
          leading: CircleAvatar(
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            child: Icon(icon, color: AppColors.primary),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(subtitle),
          trailing: const Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}
