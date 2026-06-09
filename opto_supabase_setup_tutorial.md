# Tutorial Lengkap — Setup Database Supabase untuk Opto

Tutorial ini membangun seluruh skema database Opto di Supabase sesuai `database_schema.md`: **18 tabel** di 6 modul, **14 enum**, helper function, dan **Row Level Security (RLS) default-deny** di setiap tabel. Disertai **data seed contoh** untuk tabel katalog/tutorial.

Prinsip yang ditegakkan:

- Setiap tabel di skema `public` **WAJIB** RLS aktif. RLS adalah sumber kebenaran otorisasi — bukan klien.
- Tabel medis sensitif (🔒) — `anthropometric_data`, `eye_photos`, `consultations` — **owner-only** dan tak pernah ikut di join feed/katalog/map.
- Setiap kolom FK diberi indeks (mencegah sequential scan).
- `auth.uid()` selalu dibungkus `(select auth.uid())` agar di-cache per-statement (optimasi RLS Supabase).

---

## 0. Prasyarat

1. Akun Supabase + satu project baru (catat **Project Ref**, ada di Settings → General).
2. Untuk jalur CLI: Node.js terpasang, lalu install CLI Supabase.

```bash
# salah satu:
npm install -g supabase
# atau (macOS)
brew install supabase/tap/supabase

supabase --version
```

### Setting saat membuat project (penting)

| Setting | Nilai | Alasan |
| :-- | :-- | :-- |
| Project name | `Opto` | — |
| Region | `Asia-Pacific (Singapore)` | latency rendah untuk pengguna Indonesia |
| Database password | strong, simpan aman | dipakai untuk koneksi langsung/CLI |
| **Enable Data API** | ✅ ON | dibutuhkan `supabase_flutter` |
| **Automatically expose new tables** | ❌ **OFF** | Supabase sendiri menyarankan OFF; kontrol manual akses tabel medis 🔒 |
| **Enable automatic RLS** | ✅ ON | jaring pengaman: RLS auto-aktif di tabel baru |

> Karena "Automatically expose new tables" dimatikan, **Blok 06 (`grants.sql`) menjadi WAJIB** agar klien Flutter bisa mengakses tabel.

---

## 1. Dua cara menjalankan SQL

Anda akan memakai **blok SQL yang sama** untuk kedua jalur. Delapan blok berikut harus dijalankan **berurutan** (00 → 07) karena ada ketergantungan antar-tabel.

### Cara A — SQL Editor (cepat)

1. Buka Dashboard → project Anda → **SQL Editor** → **New query**.
2. Tempel blok 00, jalankan (Run). Lanjut blok 01, dst. sampai 07.
3. SQL Editor berjalan sebagai role `postgres` sehingga **melewati RLS** — itu sebabnya seed (blok 07) berhasil meski tabel punya policy ketat.

> Bisa juga semua blok 00–06 ditempel sekaligus dalam satu query, lalu blok 07 (seed) terpisah. Disarankan tetap berurutan agar mudah men-debug error.

### Cara B — Migration files + CLI (versioned, untuk tim)

```bash
# di root repo opto-mobile (atau folder backend terpisah)
supabase init          # membuat folder supabase/
supabase link --project-ref <PROJECT_REF>   # tempel ref project Anda
```

Buat tiap migrasi (timestamp dibuat otomatis dan urut sesuai urutan perintah):

```bash
supabase migration new enums
supabase migration new identity
supabase migration new prosthetic_hub
supabase migration new consultation
supabase migration new connect
supabase migration new sos_map
supabase migration new grants
supabase migration new seed
```

Tempel isi tiap blok di bawah ke file `.sql` yang baru dibuat di `supabase/migrations/` (sesuai nama), lalu dorong ke remote:

```bash
supabase db push
```

Untuk reset/iterasi lokal (jika pakai Docker lokal): `supabase db reset`.

---

## 2. Ringkasan tabel & aturan akses

