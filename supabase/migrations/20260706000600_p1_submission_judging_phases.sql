-- P1: separate submission vs judging windows using submission_deadline.

alter table public.events
  add column if not exists submission_deadline timestamptz;

update public.events
set submission_deadline = start_date + ((end_date - start_date) * 0.7)
where submission_deadline is null
  and start_date is not null
  and end_date is not null
  and end_date > start_date;

update public.events
set submission_deadline = end_date
where submission_deadline is null;

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
      and e.submission_deadline is not null
      and e.start_date <= now()
      and e.submission_deadline > now()
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
      and e.submission_deadline is not null
      and e.end_date is not null
      and e.submission_deadline <= now()
      and e.end_date >= now()
  );
$$;

grant execute on function public.event_submission_open(uuid) to authenticated;
grant execute on function public.event_judging_open(uuid) to authenticated;
