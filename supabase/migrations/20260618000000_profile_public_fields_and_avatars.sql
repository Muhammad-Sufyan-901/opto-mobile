-- 20260618000000_profile_public_fields_and_avatars.sql
-- Phase 0: Add public-profile columns to profiles + create avatars Storage bucket.
--
-- NOTE — columns that already exist (do NOT re-add here):
--   bio    — introduced by 20260615000001_community_member_profile.sql; serves both
--            community profile cards and the Profile module.
--   handle — introduced by 20260615000001_community_member_profile.sql; this is the
--            canonical @handle for both community and profile surfaces.
--            The user's @handle is stored in the `handle` column introduced by
--            20260615000001_community_member_profile.sql — not duplicated here.
--
-- Columns added by THIS migration (all nullable — no backfill required):
--   pronouns  — free-text pronouns (e.g. "she/her")
--   location  — free-text city/region
--
-- The existing profiles_update_own policy already covers these columns (auth.uid() = id).
-- The existing profiles_select_public policy (using(true)) already covers them for SELECT.
-- No policy changes needed on public.profiles.

-- =========================================================
-- 1. Add public-profile columns to public.profiles
-- =========================================================

alter table public.profiles
  add column if not exists pronouns  text,
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
-- Policy names follow the project snake_case convention (see post_media_* policies).

-- Anyone (anon or authenticated) can read avatars — needed for community feed rendering.
create policy "avatars_select_public"
  on storage.objects
  for select to anon, authenticated
  using (bucket_id = 'avatars');

-- Owner can upload (insert) their own avatar.
create policy "avatars_insert_owner"
  on storage.objects
  for insert to authenticated
  with check (bucket_id = 'avatars' and auth.uid() = owner);

-- Owner can replace (update) their own avatar.
-- CRITICAL: Both USING and WITH CHECK required for UPDATE to work (per project convention).
create policy "avatars_update_owner"
  on storage.objects
  for update to authenticated
  using  (bucket_id = 'avatars' and auth.uid() = owner)
  with check (bucket_id = 'avatars' and auth.uid() = owner);

-- Owner can delete their own avatar.
create policy "avatars_delete_owner"
  on storage.objects
  for delete to authenticated
  using (bucket_id = 'avatars' and auth.uid() = owner);
