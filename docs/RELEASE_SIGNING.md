# Android Release Signing

Gradle reads `android/key.properties` when it exists. That file and local keystores are ignored by Git.

## Create a Local Release Keystore

```powershell
.\scripts\new_android_release_keystore.ps1
```

The script creates:

- `android/seal-release.jks`
- `android/key.properties`

Do not commit either file.

## Build Release APK

```powershell
flutter build apk --release `
  --dart-define=APP_ENV=production `
  --dart-define=SUPABASE_URL=$env:SUPABASE_URL `
  --dart-define=SUPABASE_ANON_KEY=$env:SUPABASE_ANON_KEY
```

## CI Secrets

For GitHub Actions, configure:

- `STAGING_SUPABASE_URL`
- `STAGING_SUPABASE_ANON_KEY`
- `PRODUCTION_SUPABASE_URL`
- `PRODUCTION_SUPABASE_ANON_KEY`

The workflow uploads debug and release APK artifacts. Release signing in CI should be added only after storing the keystore and passwords as GitHub secrets.
