param(
  [ValidateSet("local", "staging", "production")]
  [string]$Environment = "staging",
  [string]$ProjectUrl = $env:SUPABASE_URL,
  [string]$AnonKey = $env:SUPABASE_ANON_KEY,
  [string]$ServiceRoleKey = $env:SUPABASE_SERVICE_ROLE_KEY,
  [switch]$SkipSeed
)

$ErrorActionPreference = "Stop"

if (-not $ProjectUrl -or -not $AnonKey) {
  throw "Set SUPABASE_URL and SUPABASE_ANON_KEY for $Environment."
}

Write-Output "== Hosted Supabase check: $Environment =="
Write-Output "ProjectUrl: $ProjectUrl"

if (-not $SkipSeed) {
  if (-not $ServiceRoleKey) {
    throw "Set SUPABASE_SERVICE_ROLE_KEY or pass -SkipSeed."
  }
  Write-Output "== Seed clean demo users/data =="
  .\scripts\reset_demo_database.ps1 -ProjectUrl $ProjectUrl -ServiceRoleKey $ServiceRoleKey
  .\scripts\seed_demo_users.ps1 -ProjectUrl $ProjectUrl -ServiceRoleKey $ServiceRoleKey
}

Write-Output "== Positive RLS/business smoke =="
.\scripts\smoke_supabase_flow.ps1 -ProjectUrl $ProjectUrl -AnonKey $AnonKey

Write-Output "== Negative RLS/security smoke =="
.\scripts\smoke_supabase_negative.ps1 `
  -ProjectUrl $ProjectUrl `
  -AnonKey $AnonKey `
  -ServiceRoleKey $ServiceRoleKey

Write-Output "== Android debug build with hosted defines =="
flutter build apk --debug `
  --dart-define=APP_ENV=$Environment `
  --dart-define=SUPABASE_URL=$ProjectUrl `
  --dart-define=SUPABASE_ANON_KEY=$AnonKey

Write-Output "Hosted Supabase check finished."
