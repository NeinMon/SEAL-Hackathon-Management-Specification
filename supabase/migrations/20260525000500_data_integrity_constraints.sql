alter table submissions
  drop constraint if exists submissions_status_check,
  add constraint submissions_status_check
  check (status in ('submitted', 'approved', 'rejected'));

alter table scores
  drop constraint if exists scores_score_range_check,
  add constraint scores_score_range_check
  check (
    technical_score between 0 and 10
    and ui_score between 0 and 10
    and innovation_score between 0 and 10
    and average_score between 0 and 10
  );

alter table scores
  drop constraint if exists scores_submission_judge_unique,
  add constraint scores_submission_judge_unique
  unique (submission_id, judge_id);

alter table notifications
  drop constraint if exists notifications_type_check,
  add constraint notifications_type_check
  check (notification_type in ('invitation', 'score', 'reminder', 'system'));

create index if not exists teams_event_id_idx on teams(event_id);
create index if not exists teams_leader_id_idx on teams(leader_id);
create index if not exists team_members_user_id_idx on team_members(user_id);
create index if not exists submissions_team_id_idx on submissions(team_id);
create index if not exists scores_submission_id_idx on scores(submission_id);
create index if not exists notifications_user_id_idx on notifications(user_id);
create index if not exists messages_sender_receiver_idx on messages(sender_id, receiver_id);
