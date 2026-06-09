-- 06_grants.sql
-- Mandatory: "Automatically expose new tables" is OFF on this project.
-- GRANT opens table-level access; RLS still controls which rows are visible.

-- Tabel public-read (katalog, tutorial, direktori dokter, POI)
grant select on public.prosthetic_products to authenticated;
grant select on public.vendors             to authenticated;
grant select on public.clinics             to authenticated;
grant select on public.care_tutorials      to authenticated;
grant select on public.eye_care_exercises  to authenticated;
grant select on public.doctors             to authenticated;
grant select on public.doctor_availability to authenticated;
grant select on public.accessibility_pois  to authenticated;

-- Tabel user-owned (write tetap dibatasi oleh RLS, bukan oleh grant)
grant select, insert, update, delete on public.profiles               to authenticated;
grant select, insert, update, delete on public.accessibility_settings to authenticated;
grant select, insert, update, delete on public.caregiver_links        to authenticated;
grant select, insert, update, delete on public.emergency_contacts     to authenticated;
grant select, insert, update, delete on public.anthropometric_data    to authenticated;
grant select, insert, update, delete on public.eye_photos             to authenticated;
grant select, insert, update, delete on public.prosthetic_orders      to authenticated;
grant select, insert, update, delete on public.care_reminders         to authenticated;
grant select, insert, update, delete on public.consultation_bookings  to authenticated;
grant select, insert, update, delete on public.consultations          to authenticated;
grant select, insert, update, delete on public.posts                  to authenticated;
grant select, insert, update, delete on public.post_media             to authenticated;
grant select, insert, update, delete on public.post_replies           to authenticated;
grant select, insert, update, delete on public.follows                to authenticated;
grant select, insert, update, delete on public.content_reports        to authenticated;
grant select, insert, update, delete on public.sos_events             to authenticated;
grant select, insert, update, delete on public.poi_contributions      to authenticated;

-- Notes:
-- 1) Public-read tables get SELECT only; INSERT/UPDATE/DELETE is admin-only via is_admin() policy.
-- 2) Admin writes to catalog tables should go through Edge Functions (service_role).
-- 3) No grants to 'anon' — entire app is gated behind login.
