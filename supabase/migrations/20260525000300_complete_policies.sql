drop policy if exists "Users can join teams as themselves" on team_members;
create policy "Users can join teams as themselves"
on team_members for insert
to authenticated
with check (
  user_id = auth.uid()
  or exists (
    select 1
    from teams
    where teams.id = team_members.team_id
      and teams.leader_id = auth.uid()
  )
);

drop policy if exists "Users can delete own notifications" on notifications;
create policy "Users can delete own notifications"
on notifications for delete
to authenticated
using (user_id = auth.uid());
