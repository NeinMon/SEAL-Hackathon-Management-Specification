param(
  [string]$ProjectUrl = "http://127.0.0.1:55321",
  [string]$AnonKey = "sb_publishable_ACJWlzQHlZjBrEguHvfOxg_3BJgxAaH",
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

$participant = Login-User $ParticipantEmail
$judge = Login-User $JudgeEmail
$participantHeaders = New-AuthHeaders $participant.access_token
$judgeHeaders = New-AuthHeaders $judge.access_token
$returnHeaders = New-AuthHeaders $participant.access_token "return=representation"
$judgeUpsertHeaders = New-AuthHeaders $judge.access_token "resolution=merge-duplicates,return=representation"

$event = First-Item `
  (Invoke-RestMethod -Method Get -Uri "$ProjectUrl/rest/v1/events?select=*&limit=1" -Headers $participantHeaders) `
  "event"

$mentor = First-Item `
  (Invoke-RestMethod -Method Get -Uri "$ProjectUrl/rest/v1/users?role=eq.mentor&select=*&limit=1" -Headers $participantHeaders) `
  "mentor"

$runId = Get-Date -Format "yyyyMMddHHmmss"

$existingMembership = Invoke-RestMethod `
  -Method Get `
  -Uri "$ProjectUrl/rest/v1/team_members?user_id=eq.$($participant.user.id)&select=team_id,teams(*)&limit=1" `
  -Headers $participantHeaders

if (@($existingMembership).Count -gt 0) {
  $team = (First-Item $existingMembership "existing team membership").teams
} else {
  $teamBody = @{
    name = "Smoke Team $runId"
    leader_id = $participant.user.id
    event_id = $event.id
  } | ConvertTo-Json
  $team = First-Item `
    (Invoke-RestMethod -Method Post -Uri "$ProjectUrl/rest/v1/teams?select=*" -Headers $returnHeaders -Body $teamBody) `
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
}

$submissionBody = @{
  team_id = $team.id
  project_name = "Smoke Project $runId"
  github_url = "https://github.com/seal-demo/smoke-project"
  video_url = "https://example.com/demo"
  description = "Smoke submission created through Supabase REST."
  status = "submitted"
} | ConvertTo-Json
$submission = First-Item `
  (Invoke-RestMethod -Method Post -Uri "$ProjectUrl/rest/v1/submissions?select=*" -Headers $returnHeaders -Body $submissionBody) `
  "submission"

$messageBody = @{
  sender_id = $participant.user.id
  receiver_id = $mentor.id
  message = "Smoke mentor question $runId"
} | ConvertTo-Json
$message = First-Item `
  (Invoke-RestMethod -Method Post -Uri "$ProjectUrl/rest/v1/messages?select=*" -Headers $returnHeaders -Body $messageBody) `
  "message"

$scoreBody = @{
  submission_id = $submission.id
  judge_id = $judge.user.id
  technical_score = 8
  ui_score = 8
  innovation_score = 9
  feedback = "Smoke score insert."
  average_score = 8.3333
} | ConvertTo-Json
$score = First-Item `
  (Invoke-RestMethod -Method Post -Uri "$ProjectUrl/rest/v1/scores?on_conflict=submission_id,judge_id&select=*" -Headers $judgeUpsertHeaders -Body $scoreBody) `
  "score"

$scoreUpdateBody = @{
  submission_id = $submission.id
  judge_id = $judge.user.id
  technical_score = 9
  ui_score = 9
  innovation_score = 9
  feedback = "Smoke score update."
  average_score = 9
} | ConvertTo-Json
$scoreUpdate = First-Item `
  (Invoke-RestMethod -Method Post -Uri "$ProjectUrl/rest/v1/scores?on_conflict=submission_id,judge_id&select=*" -Headers $judgeUpsertHeaders -Body $scoreUpdateBody) `
  "score update"

$notificationTitle = "Smoke score published $runId"
$notificationBody = @{
  user_id = $participant.user.id
  title = $notificationTitle
  content = "Judge score created in smoke flow."
  notification_type = "score"
} | ConvertTo-Json
Invoke-RestMethod `
  -Method Post `
  -Uri "$ProjectUrl/rest/v1/notifications" `
  -Headers (New-AuthHeaders $judge.access_token) `
  -Body $notificationBody | Out-Null

$escapedTitle = [uri]::EscapeDataString($notificationTitle)
$notification = First-Item `
  (Invoke-RestMethod -Method Get -Uri "$ProjectUrl/rest/v1/notifications?title=eq.$escapedTitle&select=*" -Headers $participantHeaders) `
  "notification"

$read = First-Item `
  (Invoke-RestMethod `
    -Method Patch `
    -Uri "$ProjectUrl/rest/v1/notifications?id=eq.$($notification.id)&select=*" `
    -Headers (New-AuthHeaders $participant.access_token "return=representation") `
    -Body (@{ is_read = $true } | ConvertTo-Json)) `
  "read notification"

[PSCustomObject]@{
  EventLoaded = [bool]$event.id
  TeamCreated = $team.name
  SubmissionCreated = $submission.project_name
  MessageCreated = $message.message
  ScoreInsertedAverage = $score.average_score
  ScoreUpdatedAverage = $scoreUpdate.average_score
  NotificationRead = $read.is_read
} | Format-List
