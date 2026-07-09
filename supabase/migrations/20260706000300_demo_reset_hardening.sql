-- Keep demo reset in sync with new tables and document intent.

create or replace function public.organizer_reset_demo()
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if public.current_user_role() <> 'organizer' then
    raise exception 'Only organizers can reset demo data';
  end if;

  delete from public.scores;
  delete from public.notifications;
  delete from public.messages;
  delete from public.submission_history;
  delete from public.submissions;
  delete from public.team_invitations;
  delete from public.team_members;
  delete from public.teams;
  delete from public.event_mentors;
  delete from public.score_criteria;
  delete from public.events;
end;
$$;

revoke all on function public.organizer_reset_demo() from public;
grant execute on function public.organizer_reset_demo() to authenticated;