| Modul | Tabel | Akses inti |
| :-- | :-- | :-- |
| Identity | `profiles` | owner select/update; `role` hanya bisa diubah admin |
| Identity | `accessibility_settings` | owner only |
| Identity | `caregiver_links` | kedua pihak baca; hanya `user_id` approve/revoke |
| Identity | `emergency_contacts` | owner only |
| Prosthetic | `vendors`, `prosthetic_products`, `care_tutorials` | baca: authenticated; tulis: admin |
| Prosthetic | `anthropometric_data` 🔒, `eye_photos` 🔒 | owner only |
| Prosthetic | `prosthetic_orders` | owner + caregiver(`orders`) + admin |
| Prosthetic | `care_reminders` | owner + caregiver(`reminders`) baca |
| Consultation | `clinics`, `doctors`, `doctor_availability`, `eye_care_exercises` | baca: authenticated; kelola: pemilik/dokter/admin |
| Consultation | `consultation_bookings` | pasien + dokter terkait + caregiver(`bookings`) |
| Consultation | `consultations` 🔒 | pasien (baca) + dokter terkait (tulis) |
| Connect | `posts`, `post_media`, `post_replies` | baca: authenticated; tulis: penulis |
| Connect | `follows` | owner-managed |
| Connect | `content_reports` | pelapor + admin |
| SOS | `sos_events` 🔒 | owner + caregiver(`sos`) |
| Map | `accessibility_pois` | baca: authenticated; insert: authenticated |
| Map | `poi_contributions` | kontributor + admin |

> Semua policy memakai role `authenticated` karena Opto menggating seluruh app di balik onboarding/login. Jika ingin katalog bisa dilihat sebelum login, ganti `to authenticated` menjadi `to anon, authenticated` pada tabel public-read.

---

## Blok 00 — `enums.sql` (extension + enum + trigger updated_at)

```sql
-- 00_enums.sql
-- gen_random_uuid() tersedia di Supabase; pastikan pgcrypto ada.
create extension if not exists "pgcrypto" with schema extensions;

-- ENUM TYPES
create type public.user_role        as enum ('user','caregiver','doctor','admin');
create type public.vision_profile   as enum ('blind_total','low_vision','ocular_prosthesis','caregiver','unspecified');
create type public.theme_mode       as enum ('light','dark','high_contrast');
create type public.haptic_level     as enum ('off','light','full');
create type public.link_status      as enum ('pending','active','revoked');
create type public.product_type     as enum ('prosthesis','self_cleaning_case','care_kit');
create type public.data_source      as enum ('self_measured','ocularist_record');
create type public.photo_purpose    as enum ('iris_match','consultation','progress');
create type public.order_status      as enum ('draft','submitted','in_review','in_production','shipped','completed','cancelled');
create type public.tutorial_category as enum ('insert','remove','clean','lubricate','case_use');
create type public.consult_mode     as enum ('video','non_verbal','in_person');
create type public.booking_status   as enum ('booked','completed','cancelled');
create type public.sos_trigger      as enum ('button','gesture','voice');
create type public.sos_status       as enum ('active','cancelled','resolved');

-- Trigger generik: set updated_at = now() saat UPDATE
create or replace function public.set_updated_at()
returns trigger
language plpgsql
security definer set search_path = ''
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;
```

---

## Blok 01 — `identity.sql`

```sql
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
```

---

## Blok 02 — `prosthetic_hub.sql`

```sql
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

-- anthropometric_data 🔒 (owner-only)
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
-- CATATAN: akses-baca okularis "via order" butuh kolom assignee pada order
-- atau Edge Function; di luar scope skema saat ini, jadi tetap owner-only.

-- eye_photos 🔒 (referensi objek di bucket privat)
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
```

---

## Blok 03 — `consultation.sql`

