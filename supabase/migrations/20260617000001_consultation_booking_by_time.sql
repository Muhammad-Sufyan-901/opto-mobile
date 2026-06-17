-- consultation_booking_by_time.sql
--
-- Switches the booking RPC from "book by slot UUID" to "book by desired start
-- time".  The previous RPC required the client to send a real `doctor_availability.id`
-- (UUID), but the booking screen synthesises synthetic non-UUID slot ids
-- ('mock-…', 'manual-…') whenever the doctor has no published availability or
-- the patient enters an arbitrary time — causing SQLSTATE 22P02 (invalid uuid).
--
-- The new RPC accepts a timestamp and resolves-or-creates the
-- `doctor_availability` row server-side, then books it atomically.
--
-- A unique index on (doctor_id, slot_start) ensures the resolve-or-create is
-- race-safe and never produces duplicate availability entries.

-- De-dupe guard (idempotent — IF NOT EXISTS).
create unique index if not exists doctor_availability_doctor_slot_uniq
  on public.doctor_availability (doctor_id, slot_start);

-- Drop the uuid-based overload added in migration 20260617000000.
drop function if exists
  public.create_consultation_booking(uuid, uuid, public.consult_mode, boolean);

-- New overload: books by timestamp instead of slot UUID.
create or replace function public.create_consultation_booking(
  _doctor_id        uuid,
  _slot_start       timestamptz,
  _mode             public.consult_mode,
  _booked_via_voice boolean default false
)
returns public.consultation_bookings
language plpgsql
security definer
set search_path = ''
as $$
declare
  _uid     uuid := (select auth.uid());
  _slot_id uuid;
  _row     public.consultation_bookings;
begin
  if _uid is null then
    raise exception 'not authenticated' using errcode = '42501';
  end if;

  -- Resolve an existing slot for this doctor at the requested start (locked).
  select id into _slot_id
    from public.doctor_availability
   where doctor_id = _doctor_id and slot_start = _slot_start
   for update;

  if _slot_id is null then
    -- No published slot at this time — create one (30-min default duration).
    -- SECURITY DEFINER allows inserting doctor-owned rows without the patient
    -- holding an INSERT grant on doctor_availability.
    insert into public.doctor_availability (doctor_id, slot_start, slot_end, is_booked)
    values (_doctor_id, _slot_start, _slot_start + interval '30 minutes', false)
    returning id into _slot_id;

  elsif exists (
    select 1 from public.doctor_availability
     where id = _slot_id and is_booked
  ) then
    -- Existing slot already taken → mapped to ConflictFailure client-side.
    raise exception 'slot unavailable' using errcode = '23505';
  end if;

  insert into public.consultation_bookings
    (user_id, doctor_id, slot_id, mode, booked_via_voice)
  values (_uid, _doctor_id, _slot_id, _mode, _booked_via_voice)
  returning * into _row;

  update public.doctor_availability set is_booked = true where id = _slot_id;

  return _row;
end;
$$;

grant execute on function
  public.create_consultation_booking(uuid, timestamptz, public.consult_mode, boolean)
  to authenticated;

revoke execute on function
  public.create_consultation_booking(uuid, timestamptz, public.consult_mode, boolean)
  from anon;
