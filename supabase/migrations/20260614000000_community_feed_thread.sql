-- 20260614000000_community_feed_thread.sql
-- Extends the Connect (Community) feature with:
--   • posts: title, topic, voice_url columns.
--   • post_replies: parent_reply_id (one-level nesting), is_best_answer, voice_url.
--   • profiles: is_verified flag (community-visible; distinct from role).
-- RLS: best-answer can only be set by the OP author.

-- ─── profiles: community-visible verified badge ───────────────────────────────
alter table public.profiles
  add column if not exists is_verified boolean not null default false;

-- ─── posts: richer content model ─────────────────────────────────────────────
alter table public.posts
  add column if not exists title     text,           -- nullable; short heading
  add column if not exists topic     text,           -- nullable; matches chip filter labels
  add column if not exists voice_url text;           -- nullable; voice-dictated recording URL

-- Optional: index for topic-filtered feed queries.
create index if not exists posts_topic_idx on public.posts(topic)
  where topic is not null;

-- ─── post_replies: nesting + best-answer + voice ──────────────────────────────
alter table public.post_replies
  add column if not exists parent_reply_id uuid
    references public.post_replies(id) on delete cascade,  -- one-level nesting
  add column if not exists is_best_answer  boolean not null default false,
  add column if not exists voice_url       text;

-- Enforce at most one best-answer per post.
create unique index if not exists post_replies_best_answer_unique
  on public.post_replies(post_id)
  where is_best_answer = true;

-- Index for threading queries (nested replies under a parent).
create index if not exists post_replies_parent_idx on public.post_replies(parent_reply_id)
  where parent_reply_id is not null;

-- ─── RLS: best-answer can only be set by the OP author ───────────────────────
-- Add an UPDATE policy on post_replies so only the parent-post author can flip
-- is_best_answer. The existing replies_delete_own_or_admin policy covers deletes;
-- there was no UPDATE policy before, so this is additive.
create policy "replies_update_best_answer_by_post_author" on public.post_replies
  for update to authenticated
  using (
    exists (
      select 1 from public.posts p
      where p.id = post_replies.post_id
        and p.author_id = (select auth.uid())
    )
  )
  with check (
    exists (
      select 1 from public.posts p
      where p.id = post_replies.post_id
        and p.author_id = (select auth.uid())
    )
  );