```sql
-- 03_consultation.sql

-- clinics
create table public.clinics (
  id              uuid primary key default gen_random_uuid(),
  name            text not null,
  is_manufacturer boolean not null default false,
  lat             double precision,
  lng             double precision,
  address         text
);
alter table public.clinics enable row level security;
create policy "clinics_select_all" on public.clinics
  for select to authenticated using (true);
create policy "clinics_write_admin" on public.clinics
  for all to authenticated using (public.is_admin()) with check (public.is_admin());

-- sambungkan FK vendors.clinic_id (dibuat di blok 02)
alter table public.vendors
  add constraint vendors_clinic_id_fkey
  foreign key (clinic_id) references public.clinics(id);
create index vendors_clinic_id_idx on public.vendors(clinic_id);

-- doctors
create table public.doctors (
  id          uuid primary key default gen_random_uuid(),
  profile_id  uuid not null references public.profiles(id) on delete cascade,
  specialty   text not null,
  clinic_id   uuid references public.clinics(id),
  is_verified boolean not null default false
);
create index doctors_profile_id_idx on public.doctors(profile_id);
create index doctors_clinic_id_idx  on public.doctors(clinic_id);
alter table public.doctors enable row level security;

-- helper: apakah user saat ini pemilik record dokter _doctor_id
create or replace function public.owns_doctor(_doctor_id uuid)
returns boolean
language sql security definer set search_path = '' stable
as $$
  select exists (
    select 1 from public.doctors d
    where d.id = _doctor_id and d.profile_id = (select auth.uid())
  );
$$;

create policy "doctors_select_all" on public.doctors
  for select to authenticated using (true);
create policy "doctors_manage_self" on public.doctors
  for all to authenticated
  using (profile_id = (select auth.uid()) or public.is_admin())
  with check (profile_id = (select auth.uid()) or public.is_admin());

-- doctor_availability
create table public.doctor_availability (
  id         uuid primary key default gen_random_uuid(),
  doctor_id  uuid not null references public.doctors(id) on delete cascade,
  slot_start timestamptz not null,
  slot_end   timestamptz not null,
  is_booked  boolean not null default false
);
create index doctor_availability_doctor_id_idx on public.doctor_availability(doctor_id);
alter table public.doctor_availability enable row level security;
create policy "avail_select_all" on public.doctor_availability
  for select to authenticated using (true);
create policy "avail_manage_doctor" on public.doctor_availability
  for all to authenticated
  using (public.owns_doctor(doctor_id) or public.is_admin())
  with check (public.owns_doctor(doctor_id) or public.is_admin());

-- consultation_bookings
create table public.consultation_bookings (
  id              uuid primary key default gen_random_uuid(),
  user_id         uuid not null references public.profiles(id) on delete cascade,
  doctor_id       uuid not null references public.doctors(id),
  slot_id         uuid not null references public.doctor_availability(id),
  mode            public.consult_mode  not null default 'video',
  status          public.booking_status not null default 'booked',
  booked_via_voice boolean not null default false,
  created_at      timestamptz not null default now()
);
create index consultation_bookings_user_id_idx   on public.consultation_bookings(user_id);
create index consultation_bookings_doctor_id_idx on public.consultation_bookings(doctor_id);
create index consultation_bookings_slot_id_idx   on public.consultation_bookings(slot_id);
alter table public.consultation_bookings enable row level security;

-- helper akses booking (untuk dipakai policy consultations) — SECURITY DEFINER
create or replace function public.can_access_booking(_booking_id uuid)
returns boolean
language sql security definer set search_path = '' stable
as $$
  select exists (
    select 1 from public.consultation_bookings b
    where b.id = _booking_id
      and (b.user_id = (select auth.uid()) or public.owns_doctor(b.doctor_id))
  );
$$;
-- helper: apakah user saat ini DOKTER dari booking ini (untuk tulis consultations)
create or replace function public.is_doctor_of_booking(_booking_id uuid)
returns boolean
language sql security definer set search_path = '' stable
as $$
  select exists (
    select 1 from public.consultation_bookings b
    where b.id = _booking_id and public.owns_doctor(b.doctor_id)
  );
$$;

create policy "bookings_select" on public.consultation_bookings
  for select to authenticated
  using ((select auth.uid()) = user_id
         or public.owns_doctor(doctor_id)
         or public.is_active_caregiver(user_id, 'bookings')
         or public.is_admin());
create policy "bookings_insert_own" on public.consultation_bookings
  for insert to authenticated
  with check ((select auth.uid()) = user_id);
create policy "bookings_update" on public.consultation_bookings
  for update to authenticated
  using ((select auth.uid()) = user_id or public.owns_doctor(doctor_id) or public.is_admin())
  with check ((select auth.uid()) = user_id or public.owns_doctor(doctor_id) or public.is_admin());

-- consultations 🔒 (riwayat & resep)
create table public.consultations (
  id             uuid primary key default gen_random_uuid(),
  booking_id     uuid not null references public.consultation_bookings(id) on delete cascade,
  summary        text,
  prescription   text,
  recording_path text,                          -- opt-in saja, bucket privat
  created_at     timestamptz not null default now()
);
create index consultations_booking_id_idx on public.consultations(booking_id);
alter table public.consultations enable row level security;
-- pasien & dokter terkait boleh BACA
create policy "consultations_select" on public.consultations
  for select to authenticated using (public.can_access_booking(booking_id));
-- hanya dokter terkait yang boleh TULIS (summary/prescription)
create policy "consultations_insert_doctor" on public.consultations
  for insert to authenticated with check (public.is_doctor_of_booking(booking_id));
create policy "consultations_update_doctor" on public.consultations
  for update to authenticated
  using (public.is_doctor_of_booking(booking_id))
  with check (public.is_doctor_of_booking(booking_id));

-- eye_care_exercises
create table public.eye_care_exercises (
  id                 uuid primary key default gen_random_uuid(),
  title              text not null,
  audio_guide_path   text not null,
  duration_seconds   int not null,
  medical_disclaimer text not null
);
alter table public.eye_care_exercises enable row level security;
create policy "exercises_select_all" on public.eye_care_exercises
  for select to authenticated using (true);
create policy "exercises_write_admin" on public.eye_care_exercises
  for all to authenticated using (public.is_admin()) with check (public.is_admin());
```

