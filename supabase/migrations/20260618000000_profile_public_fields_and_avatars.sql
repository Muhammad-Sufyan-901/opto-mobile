-- 20260618000000_profile_public_fields_and_avatars.sql
-- Phase 0: Add public-profile columns to profiles + create avatars Storage bucket.
--
-- Columns added (all nullable — no backfill required):
--   username  — unique @handle shown on community profile cards
--   pronouns  — free-text pronouns (e.g. "she/her")
--   bio       — short user bio
--   location  — free-text city/region
--
-- The existing profiles_update_own policy already covers these columns (auth.uid() = id).
-- The existing profiles_select_public policy (using(true)) already covers them for SELECT.
-- No policy changes needed on public.profiles.

-- =========================================================
-- 1. Add public-profile columns to public.profiles
-- =========================================================

alter table public.profiles
  add column if not exists username  text unique,
  add column if not exists pronouns  text,
  add column if not exists bio       text,
  add column if not exists location  text;

-- =========================================================
-- 2. Create public avatars Storage bucket
-- =========================================================
-- Public = true so avatar_url values can be embedded in community feed cards
-- without requiring a signed URL.

insert into storage.buckets (id, name, public)
values ('avatars', 'avatars', true)
on conflict do nothing;

-- =========================================================
-- 3. RLS Policies for avatars bucket
-- =========================================================
-- Note: auth.uid() is uuid; owner column in storage.objects is also uuid.
-- Do NOT cast auth.uid()::text — that produces "operator does not exist: text = uuid".
-- See: 20260610000000_storage_buckets.sql for the same pattern on private buckets.

-- Anyone (anon or authenticated) can read avatars — needed for community feed rendering.
create policy "Public can read avatars"
  on storage.objects
  for select to anon, authenticated
  using (bucket_id = 'avatars');

-- Owner can upload (insert) their own avatar.
create policy "Owner can upload to avatars"
  on storage.objects
  for insert to authenticated
  with check (bucket_id = 'avatars' and auth.uid() = owner);

-- Owner can replace (update) their own avatar.
-- CRITICAL: Both USING and WITH CHECK required for UPDATE to work (per project convention).
create policy "Owner can update avatars"
  on storage.objects
  for update to authenticated
  using  (bucket_id = 'avatars' and auth.uid() = owner)
  with check (bucket_id = 'avatars' and auth.uid() = owner);

-- Owner can delete their own avatar.
create policy "Owner can delete avatars"
  on storage.objects
  for delete to authenticated
  using (bucket_id = 'avatars' and auth.uid() = owner);
