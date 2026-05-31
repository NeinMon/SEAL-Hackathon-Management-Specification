# SEAL Hackathon Management Mobile App

Flutter + Provider mobile app connected to Supabase/PostgreSQL for hackathon
event management, team management, project submission, judge scoring,
notifications, chat, and event map.

## Tech Stack

- Flutter
- Provider
- go_router
- Supabase Auth
- Supabase REST API
- PostgreSQL
- flutter_map + OpenStreetMap

## Local Test Accounts

```text
participant@seal.test / 123456
judge@seal.test / 123456
mentor@seal.test / 123456
organizer@seal.test / 123456
```

Login role is loaded from the account profile in `users.role`. The login screen
does not ask for a role.

## Local Supabase

Start Supabase:

```powershell
npx supabase start
```

Apply pending migrations:

```powershell
npx supabase migration up
```

Seed local Supabase users and starter workflow data:

```powershell
$env:SUPABASE_SERVICE_ROLE_KEY="YOUR_LOCAL_OR_HOSTED_SERVICE_ROLE_KEY"
.\scripts\seed_demo_users.ps1
```

## Run App

For Android Studio emulator, use `10.0.2.2` to reach the local Supabase server
running on Windows:

```powershell
flutter run -d emulator-5554 --dart-define=SUPABASE_URL=http://10.0.2.2:54321 --dart-define=SUPABASE_ANON_KEY=sb_publishable_ACJWlzQHlZjBrEguHvfOxg_3BJgxAaH
```

You can also open the project in Android Studio, select the Android emulator,
choose the `main.dart` run configuration, and press Run.

## Main Flow

1. Login as participant.
2. Open Events and Event Detail.
3. Open Teams and create/join a team.
4. Submit a project.
5. Logout and login as judge.
6. Score the submission.
7. Login as participant again and check Notifications.
8. Open Chat and send a message to mentor/organizer.
9. Open Map to view the event venue.

## Verification

```powershell
flutter analyze
flutter test
flutter build apk --debug
```

With local Supabase running and demo users seeded:

```powershell
.\scripts\smoke_supabase_flow.ps1
```

See `PROJECT_CHECKLIST.md` for the implementation-to-specification mapping.

See `MOBILE_DEPLOYMENT.md` for Android Studio, emulator, APK, and Android
device deployment steps.
