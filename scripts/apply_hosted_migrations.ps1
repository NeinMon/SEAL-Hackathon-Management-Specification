param(
  [Parameter(Mandatory = $true)]
  [string]$ProjectRef,
  [string]$DatabasePassword = $env:SUPABASE_DB_PASSWORD,
  [switch]$DryRun
)

$ErrorActionPreference = "Stop"

if (-not $DatabasePassword) {
  throw "Set SUPABASE_DB_PASSWORD or pass -DatabasePassword before pushing hosted migrations."
}

if (-not (Get-Command supabase -ErrorAction SilentlyContinue)) {
  throw "Supabase CLI was not found. Install it, login, then run this script again."
}

Write-Output "== Link Supabase project =="
supabase link --project-ref $ProjectRef --password $DatabasePassword

Write-Output "== Validate migration status =="
supabase migration list

if ($DryRun) {
  Write-Output "Dry run complete. Re-run without -DryRun to push migrations."
  exit 0
}

Write-Output "== Push migrations to hosted project =="
supabase db push --password $DatabasePassword

Write-Output "Hosted migrations applied."
