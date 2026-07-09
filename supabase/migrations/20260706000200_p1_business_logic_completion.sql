-- P1 business logic: invite-only teams, submission/judging windows, event mentors, reviewed status.

-- Submission only after event starts and before event ends.
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
      and e.start_date is not null
      and e.end_date is not null
      and e.start_date <= now()
      and e.end_date >= now()
  );
$$;

-- Judging only while the event is active.
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
      and e.end_date is not null
      and e.start_date <= now()
      and e.end_date >= now()
  );
$$;

-- Invite-only team membership: leaders add themselves; invitees need a pending invitation.
drop policy if exists "Users can join teams as themselves" on public.team_members;
drop policy if exists "Users can join teams via invitation or as leader" on public.team_members;

create policy "Users can join teams via invitation or as leader"
on public.team_members for insert
to authenticated
with check (
  exists (
    select 1
    from public.teams t
    where t.id = team_members.team_id
      and public.event_registration_open(t.event_id)
  )
  and (
    (
      user_id = auth.uid()
      and exists (
        select 1
        from public.team_invitations ti
        where ti.team_id = team_members.team_id
          and ti.invitee_id = auth.uid()
          and ti.status = 'pending'
      )
    )
    or (
      user_id = auth.uid()
      and exists (
        select 1
        from public.teams t
        where t.id = team_members.team_id
          and t.leader_id = auth.uid()
      )
    )
  )
);

-- Event mentor assignments for scoped chat.
create table if not exists public.event_mentors (
  event_id uuid not null references public.events(id) on delete cascade,
  mentor_id uuid not null references public.users(id) on delete cascade,
  assigned_at timestamptz not null default now(),
  primary key (event_id, mentor_id)
);

create index if not exists event_mentors_mentor_id_idx
on public.event_mentors(mentor_id);

create or replace function public.enforce_event_mentor_role()
returns trigger
language plpgsql
set search_path = public
as $$
declare
  v_role text;
begin
  select role into v_role
  from public.users
  where id = new.mentor_id;

  if v_role is distinct from 'mentor' then
    raise exception 'Only users with mentor role can be assigned to events.';
  end if;

  return new;
end;
$$;

drop trigger if exists event_mentors_role_check on public.event_mentors;
create trigger event_mentors_role_check
before insert or update on public.event_mentors
for each row execute function public.enforce_event_mentor_role();

alter table public.event_mentors enable row level security;

drop policy if exists "Organizers manage event mentors" on public.event_mentors;
create policy "Organizers manage event mentors"
on public.event_mentors for all
to authenticated
using (public.current_user_role() = 'organizer')
with check (public.current_user_role() = 'organizer');

drop policy if exists "Authenticated users can view event mentors" on public.event_mentors;
create policy "Authenticated users can view event mentors"
on public.event_mentors for select
to authenticated
using (true);

-- Scope mentor/participant chat to shared event assignments.
create or replace function public.can_message_receiver(receiver uuid)
returns boolean
language sql
security definer
set search_path = public
as $$
  select case public.current_user_role()
    when 'participant' then exists (
      select 1
      from public.users receiver_user
      join public.event_mentors em on em.mentor_id = receiver_user.id
      join public.team_members participant_member
        on participant_member.user_id = auth.uid()
      join public.teams participant_team
        on participant_team.id = participant_member.team_id
       and participant_team.event_id = em.event_id
      where receiver_user.id = receiver
        and receiver_user.role = 'mentor'
    )
    when 'mentor' then exists (
      select 1
      from public.users receiver_user
      join public.event_mentors em on em.mentor_id = auth.uid()
      join public.teams participant_team
        on participant_team.event_id = em.event_id
      join public.team_members receiver_member
        on receiver_member.team_id = participant_team.id
       and receiver_member.user_id = receiver
      where receiver_user.id = receiver
        and receiver_user.role = 'participant'
    )
    else false
  end
$$;

-- Mark submissions as reviewed when a score is published.
create or replace function public.mark_submission_reviewed_on_score()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  update public.submissions
  set status = 'reviewed'
  where id = new.submission_id
    and status = 'submitted';

  return new;
end;
$$;

drop trigger if exists scores_mark_submission_reviewed on public.scores;
create trigger scores_mark_submission_reviewed
after insert or update on public.scores
for each row execute function public.mark_submission_reviewed_on_score();

grant execute on function public.mark_submission_reviewed_on_score() to authenticated;
