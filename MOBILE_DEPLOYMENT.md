# Android Deployment Guide

This project is kept Android-only for Android Studio deployment. The tracked
Flutter platform folder is `android/`; unused iOS, macOS, Linux, Windows, and
web runner folders were removed to keep the repository focused.

## 1. Prepare Supabase

For the Android emulator, keep local Supabase running on Windows:

```powershell
npx supabase start
npx supabase migration up
$env:SUPABASE_SERVICE_ROLE_KEY="YOUR_LOCAL_OR_HOSTED_SERVICE_ROLE_KEY"
.\scripts\reset_demo_database.ps1
.\scripts\seed_demo_users.ps1
```

Android emulator networking maps the Windows host to `10.0.2.2`, so the app
must use:

```text
SUPABASE_URL=http://10.0.2.2:54321
SUPABASE_ANON_KEY=sb_publishable_ACJWlzQHlZjBrEguHvfOxg_3BJgxAaH
```

For a real Android phone, use a hosted Supabase project over HTTPS. Do not use
`127.0.0.1` or `10.0.2.2` on a physical phone.

## 2. Run In Android Studio

1. Open this folder in Android Studio.
2. Start an Android emulator, for example `Seal_Pixel_API_36`.
3. Select the `main.dart` Flutter run configuration.
4. Confirm additional args include:

```text
--dart-define=SUPABASE_URL=http://10.0.2.2:54321 --dart-define=SUPABASE_ANON_KEY=sb_publishable_ACJWlzQHlZjBrEguHvfOxg_3BJgxAaH
```

5. Press Run.

CLI equivalent:

```powershell
flutter run -d emulator-5554 --dart-define=SUPABASE_URL=http://10.0.2.2:54321 --dart-define=SUPABASE_ANON_KEY=sb_publishable_ACJWlzQHlZjBrEguHvfOxg_3BJgxAaH
```

## 3. Build APK

Debug APK:

```powershell
flutter build apk --debug --dart-define=SUPABASE_URL=http://10.0.2.2:54321 --dart-define=SUPABASE_ANON_KEY=sb_publishable_ACJWlzQHlZjBrEguHvfOxg_3BJgxAaH
```

Output:

```text
build/app/outputs/flutter-apk/app-debug.apk
```

Release APK for hosted Supabase:

```powershell
flutter build apk --release --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co --dart-define=SUPABASE_ANON_KEY=YOUR_ANON_KEY
```

Output:

```text
build/app/outputs/flutter-apk/app-release.apk
```

## 4. Verification

```powershell
flutter analyze
flutter test
.\scripts\smoke_supabase_flow.ps1
.\scripts\smoke_supabase_negative.ps1
flutter build apk --debug
```

The Android build avoids Flutter plugins that currently emit Kotlin Gradle
Plugin compatibility warnings for URL opening and Supabase access.

One-command local verification:

```powershell
.\scripts\test_all.ps1
```

The installed app should appear as `SEAL Hackathon` with package id
`vn.seal.hackathon`.

## 5. Release Signing

Release signing is configured through `android/key.properties`, which is ignored
by git. Use `android/key.properties.example` as the template and keep the `.jks`
file private. If `key.properties` is not present, the release build falls back
to the debug key for local demo builds only.
