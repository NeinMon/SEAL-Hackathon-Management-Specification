alter table notifications
  drop constraint if exists notifications_type_check,
  add constraint notifications_type_check
  check (notification_type in ('invitation', 'score', 'reminder', 'system', 'announcement'));
