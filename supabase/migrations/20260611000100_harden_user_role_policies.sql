-- Self-registration must create participant profiles only.
-- Users cannot change their own role; organizers can manage roles.
-- Enable Realtime for chat and notifications.

create or replace function public.enforce_user_role_rules()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  actor_role text;
begin
  select role into actor_role
  from public.users
  where id = auth.uid();

  if tg_op = 'INSERT' then
    if new.id = auth.uid() and new.role <> 'participant' then
      raise exception 'Self-registration must use participant role';
    end if;
    return new;
  end if;

  if tg_op = 'UPDATE' then
    if new.role is distinct from old.role then
      if actor_role is distinct from 'organizer' then
        raise exception 'Only organizers can change user roles';
      end if;
    end if;
    return new;
  end if;

  return new;
end;
$$;

drop trigger if exists enforce_user_role_rules on public.users;
create trigger enforce_user_role_rules
before insert or update on public.users
for each row execute function public.enforce_user_role_rules();

drop policy if exists "Users can create own profile" on users;
create policy "Users can create own participant profile"
on users for insert
to authenticated
with check (id = auth.uid() and role = 'participant');

drop policy if exists "Users can update own profile" on users;
create policy "Users can update own profile fields"
on users for update
to authenticated
using (id = auth.uid())
with check (id = auth.uid());

drop policy if exists "Organizers can manage user roles" on users;
create policy "Organizers can manage user roles"
on users for update
to authenticated
using (public.current_user_role() = 'organizer')
with check (public.current_user_role() = 'organizer');

do $$
begin
  alter publication supabase_realtime add table public.messages;
exception
  when duplicate_object then null;
end $$;

do $$
begin
  alter publication supabase_realtime add table public.notifications;
exception
  when duplicate_object then null;
end $$;
