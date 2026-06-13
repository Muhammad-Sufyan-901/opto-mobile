-- 07_seed.sql
-- Reference data for catalog tables. Idempotent (where not exists).
-- Run via SQL Editor or psql after db push — not auto-applied to remote by db push.
-- SQL Editor runs as postgres role, bypassing RLS, so inserts succeed even with strict policies.

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
select v.type, v.name, v.audio_description, v.material, v.iris_color, v.size, v.is_custom, v.price_idr, ven.vendor_id, true
from (values
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
cross join (select id as vendor_id from public.vendors where name = 'Surya Ocular Lab' limit 1) as ven
where not exists (select 1 from public.prosthetic_products p where p.name = v.name);

-- tutorial perawatan
insert into public.care_tutorials (title, category, transcript, sort_order)
select t.title, t.category, t.transcript, t.sort_order
from (values
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
select e.title, e.audio_guide_path, e.duration_seconds, e.medical_disclaimer
from (values
  ('Relaksasi Mata 20-20-20', 'audio/exercise_202020.mp3', 120,
   'Latihan ini bukan pengganti pemeriksaan medis. Hentikan jika terasa nyeri dan konsultasikan ke dokter.'),
  ('Pijat Lembut Area Sekitar Mata', 'audio/exercise_massage.mp3', 180,
   'Lakukan dengan tangan bersih dan tekanan ringan. Bukan pengganti saran medis profesional.')
) as e(title,audio_guide_path,duration_seconds,medical_disclaimer)
where not exists (select 1 from public.eye_care_exercises ec where ec.title = e.title);

-- ─────────────────────────────────────────────────────────────────────────────
-- Dokter & jadwal konsultasi
-- ─────────────────────────────────────────────────────────────────────────────
-- Inserts 3 sample doctors into auth.users (fixed UUIDs → idempotent).
-- The on_auth_user_created trigger (handle_new_user) automatically creates the
-- matching public.profiles rows with full_name from raw_user_meta_data.
--
-- Dev-only password for all seed doctors: OptoDoc@2026!
-- ⚠️  Never use these accounts or this password in production.

insert into auth.users (
  id, instance_id, aud, role,
  email, encrypted_password, email_confirmed_at,
  created_at, updated_at,
  raw_app_meta_data, raw_user_meta_data
)
values
  (
    'd9f4a3b2-1c5e-4d7f-8a09-6b3e2c1d0f5a',
    '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated',
    'dr.andi@opto.dev',
    crypt('OptoDoc@2026!', gen_salt('bf', 10)),
    now(), now(), now(),
    '{"provider":"email","providers":["email"]}'::jsonb,
    '{"full_name":"dr. Andi Pratama, Sp.M"}'::jsonb
  ),
  (
    'e8c3b2a1-0d4f-5e6c-9b07-5a2d1c0e3f4b',
    '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated',
    'dr.siti@opto.dev',
    crypt('OptoDoc@2026!', gen_salt('bf', 10)),
    now(), now(), now(),
    '{"provider":"email","providers":["email"]}'::jsonb,
    '{"full_name":"dr. Siti Rahayu, Sp.M"}'::jsonb
  ),
  (
    'f7b2a190-9e3d-4c5b-8a06-4c1b0e9d2f3c',
    '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated',
    'ahmad.okularis@opto.dev',
    crypt('OptoDoc@2026!', gen_salt('bf', 10)),
    now(), now(), now(),
    '{"provider":"email","providers":["email"]}'::jsonb,
    '{"full_name":"Ahmad Fauzi, Okularis"}'::jsonb
  )
on conflict (id) do nothing;

-- Set role = 'doctor' on the auto-created profiles.
-- The prevent_role_change trigger calls is_admin() → auth.uid(), which returns
-- null under the postgres seed role, so is_admin() = false and the trigger
-- would raise an exception. Disable it for this update only, then re-enable.
alter table public.profiles disable trigger profiles_no_role_escalation;
update public.profiles
set role = 'doctor'
where id in (
  'd9f4a3b2-1c5e-4d7f-8a09-6b3e2c1d0f5a',
  'e8c3b2a1-0d4f-5e6c-9b07-5a2d1c0e3f4b',
  'f7b2a190-9e3d-4c5b-8a06-4c1b0e9d2f3c'
)
  and role <> 'doctor'; -- skip if already set (idempotent)
alter table public.profiles enable trigger profiles_no_role_escalation;

-- Insert doctor rows. Cross-join with the seeded clinic so clinic_id is
-- resolved by name (not hardcoded UUID).
insert into public.doctors (profile_id, specialty, clinic_id, is_verified)
select v.profile_id::uuid, v.specialty, c.id, true
from (values
  ('d9f4a3b2-1c5e-4d7f-8a09-6b3e2c1d0f5a', 'Spesialis Mata'),
  ('e8c3b2a1-0d4f-5e6c-9b07-5a2d1c0e3f4b', 'Spesialis Mata'),
  ('f7b2a190-9e3d-4c5b-8a06-4c1b0e9d2f3c', 'Okularis')
) as v(profile_id, specialty)
cross join (select id from public.clinics where name = 'Klinik Mata Surya' limit 1) as c
where not exists (
  select 1 from public.doctors d where d.profile_id = v.profile_id::uuid
);

-- Insert availability slots (3 per doctor, spread over the next 10 days).
-- Idempotent: entire insert skipped if the doctor already has any slots.
insert into public.doctor_availability (doctor_id, slot_start, slot_end, is_booked)
select d.id, v.slot_start, v.slot_end, false
from public.doctors d
join (values
  ('d9f4a3b2-1c5e-4d7f-8a09-6b3e2c1d0f5a'::uuid,
   now() + interval '3 days'  + interval '9 hours',
   now() + interval '3 days'  + interval '10 hours'),
  ('d9f4a3b2-1c5e-4d7f-8a09-6b3e2c1d0f5a'::uuid,
   now() + interval '5 days'  + interval '14 hours',
   now() + interval '5 days'  + interval '15 hours'),
  ('d9f4a3b2-1c5e-4d7f-8a09-6b3e2c1d0f5a'::uuid,
   now() + interval '8 days'  + interval '10 hours',
   now() + interval '8 days'  + interval '11 hours'),
  ('e8c3b2a1-0d4f-5e6c-9b07-5a2d1c0e3f4b'::uuid,
   now() + interval '2 days'  + interval '8 hours',
   now() + interval '2 days'  + interval '9 hours'),
  ('e8c3b2a1-0d4f-5e6c-9b07-5a2d1c0e3f4b'::uuid,
   now() + interval '4 days'  + interval '13 hours',
   now() + interval '4 days'  + interval '14 hours'),
  ('e8c3b2a1-0d4f-5e6c-9b07-5a2d1c0e3f4b'::uuid,
   now() + interval '9 days'  + interval '9 hours',
   now() + interval '9 days'  + interval '10 hours'),
  ('f7b2a190-9e3d-4c5b-8a06-4c1b0e9d2f3c'::uuid,
   now() + interval '1 day'   + interval '10 hours',
   now() + interval '1 day'   + interval '11 hours'),
  ('f7b2a190-9e3d-4c5b-8a06-4c1b0e9d2f3c'::uuid,
   now() + interval '6 days'  + interval '11 hours',
   now() + interval '6 days'  + interval '12 hours'),
  ('f7b2a190-9e3d-4c5b-8a06-4c1b0e9d2f3c'::uuid,
   now() + interval '10 days' + interval '14 hours',
   now() + interval '10 days' + interval '15 hours')
) as v(profile_id, slot_start, slot_end) on d.profile_id = v.profile_id
where not exists (
  select 1 from public.doctor_availability da where da.doctor_id = d.id
);

-- ─────────────────────────────────────────────────────────────────────────────
-- Accessibility POIs — Surabaya seed
-- ─────────────────────────────────────────────────────────────────────────────
-- 5 initial POIs so the map is not empty on first launch.
-- created_by = null (nullable FK, on delete set null) — seeded by system.
-- attributes jsonb keys match the attributes read aloud by Aura in
-- accessibility_map/data/datasources/map_remote_data_source.dart.

insert into public.accessibility_pois (name, lat, lng, attributes, verified_count, created_by)
select p.name, p.lat, p.lng, p.attributes::jsonb, p.verified_count, null
from (values
  ('Stasiun Surabaya Gubeng',
   -7.2649, 112.7508,
   '{"ramp":true,"elevator":true,"tactile_path":true,"wheelchair":true,"accessible_toilet":false}',
   3),
  ('RS Mata Undaan Surabaya',
   -7.2510, 112.7438,
   '{"ramp":true,"elevator":false,"tactile_path":true,"wheelchair":true,"accessible_toilet":true}',
   2),
  ('Tunjungan Plaza Surabaya',
   -7.2575, 112.7380,
   '{"ramp":true,"elevator":true,"tactile_path":false,"wheelchair":true,"accessible_toilet":true}',
   5),
  ('Taman Bungkul',
   -7.2937, 112.7376,
   '{"ramp":true,"elevator":false,"tactile_path":true,"wheelchair":true,"accessible_toilet":true}',
   4),
  ('Bandara Juanda Terminal 1',
   -7.3799, 112.7867,
   '{"ramp":true,"elevator":true,"tactile_path":true,"wheelchair":true,"accessible_toilet":true}',
   8)
) as p(name, lat, lng, attributes, verified_count)
where not exists (
  select 1 from public.accessibility_pois poi where poi.name = p.name
);
