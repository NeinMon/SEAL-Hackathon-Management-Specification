# SEAL Hackathon Project Checklist

This file maps the project implementation to the main function specification.

## Architecture

- Flutter UI: `lib/views/**`
- Android runner: `android/**`
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
- Organizer Dashboard: `lib/views/organizer/organizer_dashboard_screen.dart`
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
- Organizer can view an operations dashboard, inspect teams/submissions, and access scoring.

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
- Team join/invite checks event max team size before writing membership rows.
- Team creation now requires an event selection and reacts immediately when the user types.
- Submission validates project name, description, GitHub URL, and video URL.
- Submission updates the team's latest submission instead of creating duplicates during demo.
- Judge scoring uses mobile-friendly sliders, validates scores from 0 to 10, and requires feedback inline.
- Chat rejects empty messages.
- Chat and notification deletes ask for confirmation.
- Mentor chat contacts are scoped to participants in related teams plus organizers.
- Providers expose loading/error/success states for UI feedback.
- Providers map Supabase errors into readable UI messages.
- Map loads event data directly, so the venue screen works even if Events was not opened first.
- Map can copy the venue address and confirms before opening external Maps.

## Database Hardening

- RLS enabled for all application tables.
- Role helper function: `current_user_role()`.
- Constraints for submission status, notification type, and score range.
- Unique score per submission per judge.
- Indexes for foreign-key-heavy queries and chat sender/receiver lookups.
- Negative smoke test covers participant score denial and cross-judge update denial.

## Map

The app uses `flutter_map` with OpenStreetMap tiles and opens external map
navigation by coordinates. No Google Maps API key is required.

## Verification Run

- `flutter analyze`
- `flutter test`
- `flutter build apk --debug`
- `.\scripts\smoke_supabase_flow.ps1`: login participant/judge, load event, create team, add member, submit project, send chat message, insert/update score, create notification, mark notification read.
- `.\scripts\smoke_supabase_negative.ps1`: verifies RLS denial cases.
- `.\scripts\test_all.ps1`: analyze, tests, positive smoke, negative smoke, debug build.
- Widget tests cover login landscape fit, event filtering, RoleGate, and judge validation.

## Platform Scope

The repository is Android-focused for Android Studio deployment. Unused iOS,
macOS, Linux, Windows, and web runner folders were removed.

Android identity is set to app label `SEAL Hackathon`, namespace/application id
`vn.seal.hackathon`, adaptive icon, and native splash background.

The app uses the pure Dart Supabase client and an Android MethodChannel for
external URLs, avoiding Android plugin Kotlin Gradle compatibility warnings.
