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

Native iPhone builds require macOS with Xcode installed. From this Windows
machine you can build Android and web, but you cannot produce or sign an iOS
IPA locally.

On macOS with Xcode installed:

```bash
flutter devices
flutter run -d ios --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co --dart-define=SUPABASE_ANON_KEY=YOUR_ANON_KEY
```

For an iOS release archive:

```bash
flutter build ipa --release --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co --dart-define=SUPABASE_ANON_KEY=YOUR_ANON_KEY
```

Open `ios/Runner.xcworkspace` in Xcode, select `Runner`, then set:

- A unique Bundle Identifier, for example `com.yourname.sealhackathon`.
- Signing & Capabilities > Team.
- Automatically manage signing.

For a physical iPhone, connect the device to the Mac, trust the Mac on the
phone, enable Developer Mode if iOS asks for it, and run the app from Xcode or
`flutter run -d ios`.

## 3.1 iPhone Testing From Windows

If you only need to test on your current iPhone without a Mac, use the web/PWA
path:

```powershell
flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8090 --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co --dart-define=SUPABASE_ANON_KEY=YOUR_ANON_KEY
```

Find your Windows LAN IP:

```powershell
ipconfig
```

On the iPhone, join the same Wi-Fi network and open:

```text
http://YOUR_WINDOWS_LAN_IP:8090/#/login
```

For a shareable test link, build the web app and host `build/web` on HTTPS:

```powershell
flutter build web --release --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co --dart-define=SUPABASE_ANON_KEY=YOUR_ANON_KEY
```

Then open the hosted URL in Safari on iPhone. This is not a native App Store
install, but it is the fastest iPhone testing route from Windows.

## 3.2 TestFlight Path

For native iPhone distribution without plugging in a device, use TestFlight:

1. Build the IPA on macOS/Xcode or a macOS CI service.
2. Upload the build to App Store Connect.
3. Add internal or external testers in TestFlight.
4. Install through the TestFlight app on iPhone.

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
flutter analyze
flutter test
flutter build web --release
flutter build apk --debug
```

Output:

```text
build/web
build/app/outputs/flutter-apk/app-debug.apk
```

Flutter currently prints a warning about some Android plugins using Kotlin
Gradle Plugin compatibility mode. The APK still builds successfully. If a
future Flutter version turns this into an error, upgrade the affected packages
with `flutter pub upgrade`.

## 7. Official References

- Flutter iOS setup: https://docs.flutter.dev/platform-integration/ios/setup
- Flutter iOS release: https://docs.flutter.dev/deployment/ios
- Apple TestFlight: https://developer.apple.com/testflight/
