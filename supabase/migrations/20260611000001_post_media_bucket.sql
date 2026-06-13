-- 20260611000001_post_media_bucket.sql
-- Creates the `post-media` Storage bucket for the Connect feature.
--
-- The Dart data layer uploads post images to `storage.from('post-media')`
-- (path pattern: posts/{postId}/{timestamp}_{filename}) and removes them via
-- the same bucket. Only `eye-photos` and `consultation-attachments` buckets
-- existed, causing a StorageException crash on any post with media.
--
-- Design decisions:
--   public = true  — community feed images are non-sensitive; public URLs let
--                    the feed display other users' media without signed-URL
--                    overhead. Accessibility is enforced at DB level via the
--                    NOT NULL / non-empty CHECK on post_media.alt_text.
--   Write policies  — use the `owner` column (populated by Supabase Storage
--                    on upload as auth.uid()). The upload path has no user-id
--                    folder, so storage.foldername() is NOT used here.

insert into storage.buckets (id, name, public)
values ('post-media', 'post-media', true)
on conflict do nothing;

-- ── Write policies on storage.objects ────────────────────────────────────────
-- (Public bucket has no SELECT policy needed — anonymous reads work via the
--  public URL. Only authenticated writes are gated.)

-- Authenticated users can upload their own media
create policy "post_media_insert_owner"
  on storage.objects
  for insert to authenticated
  with check (bucket_id = 'post-media' and auth.uid() = owner);

-- Owner can replace/upsert their own object
-- CRITICAL: both USING and WITH CHECK are required for UPDATE to work
create policy "post_media_update_owner"
  on storage.objects
  for update to authenticated
  using  (bucket_id = 'post-media' and auth.uid() = owner)
  with check (bucket_id = 'post-media' and auth.uid() = owner);

-- Owner can delete their own media (called by removeMedia in data source)
create policy "post_media_delete_owner"
  on storage.objects
  for delete to authenticated
  using (bucket_id = 'post-media' and auth.uid() = owner);
