-- 20260630000000_prosthetic_orders_payment.sql
--
-- Adds shipping address + payment columns to prosthetic_orders.
-- Existing rows (status='draft') are unaffected — all new columns are nullable
-- or have safe defaults.

-- ── New enum types ──────────────────────────────────────────────────────────

create type public.payment_method as enum ('virtual_account', 'cod');
create type public.payment_status as enum ('pending', 'paid', 'cancelled');

-- ── Extend prosthetic_orders ────────────────────────────────────────────────
-- order_group_id: ties all line-item rows of one checkout together so address
-- and payment are shared across a multi-product order.

alter table public.prosthetic_orders
  add column order_group_id     uuid,
  add column payment_method     public.payment_method,
  add column payment_status     public.payment_status not null default 'pending',
  add column virtual_account_no text,
  add column recipient_name     text,
  add column recipient_phone    text,
  add column shipping_address   text,
  add column shipping_city      text,
  add column shipping_postal_code text;

-- Index for grouping queries (e.g. "all rows for this checkout").
create index prosthetic_orders_group_id_idx
  on public.prosthetic_orders(order_group_id)
  where order_group_id is not null;

-- No new RLS policies required: existing orders_select / orders_insert_own /
-- orders_update policies already gate on user_id and cover the new columns.
-- virtual_account_no is owner-data — never expose in admin/vendor joins beyond
-- what the existing select policy grants.
