create table if not exists public.team_invitations (
  id uuid primary key default gen_random_uuid(),
  team_id uuid not null references public.teams(id) on delete cascade,
  inviter_id uuid not null references public.users(id) on delete cascade,
  invitee_id uuid not null references public.users(id) on delete cascade,
  status text not null default 'pending'
    check (status in ('pending', 'accepted', 'declined')),
  created_at timestamp default now(),
  responded_at timestamp,
  constraint team_invitations_no_self_invite
    check (inviter_id <> invitee_id)
);

create unique index if not exists team_invitations_one_pending_idx
on public.team_invitations(team_id, invitee_id)
where status = 'pending';

create index if not exists team_invitations_invitee_status_idx
on public.team_invitations(invitee_id, status, created_at desc);

alter table public.team_invitations enable row level security;

drop policy if exists "Team leaders can view sent invitations" on public.team_invitations;
create policy "Team leaders can view sent invitations"
on public.team_invitations for select
to authenticated
using (
  invitee_id = auth.uid()
  or public.current_user_role() = 'organizer'
  or exists (
    select 1
    from public.teams
    where teams.id = team_invitations.team_id
      and teams.leader_id = auth.uid()
  )
);

drop policy if exists "Team leaders can create invitations" on public.team_invitations;
create policy "Team leaders can create invitations"
on public.team_invitations for insert
to authenticated
with check (
  inviter_id = auth.uid()
  and status = 'pending'
  and exists (
    select 1
    from public.teams
    where teams.id = team_invitations.team_id
      and teams.leader_id = auth.uid()
  )
);

drop policy if exists "Invitees can respond to own invitations" on public.team_invitations;
create policy "Invitees can respond to own invitations"
on public.team_invitations for update
to authenticated
using (invitee_id = auth.uid() and status = 'pending')
with check (
  invitee_id = auth.uid()
  and status in ('accepted', 'declined')
  and responded_at is not null
);
