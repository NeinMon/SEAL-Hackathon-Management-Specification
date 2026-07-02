param(
  [switch]$SkipSupabase,
  [string]$ProjectUrl = "http://127.0.0.1:55321",
  [string]$AnonKey = "sb_publishable_ACJWlzQHlZjBrEguHvfOxg_3BJgxAaH"
)

$ErrorActionPreference = "Stop"

Write-Output "== Flutter analyze =="
flutter analyze

Write-Output "== Flutter tests =="
flutter test

if (-not $SkipSupabase) {
  Write-Output "== Supabase positive smoke =="
  .\scripts\smoke_supabase_flow.ps1 -ProjectUrl $ProjectUrl -AnonKey $AnonKey

  Write-Output "== Supabase negative smoke =="
  .\scripts\smoke_supabase_negative.ps1 -ProjectUrl $ProjectUrl -AnonKey $AnonKey
} else {
  Write-Output "== Supabase smoke skipped =="
}

Write-Output "== Android debug build =="
flutter build apk --debug

Write-Output "== Android release build =="
flutter build apk --release

if (-not $SkipSupabase -and $env:SUPABASE_SERVICE_ROLE_KEY) {
  Write-Output "== Restore clean demo data =="
  .\scripts\reset_demo_database.ps1 -ProjectUrl $ProjectUrl
  .\scripts\seed_demo_users.ps1 -ProjectUrl $ProjectUrl
}

Write-Output "All checks finished."