---

## Blok 04 — `connect.sql`

```sql
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

-- follows (owner-managed) — P2
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
```

---

## Blok 05 — `sos_map.sql`

```sql
-- 05_sos_map.sql

-- sos_events 🔒
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

-- poi_contributions — P2
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
```

---

## Blok 06 — `grants.sql` (WAJIB jika "Automatically expose new tables" dimatikan)

> Jika saat membuat project Anda **menonaktifkan** "Automatically expose new tables" (disarankan untuk Opto), role `authenticated` belum punya privilege level-tabel. Tanpa blok ini, klien Flutter akan menerima error *permission denied* meski policy RLS sudah benar. `GRANT` membuka akses **level tabel**; **RLS** tetap menentukan **baris mana** yang boleh dilihat — keduanya wajib ada.
>
> Jika Anda membiarkan "Automatically expose new tables" tetap **aktif**, blok ini boleh dilewati (Supabase sudah meng-grant otomatis), tetapi menjalankannya tetap aman.

```sql
-- 06_grants.sql

-- Tabel public-read (katalog, tutorial, direktori dokter, POI)
grant select on public.prosthetic_products to authenticated;
grant select on public.vendors             to authenticated;
grant select on public.clinics             to authenticated;
grant select on public.care_tutorials      to authenticated;
grant select on public.eye_care_exercises  to authenticated;
grant select on public.doctors             to authenticated;
grant select on public.doctor_availability to authenticated;
grant select on public.accessibility_pois  to authenticated;

-- Tabel user-owned (write tetap dibatasi oleh RLS, bukan oleh grant)
grant select, insert, update, delete on public.profiles               to authenticated;
grant select, insert, update, delete on public.accessibility_settings to authenticated;
grant select, insert, update, delete on public.caregiver_links        to authenticated;
grant select, insert, update, delete on public.emergency_contacts     to authenticated;
grant select, insert, update, delete on public.anthropometric_data    to authenticated;
grant select, insert, update, delete on public.eye_photos             to authenticated;
grant select, insert, update, delete on public.prosthetic_orders      to authenticated;
grant select, insert, update, delete on public.care_reminders         to authenticated;
grant select, insert, update, delete on public.consultation_bookings  to authenticated;
grant select, insert, update, delete on public.consultations          to authenticated;
grant select, insert, update, delete on public.posts                  to authenticated;
grant select, insert, update, delete on public.post_media             to authenticated;
grant select, insert, update, delete on public.post_replies           to authenticated;
grant select, insert, update, delete on public.follows                to authenticated;
grant select, insert, update, delete on public.content_reports        to authenticated;
grant select, insert, update, delete on public.sos_events             to authenticated;
grant select, insert, update, delete on public.poi_contributions      to authenticated;

-- CATATAN:
-- 1) Tabel public-read hanya diberi SELECT. INSERT/UPDATE/DELETE tetap ditolak
--    untuk authenticated (hanya admin via is_admin() di policy, yang berjalan
--    dengan privilege table-level milik service_role / postgres).
-- 2) Untuk admin menulis ke katalog dari app: gunakan Edge Function (service_role),
--    bukan grant langsung ke authenticated.
-- 3) Tidak ada grant ke 'anon' — seluruh app digating di balik login.
```

