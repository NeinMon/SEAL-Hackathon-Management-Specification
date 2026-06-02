param(
  [string]$ProjectUrl = "http://127.0.0.1:54321",
  [string]$ServiceRoleKey = $env:SUPABASE_SERVICE_ROLE_KEY
)

$ErrorActionPreference = "Stop"

if (-not $ServiceRoleKey) {
  throw "Set SUPABASE_SERVICE_ROLE_KEY before running this script."
}

$headers = @{
  apikey = $ServiceRoleKey
  Authorization = "Bearer $ServiceRoleKey"
  "Content-Type" = "application/json"
  Prefer = "return=minimal"
}

function Invoke-DemoDelete([string]$Table, [string]$Filter, [string]$Label) {
  Invoke-RestMethod `
    -Method Delete `
    -Uri "$ProjectUrl/rest/v1/$Table`?$Filter" `
    -Headers $headers | Out-Null
  Write-Output "Reset: $Label"
}

function Enc([string]$Value) {
  [uri]::EscapeDataString($Value)
}

function Invoke-DeleteAll([string]$Table, [string]$Label, [string]$Filter = "id=not.is.null") {
  Invoke-DemoDelete $Table $Filter $Label
}

Invoke-DeleteAll "scores" "all scores"
Invoke-DeleteAll "notifications" "all notifications"
Invoke-DeleteAll "messages" "all messages"
Invoke-DeleteAll "submission_history" "all submission history"
Invoke-DeleteAll "submissions" "all submissions"
Invoke-DemoDelete "team_members" "team_id=not.is.null" "all team members"
Invoke-DeleteAll "teams" "all teams"
Invoke-DeleteAll "events" "all events"
Invoke-DemoDelete "users" "id=not.is.null" "all public users"

Invoke-DemoDelete "scores" "feedback=$(Enc 'like.Smoke score*')" "smoke scores"
Invoke-DemoDelete "scores" "feedback=$(Enc 'like.Seeded by service role*')" "negative smoke scores"
Invoke-DemoDelete "scores" "submission_id=eq.22222222-2222-4222-8222-222222222222" "seed submission scores"
Invoke-DemoDelete "notifications" "id=eq.44444444-4444-4444-8444-444444444444" "seed notification"
Invoke-DemoDelete "notifications" "id=in.(44444444-4444-4444-8444-444444444445,44444444-4444-4444-8444-444444444446,44444444-4444-4444-8444-444444444447)" "seed notification set"
Invoke-DemoDelete "notifications" "title=$(Enc 'like.Smoke*')" "smoke notifications"
Invoke-DemoDelete "messages" "id=eq.33333333-3333-4333-8333-333333333333" "seed chat message"
Invoke-DemoDelete "messages" "id=eq.33333333-3333-4333-8333-333333333334" "seed participant question"
Invoke-DemoDelete "messages" "message=$(Enc 'like.Smoke mentor question*')" "smoke chat messages"
Invoke-DemoDelete "submissions" "id=eq.22222222-2222-4222-8222-222222222222" "seed submission"
Invoke-DemoDelete "submissions" "project_name=$(Enc 'like.Smoke Project*')" "smoke submissions"
Invoke-DemoDelete "submissions" "project_name=$(Enc 'like.Negative Project*')" "negative smoke submissions"
Invoke-DemoDelete "team_members" "team_id=eq.11111111-1111-4111-8111-111111111111" "seed team members"
Invoke-DemoDelete "team_members" "team_id=eq.11111111-1111-4111-8111-111111111112" "seed other team members"
Invoke-DemoDelete "teams" "id=eq.11111111-1111-4111-8111-111111111111" "seed team"
Invoke-DemoDelete "teams" "id=eq.11111111-1111-4111-8111-111111111112" "seed other team"
Invoke-DemoDelete "teams" "name=$(Enc 'like.Smoke Team*')" "smoke teams"
Invoke-DemoDelete "teams" "name=$(Enc 'like.Negative Team*')" "negative smoke teams"
Invoke-DemoDelete "events" "id=eq.00000000-0000-4000-8000-000000000001" "seed event"

Write-Output "Demo reset finished. Run .\scripts\seed_demo_users.ps1 to recreate the clean demo workspace."
