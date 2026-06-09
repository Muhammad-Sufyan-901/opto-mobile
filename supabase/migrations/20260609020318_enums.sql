-- 00_enums.sql
-- gen_random_uuid() tersedia di Supabase; pastikan pgcrypto ada.
create extension if not exists "pgcrypto" with schema extensions;

-- ENUM TYPES
create type public.user_role        as enum ('user','caregiver','doctor','admin');
create type public.vision_profile   as enum ('blind_total','low_vision','ocular_prosthesis','caregiver','unspecified');
create type public.theme_mode       as enum ('light','dark','high_contrast');
create type public.haptic_level     as enum ('off','light','full');
create type public.link_status      as enum ('pending','active','revoked');
create type public.product_type     as enum ('prosthesis','self_cleaning_case','care_kit');
create type public.data_source      as enum ('self_measured','ocularist_record');
create type public.photo_purpose    as enum ('iris_match','consultation','progress');
create type public.order_status     as enum ('draft','submitted','in_review','in_production','shipped','completed','cancelled');
create type public.tutorial_category as enum ('insert','remove','clean','lubricate','case_use');
create type public.consult_mode     as enum ('video','non_verbal','in_person');
create type public.booking_status   as enum ('booked','completed','cancelled');
create type public.sos_trigger      as enum ('button','gesture','voice');
create type public.sos_status       as enum ('active','cancelled','resolved');

-- Trigger generik: set updated_at = now() saat UPDATE
create or replace function public.set_updated_at()
returns trigger
language plpgsql
security definer set search_path = ''
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;
