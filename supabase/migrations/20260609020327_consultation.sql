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

-- consultations (riwayat & resep)
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
