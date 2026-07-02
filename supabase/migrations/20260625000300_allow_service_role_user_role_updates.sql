-- Allow service_role key (admin scripts) to seed/update roles.
-- Keeps the original rule: authenticated non-organizers cannot change roles.

create or replace function public.enforce_user_role_rules()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  actor_role text;
begin
  -- Service role requests (admin API / service key) should be allowed.
  -- This is required for demo seeding scripts and local automation.
  if auth.role() = 'service_role' then
    return new;
  end if;

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

