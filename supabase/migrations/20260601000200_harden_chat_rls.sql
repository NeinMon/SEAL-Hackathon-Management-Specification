create or replace function public.can_message_receiver(receiver uuid)
returns boolean
language sql
security definer
set search_path = public
as $$
  select case public.current_user_role()
    when 'organizer' then true
    when 'participant' then exists (
      select 1
      from public.users receiver_user
      where receiver_user.id = receiver
        and receiver_user.role in ('mentor', 'organizer')
    )
    when 'mentor' then exists (
      select 1
      from public.users receiver_user
      where receiver_user.id = receiver
        and receiver_user.role = 'organizer'
    ) or exists (
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

drop policy if exists "Users can send own messages" on messages;
create policy "Users can send own messages"
on messages for insert
to authenticated
with check (
  sender_id = auth.uid()
  and public.can_message_receiver(receiver_id)
);
