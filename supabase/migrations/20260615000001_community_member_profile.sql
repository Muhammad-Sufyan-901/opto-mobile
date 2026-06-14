-- Add bio, handle, is_mentor to profiles
alter table public.profiles
  add column if not exists bio       text,
  add column if not exists handle    text unique,
  add column if not exists is_mentor boolean not null default false;

-- RPC: aggregate community stats for a member in one call
create or replace function public.community_member_stats(_member_id uuid)
returns table(posts_count int, helpful_count int, circles_count int)
language sql
security definer
set search_path = ''
stable
as $$
  select
    (select count(*)::int from public.posts p where p.author_id = _member_id),
    (select count(*)::int from public.post_likes pl
       join public.posts p on p.id = pl.post_id
       where p.author_id = _member_id),
    (select count(*)::int from public.circle_members cm where cm.member_id = _member_id);
$$;

grant execute on function public.community_member_stats(uuid) to authenticated;
