-- 20260610000000_storage_buckets.sql
-- B2-1: Create private Supabase Storage buckets with full RLS policies
-- Buckets: eye-photos (🔒 medically sensitive), consultation-attachments (🔒 medically sensitive)
-- Each bucket enforces owner-only read/write/update via storage.objects policies

-- =========================================================
-- Create private storage buckets (if not exists)
-- =========================================================

-- eye-photos: private bucket for iris/prosthetic match photos and consultations
insert into storage.buckets (id, name, public)
values ('eye-photos', 'eye-photos', false)
on conflict do nothing;

-- consultation-attachments: private bucket for consultation documents/receipts
insert into storage.buckets (id, name, public)
values ('consultation-attachments', 'consultation-attachments', false)
on conflict do nothing;

-- =========================================================
-- RLS Policies for eye-photos bucket
-- =========================================================
-- Note: storage.objects RLS is already enabled by default.
-- We need INSERT + SELECT + UPDATE for upsert operations to work.
-- Without UPDATE policy, file replacement silently fails.

-- Owner can upload to eye-photos
-- Note: auth.uid() is uuid; owner column in storage.objects is also uuid.
-- Do NOT cast auth.uid()::text — that produces "operator does not exist: text = uuid".
create policy "Owner can upload to eye-photos"
  on storage.objects
  for insert to authenticated
  with check (bucket_id = 'eye-photos' and auth.uid() = owner);

-- Owner can read (download) from eye-photos
create policy "Owner can read eye-photos"
  on storage.objects
  for select to authenticated
  using (bucket_id = 'eye-photos' and auth.uid() = owner);

-- Owner can update (upsert) in eye-photos
-- CRITICAL: Both USING and WITH CHECK required for UPDATE to work
create policy "Owner can update eye-photos"
  on storage.objects
  for update to authenticated
  using (bucket_id = 'eye-photos' and auth.uid() = owner)
  with check (bucket_id = 'eye-photos' and auth.uid() = owner);

-- =========================================================
-- RLS Policies for consultation-attachments bucket
-- =========================================================
-- Same ownership model as eye-photos

-- Owner can upload to consultation-attachments
create policy "Owner can upload to consultation-attachments"
  on storage.objects
  for insert to authenticated
  with check (bucket_id = 'consultation-attachments' and auth.uid() = owner);

-- Owner can read (download) from consultation-attachments
create policy "Owner can read consultation-attachments"
  on storage.objects
  for select to authenticated
  using (bucket_id = 'consultation-attachments' and auth.uid() = owner);

-- Owner can update (upsert) in consultation-attachments
-- CRITICAL: Both USING and WITH CHECK required for UPDATE to work
create policy "Owner can update consultation-attachments"
  on storage.objects
  for update to authenticated
  using (bucket_id = 'consultation-attachments' and auth.uid() = owner)
  with check (bucket_id = 'consultation-attachments' and auth.uid() = owner);
