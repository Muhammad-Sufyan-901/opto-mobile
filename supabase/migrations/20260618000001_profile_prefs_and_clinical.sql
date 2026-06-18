-- 20260618000001_profile_prefs_and_clinical.sql
-- Three changes:
--   1. Extend accessibility_settings with sound_effects_enabled
--   2. Extend profiles with preferred_language and clinic_id
--   3. Create vision_clinical_profile (owner-only 🔒 medically sensitive)
--
-- NOTE — no new RLS policies are required for the two ALTER TABLE statements:
--   profiles        — existing profiles_update_own and profiles_select_public already cover new columns.
--   accessibility_settings — existing owner-only policy already covers new column.

-- =========================================================
-- 1. Extend accessibility_settings
-- =========================================================

alter table public.accessibility_settings
  add column if not exists sound_effects_enabled boolean not null default true;

-- =========================================================
-- 2. Extend profiles
-- =========================================================

alter table public.profiles
  add column if not exists preferred_language text not null default 'en',
  add column if not exists clinic_id          uuid references public.clinics(id) on delete set null;

-- =========================================================
-- 3. Create vision_clinical_profile 🔒
-- Owner-only; medically sensitive — never join into community/map/catalog queries,
-- never cache beyond session.
-- =========================================================

create table public.vision_clinical_profile (
  user_id                  uuid primary key references public.profiles(id) on delete cascade,
  diagnosis                text,
  diagnosis_severity       text,
  affected_eyes            text,
  diagnosed_year           int check (diagnosed_year between 1900 and extract(year from now())::int),
  light_perception         text,
  central_acuity           text,
  visual_field             text,
  prosthesis_eye           text,
  prosthesis_type          text,
  prosthesis_material      text,
  prosthesis_fitted_date   date,
  prosthesis_fitted_clinic text,
  last_polish_date         date,
  next_polish_due          date,
  assistive_tech           jsonb not null default '[]',
  created_at               timestamptz not null default now(),
  updated_at               timestamptz default now()
);

alter table public.vision_clinical_profile enable row level security;

create policy "vision_clinical_all_own" on public.vision_clinical_profile
  for all to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

grant select, insert, update, delete on public.vision_clinical_profile to authenticated;
