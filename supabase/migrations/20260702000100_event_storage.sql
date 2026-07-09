-- Create storage bucket for event banners
insert into storage.buckets (id, name, public)
values ('event-banners', 'event-banners', true)
on conflict (id) do nothing;

-- Set up storage policies
create policy "Banner Public Access"
on storage.objects for select
using ( bucket_id = 'event-banners' );

create policy "Organizer Banner Upload"
on storage.objects for insert
with check (
  bucket_id = 'event-banners'
  AND (
    select role from public.users
    where id = auth.uid()
  ) = 'organizer'
);

create policy "Organizer Banner Update"
on storage.objects for update
using (
  bucket_id = 'event-banners'
  AND (
    select role from public.users
    where id = auth.uid()
  ) = 'organizer'
);

create policy "Organizer Banner Delete"
on storage.objects for delete
using (
  bucket_id = 'event-banners'
  AND (
    select role from public.users
    where id = auth.uid()
  ) = 'organizer'
);
