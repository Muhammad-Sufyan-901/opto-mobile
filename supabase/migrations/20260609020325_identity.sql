-- 01_identity.sql

-- =========================================================
-- profiles (extends auth.users 1:1)
-- =========================================================
create table public.profiles (
  id             uuid primary key references auth.users(id) on delete cascade,
  role           public.user_role not null default 'user',
  full_name      text not null default '',
  phone          text unique,
  vision_profile public.vision_profile,
  avatar_url     text,
  created_at     timestamptz not null default now()
);
alter table public.profiles enable row level security;

-- helper: apakah user saat ini admin (SECURITY DEFINER agar tidak rekursif ke RLS profiles)
create or replace function public.is_admin()
returns boolean
language sql
security definer set search_path = ''
stable
as $$
  select exists (
    select 1 from public.profiles
    where id = (select auth.uid()) and role = 'admin'
  );
$$;

-- cegah eskalasi: hanya admin yang boleh mengubah kolom role
create or replace function public.prevent_role_change()
returns trigger
language plpgsql
security definer set search_path = ''
as $$
begin
  if new.role <> old.role and not public.is_admin() then
    raise exception 'Hanya admin yang dapat mengubah role';
  end if;
  return new;
end;
$$;
create trigger profiles_no_role_escalation
  before update on public.profiles
  for each row execute function public.prevent_role_change();

create policy "profiles_select_own" on public.profiles
  for select to authenticated using ((select auth.uid()) = id);
create policy "profiles_insert_own" on public.profiles
  for insert to authenticated with check ((select auth.uid()) = id);
create policy "profiles_update_own" on public.profiles
  for update to authenticated using ((select auth.uid()) = id) with check ((select auth.uid()) = id);

-- =========================================================
-- accessibility_settings
-- =========================================================
create table public.accessibility_settings (
  user_id          uuid primary key references public.profiles(id) on delete cascade,
  theme            public.theme_mode  not null default 'light',
  text_scale       numeric(3,2)       not null default 1.0 check (text_scale between 1.0 and 3.0),
  font_family      text               not null default 'AtkinsonHyperlegible',
  haptic_intensity public.haptic_level not null default 'full',
  voice_enabled    boolean            not null default true,
  hotword_enabled  boolean            not null default false,
  updated_at       timestamptz        not null default now()
);
alter table public.accessibility_settings enable row level security;
create trigger acc_settings_set_updated
  before update on public.accessibility_settings
  for each row execute function public.set_updated_at();

create policy "acc_settings_all_own" on public.accessibility_settings
  for all to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

-- =========================================================
-- Auto-provision profil + settings saat user baru dibuat di auth.users
-- =========================================================
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = ''
as $$
begin
  insert into public.profiles (id, full_name, phone)
  values (new.id, coalesce(new.raw_user_meta_data->>'full_name',''), new.phone);
  insert into public.accessibility_settings (user_id) values (new.id);
  return new;
end;
$$;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- =========================================================
-- caregiver_links
-- =========================================================
create table public.caregiver_links (
  id           uuid primary key default gen_random_uuid(),
  user_id      uuid not null references public.profiles(id) on delete cascade,
  caregiver_id uuid not null references public.profiles(id) on delete cascade,
  status       public.link_status not null default 'pending',
  permissions  text[] not null default '{}',  -- {sos, bookings, reminders, orders}
  created_at   timestamptz not null default now(),
  unique (user_id, caregiver_id),
  check (user_id <> caregiver_id)
);
create index caregiver_links_user_id_idx      on public.caregiver_links(user_id);
create index caregiver_links_caregiver_id_idx on public.caregiver_links(caregiver_id);
alter table public.caregiver_links enable row level security;

-- helper: apakah user saat ini caregiver AKTIF utk _user_id dgn permission _perm
create or replace function public.is_active_caregiver(_user_id uuid, _perm text)
returns boolean
language sql
security definer set search_path = ''
stable
as $$
  select exists (
    select 1 from public.caregiver_links cl
    where cl.user_id      = _user_id
      and cl.caregiver_id = (select auth.uid())
      and cl.status       = 'active'
      and _perm = any (cl.permissions)
  );
$$;

create policy "cl_select_party" on public.caregiver_links
  for select to authenticated
  using ((select auth.uid()) = user_id or (select auth.uid()) = caregiver_id);
-- caregiver mengajukan tautan (status awal 'pending')
create policy "cl_insert_caregiver" on public.caregiver_links
  for insert to authenticated
  with check ((select auth.uid()) = caregiver_id and status = 'pending');
-- hanya user yg didukung yg boleh approve/revoke
create policy "cl_update_user" on public.caregiver_links
  for update to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);
create policy "cl_delete_user" on public.caregiver_links
  for delete to authenticated
  using ((select auth.uid()) = user_id);

-- =========================================================
-- emergency_contacts
-- =========================================================
create table public.emergency_contacts (
  id           uuid primary key default gen_random_uuid(),
  user_id      uuid not null references public.profiles(id) on delete cascade,
  name         text not null,
  phone        text not null,
  relationship text,
  priority     int  not null default 0,
  created_at   timestamptz not null default now()
);
create index emergency_contacts_user_id_idx on public.emergency_contacts(user_id);
alter table public.emergency_contacts enable row level security;
create policy "ec_all_own" on public.emergency_contacts
  for all to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);
