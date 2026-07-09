-- P0 business logic fixes: notification RLS hardening and team max size enforcement.

-- Score/reminder notifications are created only by server-side triggers.
drop policy if exists "Authenticated users can create notifications" on notifications;

create policy "Authenticated users can create notifications"
on notifications for insert
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
        from public.teams t
        where t.leader_id = auth.uid()
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

create or replace function public.enforce_team_max_size()
returns trigger
language plpgsql
set search_path = public
as $$
declare
  v_max_size integer;
  v_member_count integer;
begin
  select e.max_team_size
  into v_max_size
  from public.teams t
  join public.events e on e.id = t.event_id
  where t.id = new.team_id;

  if v_max_size is null or v_max_size <= 0 then
    return new;
  end if;

  select count(*)
  into v_member_count
  from public.team_members tm
  where tm.team_id = new.team_id;

  if v_member_count >= v_max_size then
    raise exception 'Team has reached the maximum size of % members.', v_max_size;
  end if;

  return new;
end;
$$;

drop trigger if exists team_members_max_size on public.team_members;
create trigger team_members_max_size
before insert on public.team_members
for each row execute function public.enforce_team_max_size();

grant execute on function public.enforce_team_max_size() to authenticated;
