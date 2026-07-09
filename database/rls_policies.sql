alter table users enable row level security;
alter table events enable row level security;
alter table teams enable row level security;
alter table team_members enable row level security;
alter table team_invitations enable row level security;
alter table submissions enable row level security;
alter table submission_history enable row level security;
alter table scores enable row level security;
alter table score_criteria enable row level security;
alter table notifications enable row level security;
alter table messages enable row level security;

create or replace function public.current_user_role()
returns text
language sql
security definer
set search_path = public
as $$
  select role from public.users where id = auth.uid()
$$;

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
      where receiver_user.id = receiver
        and receiver_user.role = 'mentor'
    )
    when 'mentor' then exists (
      select 1
      from public.users receiver_user
      join public.team_members mentor_member
        on mentor_member.user_id = auth.uid()
      join public.team_members receiver_member
        on receiver_member.team_id = mentor_member.team_id
       and receiver_member.user_id = receiver
      where receiver_user.id = receiver
        and receiver_user.role = 'participant'
    )
    else false
  end
$$;

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

drop policy if exists "Users can create own profile" on users;
create policy "Users can create own profile"
on users for insert
with check (id = auth.uid());

drop policy if exists "Authenticated users can view profiles" on users;
create policy "Authenticated users can view profiles"
on users for select
to authenticated
using (true);

drop policy if exists "Users can update own profile" on users;
create policy "Users can update own profile"
on users for update
using (id = auth.uid())
with check (id = auth.uid());

drop policy if exists "Anyone can view events" on events;
create policy "Anyone can view events"
on events for select
using (true);

drop policy if exists "Organizers can create events" on events;
create policy "Organizers can create events"
on events for insert
to authenticated
with check (public.current_user_role() = 'organizer');

drop policy if exists "Organizers can update events" on events;
create policy "Organizers can update events"
on events for update
to authenticated
using (public.current_user_role() = 'organizer')
with check (public.current_user_role() = 'organizer');

drop policy if exists "Authenticated users can view teams" on teams;
create policy "Authenticated users can view teams"
on teams for select
to authenticated
using (true);

drop policy if exists "Users can create led teams" on teams;
create policy "Users can create led teams"
on teams for insert
to authenticated
with check (
  leader_id = auth.uid()
  and public.event_registration_open(event_id)
);

drop policy if exists "Team leaders can update teams" on teams;
create policy "Team leaders can update teams"
on teams for update
to authenticated
using (leader_id = auth.uid())
with check (leader_id = auth.uid());

drop policy if exists "Authenticated users can view team members" on team_members;
create policy "Authenticated users can view team members"
on team_members for select
to authenticated
using (true);

drop policy if exists "Users can join teams as themselves" on team_members;
create policy "Users can join teams as themselves"
on team_members for insert
to authenticated
with check (
  (
    user_id = auth.uid()
    or exists (
      select 1
      from teams
      where teams.id = team_members.team_id
        and teams.leader_id = auth.uid()
    )
  )
  and exists (
    select 1
    from teams
    where teams.id = team_members.team_id
      and public.event_registration_open(teams.event_id)
  )
);

drop policy if exists "Users can leave teams as themselves" on team_members;
create policy "Users can leave teams as themselves"
on team_members for delete
to authenticated
using (user_id = auth.uid());

drop policy if exists "Team leaders can view sent invitations" on team_invitations;
create policy "Team leaders can view sent invitations"
on team_invitations for select
to authenticated
using (
  invitee_id = auth.uid()
  or public.current_user_role() = 'organizer'
  or exists (
    select 1
    from teams
    where teams.id = team_invitations.team_id
      and teams.leader_id = auth.uid()
  )
);

drop policy if exists "Team leaders can create invitations" on team_invitations;
create policy "Team leaders can create invitations"
on team_invitations for insert
to authenticated
with check (
  inviter_id = auth.uid()
  and status = 'pending'
  and exists (
    select 1
    from teams
    where teams.id = team_invitations.team_id
      and teams.leader_id = auth.uid()
  )
);

drop policy if exists "Invitees can respond to own invitations" on team_invitations;
create policy "Invitees can respond to own invitations"
on team_invitations for update
to authenticated
using (invitee_id = auth.uid() and status = 'pending')
with check (
  invitee_id = auth.uid()
  and status in ('accepted', 'declined')
  and responded_at is not null
);

drop policy if exists "Authenticated users can view submissions" on submissions;
create policy "Authenticated users can view submissions"
on submissions for select
to authenticated
using (true);

drop policy if exists "Team members can create submissions" on submissions;
create policy "Team members can create submissions"
on submissions for insert
to authenticated
with check (
  exists (
    select 1
    from team_members tm
    join teams t on t.id = tm.team_id
    where tm.team_id = submissions.team_id
      and tm.user_id = auth.uid()
      and public.event_submission_open(t.event_id)
  )
);

drop policy if exists "Team members can update submissions" on submissions;
create policy "Team members can update submissions"
on submissions for update
to authenticated
using (
  exists (
    select 1
    from team_members tm
    join teams t on t.id = tm.team_id
    where tm.team_id = submissions.team_id
      and tm.user_id = auth.uid()
      and public.event_submission_open(t.event_id)
  )
)
with check (
  exists (
    select 1
    from team_members tm
    join teams t on t.id = tm.team_id
    where tm.team_id = submissions.team_id
      and tm.user_id = auth.uid()
      and public.event_submission_open(t.event_id)
  )
);

drop policy if exists "Authenticated users can view submission history" on submission_history;
create policy "Authenticated users can view submission history"
on submission_history for select
to authenticated
using (true);

drop policy if exists "Authenticated users can view scores" on scores;
create policy "Authenticated users can view scores"
on scores for select
to authenticated
using (true);

drop policy if exists "Authenticated users can view score criteria" on score_criteria;
create policy "Authenticated users can view score criteria"
on score_criteria for select
to authenticated
using (true);

drop policy if exists "Organizers can manage score criteria" on score_criteria;
create policy "Organizers can manage score criteria"
on score_criteria for all
to authenticated
using (public.current_user_role() = 'organizer')
with check (public.current_user_role() = 'organizer');

drop policy if exists "Judges can create scores" on scores;
create policy "Judges can create scores"
on scores for insert
to authenticated
with check (
  judge_id = auth.uid()
  and public.current_user_role() = 'judge'
  and public.event_judging_open(public.submission_event_id(submission_id))
);

drop policy if exists "Judges can update own scores" on scores;
create policy "Judges can update own scores"
on scores for update
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

drop policy if exists "Users can view own notifications" on notifications;
create policy "Users can view own notifications"
on notifications for select
to authenticated
using (user_id = auth.uid());

drop policy if exists "Users can create own notifications" on notifications;
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

drop policy if exists "Users can update own notifications" on notifications;
create policy "Users can update own notifications"
on notifications for update
to authenticated
using (user_id = auth.uid())
with check (user_id = auth.uid());

drop policy if exists "Users can delete own notifications" on notifications;
create policy "Users can delete own notifications"
on notifications for delete
to authenticated
using (user_id = auth.uid());

drop policy if exists "Users can view own messages" on messages;
create policy "Users can view own messages"
on messages for select
to authenticated
using (sender_id = auth.uid() or receiver_id = auth.uid());

drop policy if exists "Users can send own messages" on messages;
create policy "Users can send own messages"
on messages for insert
to authenticated
with check (
  sender_id = auth.uid()
  and public.can_message_receiver(receiver_id)
);

drop policy if exists "Users can delete sent messages" on messages;
create policy "Users can delete sent messages"
on messages for delete
to authenticated
using (sender_id = auth.uid());
