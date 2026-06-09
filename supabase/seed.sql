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
