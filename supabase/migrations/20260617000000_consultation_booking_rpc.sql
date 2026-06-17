-- consultation_booking_rpc.sql
--
-- Replaces the non-atomic two-step write (INSERT booking + UPDATE slot flag)
-- that the Flutter client previously executed directly. Because `authenticated`
-- holds only SELECT on `doctor_availability` (intentional — patients must never
-- mutate slot records), the previous UPDATE raised SQLSTATE 42501 and surfaced
-- as "Anda tidak memiliki izin untuk melakukan tindakan ini." to the user.
--
-- This SECURITY DEFINER function runs as the migration owner, bypassing the
-- table-level grant gap, but always uses auth.uid() as the booking owner so a
-- caller can only book on their own behalf.  The SELECT … FOR UPDATE makes the
-- availability check + flag-flip atomic (no double-booking race).

create or replace function public.create_consultation_booking(
  _doctor_id        uuid,
  _slot_id          uuid,
  _mode             public.consult_mode,
  _booked_via_voice boolean default false
)
returns public.consultation_bookings
language plpgsql
security definer
set search_path = ''
as $$
declare
  _uid uuid := (select auth.uid());
  _row public.consultation_bookings;
begin
  if _uid is null then
    raise exception 'not authenticated' using errcode = '42501';
  end if;

  -- Lock the row; verify the slot belongs to the requested doctor and is free.
  -- FOR UPDATE ensures no concurrent booking can slip in between the check and
  -- the subsequent INSERT + UPDATE.
  perform 1
    from public.doctor_availability
   where id = _slot_id
     and doctor_id = _doctor_id
     and is_booked = false
   for update;

  if not found then
    -- Reuse errcode 23505 so the Flutter client's existing handler in
    -- ConsultationRemoteDataSourceImpl.createBooking (lines 200-203) surfaces
    -- the friendly "Slot sudah dipesan oleh pasien lain." ConflictFailure.
    raise exception 'slot unavailable' using errcode = '23505';
  end if;

  insert into public.consultation_bookings
    (user_id, doctor_id, slot_id, mode, booked_via_voice)
  values (_uid, _doctor_id, _slot_id, _mode, _booked_via_voice)
  returning * into _row;

  update public.doctor_availability
     set is_booked = true
   where id = _slot_id;

  return _row;
end;
$$;

-- Allow authenticated users (patients) to call this RPC; deny anon entirely.
grant execute on function
  public.create_consultation_booking(uuid, uuid, public.consult_mode, boolean)
  to authenticated;

revoke execute on function
  public.create_consultation_booking(uuid, uuid, public.consult_mode, boolean)
  from anon;
