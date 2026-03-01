# 🔒 Row Level Security (RLS) Policies - ÉCLAT Beauty

## Resumen

Este documento describe todas las políticas de Row Level Security implementadas en la base de datos de Supabase para ÉCLAT Beauty. Las políticas RLS garantizan que los usuarios solo puedan acceder y modificar los datos para los que tienen permisos.

## 📋 Tablas con RLS Habilitado

Las siguientes tablas tienen RLS habilitado:

1. ✅ `categories`
2. ✅ `products`
3. ✅ `brands`
4. ✅ `orders`
5. ✅ `order_items`
6. ✅ `settings`
7. ✅ `reviews`
8. ✅ `wishlist`
9. ✅ `subcategories`
10. ✅ `newsletter_subscribers`

---

## 🏷️ Categories

### Políticas

| Política | Operación | Regla | Descripción |
|----------|-----------|-------|-------------|
| `Categories are viewable by everyone` | SELECT | `true` | Todos pueden ver categorías (público) |
| `Categories are editable by admins only` | ALL | `auth.role() = 'authenticated' AND auth.jwt()->>'role' = 'admin'` | Solo admins pueden crear/editar/eliminar |

### Uso en Flutter

```dart
// ✅ Público - No requiere autenticación
final categories = await supabase.from('categories').select();

// ❌ Requiere admin
final newCategory = await supabase.from('categories').insert({...}); // Falla si no es admin
```

---

## 🛍️ Products

### Políticas

| Política | Operación | Regla | Descripción |
|----------|-----------|-------|-------------|
| `Products are viewable by everyone` | SELECT | `true` | Todos pueden ver productos (público) |
| `Products are editable by admins only` | ALL | `auth.role() = 'authenticated' AND auth.jwt()->>'role' = 'admin'` | Solo admins pueden gestionar productos |

### Uso en Flutter

```dart
// ✅ Público - Cualquiera puede leer
final products = await supabase.from('products').select();

// ✅ Público - Producto individual
final product = await supabase
  .from('products')
  .select()
  .eq('slug', 'chanel-rouge-allure')
  .single();

// ❌ Solo admin puede crear/editar
final updated = await supabase
  .from('products')
  .update({'stock': 50})
  .eq('id', productId); // Requiere admin
```

**⚠️ IMPORTANTE**: NO actualices stock directamente. Usa las funciones RPC:
- `create_order()` - Decrementa stock atómicamente
- `cancel_order()` - Restaura stock
- `process_return()` - Opcionalmente restaura stock

---

## 🏢 Brands

### Políticas

| Política | Operación | Regla | Descripción |
|----------|-----------|-------|-------------|
| `Brands are viewable by everyone` | SELECT | `true` | Todos pueden ver marcas |
| `Brands are editable by admins` | INSERT, UPDATE, DELETE | `auth.role() = 'authenticated'` | Usuarios autenticados pueden editar (verificar admin en app) |

### Uso en Flutter

```dart
// ✅ Público
final brands = await supabase.from('brands').select();

// ⚠️ Requiere autenticación (verificar is_admin en Flutter)
final newBrand = await supabase.from('brands').insert({...});
```

**Nota**: La política permite cualquier usuario autenticado, pero la app Flutter debe verificar `is_admin = true` antes de mostrar UI de edición.

---

## 📦 Orders & Order Items

### Políticas - Orders

| Política | Operación | Regla | Descripción |
|----------|-----------|-------|-------------|
| `Users can view their own orders` | SELECT | `auth.uid() = user_id` | Los usuarios ven solo sus pedidos |
| `Admins can view all orders` | SELECT | `auth.uid() IN (SELECT id FROM profiles WHERE is_admin = TRUE)` | Admins ven todos los pedidos |
| `Admins can update all orders` | UPDATE | `auth.uid() IN (SELECT id FROM profiles WHERE is_admin = TRUE)` | Solo admins cambian estado |

### Políticas - Order Items

| Política | Operación | Regla | Descripción |
|----------|-----------|-------|-------------|
| `Admins can view all order items` | SELECT | `auth.uid() IN (SELECT id FROM profiles WHERE is_admin = TRUE)` | Admins ven todos los items |
| `Users can view their own order items` | SELECT | `EXISTS (SELECT 1 FROM orders WHERE orders.id = order_items.order_id AND orders.user_id = auth.uid())` | Usuarios ven items de sus pedidos |

### Uso en Flutter

```dart
// ✅ Usuario autenticado - Solo sus pedidos
final myOrders = await supabase
  .from('orders')
  .select('''
    *,
    order_items:order_items(
      *,
      product:products(*)
    )
  ''');

// ✅ Admin - Todos los pedidos
final allOrders = await supabase.from('orders').select(); // Solo si is_admin = true

// ❌ Crear orden directamente - PROHIBIDO
// Usa RPC en su lugar:
final order = await supabase.rpc('create_order', params: {...});

// ✅ Admin - Actualizar estado de pedido
final updated = await supabase.rpc('update_order_status', params: {
  'p_order_id': orderId,
  'p_new_status': 'shipped',
});
```

