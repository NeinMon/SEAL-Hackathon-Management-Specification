create index if not exists messages_receiver_sender_idx
on messages(receiver_id, sender_id);

create index if not exists submissions_submitted_at_idx
on submissions(submitted_at desc);

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
)
with check (
  exists (
    select 1
    from team_members
    where team_members.team_id = submissions.team_id
      and team_members.user_id = auth.uid()
  )
);
