-- Enforce hackathon lifecycle windows at the database layer:
-- registration -> team create/join
-- submission window -> project submit/update
-- judging window -> score create/update

create or replace function public.event_registration_open(p_event_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.events e
    where e.id = p_event_id
      and e.end_date is not null
      and e.registration_deadline is not null
      and e.end_date >= now()
      and e.registration_deadline >= now()
  );
$$;

create or replace function public.event_submission_open(p_event_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.events e
    where e.id = p_event_id
      and e.end_date is not null
      and e.end_date >= now()
  );
$$;

create or replace function public.event_judging_open(p_event_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.events e
    where e.id = p_event_id
      and e.start_date is not null
      and e.start_date <= now()
  );
$$;

create or replace function public.team_event_id(p_team_id uuid)
returns uuid
language sql
stable
security definer
set search_path = public
as $$
  select t.event_id
  from public.teams t
  where t.id = p_team_id
  limit 1;
$$;

create or replace function public.submission_event_id(p_submission_id uuid)
returns uuid
language sql
stable
security definer
set search_path = public
as $$
  select t.event_id
  from public.submissions s
  join public.teams t on t.id = s.team_id
  where s.id = p_submission_id
  limit 1;
$$;

grant execute on function public.event_registration_open(uuid) to authenticated;
grant execute on function public.event_submission_open(uuid) to authenticated;
grant execute on function public.event_judging_open(uuid) to authenticated;
grant execute on function public.team_event_id(uuid) to authenticated;
grant execute on function public.submission_event_id(uuid) to authenticated;

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

drop policy if exists "Users can create led teams" on public.teams;
create policy "Users can create led teams"
on public.teams for insert
to authenticated
with check (
  leader_id = auth.uid()
  and public.event_registration_open(event_id)
);

drop policy if exists "Users can join teams as themselves" on public.team_members;
create policy "Users can join teams as themselves"
on public.team_members for insert
to authenticated
with check (
  (
    user_id = auth.uid()
    or exists (
      select 1
      from public.teams
      where teams.id = team_members.team_id
        and teams.leader_id = auth.uid()
    )
  )
  and exists (
    select 1
    from public.teams
    where teams.id = team_members.team_id
      and public.event_registration_open(teams.event_id)
  )
);

drop policy if exists "Team members can create submissions" on public.submissions;
create policy "Team members can create submissions"
on public.submissions for insert
to authenticated
with check (
  exists (
    select 1
    from public.team_members tm
    join public.teams t on t.id = tm.team_id
    where tm.team_id = submissions.team_id
      and tm.user_id = auth.uid()
      and public.event_submission_open(t.event_id)
  )
);

drop policy if exists "Team members can update submissions" on public.submissions;
create policy "Team members can update submissions"
on public.submissions for update
to authenticated
using (
  exists (
    select 1
    from public.team_members tm
    join public.teams t on t.id = tm.team_id
    where tm.team_id = submissions.team_id
      and tm.user_id = auth.uid()
      and public.event_submission_open(t.event_id)
  )
)
with check (
  exists (
    select 1
    from public.team_members tm
    join public.teams t on t.id = tm.team_id
    where tm.team_id = submissions.team_id
      and tm.user_id = auth.uid()
      and public.event_submission_open(t.event_id)
  )
);

drop policy if exists "Judges can create scores" on public.scores;
create policy "Judges can create scores"
on public.scores for insert
to authenticated
with check (
  judge_id = auth.uid()
  and public.current_user_role() = 'judge'
  and public.event_judging_open(public.submission_event_id(submission_id))
);

drop policy if exists "Judges can update own scores" on public.scores;
create policy "Judges can update own scores"
on public.scores for update
to authenticated
using (
  judge_id = auth.uid()
  and public.current_user_role() = 'judge'
  and public.event_judging_open(public.submission_event_id(submission_id))
)
with check (
  judge_id = auth.uid()
  and public.current_user_role() = 'judge'
  and public.event_judging_open(public.submission_event_id(submission_id))
);
