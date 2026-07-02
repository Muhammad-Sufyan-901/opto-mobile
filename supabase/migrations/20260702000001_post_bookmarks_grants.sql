-- 20260702000001_post_bookmarks_grants.sql
-- Fixes a `42501` (permission denied) error blocking My Activity / bookmark
-- toggling: "Automatically expose new tables" is OFF on this project, so
-- every table needs an explicit table-level GRANT in addition to its RLS
-- policies (see 20260609021207_grants.sql, and the identical bug already hit
-- once for post_likes in 20260614000001_community_profiles_public_read.sql).
--
-- 20260702000000_post_bookmarks.sql added post_bookmarks with RLS policies
-- but no GRANT, so PostgREST rejected all select/insert/delete calls from the
-- Flutter client — including the read that powers My Activity's "Saved" tab.

grant select, insert, delete on public.post_bookmarks to authenticated;
