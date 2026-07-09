-- P0: demo reset must not delete user accounts; tighten invitation notification RLS.

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

drop policy if exists "Authenticated users can create notifications" on public.notifications;

create policy "Authenticated users can create notifications"
on public.notifications for insert
to authenticated
with check (
  notification_type not in ('score', 'reminder')
  and (
    user_id = auth.uid()
    or (
      notification_type = 'announcement'
      and public.current_user_role() = 'organizer'
    )
    or (
      notification_type = 'invitation'
      and exists (
        select 1
        from public.team_invitations ti
        where ti.inviter_id = auth.uid()
          and ti.invitee_id = notifications.user_id
          and ti.status = 'pending'
      )
    )
    or (
      notification_type = 'system'
      and exists (
        select 1
        from public.team_members sender
        join public.team_members recipient
          on recipient.team_id = sender.team_id
        where sender.user_id = auth.uid()
          and recipient.user_id = notifications.user_id
      )
    )
  )
);
