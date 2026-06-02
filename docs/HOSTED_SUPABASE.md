# Hosted Supabase Setup

This app supports three runtime targets through Dart defines:

- `APP_ENV=local`
- `APP_ENV=staging`
- `APP_ENV=production`

## Create Hosted Project

1. Create a Supabase hosted project from the Supabase dashboard.
2. Copy the project URL, anon key, and service role key.
3. Apply every SQL file in `supabase/migrations` in order, or link the Supabase CLI to the hosted project and run:

```powershell
supabase link --project-ref <project-ref>
supabase db push
```

The repository also includes a checked script for this:

```powershell
$env:SUPABASE_PROJECT_REF="<project-ref>"
$env:SUPABASE_DB_PASSWORD="<database-password>"
.\scripts\apply_hosted_migrations.ps1 -ProjectRef $env:SUPABASE_PROJECT_REF
```

## Seed Demo Data

Use service role only from your machine or CI secret, never inside the app:

```powershell
$env:SUPABASE_URL="https://<project-ref>.supabase.co"
$env:SUPABASE_ANON_KEY="<anon-key>"
$env:SUPABASE_SERVICE_ROLE_KEY="<service-role-key>"
.\scripts\hosted_supabase_check.ps1 -Environment staging
```

The script resets demo rows, seeds demo users/data, runs positive and negative RLS smoke checks, and builds an Android debug APK against the hosted project.

To apply migrations first and then run the full hosted smoke:

```powershell
$env:SUPABASE_PROJECT_REF="<project-ref>"
$env:SUPABASE_DB_PASSWORD="<database-password>"
.\scripts\hosted_supabase_check.ps1 -Environment staging -ApplyMigrations
```

## Organizer Demo Reset Edge Function

The app includes `supabase/functions/admin-reset-demo`. Deploy it after applying migrations:

```powershell
supabase functions deploy admin-reset-demo
```

The function checks the caller's JWT, verifies the caller is an `organizer` in `public.users`, and only then uses the server-side `SUPABASE_SERVICE_ROLE_KEY` to reset and seed deterministic demo rows. Do not put the service role key in Dart defines or app config.

After deployment, the Organizer Dashboard can run **Reset dữ liệu demo** from the app without exposing admin secrets to mobile clients.

## Clean Demo Data

`scripts/seed_demo_users.ps1` creates a deterministic demo workspace:

- `SEAL Innovation Hackathon 2026`
- demo accounts: participant, judge, mentor, organizer
- `Seal Builders` team with participant and mentor
- `Campus Copilot` reviewed submission
- one judge score with feedback
- system, score, invitation, and announcement notifications
- mentor welcome message and participant question

Reset and recreate the clean backend:

```powershell
.\scripts\reset_demo_database.ps1
.\scripts\seed_demo_users.ps1
```

## Build Commands

Local emulator:

```powershell
flutter build apk --debug `
  --dart-define=APP_ENV=local `
  --dart-define=SUPABASE_URL=http://10.0.2.2:54321 `
  --dart-define=SUPABASE_ANON_KEY=<local-anon-key>
```

Staging hosted:

```powershell
flutter build apk --debug `
  --dart-define=APP_ENV=staging `
  --dart-define=SUPABASE_URL=$env:SUPABASE_URL `
  --dart-define=SUPABASE_ANON_KEY=$env:SUPABASE_ANON_KEY
```

Production hosted:

```powershell
flutter build apk --release `
  --dart-define=APP_ENV=production `
  --dart-define=SUPABASE_URL=$env:SUPABASE_URL `
  --dart-define=SUPABASE_ANON_KEY=$env:SUPABASE_ANON_KEY
```

## Acceptance

- `flutter analyze`
- `flutter test`
- `.\scripts\hosted_supabase_check.ps1 -Environment staging`
- `.\scripts\hosted_supabase_check.ps1 -Environment staging -ApplyMigrations`
- `flutter build apk --debug` with staging defines
- `flutter build apk --release` with production defines
- No raw Supabase/PostgREST exception should appear in the UI.

## Environment Separation

Use separate hosted projects or at minimum separate credentials for:

- Local: emulator/local Supabase only.
- Staging: seeded demo data and CI smoke checks.
- Production: real users/data and release APK/AAB builds.

Do not put service role keys, database passwords, or keystore passwords in Dart defines. The app only receives `SUPABASE_URL` and `SUPABASE_ANON_KEY`.
