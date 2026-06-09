-- fix_anon_rpc.sql
-- is_admin() and is_active_caregiver() were revoked FROM anon in the previous
-- migration, but anon still inherits EXECUTE through the PUBLIC role.
-- Revoke from PUBLIC entirely, then grant explicitly to authenticated only.
-- Flutter clients can still call rpc('is_admin') when signed in; anon cannot.

revoke execute on function public.is_admin() from public;
grant  execute on function public.is_admin() to authenticated;

revoke execute on function public.is_active_caregiver(uuid, text) from public;
grant  execute on function public.is_active_caregiver(uuid, text) to authenticated;
