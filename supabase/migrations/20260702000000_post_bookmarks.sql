-- 20260702000000_post_bookmarks.sql
-- Adds the `post_bookmarks` table for the Connect feature's "save post"
-- functionality (community_thread_card.dart / post_thread_screen.dart save
-- buttons, surfaced in profile/My Activity's "Saved" tab).
--
-- Unlike `post_likes` (a public social signal — anyone can see who liked
-- what), a bookmark is a private per-user save list: select is restricted to
-- the owning user, mirroring the `follows` table's owner-only RLS pattern.

create table public.post_bookmarks (
  id         uuid        primary key default gen_random_uuid(),
  post_id    uuid        not null references public.posts(id) on delete cascade,
  user_id    uuid        not null references public.profiles(id) on delete cascade,
  created_at timestamptz not null default now(),
  unique (post_id, user_id)   -- required: Dart TOCTOU guard catches 23505
);

create index post_bookmarks_post_id_idx on public.post_bookmarks(post_id);
create index post_bookmarks_user_id_idx on public.post_bookmarks(user_id);

alter table public.post_bookmarks enable row level security;

-- Bookmarks are private — only the owning user can see their own saved posts.
create policy "bookmarks_select_own" on public.post_bookmarks
  for select to authenticated
  using ((select auth.uid()) = user_id);

-- Only the acting user can bookmark on their own behalf.
create policy "bookmarks_insert_own" on public.post_bookmarks
  for insert to authenticated
  with check ((select auth.uid()) = user_id);

-- Only the acting user can remove their own bookmark.
create policy "bookmarks_delete_own" on public.post_bookmarks
  for delete to authenticated
  using ((select auth.uid()) = user_id);
