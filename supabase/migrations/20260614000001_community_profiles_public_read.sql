-- 20260614000001_community_profiles_public_read.sql
-- Fixes two `42501` (RLS / permission denied) issues that block the community feed.
--
-- Problem 1 — profiles_select_own blocks author join in the feed:
--   The feed query embeds `author:profiles!author_id(full_name, avatar_url, is_verified)`
--   which reads OTHER users' profiles. The existing profiles_select_own policy
--   (`using (auth.uid() = id)`) blocks every row that isn't the current user, so
--   PostgREST returns 42501 on every feed load.
--   Fix: add a permissive SELECT policy for all authenticated users (policies are OR'd).
--
-- Problem 2 — post_likes has no GRANT to authenticated:
--   post_likes was created in 20260611000000_post_likes.sql, which ran AFTER the
--   consolidated grants migration (20260609021207_grants.sql). Auto-expose is OFF on
--   this project, so tables need explicit grants. post_likes has RLS policies but no
--   GRANT, so PostgREST can't execute the `like_count:post_likes(count)` aggregate
--   or direct like/unlike queries from the Flutter client.

-- ─── Fix 1: allow community members to read any profile ──────────────────────
-- Profiles expose: full_name, avatar_url, is_verified, role, vision_profile.
-- No sensitive health tables (anthropometric_data, eye_photos, consultations) are
-- on this table. Restricting reads to own-row breaks every community join.
create policy "profiles_select_public" on public.profiles
  for select to authenticated using (true);

-- ─── Fix 2: grant table-level access on post_likes to authenticated ──────────
grant select, insert, delete on public.post_likes to authenticated;
