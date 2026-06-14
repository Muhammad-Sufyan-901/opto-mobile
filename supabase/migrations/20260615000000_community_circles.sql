-- circles table
create table public.circles (
  id          uuid primary key default gen_random_uuid(),
  slug        text unique not null,   -- matches posts.topic chip labels
  name        text not null,
  description text,
  about       text,
  icon_key    text,                   -- e.g. 'aperture', 'eye', 'sparkle', 'stethoscope'
  color_key   text default 'blue',   -- 'blue' | 'violet' | 'green' | 'amber'
  pinned_note text,
  created_at  timestamptz not null default now()
);
create index circles_slug_idx on public.circles(slug);
alter table public.circles enable row level security;
create policy "circles_select_all" on public.circles
  for select to authenticated using (true);
create policy "circles_insert_admin" on public.circles
  for insert to authenticated with check (public.is_admin());
create policy "circles_update_admin" on public.circles
  for update to authenticated using (public.is_admin()) with check (public.is_admin());

-- circle_members table
create table public.circle_members (
  circle_id  uuid not null references public.circles(id) on delete cascade,
  member_id  uuid not null references public.profiles(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (circle_id, member_id)
);
create index circle_members_member_id_idx on public.circle_members(member_id);
alter table public.circle_members enable row level security;
create policy "circle_members_select_all" on public.circle_members
  for select to authenticated using (true);
create policy "circle_members_insert_own" on public.circle_members
  for insert to authenticated with check ((select auth.uid()) = member_id);
create policy "circle_members_delete_own" on public.circle_members
  for delete to authenticated using ((select auth.uid()) = member_id);

-- grants
grant select on public.circles to authenticated;
grant select, insert, delete on public.circle_members to authenticated;