---

## Blok 07 — `seed.sql` (data contoh, jalankan via SQL Editor)

> Tabel referensi publik (tanpa `user_id`) bisa diisi karena SQL Editor melewati RLS. `audio_description`/`transcript` ditulis dalam Bahasa Indonesia karena pasar target Indonesia. Skrip ini idempotent (aman dijalankan ulang) berkat `where not exists`.

```sql
-- 07_seed.sql

-- klinik + vendor
with c as (
  insert into public.clinics (name, is_manufacturer, lat, lng, address)
  select 'Klinik Mata Surya', true, -7.2575, 112.7521, 'Jl. Pemuda No. 10, Surabaya'
  where not exists (select 1 from public.clinics where name = 'Klinik Mata Surya')
  returning id
)
insert into public.vendors (name, is_verified, clinic_id)
select 'Surya Ocular Lab', true, c.id from c
where not exists (select 1 from public.vendors where name = 'Surya Ocular Lab');

-- produk katalog
insert into public.prosthetic_products
  (type, name, audio_description, material, iris_color, size, is_custom, price_idr, vendor_id, is_active)
select v.* from (values
  ('prosthesis'::public.product_type,
   'Prostesis Mata Akrilik — Cokelat',
   'Prostesis mata berbahan akrilik medis dengan iris warna cokelat. Ukuran sedang, permukaan dipoles halus untuk kenyamanan. Termasuk panduan perawatan. Harga tiga juta lima ratus ribu rupiah.',
   'Akrilik medis', 'Cokelat', 'M', false, 3500000),
  ('self_cleaning_case'::public.product_type,
   'Wadah Pembersih Otomatis',
   'Wadah penyimpan prostesis dengan fitur pembersih otomatis menggunakan larutan steril. Indikator getar saat siklus selesai. Harga delapan ratus ribu rupiah.',
   'Polipropilena', null, null, false, 800000),
  ('care_kit'::public.product_type,
   'Paket Perawatan Harian',
   'Paket berisi cairan lubrikan, kain mikrofiber, dan pinset silikon untuk perawatan harian prostesis. Harga dua ratus lima puluh ribu rupiah.',
   'Campuran', null, null, false, 250000)
) as v(type,name,audio_description,material,iris_color,size,is_custom,price_idr)
cross join (select id from public.vendors where name = 'Surya Ocular Lab' limit 1) as ven(vendor_id),
lateral (select ven.vendor_id) as vid
where not exists (select 1 from public.prosthetic_products p where p.name = v.name);

-- tutorial perawatan
insert into public.care_tutorials (title, category, transcript, sort_order)
select * from (values
  ('Memasang Prostesis', 'insert'::public.tutorial_category,
   'Cuci tangan sampai bersih. Pegang prostesis dengan sisi atas menghadap atas. Angkat kelopak mata atas, masukkan tepi atas prostesis ke bawah kelopak, lalu tarik kelopak bawah hingga prostesis masuk sempurna.', 1),
  ('Melepas Prostesis', 'remove'::public.tutorial_category,
   'Cuci tangan. Tarik kelopak mata bawah ke bawah. Gunakan pinset silikon atau jari untuk menekan tepi bawah prostesis hingga terlepas perlahan ke telapak tangan.', 2),
  ('Membersihkan Prostesis', 'clean'::public.tutorial_category,
   'Bersihkan prostesis dengan sabun lembut dan air hangat. Hindari alkohol. Bilas hingga tak ada sisa sabun lalu keringkan dengan kain mikrofiber.', 3),
  ('Memberi Lubrikan', 'lubricate'::public.tutorial_category,
   'Teteskan satu hingga dua tetes cairan lubrikan ke permukaan prostesis sebelum dipasang untuk mengurangi gesekan dan menjaga kelembapan.', 4),
  ('Menggunakan Wadah Pembersih', 'case_use'::public.tutorial_category,
   'Letakkan prostesis di dalam wadah, isi larutan steril sampai batas, tutup rapat, lalu tekan tombol untuk memulai siklus. Getaran menandakan siklus selesai.', 5)
) as t(title,category,transcript,sort_order)
where not exists (select 1 from public.care_tutorials ct where ct.title = t.title);

-- latihan perawatan mata
insert into public.eye_care_exercises (title, audio_guide_path, duration_seconds, medical_disclaimer)
select * from (values
  ('Relaksasi Mata 20-20-20', 'audio/exercise_202020.mp3', 120,
   'Latihan ini bukan pengganti pemeriksaan medis. Hentikan jika terasa nyeri dan konsultasikan ke dokter.'),
  ('Pijat Lembut Area Sekitar Mata', 'audio/exercise_massage.mp3', 180,
   'Lakukan dengan tangan bersih dan tekanan ringan. Bukan pengganti saran medis profesional.')
) as e(title,audio_guide_path,duration_seconds,medical_disclaimer)
where not exists (select 1 from public.eye_care_exercises ec where ec.title = e.title);
```

