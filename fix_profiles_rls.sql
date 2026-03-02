-- ============================================================
-- FIX: profiles + app_settings RLS — CORREGIDO
-- Ejecutar en Supabase → SQL Editor
-- ============================================================
-- IMPORTANTE: Muchas RLS de otras tablas (products, orders,
-- app_settings…) hacen sub-consultas a profiles para comprobar
-- is_admin. Por eso profiles debe ser legible por TODOS los
-- autenticados (no contiene datos sensibles).
--
-- Además app_settings contiene flags públicos como
-- flash_sale_enabled y offers_enabled que necesitan ser leídos
-- por TODOS los usuarios (no solo admin).
-- ============================================================

-- ════════════════════════════════════════════════════════════
-- 1. PROFILES
-- ════════════════════════════════════════════════════════════
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- SELECT: todos los autenticados pueden leer todos los perfiles
DROP POLICY IF EXISTS "profiles_select" ON public.profiles;
CREATE POLICY "profiles_select"
  ON public.profiles FOR SELECT
  TO authenticated
  USING (true);

-- UPDATE: cada usuario solo puede modificar su propio perfil
DROP POLICY IF EXISTS "profiles_update_own" ON public.profiles;
CREATE POLICY "profiles_update_own"
  ON public.profiles FOR UPDATE
  TO authenticated
  USING (id = auth.uid())
  WITH CHECK (id = auth.uid());

-- ════════════════════════════════════════════════════════════
-- 2. APP_SETTINGS — lectura pública, escritura solo admin
-- ════════════════════════════════════════════════════════════
ALTER TABLE public.app_settings ENABLE ROW LEVEL SECURITY;

-- SELECT: todos los autenticados pueden leer (contiene flags públicos)
DROP POLICY IF EXISTS "app_settings_select_admin" ON public.app_settings;
DROP POLICY IF EXISTS "app_settings_select_all" ON public.app_settings;
CREATE POLICY "app_settings_select_all"
  ON public.app_settings FOR SELECT
  TO authenticated
  USING (true);

-- WRITE: solo admin puede modificar
DROP POLICY IF EXISTS "app_settings_write_admin" ON public.app_settings;
CREATE POLICY "app_settings_write_admin"
  ON public.app_settings FOR ALL
  TO authenticated
  USING (
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND is_admin = true)
  )
  WITH CHECK (
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND is_admin = true)
  );

-- ════════════════════════════════════════════════════════════
-- 3. Verificar
-- ════════════════════════════════════════════════════════════
SELECT tablename, policyname, cmd, qual
FROM pg_policies
WHERE tablename IN ('profiles', 'app_settings')
ORDER BY tablename, cmd;
