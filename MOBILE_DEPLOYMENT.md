# Mobile Deployment Guide

This app is a Flutter mobile application backed by Supabase/PostgreSQL.

## 1. Prepare Supabase

Use a hosted Supabase project for real mobile devices. Do not use
`http://127.0.0.1:54321` on a phone because that address points to the phone
itself, not your computer.

Run the SQL migrations against the hosted project:

```powershell
npx supabase link --project-ref YOUR_PROJECT_REF
npx supabase db push
```

Then seed only the accounts/data you want for testing, or create accounts from
the app registration screen.

## 2. Android Development Run

Connect an Android device or start an emulator:

```powershell
flutter devices
flutter run -d android --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co --dart-define=SUPABASE_ANON_KEY=YOUR_ANON_KEY
```

For a release APK:

```powershell
flutter build apk --release --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co --dart-define=SUPABASE_ANON_KEY=YOUR_ANON_KEY
```

Output:

```text
build/app/outputs/flutter-apk/app-release.apk
```

For Google Play/App Bundle:

```powershell
flutter build appbundle --release --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co --dart-define=SUPABASE_ANON_KEY=YOUR_ANON_KEY
```

Output:

```text
build/app/outputs/bundle/release/app-release.aab
```

## 3. iOS Development Run

On macOS with Xcode installed:

```bash
flutter devices
flutter run -d ios --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co --dart-define=SUPABASE_ANON_KEY=YOUR_ANON_KEY
```

For an iOS release archive:

```bash
flutter build ipa --release --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co --dart-define=SUPABASE_ANON_KEY=YOUR_ANON_KEY
```

## 4. Required Runtime Configuration

The app does not run with mock data. These two values are required:

```text
SUPABASE_URL
SUPABASE_ANON_KEY
```

If they are missing, the app shows a Supabase configuration screen.

## 5. Production Checklist

- Use a hosted Supabase project.
- Keep RLS enabled.
- Confirm Email Auth settings.
- Use HTTPS Supabase URL for mobile builds.
- Do not commit service-role keys.
- Build with `--release` for APK/AAB/IPA.
- Test login, events, team creation, submission, scoring, notifications, chat, and map on a real device.

## 6. Current Build Verification

Verified on Windows:

```powershell
flutter build apk --debug --dart-define=SUPABASE_URL=http://127.0.0.1:54321 --dart-define=SUPABASE_ANON_KEY=YOUR_ANON_KEY
```

Output:

```text
build/app/outputs/flutter-apk/app-debug.apk
```

Flutter currently prints a warning about some Android plugins using Kotlin
Gradle Plugin compatibility mode. The APK still builds successfully. If a
future Flutter version turns this into an error, upgrade the affected packages
with `flutter pub upgrade`.
