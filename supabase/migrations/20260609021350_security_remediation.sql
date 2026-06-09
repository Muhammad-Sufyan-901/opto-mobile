-- security_remediation.sql
-- Fixes two categories of advisor WARNs raised after the initial schema push:
--
-- 1) SECURITY DEFINER functions callable by anon/authenticated via REST RPC.
--    These are internal helpers (trigger fns, policy helpers) that must never
--    be API endpoints. Revoke EXECUTE from PUBLIC, then re-grant selectively.
--
-- 2) Multiple permissive SELECT policies on catalog tables — caused by admin
--    write policies using FOR ALL (which also covers SELECT). Split to explicit
--    FOR INSERT, UPDATE, DELETE so only one SELECT policy fires per query.

-- =========================================================
-- Part 1: EXECUTE revocations
-- =========================================================

-- Trigger functions — must never be callable by clients
revoke execute on function public.set_updated_at() from public;
revoke execute on function public.handle_new_user() from public;
revoke execute on function public.prevent_role_change() from public;

-- Internal RLS helpers — not useful as REST endpoints; used only inside policies
revoke execute on function public.owns_doctor(uuid) from public;
revoke execute on function public.can_access_booking(uuid) from public;
revoke execute on function public.is_doctor_of_booking(uuid) from public;
revoke execute on function public.owns_post(uuid) from public;

-- Client-useful helpers: keep for authenticated, revoke from anon
-- is_admin() and is_active_caregiver() may be called by Flutter to adjust UI
revoke execute on function public.is_admin() from anon;
revoke execute on function public.is_active_caregiver(uuid, text) from anon;

-- =========================================================
-- Part 2: Split FOR ALL admin policies into INSERT, UPDATE, DELETE
-- (removes duplicate permissive SELECT policies)
-- =========================================================

-- vendors
drop policy if exists "vendors_write_admin" on public.vendors;
create policy "vendors_insert_admin" on public.vendors
  for insert to authenticated with check (public.is_admin());
create policy "vendors_update_admin" on public.vendors
  for update to authenticated using (public.is_admin()) with check (public.is_admin());
create policy "vendors_delete_admin" on public.vendors
  for delete to authenticated using (public.is_admin());

-- prosthetic_products
drop policy if exists "products_write_admin" on public.prosthetic_products;
create policy "products_insert_admin" on public.prosthetic_products
  for insert to authenticated with check (public.is_admin());
create policy "products_update_admin" on public.prosthetic_products
  for update to authenticated using (public.is_admin()) with check (public.is_admin());
create policy "products_delete_admin" on public.prosthetic_products
  for delete to authenticated using (public.is_admin());

-- care_tutorials
drop policy if exists "tutorials_write_admin" on public.care_tutorials;
create policy "tutorials_insert_admin" on public.care_tutorials
  for insert to authenticated with check (public.is_admin());
create policy "tutorials_update_admin" on public.care_tutorials
  for update to authenticated using (public.is_admin()) with check (public.is_admin());
create policy "tutorials_delete_admin" on public.care_tutorials
  for delete to authenticated using (public.is_admin());

-- care_reminders (FOR ALL owner policy also covers SELECT alongside reminders_select)
drop policy if exists "reminders_write_own" on public.care_reminders;
create policy "reminders_insert_own" on public.care_reminders
  for insert to authenticated with check ((select auth.uid()) = user_id);
create policy "reminders_update_own" on public.care_reminders
  for update to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);
create policy "reminders_delete_own" on public.care_reminders
  for delete to authenticated using ((select auth.uid()) = user_id);

-- clinics
drop policy if exists "clinics_write_admin" on public.clinics;
create policy "clinics_insert_admin" on public.clinics
  for insert to authenticated with check (public.is_admin());
create policy "clinics_update_admin" on public.clinics
  for update to authenticated using (public.is_admin()) with check (public.is_admin());
create policy "clinics_delete_admin" on public.clinics
  for delete to authenticated using (public.is_admin());

-- doctors
drop policy if exists "doctors_manage_self" on public.doctors;
create policy "doctors_insert_self" on public.doctors
  for insert to authenticated
  with check (profile_id = (select auth.uid()) or public.is_admin());
create policy "doctors_update_self" on public.doctors
  for update to authenticated
  using (profile_id = (select auth.uid()) or public.is_admin())
  with check (profile_id = (select auth.uid()) or public.is_admin());
create policy "doctors_delete_self" on public.doctors
  for delete to authenticated
  using (profile_id = (select auth.uid()) or public.is_admin());

-- doctor_availability
drop policy if exists "avail_manage_doctor" on public.doctor_availability;
create policy "avail_insert_doctor" on public.doctor_availability
  for insert to authenticated
  with check (public.owns_doctor(doctor_id) or public.is_admin());
create policy "avail_update_doctor" on public.doctor_availability
  for update to authenticated
  using (public.owns_doctor(doctor_id) or public.is_admin())
  with check (public.owns_doctor(doctor_id) or public.is_admin());
create policy "avail_delete_doctor" on public.doctor_availability
  for delete to authenticated
  using (public.owns_doctor(doctor_id) or public.is_admin());

-- eye_care_exercises
drop policy if exists "exercises_write_admin" on public.eye_care_exercises;
create policy "exercises_insert_admin" on public.eye_care_exercises
  for insert to authenticated with check (public.is_admin());
create policy "exercises_update_admin" on public.eye_care_exercises
  for update to authenticated using (public.is_admin()) with check (public.is_admin());
create policy "exercises_delete_admin" on public.eye_care_exercises
  for delete to authenticated using (public.is_admin());