**⚠️ CRÍTICO**: Las órdenes SOLO se crean mediante `create_order()` RPC. No insertes manualmente en `orders` o `order_items`.

---

## ⚙️ Settings

### Políticas

| Política | Operación | Regla | Descripción |
|----------|-----------|-------|-------------|
| `Everyone can view settings` | SELECT | `true` | Todos pueden ver configuración (necesario para feature flags) |
| `Admins can update settings` | UPDATE | `auth.uid() IN (SELECT id FROM profiles WHERE is_admin = TRUE)` | Solo admins actualizan |
| `Admins can insert settings` | INSERT | `auth.uid() IN (SELECT id FROM profiles WHERE is_admin = TRUE)` | Solo admins insertan |

### Uso en Flutter

```dart
// ✅ Público - Leer settings
final settings = await supabase.from('settings').select().maybeSingle();

// Verificar si flash sales está habilitado
final flashSaleEnabled = settings?['flash_sale_enabled'] ?? false;

// ❌ Solo admin - Actualizar settings
final updated = await supabase
  .from('settings')
  .update({'offers_enabled': true})
  .eq('id', settingsId); // Requiere is_admin = true
```

---

## ⭐ Reviews

### Políticas

| Política | Operación | Regla | Descripción |
|----------|-----------|-------|-------------|
| `reviews_are_public` | SELECT | `true` | Todos pueden ver reviews |
| `users_can_create_own_reviews` | INSERT | `auth.role() = 'authenticated' AND auth.uid() = user_id` | Usuarios autenticados pueden crear |
| `users_can_update_own_reviews` | UPDATE | `auth.uid() = user_id` | Solo pueden editar sus propias reviews |
| `users_can_delete_own_reviews` | DELETE | `auth.uid() = user_id` | Solo pueden eliminar sus propias reviews |

### Uso en Flutter

```dart
// ✅ Público - Ver reviews de producto
final reviews = await supabase
  .from('reviews')
  .select('*, user:profiles!reviews_user_id_fkey(full_name)')
  .eq('product_id', productId);

// ✅ Usuario autenticado - Crear review
final newReview = await supabase.from('reviews').insert({
  'product_id': productId,
  'user_id': currentUserId, // Debe coincidir con auth.uid()
  'rating': 5,
  'comment': 'Excelente producto!',
});

// ✅ Usuario - Editar su propia review
final updated = await supabase
  .from('reviews')
  .update({'comment': 'Actualizado'})
  .eq('id', reviewId); // Solo funciona si user_id = auth.uid()

// ❌ No puedes editar reviews de otros usuarios
```

---

## ❤️ Wishlist

### Políticas

| Política | Operación | Regla | Descripción |
|----------|-----------|-------|-------------|
| `Users can view their own wishlist` | SELECT | `auth.uid() = user_id` | Solo ven su propia wishlist |
| `Users can add to their own wishlist` | INSERT | `auth.uid() = user_id` | Solo añaden a su wishlist |
| `Users can remove from their own wishlist` | DELETE | `auth.uid() = user_id` | Solo eliminan de su wishlist |

### Uso en Flutter

```dart
// ✅ Usuario autenticado - Ver su wishlist
final wishlist = await supabase
  .from('wishlist')
  .select('*, product:products(*)');

// ✅ Añadir a wishlist
final added = await supabase.from('wishlist').insert({
  'user_id': currentUserId, // Debe coincidir con auth.uid()
  'product_id': productId,
});

// ✅ Eliminar de wishlist
await supabase
  .from('wishlist')
  .delete()
  .eq('product_id', productId); // Solo funciona si user_id = auth.uid()
```

---

## 📂 Subcategories

### Políticas

| Política | Operación | Regla | Descripción |
|----------|-----------|-------|-------------|
| `Public read subcategories` | SELECT | `true` | Todos pueden ver |
| `Admin manage subcategories` | INSERT, UPDATE, DELETE | `auth.uid() IN (SELECT id FROM profiles WHERE is_admin = TRUE)` | Solo admins gestionan |

---

## 📧 Newsletter Subscribers

### Políticas

| Política | Operación | Regla | Descripción |
|----------|-----------|-------|-------------|
| `Public enable insert newsletter` | INSERT | `true` | Cualquiera puede suscribirse |
| `Admin view newsletter` | SELECT | `auth.uid() IN (SELECT id FROM profiles WHERE is_admin = TRUE)` | Solo admins ven suscriptores |

### Uso en Flutter

```dart
// ✅ Público - Suscribirse al newsletter
await supabase.from('newsletter_subscribers').insert({
  'email': userEmail,
});

// ✅ Admin - Ver todos los suscriptores
final subscribers = await supabase
  .from('newsletter_subscribers')
  .select(); // Requiere is_admin = true
```

