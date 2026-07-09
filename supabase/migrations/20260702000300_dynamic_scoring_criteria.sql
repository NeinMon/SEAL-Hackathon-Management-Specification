create table if not exists public.score_criteria (
  id text not null,
  event_id uuid not null references public.events(id) on delete cascade,
  label text not null,
  description text default '',
  weight numeric not null default 1 check (weight > 0),
  sort_order integer not null default 0,
  created_at timestamp default now(),
  primary key (event_id, id)
);

alter table public.score_criteria enable row level security;

drop policy if exists "Authenticated users can view score criteria" on public.score_criteria;
create policy "Authenticated users can view score criteria"
on public.score_criteria for select
to authenticated
using (true);

drop policy if exists "Organizers can manage score criteria" on public.score_criteria;
create policy "Organizers can manage score criteria"
on public.score_criteria for all
to authenticated
using (public.current_user_role() = 'organizer')
with check (public.current_user_role() = 'organizer');

alter table public.scores
  add column if not exists criteria_scores jsonb not null default '{}'::jsonb;

alter table public.scores
  drop constraint if exists scores_criteria_scores_object_check,
  add constraint scores_criteria_scores_object_check
  check (jsonb_typeof(criteria_scores) = 'object');
