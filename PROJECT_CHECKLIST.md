# SEAL Hackathon Project Checklist

This file maps the project implementation to the main function specification.

## Architecture

- Flutter UI: `lib/views/**`
- Model layer: `lib/models/**`
- Provider/ViewModel layer: `lib/providers/**`
- Supabase service layer: `lib/services/supabase_services.dart`
- Database schema: `database/supabase_schema.sql`
- RLS policies: `database/rls_policies.sql`
- Supabase migrations: `supabase/migrations/**`

## Implemented Screens

- Login/Register: `lib/views/auth/login_screen.dart`
- Event List: `lib/views/events/event_list_screen.dart`
- Event Detail + Leaderboard: `lib/views/events/event_detail_screen.dart`
- Team Management: `lib/views/teams/team_screen.dart`
- Project Submission: `lib/views/submissions/submission_screen.dart`
- Judge Scoring: `lib/views/judge/judge_screen.dart`
- Notifications: `lib/views/notifications/notification_screen.dart`
- Chat: `lib/views/chat/chat_screen.dart`
- Event Map: `lib/views/map/map_screen.dart`
- Profile Update: `lib/views/profile/profile_screen.dart`

## Role Behavior

- Login does not ask for a role.
- Role is loaded from `users.role` after authentication.
- Participant can manage teams, submit projects, chat, read notifications, and view maps.
- Judge can score submissions and publish feedback.
- Mentor can view teams and chat.
- Organizer can view operations, manage events/data via Supabase, and access scoring preview.

## Data Features

- `users`: account profile and role
- `events`: hackathon catalog and location
- `teams`: participant teams
- `team_members`: many-to-many team membership
- `submissions`: repository, video, description, status
- `scores`: judge rubric, feedback, average score
- `notifications`: invitation, score, reminder, system messages
- `messages`: participant/mentor/organizer chat history

## CRUD Coverage

- Create: register, create team, join team, submit project, submit score, send message, create notification
- Read: events, event detail, teams, submissions, scores, notifications, chat, profile
- Update: profile, team name, mark notification as read, score upsert
- Delete: leave team, delete notification, delete message

## Validation And State

- Auth validates email/password and registration profile fields.
- Team validates team name and invite email.
- Team creation now requires an event selection and reacts immediately when the user types.
- Submission validates project name, description, GitHub URL, and video URL.
- Judge scoring validates numeric scores from 0 to 10 and requires feedback.
- Chat rejects empty messages.
- Providers expose loading/error/success states for UI feedback.
- Map loads event data directly, so the venue screen works even if Events was not opened first.

## Database Hardening

- RLS enabled for all application tables.
- Role helper function: `current_user_role()`.
- Constraints for submission status, notification type, and score range.
- Unique score per submission per judge.
- Indexes for foreign-key-heavy queries.

## Map

The app uses `flutter_map` with OpenStreetMap tiles and opens external map
navigation by coordinates. No Google Maps API key is required.

## Verification Run

- `flutter analyze`
- `flutter test`
- `flutter build web --release`
- `flutter build apk --debug`
- `.\scripts\smoke_supabase_flow.ps1`: login participant/judge, load event, create team, add member, submit project, send chat message, insert/update score, create notification, mark notification read.
