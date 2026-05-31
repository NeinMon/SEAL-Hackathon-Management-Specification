# SEAL Hackathon Demo Script

Use this script for a clean 5-10 minute Android Studio demo.

## Before Demo

```powershell
npx supabase start
npx supabase migration up
$env:SUPABASE_SERVICE_ROLE_KEY="YOUR_LOCAL_SERVICE_ROLE_KEY"
.\scripts\test_all.ps1
```

`test_all.ps1` restores clean demo data at the end when `SUPABASE_SERVICE_ROLE_KEY`
is available.

Run from Android Studio or PowerShell:

```powershell
flutter run -d emulator-5554 --dart-define=SUPABASE_URL=http://10.0.2.2:54321 --dart-define=SUPABASE_ANON_KEY=sb_publishable_ACJWlzQHlZjBrEguHvfOxg_3BJgxAaH
```

## 5 Minute Flow

1. Login `participant@seal.test / 123456`.
2. Open Events, search/filter, then open the event detail.
3. Show timeline, rules, prize, and leaderboard.
4. Open Teams, show `Seal Builders`, invite/join validation, and max member state.
5. Open Submit, update `Campus Copilot` with GitHub/demo links.
6. Logout, login `judge@seal.test / 123456`.
7. Open Judge, move score sliders, add feedback, submit/update score.
8. Logout, login `organizer@seal.test / 123456`, open Dashboard and show operations metrics.
9. Logout, login participant again, open Inbox and show score notification.
10. Open Chat, send a mentor message, then delete it with confirmation.
11. Open Map, copy address, then use Open in Maps only if you want to show external navigation.

## 10 Minute Flow

Add these after the 5 minute flow:

1. Show Profile update and logout state reset.
2. Show empty and loading states by resetting demo data.
3. Run `.\scripts\smoke_supabase_negative.ps1` to prove RLS blocks invalid scoring.
4. Explain Android identity: app label `SEAL Hackathon`, package `vn.seal.hackathon`, adaptive icon, and splash screen.

## Demo Accounts

```text
participant@seal.test / 123456
judge@seal.test / 123456
mentor@seal.test / 123456
organizer@seal.test / 123456
```
