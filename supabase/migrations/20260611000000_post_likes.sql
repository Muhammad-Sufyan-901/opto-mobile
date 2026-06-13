-- 20260611000000_post_likes.sql
-- Adds the `post_likes` table for the Connect feature.
--
-- The Dart data layer (connect_remote_data_source.dart) calls
-- `.from('post_likes')` with select/insert/delete and relies on a
-- UNIQUE(post_id, user_id) constraint to handle concurrent double-taps
-- (catches PostgrestException code '23505'). This table was absent from the
-- original connect migration (20260609020328_connect.sql), causing a runtime
-- crash whenever a user attempts to like/unlike a post.

create table public.post_likes (
  id         uuid        primary key default gen_random_uuid(),
  post_id    uuid        not null references public.posts(id) on delete cascade,
  user_id    uuid        not null references public.profiles(id) on delete cascade,
  created_at timestamptz not null default now(),
  unique (post_id, user_id)   -- required: Dart TOCTOU guard catches 23505
);

create index post_likes_post_id_idx on public.post_likes(post_id);
create index post_likes_user_id_idx on public.post_likes(user_id);

alter table public.post_likes enable row level security;

-- Anyone in the community can see who liked what (public feed context)
create policy "likes_select_all" on public.post_likes
  for select to authenticated using (true);

-- Only the acting user can insert their own like
create policy "likes_insert_own" on public.post_likes
  for insert to authenticated
  with check ((select auth.uid()) = user_id);

-- Only the acting user can unlike (delete their own row)
create policy "likes_delete_own" on public.post_likes
  for delete to authenticated
  using ((select auth.uid()) = user_id);
