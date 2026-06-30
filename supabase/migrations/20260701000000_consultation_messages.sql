-- 20260701000000_consultation_messages.sql
-- Adds the consultation_messages table for Text-Chat consultation sessions.
--
-- 🔒 MEDICALLY SENSITIVE: Messages are part of doctor-patient consultations.
--    Access is restricted to the patient and the assigned doctor via RLS,
--    reusing the existing can_access_booking() SECURITY DEFINER helper.
--    This table must NEVER be joined into catalog, community/map, or public
--    queries.  Realtime is enabled so both parties receive live message delivery,
--    but clients MUST filter by booking_id at subscription time.

-- ── Table ────────────────────────────────────────────────────────────────────

create table public.consultation_messages (
  id          uuid        primary key default gen_random_uuid(),
  booking_id  uuid        not null references public.consultation_bookings(id) on delete cascade,
  sender_id   uuid        not null references public.profiles(id) on delete cascade,
  body        text        not null,
  created_at  timestamptz not null default now()
);

create index consultation_messages_booking_id_idx on public.consultation_messages(booking_id);
create index consultation_messages_created_at_idx  on public.consultation_messages(created_at);

alter table public.consultation_messages enable row level security;

-- ── RLS policies ─────────────────────────────────────────────────────────────
-- Reuse public.can_access_booking(_booking_id) defined in
-- 20260609020327_consultation.sql — returns true for the patient (user_id) and
-- the assigned doctor (owns_doctor(doctor_id)).

-- Patient and assigned doctor may read all messages for a booking they own.
create policy "consult_messages_select" on public.consultation_messages
  for select to authenticated
  using (public.can_access_booking(booking_id));

-- Either party may insert messages, but only as themselves (sender_id = auth.uid()).
create policy "consult_messages_insert" on public.consultation_messages
  for insert to authenticated
  with check (
    public.can_access_booking(booking_id)
    and sender_id = (select auth.uid())
  );

-- No UPDATE or DELETE policies — messages are immutable once sent.

-- ── Realtime ─────────────────────────────────────────────────────────────────
-- Mirrors 20260610000001_realtime.sql pattern.  RLS still applies on all
-- Realtime subscriptions.  Clients must subscribe with a channel filter
-- (eq('booking_id', <id>)) to avoid receiving messages from other bookings.
alter publication supabase_realtime add table public.consultation_messages;
