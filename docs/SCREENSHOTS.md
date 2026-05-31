# Demo Screenshots

Capture these screens for the final report or slide deck after starting the
Android emulator and running the app with local Supabase.

```powershell
flutter run -d emulator-5554 --dart-define=SUPABASE_URL=http://10.0.2.2:54321 --dart-define=SUPABASE_ANON_KEY=sb_publishable_ACJWlzQHlZjBrEguHvfOxg_3BJgxAaH
```

Captured in this repository:

- `docs/screenshots/login.png`
- `docs/screenshots/login_keyboard.png`

Recommended extra capture set:

- Login: branded entry screen.
- Events: event cards, search, and filters.
- Event detail: timeline, rules, prize, leaderboard.
- Teams: roster, max-size state, invite dialog.
- Submission: update submission state.
- Judge: scoring sliders and inline validation.
- Organizer: operations dashboard.
- Inbox: unread/read grouping.
- Chat: scoped conversation and delete confirmation.
- Map: embedded map, copy address, external maps confirm.

Android Studio screenshot shortcut:

```text
Emulator toolbar -> camera icon
```

ADB fallback:

```powershell
adb exec-out screencap -p > docs\screenshots\events.png
```
