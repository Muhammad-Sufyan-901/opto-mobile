-- 20260610000001_realtime.sql
-- B2-2: Enable Supabase Realtime on tables needed by Connect, SOS, and Consultation features
-- Realtime allows clients to subscribe to live row changes via websocket, subject to RLS policies
-- NOTE: RLS policies STILL APPLY on all Realtime subscriptions — these ALTER PUBLICATION commands
--       just allow the tables to emit change events. Scoping (e.g., filter by user_id) must be
--       enforced by the client's Realtime subscription channel filter.

-- =========================================================
-- Connect (Community) — live feed
-- =========================================================
-- Enable Realtime on posts so new posts appear immediately in the feed
alter publication supabase_realtime add table public.posts;

-- Enable Realtime on post_replies so new replies appear immediately
alter publication supabase_realtime add table public.post_replies;

-- =========================================================
-- SOS (Emergency) — active event dispatch
-- =========================================================
-- Enable Realtime on sos_events for live status and location updates to caregivers
-- 🔒 MEDICALLY SENSITIVE: sos_events is owner-only and active-caregiver visible per RLS.
--    Clients MUST use a scoped Realtime channel (filter by user_id) to avoid broadcasting
--    sensitive location/status data. The RLS policy is enforced by Supabase; the client
--    is responsible for correct subscription filtering.
alter publication supabase_realtime add table public.sos_events;

-- =========================================================
-- Consultation — WebRTC signaling
-- =========================================================
-- Enable Realtime on consultation_bookings so booking status updates (e.g., ready for WebRTC)
-- propagate immediately to both patient and doctor
-- 🔒 MEDICALLY SENSITIVE: consultation_bookings contains patient data and must be filtered
--    per patient/doctor pair. Clients MUST use a scoped Realtime channel to avoid leaking
--    booking info across users. The RLS policy is enforced; the client filters at subscribe time.
alter publication supabase_realtime add table public.consultation_bookings;
