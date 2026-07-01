-- 20260701000001_consultation_messages_grants.sql
-- consultation_messages (20260701000000) added RLS policies but omitted the
-- base table-level GRANT. Auto-expose is OFF on this project (see
-- 20260609021207_grants.sql / 20260614000001_community_profiles_public_read.sql),
-- so PostgREST rejects all access with 42501 until the role is granted
-- privileges explicitly. RLS still restricts rows via can_access_booking().

grant select, insert on public.consultation_messages to authenticated;
