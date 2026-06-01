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

## Seed Demo Data

Use service role only from your machine or CI secret, never inside the app:

```powershell
$env:SUPABASE_URL="https://<project-ref>.supabase.co"
$env:SUPABASE_ANON_KEY="<anon-key>"
$env:SUPABASE_SERVICE_ROLE_KEY="<service-role-key>"
.\scripts\hosted_supabase_check.ps1 -Environment staging
```

The script resets demo rows, seeds demo users/data, runs positive and negative RLS smoke checks, and builds an Android debug APK against the hosted project.

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
- `flutter build apk --debug` with staging defines
- `flutter build apk --release` with production defines
- No raw Supabase/PostgREST exception should appear in the UI.
