-- One participant may belong to at most one team per hackathon event.

create or replace function public.enforce_one_team_per_event_per_user()
returns trigger
language plpgsql
set search_path = public
as $$
declare
  v_event_id uuid;
  v_existing_team_id uuid;
begin
  select event_id
  into v_event_id
  from public.teams
  where id = new.team_id;

  if v_event_id is null then
    return new;
  end if;

  select tm.team_id
  into v_existing_team_id
  from public.team_members tm
  join public.teams t on t.id = tm.team_id
  where tm.user_id = new.user_id
    and t.event_id = v_event_id
    and tm.team_id <> new.team_id
  limit 1;

  if v_existing_team_id is not null then
    raise exception 'User is already on a team for this event.';
  end if;

  return new;
end;
$$;

create or replace function public.enforce_leader_one_team_per_event()
returns trigger
language plpgsql
set search_path = public
as $$
declare
  v_existing_team_id uuid;
begin
  if new.leader_id is null or new.event_id is null then
    return new;
  end if;

  select tm.team_id
  into v_existing_team_id
  from public.team_members tm
  join public.teams t on t.id = tm.team_id
  where tm.user_id = new.leader_id
    and t.event_id = new.event_id
  limit 1;

  if v_existing_team_id is not null then
    raise exception 'User is already on a team for this event.';
  end if;

  return new;
end;
$$;

drop trigger if exists team_members_one_team_per_event on public.team_members;
create trigger team_members_one_team_per_event
before insert on public.team_members
for each row execute function public.enforce_one_team_per_event_per_user();

drop trigger if exists teams_leader_one_team_per_event on public.teams;
create trigger teams_leader_one_team_per_event
before insert on public.teams
for each row execute function public.enforce_leader_one_team_per_event();

grant execute on function public.enforce_one_team_per_event_per_user() to authenticated;
grant execute on function public.enforce_leader_one_team_per_event() to authenticated;
