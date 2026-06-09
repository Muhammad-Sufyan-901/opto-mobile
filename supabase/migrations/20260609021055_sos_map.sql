-- 05_sos_map.sql

-- sos_events
create table public.sos_events (
  id             uuid primary key default gen_random_uuid(),
  user_id        uuid not null references public.profiles(id) on delete cascade,
  trigger_method public.sos_trigger not null,
  lat            double precision,
  lng            double precision,
  status         public.sos_status not null default 'active',
  dispatched_at  timestamptz,                  -- diisi oleh Edge Function sos-dispatch
  created_at     timestamptz not null default now()
);
create index sos_events_user_id_idx on public.sos_events(user_id);
alter table public.sos_events enable row level security;
create policy "sos_select" on public.sos_events
  for select to authenticated
  using ((select auth.uid()) = user_id
         or public.is_active_caregiver(user_id, 'sos'));
create policy "sos_insert_own" on public.sos_events
  for insert to authenticated with check ((select auth.uid()) = user_id);
create policy "sos_update" on public.sos_events
  for update to authenticated
  using ((select auth.uid()) = user_id or public.is_active_caregiver(user_id, 'sos'))
  with check ((select auth.uid()) = user_id or public.is_active_caregiver(user_id, 'sos'));

-- accessibility_pois
create table public.accessibility_pois (
  id             uuid primary key default gen_random_uuid(),
  name           text not null,
  lat            double precision not null,
  lng            double precision not null,
  attributes     jsonb not null default '{}'::jsonb,  -- {ramp, elevator, tactile_path, ...}
  verified_count int  not null default 0,
  created_by     uuid references public.profiles(id) on delete set null,
  created_at     timestamptz not null default now()
);
alter table public.accessibility_pois enable row level security;
create policy "pois_select_all" on public.accessibility_pois
  for select to authenticated using (true);
create policy "pois_insert_auth" on public.accessibility_pois
  for insert to authenticated
  with check ((select auth.uid()) = created_by);
create policy "pois_update_creator_or_admin" on public.accessibility_pois
  for update to authenticated
  using ((select auth.uid()) = created_by or public.is_admin())
  with check ((select auth.uid()) = created_by or public.is_admin());

-- poi_contributions
create table public.poi_contributions (
  id         uuid primary key default gen_random_uuid(),
  poi_id     uuid not null references public.accessibility_pois(id) on delete cascade,
  user_id    uuid not null references public.profiles(id) on delete cascade,
  change     jsonb not null,
  status     text  not null default 'pending', -- pending | accepted | rejected
  created_at timestamptz not null default now()
);
create index poi_contributions_poi_id_idx  on public.poi_contributions(poi_id);
create index poi_contributions_user_id_idx on public.poi_contributions(user_id);
alter table public.poi_contributions enable row level security;
create policy "contrib_select" on public.poi_contributions
  for select to authenticated
  using ((select auth.uid()) = user_id or public.is_admin());
create policy "contrib_insert_own" on public.poi_contributions
  for insert to authenticated with check ((select auth.uid()) = user_id);
create policy "contrib_update_admin" on public.poi_contributions
  for update to authenticated using (public.is_admin()) with check (public.is_admin());
