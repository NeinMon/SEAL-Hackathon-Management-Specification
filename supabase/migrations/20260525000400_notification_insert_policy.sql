drop policy if exists "Users can create own notifications" on notifications;
drop policy if exists "Authenticated users can create notifications" on notifications;

create policy "Authenticated users can create notifications"
on notifications for insert
to authenticated
with check (true);
