-- 02_prosthetic_hub.sql

-- vendors (FK ke clinics ditambahkan di blok 03 setelah clinics dibuat)
create table public.vendors (
  id          uuid primary key default gen_random_uuid(),
  name        text not null,
  is_verified boolean not null default false,
  clinic_id   uuid
);
alter table public.vendors enable row level security;
create policy "vendors_select_all" on public.vendors
  for select to authenticated using (true);
create policy "vendors_write_admin" on public.vendors
  for all to authenticated using (public.is_admin()) with check (public.is_admin());

-- prosthetic_products (katalog terverifikasi)
create table public.prosthetic_products (
  id                uuid primary key default gen_random_uuid(),
  type              public.product_type not null,
  name              text not null,
  audio_description text not null,             -- WAJIB: deskripsi spoken lengkap
  material          text not null,
  iris_color        text,
  size              text,
  is_custom         boolean not null default false,
  price_idr         int not null,
  vendor_id         uuid references public.vendors(id),
  is_active         boolean not null default true
);
create index prosthetic_products_vendor_id_idx on public.prosthetic_products(vendor_id);
alter table public.prosthetic_products enable row level security;
create policy "products_select_active" on public.prosthetic_products
  for select to authenticated using (is_active = true or public.is_admin());
create policy "products_write_admin" on public.prosthetic_products
  for all to authenticated using (public.is_admin()) with check (public.is_admin());

-- anthropometric_data (owner-only)
create table public.anthropometric_data (
  id               uuid primary key default gen_random_uuid(),
  user_id          uuid not null references public.profiles(id) on delete cascade,
  socket_size_mm   numeric,
  curvature        numeric,
  iris_diameter_mm numeric,
  matched_iris_hex text,
  source           public.data_source not null,
  created_at       timestamptz not null default now()
);
create index anthropometric_data_user_id_idx on public.anthropometric_data(user_id);
alter table public.anthropometric_data enable row level security;
create policy "anthro_all_own" on public.anthropometric_data
  for all to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

-- eye_photos (referensi objek di bucket privat)
create table public.eye_photos (
  id           uuid primary key default gen_random_uuid(),
  user_id      uuid not null references public.profiles(id) on delete cascade,
  storage_path text not null,
  purpose      public.photo_purpose not null,
  created_at   timestamptz not null default now()
);
create index eye_photos_user_id_idx on public.eye_photos(user_id);
alter table public.eye_photos enable row level security;
create policy "eye_photos_all_own" on public.eye_photos
  for all to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

-- prosthetic_orders
create table public.prosthetic_orders (
  id                uuid primary key default gen_random_uuid(),
  user_id           uuid not null references public.profiles(id) on delete cascade,
  product_id        uuid not null references public.prosthetic_products(id),
  anthropometric_id uuid references public.anthropometric_data(id),
  status            public.order_status not null default 'draft',
  consent_given     boolean not null default false,
  total_idr         int not null,
  created_at        timestamptz not null default now()
);
create index prosthetic_orders_user_id_idx    on public.prosthetic_orders(user_id);
create index prosthetic_orders_product_id_idx on public.prosthetic_orders(product_id);
alter table public.prosthetic_orders enable row level security;
create policy "orders_select" on public.prosthetic_orders
  for select to authenticated
  using ((select auth.uid()) = user_id
         or public.is_active_caregiver(user_id, 'orders')
         or public.is_admin());
create policy "orders_insert_own" on public.prosthetic_orders
  for insert to authenticated
  with check ((select auth.uid()) = user_id);
create policy "orders_update" on public.prosthetic_orders
  for update to authenticated
  using ((select auth.uid()) = user_id or public.is_admin())
  with check ((select auth.uid()) = user_id or public.is_admin());

-- care_tutorials
create table public.care_tutorials (
  id                   uuid primary key default gen_random_uuid(),
  title                text not null,
  category             public.tutorial_category not null,
  video_path           text,
  audio_narration_path text,
  transcript           text not null,
  sort_order           int not null default 0
);
alter table public.care_tutorials enable row level security;
create policy "tutorials_select_all" on public.care_tutorials
  for select to authenticated using (true);
create policy "tutorials_write_admin" on public.care_tutorials
  for all to authenticated using (public.is_admin()) with check (public.is_admin());

-- care_reminders
create table public.care_reminders (
  id               uuid primary key default gen_random_uuid(),
  user_id          uuid not null references public.profiles(id) on delete cascade,
  label            text not null,
  schedule_cron    text not null,
  notify_caregiver boolean not null default false,
  is_active        boolean not null default true
);
create index care_reminders_user_id_idx on public.care_reminders(user_id);
alter table public.care_reminders enable row level security;
create policy "reminders_select" on public.care_reminders
  for select to authenticated
  using ((select auth.uid()) = user_id
         or public.is_active_caregiver(user_id, 'reminders'));
create policy "reminders_write_own" on public.care_reminders
  for all to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);
