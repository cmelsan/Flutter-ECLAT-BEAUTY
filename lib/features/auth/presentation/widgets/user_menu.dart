import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/auth_provider.dart';

class UserMenu extends ConsumerWidget {
  const UserMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    // If not authenticated, show login button
    if (!authState.isAuthenticated || user == null) {
      return IconButton(
        icon: const Icon(Icons.person_outline),
        onPressed: () => Navigator.of(context).pushNamed('/login'),
        tooltip: 'Iniciar sesión',
      );
    }

    // If authenticated, show menu
    return PopupMenuButton<String>(
      onSelected: (value) => _handleMenuSelection(context, ref, value),
      icon: CircleAvatar(
        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
        child: user.avatarUrl != null && user.avatarUrl!.isNotEmpty
            ? ClipOval(
                child: Image.network(
                  user.avatarUrl!,
                  fit: BoxFit.cover,
                  width: 40,
                  height: 40,
                  errorBuilder: (_, _, _) => _buildDefaultAvatar(user.displayName),
                ),
              )
            : _buildDefaultAvatar(user.displayName),
      ),
      tooltip: 'Mi cuenta',
      itemBuilder: (context) => [
        // User info header
        PopupMenuItem<String>(
          enabled: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.displayName,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user.email,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              if (user.isAdmin) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'ADMINISTRADOR',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
              const Divider(height: 16),
            ],
          ),
        ),

        // Admin panel (only for admins)
        if (user.isAdmin)
          const PopupMenuItem<String>(
            value: 'admin',
            child: Row(
              children: [
                Icon(Icons.admin_panel_settings, size: 20),
                SizedBox(width: 12),
                Text('Panel de Administración'),
              ],
            ),
          ),

        // My account
        const PopupMenuItem<String>(
          value: 'account',
          child: Row(
            children: [
              Icon(Icons.person_outline, size: 20),
              SizedBox(width: 12),
              Text('Mi Cuenta'),
            ],
          ),
        ),

        // My orders
        const PopupMenuItem<String>(
          value: 'orders',
          child: Row(
            children: [
              Icon(Icons.shopping_bag_outlined, size: 20),
              SizedBox(width: 12),
              Text('Mis Pedidos'),
            ],
          ),
        ),

        // Wishlist
        const PopupMenuItem<String>(
          value: 'wishlist',
          child: Row(
            children: [
              Icon(Icons.favorite_border, size: 20),
              SizedBox(width: 12),
              Text('Lista de Deseos'),
            ],
          ),
        ),

        // Addresses
        const PopupMenuItem<String>(
          value: 'addresses',
          child: Row(
            children: [
              Icon(Icons.location_on_outlined, size: 20),
              SizedBox(width: 12),
              Text('Mis Direcciones'),
            ],
          ),
        ),

        const PopupMenuDivider(),

        // Logout
        const PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout, size: 20, color: Colors.red),
              SizedBox(width: 12),
              Text(
                'Cerrar Sesión',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultAvatar(String name) {
    return Text(
      name.isNotEmpty ? name[0].toUpperCase() : '?',
      style: const TextStyle(
        color: AppColors.primary,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }

  void _handleMenuSelection(BuildContext context, WidgetRef ref, String value) {
    switch (value) {
      case 'admin':
        Navigator.of(context).pushNamed('/admin');
        break;
      case 'account':
        Navigator.of(context).pushNamed('/mi-cuenta');
        break;
      case 'orders':
        Navigator.of(context).pushNamed('/pedidos');
        break;
      case 'wishlist':
        Navigator.of(context).pushNamed('/favoritos');
        break;
      case 'addresses':
        Navigator.of(context).pushNamed('/direcciones');
        break;
      case 'logout':
        _showLogoutDialog(context, ref);
        break;
    }
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await ref.read(authProvider.notifier).signOut();
              if (context.mounted) {
                Navigator.of(context).pushReplacementNamed('/');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }
}
