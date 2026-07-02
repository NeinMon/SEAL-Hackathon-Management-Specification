-- Database triggers backing event lifecycle enforcement.
-- Applied via supabase/migrations/20260618000100_event_lifecycle_enforcement.sql

create or replace function public.enforce_team_registration_window()
returns trigger
language plpgsql
set search_path = public
as $$
begin
  if new.event_id is null then
    raise exception 'Event is required to create a team.';
  end if;

  if not public.event_registration_open(new.event_id) then
    raise exception 'Event registration is closed for this hackathon.';
  end if;

  return new;
end;
$$;

create or replace function public.enforce_team_member_registration_window()
returns trigger
language plpgsql
set search_path = public
as $$
declare
  v_event_id uuid;
begin
  select public.team_event_id(new.team_id) into v_event_id;

  if v_event_id is null then
    raise exception 'Team not found for membership change.';
  end if;

  if not public.event_registration_open(v_event_id) then
    raise exception 'Event registration is closed for this hackathon.';
  end if;

  return new;
end;
$$;

create or replace function public.enforce_submission_window()
returns trigger
language plpgsql
set search_path = public
as $$
declare
  v_event_id uuid;
begin
  select public.team_event_id(new.team_id) into v_event_id;

  if v_event_id is null then
    raise exception 'Team not found for submission.';
  end if;

  if not public.event_submission_open(v_event_id) then
    raise exception 'Event has ended. Submissions are closed.';
  end if;

  return new;
end;
$$;

create or replace function public.enforce_judging_window()
returns trigger
language plpgsql
set search_path = public
as $$
declare
  v_event_id uuid;
begin
  select public.submission_event_id(new.submission_id) into v_event_id;

  if v_event_id is null then
    raise exception 'Submission not found for scoring.';
  end if;

  if not public.event_judging_open(v_event_id) then
    raise exception 'Event has not started yet. Judging is not open.';
  end if;

  return new;
end;
$$;

drop trigger if exists teams_registration_window on public.teams;
create trigger teams_registration_window
before insert on public.teams
for each row execute function public.enforce_team_registration_window();

drop trigger if exists team_members_registration_window on public.team_members;
create trigger team_members_registration_window
before insert on public.team_members
for each row execute function public.enforce_team_member_registration_window();

drop trigger if exists submissions_submission_window on public.submissions;
create trigger submissions_submission_window
before insert or update on public.submissions
for each row execute function public.enforce_submission_window();

drop trigger if exists scores_judging_window on public.scores;
create trigger scores_judging_window
before insert or update on public.scores
for each row execute function public.enforce_judging_window();