> **Seed user**: jangan `INSERT` langsung ke `auth.users`. Buat user uji lewat Dashboard → Authentication → Add user (atau OTP dari app). Trigger `handle_new_user` otomatis membuat baris `profiles` + `accessibility_settings`. Untuk menjadikan seseorang admin/doctor, ubah `profiles.role` lewat SQL Editor (mem-bypass guard role).

---

## 3. Verifikasi setelah setup

**Pastikan RLS aktif di semua tabel** — query ini harus mengembalikan 0 baris:

```sql
select tablename
from pg_tables
where schemaname = 'public' and rowsecurity = false;
```

**Cek security advisors** (penting — menangkap tabel tanpa policy, fungsi tanpa `search_path`, dll.):

- Dashboard → **Advisors** → Security, atau via CLI:

```bash
supabase db advisors
```

**Uji RLS happy-path & sad-path.** Buat dua user uji, login sebagai user A, lalu coba baca data user B — harus kosong:

```sql
-- jalankan sambil "berperan" sebagai user tertentu di SQL Editor:
-- set request.jwt.claims via Dashboard "Run as" atau uji dari app.
select * from public.emergency_contacts;   -- hanya milik sendiri yg muncul
```

Daftar policy terpasang:

```sql
select schemaname, tablename, policyname, cmd
from pg_policies
where schemaname = 'public'
order by tablename, policyname;
```

---

## 4. Catatan & langkah lanjutan (di luar scope tabel+RLS)

Sesuai pilihan, tutorial ini berhenti di tabel + enum + RLS. Yang belum dibuat dan menjadi langkah berikut:

- **Storage buckets** privat: `eye-photos`, `consultation-attachments` (signed-URL only), serta `post-media`, `tutorial-videos`. Policy bucket harus mencerminkan RLS tabel (owner-only untuk yang medis).
- **Edge Functions**: `scene-describe`, `sos-dispatch`, `send-notification`, webhook pembayaran — satu-satunya tempat `service_role` key dipakai.
- **Realtime channels**: feed Connect, streaming lokasi SOS (scope per-event), signaling WebRTC konsultasi.
- **Akses-baca okularis** ke `anthropometric_data`/`eye_photos` memerlukan kolom assignee pada `prosthetic_orders` (atau lewat Edge Function). Saat ini saya pertahankan owner-only agar tidak melonggarkan data 🔒 secara tak sengaja.
- **Eksposur Data API**: karena "Automatically expose new tables" dimatikan, akses level-tabel diberikan lewat **Blok 06 (`grants.sql`)**. Jika sebuah tabel baru ditambahkan kemudian, tambahkan `GRANT`-nya di migrasi yang sama.

Jika nanti Anda ingin saya lanjutkan ke salah satu poin di atas (mis. policy Storage bucket, atau kontrak tipe Dart per tabel agar mapping `freezed` 1:1), sebutkan saja modulnya.
