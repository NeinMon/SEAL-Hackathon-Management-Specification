-- D: per-event venue contact fields for map / support.

alter table public.events
  add column if not exists support_hotline text,
  add column if not exists opening_hours text;

comment on column public.events.support_hotline is 'Event-specific support hotline shown on map screen';
comment on column public.events.opening_hours is 'Human-readable opening hours for the venue';
