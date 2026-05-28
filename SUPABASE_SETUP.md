# Supabase setup

## 1. Create tables

Open Supabase Dashboard, go to SQL Editor, then run:

```sql
-- paste database/supabase_schema.sql here
```

Then run the RLS policy file:

```sql
-- paste database/rls_policies.sql here
```

If you use the included local Supabase project, apply migrations instead:

```powershell
npx supabase migration up
```

## 2. Enable auth

Go to Authentication > Providers and enable Email provider.

For faster classroom demo, you can temporarily disable email confirmation:

Authentication > Providers > Email > Confirm email = off.

## 3. Run app with keys

Use your Supabase project URL and anon public key:

```bash
flutter run -d chrome ^
  --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co ^
  --dart-define=SUPABASE_ANON_KEY=YOUR_ANON_KEY
```

PowerShell one-line version:

```powershell
flutter run -d chrome --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co --dart-define=SUPABASE_ANON_KEY=YOUR_ANON_KEY
```

Without these two values, the app shows a Supabase configuration screen and does not run with mock data.

## Map

The app uses `flutter_map` with OpenStreetMap tiles, so no Google Maps API key is required.

## 4. Demo flow

For local Supabase, seed demo accounts after `npx supabase start`:

```powershell
$env:SUPABASE_SERVICE_ROLE_KEY="YOUR_LOCAL_OR_HOSTED_SERVICE_ROLE_KEY"
.\scripts\seed_demo_users.ps1
```

Demo accounts:

```text
participant@seal.test / 123456
judge@seal.test / 123456
mentor@seal.test / 123456
organizer@seal.test / 123456
```

1. Login as participant.
2. Open Events.
3. Create a team.
4. Submit a project.
5. Logout and login a judge account.
6. Open Judge and submit score.
7. Login as participant again, then open Notifications and Chat.