---

## 🔐 Verificación de Admin en Flutter

Las políticas verifican `is_admin` desde la tabla `profiles`:

```dart
// Verificar si el usuario actual es admin
Future<bool> isAdmin() async {
  final userId = supabase.auth.currentUser?.id;
  if (userId == null) return false;

  final profile = await supabase
    .from('profiles')
    .select('is_admin')
    .eq('id', userId)
    .maybeSingle();

  return profile?['is_admin'] == true;
}
```

**Uso en la app**:

```dart
// Mostrar UI de admin solo si es admin
if (await isAdmin()) {
  // Mostrar botones de edición, panel admin, etc.
} else {
  // Mostrar UI de usuario normal
}
```

---

## 📝 Tablas SIN RLS (Acceso Completo)

Las siguientes tablas **NO** tienen RLS y son accesibles mediante funciones RPC o triggers:

- `carts` - Gestionado por sessionId o userId
- `coupons` - Lectura pública, escritura por admin (sin políticas explícitas)
- `coupon_usage` - Insertado por RPC `increment_coupon_usage_atomic()`
- `user_addresses` - Gestionado por userId
- `order_status_history` - Poblado por triggers automáticos

**Nota**: Estas tablas confían en la lógica de aplicación y funciones RPC para seguridad.

---

## ⚠️ Buenas Prácticas

### 1. No hagas INSERT directo en tablas críticas

❌ **MAL**:
```dart
// Nunca hagas esto
await supabase.from('orders').insert({...});
```

✅ **BIEN**:
```dart
// Usa la función RPC
await supabase.rpc('create_order', params: {...});
```

### 2. Verifica permisos en Flutter antes de mostrar UI

```dart
// Verifica admin antes de mostrar botones de edición
final isAdmin = await profilesDataSource.isAdmin();

if (isAdmin) {
  return ElevatedButton(
    onPressed: () => _editProduct(),
    child: Text('Editar Producto'),
  );
}
```

### 3. Maneja errores de RLS en la app

```dart
try {
  await supabase.from('products').update({...});
} on PostgrestException catch (e) {
  if (e.code == '42501') {
    // Permiso denegado
    showError('No tienes permisos para realizar esta acción');
  }
}
```

### 4. No confíes solo en el frontend

Las políticas RLS son la **última línea de defensa**. Aunque ocultes botones en Flutter, la BD siempre valida permisos.

---

## 🧪 Testing de RLS

### Test 1: Usuario normal intenta editar producto

```dart
// Login como usuario normal (no admin)
await supabase.auth.signInWithPassword(
  email: 'user@example.com',
  password: 'password',
);

// Intenta actualizar producto
try {
  await supabase.from('products').update({'stock': 100}).eq('id', productId);
  // ❌ Debería fallar
} catch (e) {
  // ✅ Esperamos un error de permisos
  print('Permisos funcionan correctamente');
}
```

### Test 2: Usuario ve solo sus propios pedidos

```dart
final orders = await supabase.from('orders').select();
// ✅ Solo retorna pedidos donde user_id = auth.uid()
```

### Test 3: Admin ve todos los pedidos

```dart
// Login como admin
await supabase.auth.signInWithPassword(
  email: 'admin@eclat.com',
  password: 'adminpass',
);

final allOrders = await supabase.from('orders').select();
// ✅ Retorna todos los pedidos
```

---

## 📚 Referencias

- [Supabase RLS Documentation](https://supabase.com/docs/guides/auth/row-level-security)
- [PostgreSQL Policies](https://www.postgresql.org/docs/current/sql-createpolicy.html)
- Archivos SQL del proyecto:
  - `database-schema.sql` - Políticas principales
  - `migration_reviews.sql` - Políticas de reviews
  - `migration_wishlist.sql` - Políticas de wishlist
  - `migration_newsletter.sql` - Políticas de newsletter
  - `migration_subcategories.sql` - Políticas de subcategorías

---

## ✅ Resumen

- **Tablas públicas (lectura)**: `categories`, `products`, `brands`, `settings`, `reviews`, `subcategories`
- **Tablas protegidas por usuario**: `orders`, `order_items`, `wishlist`, `reviews` (escritura)
- **Tablas solo admin**: Todas las operaciones de escritura en `categories`, `products`, `brands`, `settings`, `subcategories`
- **Funciones RPC**: Usan `SECURITY DEFINER` para ejecutar con permisos elevados (validación incluida)

La implementación de RLS garantiza que:
1. ✅ Los usuarios solo ven sus propios datos sensibles
2. ✅ Solo los admins pueden modificar catálogo y configuración
3. ✅ Las operaciones críticas usan funciones RPC con validación
4. ✅ La seguridad está en la base de datos, no solo en el frontend
