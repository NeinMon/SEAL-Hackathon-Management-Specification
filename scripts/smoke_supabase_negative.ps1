param(
  [string]$ProjectUrl = "http://127.0.0.1:54321",
  [string]$AnonKey = "sb_publishable_ACJWlzQHlZjBrEguHvfOxg_3BJgxAaH",
  [string]$ServiceRoleKey = $env:SUPABASE_SERVICE_ROLE_KEY,
  [string]$ParticipantEmail = "participant@seal.test",
  [string]$JudgeEmail = "judge@seal.test",
  [string]$Password = "123456"
)

$ErrorActionPreference = "Stop"

function New-BaseHeaders {
  @{
    apikey = $AnonKey
    "Content-Type" = "application/json"
  }
}

function Login-User([string]$Email) {
  $body = @{
    email = $Email
    password = $Password
  } | ConvertTo-Json

  Invoke-RestMethod `
    -Method Post `
    -Uri "$ProjectUrl/auth/v1/token?grant_type=password" `
    -Headers (New-BaseHeaders) `
    -Body $body
}

function New-AuthHeaders([string]$Token, [string]$Prefer = $null) {
  $headers = New-BaseHeaders
  $headers.Authorization = "Bearer $Token"
  if ($Prefer) {
    $headers.Prefer = $Prefer
  }
  $headers
}

function First-Item($Value, [string]$Name) {
  $item = @($Value)[0]
  if (-not $item) {
    throw "Expected $Name but received no data."
  }
  $item
}

function Assert-Blocked([scriptblock]$Action, [string]$Name) {
  try {
    $result = & $Action
    if ($null -eq $result -or @($result).Count -eq 0) {
      Write-Output "PASS: $Name was blocked with no returned rows."
      return
    }
    throw "Expected the request to be blocked, but it returned rows."
  } catch {
    Write-Output "PASS: $Name was blocked. $($_.Exception.Message)"
  }
}

$participant = Login-User $ParticipantEmail
$judge = Login-User $JudgeEmail
$participantHeaders = New-AuthHeaders $participant.access_token
$participantReturnHeaders = New-AuthHeaders $participant.access_token "return=representation"
$judgeReturnHeaders = New-AuthHeaders $judge.access_token "return=representation"

$event = First-Item `
  (Invoke-RestMethod -Method Get -Uri "$ProjectUrl/rest/v1/events?select=*&limit=1" -Headers $participantHeaders) `
  "event"

$runId = Get-Date -Format "yyyyMMddHHmmss"
$teamBody = @{
  name = "Negative Team $runId"
  leader_id = $participant.user.id
  event_id = $event.id
} | ConvertTo-Json
$team = First-Item `
  (Invoke-RestMethod -Method Post -Uri "$ProjectUrl/rest/v1/teams?select=*" -Headers $participantReturnHeaders -Body $teamBody) `
  "team"

$memberBody = @{
  team_id = $team.id
  user_id = $participant.user.id
} | ConvertTo-Json
Invoke-RestMethod `
  -Method Post `
  -Uri "$ProjectUrl/rest/v1/team_members" `
  -Headers (New-AuthHeaders $participant.access_token "resolution=merge-duplicates") `
  -Body $memberBody | Out-Null

$submissionBody = @{
  team_id = $team.id
  project_name = "Negative Project $runId"
  github_url = "https://github.com/seal-demo/negative-project"
  video_url = "https://example.com/demo"
  description = "Negative RLS smoke submission."
  status = "submitted"
} | ConvertTo-Json
$submission = First-Item `
  (Invoke-RestMethod -Method Post -Uri "$ProjectUrl/rest/v1/submissions?select=*" -Headers $participantReturnHeaders -Body $submissionBody) `
  "submission"

$participantScoreBody = @{
  submission_id = $submission.id
  judge_id = $participant.user.id
  technical_score = 10
  ui_score = 10
  innovation_score = 10
  feedback = "Participant should not score."
  average_score = 10
} | ConvertTo-Json

Assert-Blocked -Name "participant cannot create scores" -Action {
  Invoke-RestMethod `
    -Method Post `
    -Uri "$ProjectUrl/rest/v1/scores?select=*" `
    -Headers $participantReturnHeaders `
    -Body $participantScoreBody
}

if ($ServiceRoleKey) {
  $serviceHeaders = @{
    apikey = $ServiceRoleKey
    Authorization = "Bearer $ServiceRoleKey"
    "Content-Type" = "application/json"
    Prefer = "resolution=merge-duplicates,return=representation"
  }
  $scoreId = "55555555-5555-4555-8555-555555555555"
  $otherJudgeScoreBody = @{
    id = $scoreId
    submission_id = $submission.id
    judge_id = $participant.user.id
    technical_score = 6
    ui_score = 6
    innovation_score = 6
    feedback = "Seeded by service role for negative update check."
    average_score = 6
  } | ConvertTo-Json
  Invoke-RestMethod `
    -Method Post `
    -Uri "$ProjectUrl/rest/v1/scores" `
    -Headers $serviceHeaders `
    -Body $otherJudgeScoreBody | Out-Null

  $judgePatchBody = @{
    technical_score = 9
    ui_score = 9
    innovation_score = 9
    feedback = "Judge should not update another judge score."
    average_score = 9
  } | ConvertTo-Json

  Assert-Blocked -Name "judge cannot update another user's score" -Action {
    Invoke-RestMethod `
      -Method Patch `
      -Uri "$ProjectUrl/rest/v1/scores?id=eq.$scoreId&select=*" `
      -Headers $judgeReturnHeaders `
      -Body $judgePatchBody
  }
} else {
  Write-Output "SKIP: judge update negative case requires SUPABASE_SERVICE_ROLE_KEY."
}
