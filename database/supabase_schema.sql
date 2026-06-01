create table if not exists users (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null,
  email text not null unique,
  role text not null check (role in ('participant', 'judge', 'mentor', 'organizer')),
  university text,
  created_at timestamp default now()
);

create table if not exists events (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  description text,
  start_date timestamp,
  end_date timestamp,
  location text,
  banner_url text,
  registration_deadline timestamp,
  max_team_size integer,
  rules text,
  prize text,
  latitude double precision,
  longitude double precision,
  created_at timestamp default now()
);

create table if not exists teams (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  leader_id uuid references users(id),
  event_id uuid references events(id),
  created_at timestamp default now()
);

create table if not exists team_members (
  team_id uuid references teams(id) on delete cascade,
  user_id uuid references users(id) on delete cascade,
  joined_at timestamp default now(),
  primary key (team_id, user_id)
);

create table if not exists submissions (
  id uuid primary key default gen_random_uuid(),
  team_id uuid references teams(id),
  github_url text,
  video_url text,
  project_name text,
  description text,
  status text default 'submitted' check (status in ('draft', 'submitted', 'reviewed')),
  submitted_at timestamp default now()
);

create table if not exists submission_history (
  id uuid primary key default gen_random_uuid(),
  submission_id uuid references submissions(id) on delete cascade,
  status text not null,
  project_name text,
  changed_at timestamp default now()
);

create table if not exists scores (
  id uuid primary key default gen_random_uuid(),
  submission_id uuid references submissions(id),
  judge_id uuid references users(id),
  technical_score numeric,
  ui_score numeric,
  innovation_score numeric,
  feedback text,
  average_score numeric,
  created_at timestamp default now(),
  constraint scores_score_range_check check (
    technical_score between 0 and 10
    and ui_score between 0 and 10
    and innovation_score between 0 and 10
    and average_score between 0 and 10
  ),
  constraint scores_submission_judge_unique unique (submission_id, judge_id)
);

create table if not exists notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references users(id),
  title text not null,
  content text,
  is_read boolean default false,
  notification_type text check (notification_type in ('invitation', 'score', 'reminder', 'system')),
  created_at timestamp default now()
);

create table if not exists messages (
  id uuid primary key default gen_random_uuid(),
  sender_id uuid references users(id),
  receiver_id uuid references users(id),
  message text not null,
  created_at timestamp default now()
);

create index if not exists teams_event_id_idx on teams(event_id);
create index if not exists teams_leader_id_idx on teams(leader_id);
create index if not exists team_members_user_id_idx on team_members(user_id);
create index if not exists submissions_team_id_idx on submissions(team_id);
create index if not exists submissions_submitted_at_idx on submissions(submitted_at desc);
create index if not exists submission_history_submission_id_idx on submission_history(submission_id, changed_at desc);
create index if not exists scores_submission_id_idx on scores(submission_id);
create index if not exists notifications_user_id_idx on notifications(user_id);
create index if not exists messages_sender_receiver_idx on messages(sender_id, receiver_id);
create index if not exists messages_receiver_sender_idx on messages(receiver_id, sender_id);

insert into events (
  title,
  description,
  start_date,
  end_date,
  location,
  banner_url,
  registration_deadline,
  max_team_size,
  rules,
  prize,
  latitude,
  longitude
) values (
  'SEAL Innovation Hackathon 2026',
  'Build practical technology products for education, community, and smart campus challenges.',
  '2026-06-12',
  '2026-06-14',
  'FPT University HCMC',
  'https://images.unsplash.com/photo-1517048676732-d65bc937f952?w=1200',
  '2026-06-05',
  5,
  'Teams submit GitHub repository, demo video, and final pitch before deadline.',
  'First prize 20,000,000 VND, mentorship package, and incubation support.',
  10.8411,
  106.8100
);
