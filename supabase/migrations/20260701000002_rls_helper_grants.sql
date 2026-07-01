-- 20260701000002_rls_helper_grants.sql
-- 20260609021350_security_remediation.sql revoked EXECUTE on these RLS helper
-- functions from PUBLIC (to stop them being callable as REST RPC endpoints),
-- stating the intent to "re-grant selectively" — but never added the re-grant.
--
-- RLS policies invoke these functions using the querying role's own
-- privileges (SECURITY DEFINER only changes whose privileges the function
-- BODY runs with, not who may call it), so every policy using them has been
-- rejected with 42501 for the `authenticated` role ever since. Re-grant
-- EXECUTE to authenticated only — anon still has no access.

grant execute on function public.owns_doctor(uuid)          to authenticated;
grant execute on function public.can_access_booking(uuid)   to authenticated;
grant execute on function public.is_doctor_of_booking(uuid) to authenticated;
grant execute on function public.owns_post(uuid)             to authenticated;
