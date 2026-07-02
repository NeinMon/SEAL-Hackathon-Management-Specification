-- Ensure participants receive score notifications reliably (server-side).
-- The app previously attempted to create notifications client-side, which can be missed.

create or replace function public.notify_score_published()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_team_id uuid;
  v_project_name text;
  v_event_id uuid;
  v_title text;
  v_content text;
begin
  -- Only notify on INSERT, or when score changes on UPDATE.
  if tg_op = 'UPDATE' then
    if new.average_score is not distinct from old.average_score
      and new.feedback is not distinct from old.feedback then
      return new;
    end if;
  end if;

  select s.team_id, s.project_name
    into v_team_id, v_project_name
  from submissions s
  where s.id = new.submission_id;

  if v_team_id is null then
    return new;
  end if;

  select t.event_id into v_event_id
  from teams t
  where t.id = v_team_id;

  v_title := 'Có điểm mới';
  v_content := format(
    'Bài "%s" đã được chấm. Điểm TB: %s. %s',
    coalesce(v_project_name, 'Project'),
    coalesce(round(new.average_score::numeric, 1)::text, 'N/A'),
    case when new.feedback is null or btrim(new.feedback) = '' then '' else format('Nhận xét: %s', new.feedback) end
  );

  -- Insert for all team members + leader (distinct), unread by default.
  insert into notifications (user_id, title, content, notification_type)
  select distinct x.user_id, v_title, (case when v_event_id is null then v_content else format('[[event:%s]] %s', v_event_id::text, v_content) end), 'score'
  from (
    select tm.user_id
    from team_members tm
    where tm.team_id = v_team_id
    union
    select t.leader_id as user_id
    from teams t
    where t.id = v_team_id
  ) x
  where x.user_id is not null;

  return new;
end;
$$;

drop trigger if exists scores_publish_notification on public.scores;
create trigger scores_publish_notification
after insert or update on public.scores
for each row execute function public.notify_score_published();

