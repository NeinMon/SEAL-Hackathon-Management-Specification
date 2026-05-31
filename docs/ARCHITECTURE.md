# Architecture

```text
Android Studio / Emulator
        |
        v
Flutter Material UI
        |
        v
Provider state layer
        |
        v
Supabase services
        |
        v
Supabase Auth + PostgREST + PostgreSQL RLS
```

## App Layers

- `lib/views`: role-based screens for events, teams, submissions, judging, chat, map, profile, and organizer operations.
- `lib/providers`: loading/error/success state and screen-facing business rules.
- `lib/services`: Supabase Auth and REST calls.
- `lib/models`: typed app models mapped from Supabase rows.
- `lib/widgets`: reusable UI components and role gates.
- `supabase/migrations`: schema and RLS policy evolution.
- `scripts`: repeatable demo, smoke, and verification commands.

## Role Flow

```text
Login
  |
  +-- participant -> Events -> Teams -> Submit -> Chat -> Map
  +-- judge       -> Judge scoring -> Alerts
  +-- mentor      -> Teams -> Scoped chat
  +-- organizer   -> Dashboard -> Teams -> Judge -> Alerts
```

## RLS Coverage

- Participants can create/update submissions only for their teams.
- Judges can insert/update only their own score rows.
- Notifications and messages are scoped to the authenticated user.
- Negative smoke tests verify participant score denial and cross-judge update denial.
