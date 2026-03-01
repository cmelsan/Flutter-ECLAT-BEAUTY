import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    if (!auth.isAuthenticated) {
      return Scaffold(
        appBar: AppBar(title: const Text('Mi Cuenta')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.person_outline, size: 64, color: AppColors.textTertiary),
              const SizedBox(height: 16),
              const Text('Inicia sesión para ver tu cuenta'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  context.push('/login');
                },
                child: const Text('INICIAR SESIÓN'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Mi Cuenta')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // User info
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    child: Text(
                      (auth.user?.displayName != null && auth.user!.displayName!.trim().isNotEmpty) 
                          ? auth.user!.displayName!.trim()[0].toUpperCase() 
                          : 'U',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          auth.user?.displayName ?? '',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          auth.user?.email ?? '',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Menu items
          _MenuTile(
            icon: Icons.receipt_long_outlined,
            title: 'Mis Pedidos',
            onTap: () {
              context.push('/pedidos');
            },
          ),
          _MenuTile(
            icon: Icons.favorite_border,
            title: 'Favoritos',
            onTap: () {
              context.go('/favoritos');
            },
          ),
          _MenuTile(
            icon: Icons.location_on_outlined,
            title: 'Direcciones',
            onTap: () {
              context.push('/direcciones');
            },
          ),
          _MenuTile(
            icon: Icons.person_outline,
            title: 'Editar perfil',
            onTap: () {
              context.push('/editar-perfil');
            },
          ),

          // Admin panel (only for admin users)
          if (auth.isAdmin) ...[
            const Divider(height: 32),
            _MenuTile(
              icon: Icons.admin_panel_settings_outlined,
              title: 'Panel de Administración',
              subtitle: 'Gestionar pedidos, productos y más',
              onTap: () {
                context.push('/admin');
              },
              iconColor: AppColors.primary,
            ),
          ],

          const Divider(height: 32),

          // Sign out
          _MenuTile(
            icon: Icons.logout,
            title: 'Cerrar sesión',
            iconColor: AppColors.error,
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('¿Cerrar sesión?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Cancelar'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Cerrar sesión'),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                ref.read(authProvider.notifier).signOut();
              }
            },
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Color? iconColor;

  const _MenuTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? AppColors.textSecondary),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: const Icon(Icons.chevron_right, color: AppColors.textTertiary),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
