-- 20260616000002_supplies_catalog_seed.sql
-- Seed 5 curated supply products for the Opto prosthetic hub supply catalog.
-- Deactivates the two old generic accessory rows that would otherwise appear
-- as duplicates in the catalog (the prosthesis row stays active for the
-- custom-order flow).
--
-- Depends on: 20260616000001_supplies_catalog_extend.sql
-- (enum values 'solution', 'cloth', 'storage_case' must already exist)

-- =========================================================
-- Deactivate old generic accessory rows
-- =========================================================
-- These were seeded in seed.sql under the old schema and no longer represent
-- the curated catalog entries. Deactivating (rather than deleting) preserves
-- any referential integrity with existing orders.

update public.prosthetic_products
set is_active = false
where name in ('Wadah Pembersih Otomatis', 'Paket Perawatan Harian');

-- =========================================================
-- Insert 5 curated supply products (idempotent)
-- =========================================================
-- Matches exactly the data returned by SuppliesRepositoryMock.getProducts().
-- The `where not exists` guard makes this safe to re-run.

insert into public.prosthetic_products
  (type, name, audio_description, material, is_custom, price_idr, is_active, image_path)
select
  v.type::public.product_type,
  v.name,
  v.audio_description,
  v.material,
  v.is_custom,
  v.price_idr,
  true, -- is_active: always true for seeded catalog products (not part of each VALUES row)
  v.image_path
from (values
  ('solution',
   'Daily Cleaning Solution',
   'Saline-based daily cleaning solution for ocular prostheses. 100ml bottle. Alcohol-free.',
   'Saline',
   false,
   45000,
   'daily_cleaning_solution.png'),
  ('self_cleaning_case',
   'Premium Self-Cleaning Case',
   'Ultrasonic self-cleaning case for overnight care. USB-rechargeable. Includes solution refill.',
   'Polypropylene',
   false,
   350000,
   'self_cleaning_case.png'),
  ('storage_case',
   'Standard Storage Case',
   'Hard-shell storage case with padded interior. Fits all standard ocular prostheses.',
   'ABS Plastic',
   false,
   85000,
   'standard_storage_case.png'),
  ('care_kit',
   'Prosthetic Care Kit',
   'Complete starter kit: cleaning solution, storage case, and microfiber cloth. Recommended for new users.',
   'Mixed',
   false,
   195000,
   'prosthetic_care_kit.png'),
  ('cloth',
   'Microfiber Cleaning Cloth',
   'Ultra-soft microfiber cloth, lint-free. Pack of 5. Safe for lens surfaces.',
   'Microfiber',
   false,
   25000,
   'microfiber_cleaning_cloth.png')
) as v(type, name, audio_description, material, is_custom, price_idr, image_path)
where not exists (
  select 1 from public.prosthetic_products p where p.name = v.name
);
