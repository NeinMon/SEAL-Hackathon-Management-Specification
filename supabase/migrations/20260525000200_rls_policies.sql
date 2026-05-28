alter table users enable row level security;
alter table events enable row level security;
alter table teams enable row level security;
alter table team_members enable row level security;
alter table submissions enable row level security;
alter table scores enable row level security;
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
with check (leader_id = auth.uid());

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
with check (user_id = auth.uid());

drop policy if exists "Users can leave teams as themselves" on team_members;
create policy "Users can leave teams as themselves"
on team_members for delete
to authenticated
using (user_id = auth.uid());

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
    from team_members
    where team_members.team_id = submissions.team_id
      and team_members.user_id = auth.uid()
  )
);

drop policy if exists "Team members can update submissions" on submissions;
create policy "Team members can update submissions"
on submissions for update
to authenticated
using (
  exists (
    select 1
    from team_members
    where team_members.team_id = submissions.team_id
      and team_members.user_id = auth.uid()
  )
);

drop policy if exists "Authenticated users can view scores" on scores;
create policy "Authenticated users can view scores"
on scores for select
to authenticated
using (true);

drop policy if exists "Judges can create scores" on scores;
create policy "Judges can create scores"
on scores for insert
to authenticated
with check (
  judge_id = auth.uid()
  and public.current_user_role() = 'judge'
);

drop policy if exists "Users can view own notifications" on notifications;
create policy "Users can view own notifications"
on notifications for select
to authenticated
using (user_id = auth.uid());

drop policy if exists "Users can create own notifications" on notifications;
create policy "Users can create own notifications"
on notifications for insert
to authenticated
with check (user_id = auth.uid());

drop policy if exists "Users can update own notifications" on notifications;
create policy "Users can update own notifications"
on notifications for update
to authenticated
using (user_id = auth.uid())
with check (user_id = auth.uid());

drop policy if exists "Users can view own messages" on messages;
create policy "Users can view own messages"
on messages for select
to authenticated
using (sender_id = auth.uid() or receiver_id = auth.uid());

drop policy if exists "Users can send own messages" on messages;
create policy "Users can send own messages"
on messages for insert
to authenticated
with check (sender_id = auth.uid());

drop policy if exists "Users can delete sent messages" on messages;
create policy "Users can delete sent messages"
on messages for delete
to authenticated
using (sender_id = auth.uid());
