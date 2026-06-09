-- 04_connect.sql

-- posts
create table public.posts (
  id         uuid primary key default gen_random_uuid(),
  author_id  uuid not null references public.profiles(id) on delete cascade,
  body       text not null,
  created_at timestamptz not null default now()
);
create index posts_author_id_idx  on public.posts(author_id);
create index posts_created_at_idx on public.posts(created_at desc);
alter table public.posts enable row level security;

create or replace function public.owns_post(_post_id uuid)
returns boolean
language sql security definer set search_path = '' stable
as $$
  select exists (
    select 1 from public.posts p
    where p.id = _post_id and p.author_id = (select auth.uid())
  );
$$;

create policy "posts_select_all" on public.posts
  for select to authenticated using (true);
create policy "posts_insert_own" on public.posts
  for insert to authenticated with check ((select auth.uid()) = author_id);
create policy "posts_update_own" on public.posts
  for update to authenticated
  using ((select auth.uid()) = author_id) with check ((select auth.uid()) = author_id);
create policy "posts_delete_own_or_admin" on public.posts
  for delete to authenticated
  using ((select auth.uid()) = author_id or public.is_admin());

-- post_media (alt_text WAJIB & non-kosong)
create table public.post_media (
  id           uuid primary key default gen_random_uuid(),
  post_id      uuid not null references public.posts(id) on delete cascade,
  storage_path text not null,
  alt_text     text not null check (length(btrim(alt_text)) > 0)
);
create index post_media_post_id_idx on public.post_media(post_id);
alter table public.post_media enable row level security;
create policy "media_select_all" on public.post_media
  for select to authenticated using (true);
create policy "media_insert_author" on public.post_media
  for insert to authenticated with check (public.owns_post(post_id));
create policy "media_delete_author" on public.post_media
  for delete to authenticated using (public.owns_post(post_id) or public.is_admin());

-- post_replies
create table public.post_replies (
  id         uuid primary key default gen_random_uuid(),
  post_id    uuid not null references public.posts(id) on delete cascade,
  author_id  uuid not null references public.profiles(id) on delete cascade,
  body       text not null,
  created_at timestamptz not null default now()
);
create index post_replies_post_id_idx   on public.post_replies(post_id);
create index post_replies_author_id_idx on public.post_replies(author_id);
alter table public.post_replies enable row level security;
create policy "replies_select_all" on public.post_replies
  for select to authenticated using (true);
create policy "replies_insert_own" on public.post_replies
  for insert to authenticated with check ((select auth.uid()) = author_id);
create policy "replies_delete_own_or_admin" on public.post_replies
  for delete to authenticated
  using ((select auth.uid()) = author_id or public.is_admin());

-- follows (owner-managed)
create table public.follows (
  follower_id uuid not null references public.profiles(id) on delete cascade,
  target_id   uuid not null references public.profiles(id) on delete cascade,
  type        text not null default 'people',   -- 'people' | 'topic'
  created_at  timestamptz not null default now(),
  primary key (follower_id, target_id, type)
);
create index follows_target_id_idx on public.follows(target_id);
alter table public.follows enable row level security;
create policy "follows_select_own" on public.follows
  for select to authenticated using ((select auth.uid()) = follower_id);
create policy "follows_insert_own" on public.follows
  for insert to authenticated with check ((select auth.uid()) = follower_id);
create policy "follows_delete_own" on public.follows
  for delete to authenticated using ((select auth.uid()) = follower_id);

-- content_reports
create table public.content_reports (
  id          uuid primary key default gen_random_uuid(),
  reporter_id uuid not null references public.profiles(id) on delete cascade,
  post_id     uuid references public.posts(id) on delete cascade,
  reason      text not null,
  status      text not null default 'open',   -- open | reviewing | resolved
  created_at  timestamptz not null default now()
);
create index content_reports_post_id_idx on public.content_reports(post_id);
alter table public.content_reports enable row level security;
create policy "reports_select" on public.content_reports
  for select to authenticated
  using ((select auth.uid()) = reporter_id or public.is_admin());
create policy "reports_insert_own" on public.content_reports
  for insert to authenticated with check ((select auth.uid()) = reporter_id);
create policy "reports_update_admin" on public.content_reports
  for update to authenticated using (public.is_admin()) with check (public.is_admin());
