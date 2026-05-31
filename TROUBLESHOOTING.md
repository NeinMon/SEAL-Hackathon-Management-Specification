# Troubleshooting

## Android Emulator Cannot Connect To Supabase

Use `10.0.2.2` from the emulator:

```powershell
flutter run -d emulator-5554 --dart-define=SUPABASE_URL=http://10.0.2.2:54321 --dart-define=SUPABASE_ANON_KEY=sb_publishable_ACJWlzQHlZjBrEguHvfOxg_3BJgxAaH
```

Use `127.0.0.1` only for scripts running on Windows.

## Judge Submit Shows Permission Denied

Run migrations and login as the judge account:

```powershell
npx supabase migration up
```

The score update policy is in `supabase/migrations/20260531000100_score_update_policy.sql` and the hardened submission policy is in `supabase/migrations/20260531000200_demo_hardening.sql`.

## Google Maps Opens And You Cannot Return

The app now asks before opening external Maps. If you open it, use Android Back or the emulator Recent Apps button to return to `SEAL Hackathon`. For demo, use `Copy address` when you do not need external navigation.

## Demo Data Looks Messy

Reset and reseed:

```powershell
$env:SUPABASE_SERVICE_ROLE_KEY="YOUR_LOCAL_SERVICE_ROLE_KEY"
.\scripts\reset_demo_database.ps1
.\scripts\seed_demo_users.ps1
```

## GitHub CLI Is Installed But Not Logged In

Run:

```powershell
gh auth login
```

The project can still be pushed with normal `git push` if your Git credentials are already configured.
