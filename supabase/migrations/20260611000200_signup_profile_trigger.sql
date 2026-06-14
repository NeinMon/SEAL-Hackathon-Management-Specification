-- Create public.users profile when a new auth user signs up (before email confirmation).
create or replace function public.handle_auth_user_created()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.users (id, full_name, email, role, university)
  values (
    new.id,
    coalesce(new.raw_user_meta_data ->> 'full_name', split_part(new.email, '@', 1)),
    new.email,
    'participant',
    nullif(new.raw_user_meta_data ->> 'university', '')
  )
  on conflict (id) do update
    set full_name = excluded.full_name,
        university = excluded.university;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute function public.handle_auth_user_created();
