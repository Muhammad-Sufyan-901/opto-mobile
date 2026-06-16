-- 20260616000001_supplies_catalog_extend.sql
-- Extend product_type enum with new supply catalog values, add image_path column,
-- and create a public storage bucket for product images.
--
-- NOTE: ALTER TYPE ... ADD VALUE cannot be used in the same transaction as
-- statements that depend on the new enum values. This migration file handles
-- only the DDL (enum extension, column addition, bucket creation).
-- The seed INSERT that uses the new enum values lives in the next migration
-- (20260616000002_supplies_catalog_seed.sql).

-- =========================================================
-- Extend product_type enum
-- =========================================================

alter type public.product_type add value if not exists 'solution';
alter type public.product_type add value if not exists 'cloth';
alter type public.product_type add value if not exists 'storage_case';

-- =========================================================
-- Add image_path column to prosthetic_products
-- =========================================================
-- Nullable: not all products (e.g. custom prosthesis orders) have a catalog image.
-- Stores the Storage object key (filename) within the product-images bucket.

alter table public.prosthetic_products
  add column if not exists image_path text;

-- =========================================================
-- Create public storage bucket for product images
-- =========================================================
-- Public bucket: no RLS policies needed — images are accessible to anyone
-- with the public URL (consistent with the product catalog being readable
-- by all authenticated users via the products_select_active policy).

insert into storage.buckets (id, name, public)
values ('product-images', 'product-images', true)
on conflict do nothing;
