alter table submissions
drop constraint if exists submissions_status_check;

update submissions
set status = 'reviewed'
where status in ('approved', 'rejected');

alter table submissions
add constraint submissions_status_check
check (status in ('draft', 'submitted', 'reviewed'));

create table if not exists submission_history (
  id uuid primary key default gen_random_uuid(),
  submission_id uuid references submissions(id) on delete cascade,
  status text not null,
  project_name text,
  changed_at timestamp default now()
);

create index if not exists submission_history_submission_id_idx
on submission_history(submission_id, changed_at desc);

alter table submission_history enable row level security;

create or replace function public.record_submission_history()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into submission_history(submission_id, status, project_name)
  values (new.id, new.status, new.project_name);
  return new;
end;
$$;

drop trigger if exists submissions_history_insert on submissions;
create trigger submissions_history_insert
after insert on submissions
for each row execute function public.record_submission_history();

drop trigger if exists submissions_history_update on submissions;
create trigger submissions_history_update
after update of status, project_name, github_url, video_url, description on submissions
for each row execute function public.record_submission_history();

drop policy if exists "Authenticated users can view submission history" on submission_history;
create policy "Authenticated users can view submission history"
on submission_history for select
to authenticated
using (true);

drop policy if exists "System can create submission history" on submission_history;
create policy "System can create submission history"
on submission_history for insert
to authenticated
with check (
  exists (
    select 1
    from submissions
    join team_members on team_members.team_id = submissions.team_id
    where submissions.id = submission_history.submission_id
      and team_members.user_id = auth.uid()
  )
);
