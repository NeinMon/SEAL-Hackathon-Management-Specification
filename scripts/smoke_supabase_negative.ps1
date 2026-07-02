param(
  [string]$ProjectUrl = "http://127.0.0.1:55321",
  [string]$AnonKey = "sb_publishable_ACJWlzQHlZjBrEguHvfOxg_3BJgxAaH",
  [string]$ServiceRoleKey = $env:SUPABASE_SERVICE_ROLE_KEY,
  [string]$ParticipantEmail = "participant@seal.test",
  [string]$JudgeEmail = "judge@seal.test",
  [string]$MentorEmail = "mentor@seal.test",
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
$mentor = Login-User $MentorEmail
$participantHeaders = New-AuthHeaders $participant.access_token
$participantReturnHeaders = New-AuthHeaders $participant.access_token "return=representation"
$judgeReturnHeaders = New-AuthHeaders $judge.access_token "return=representation"
$mentorReturnHeaders = New-AuthHeaders $mentor.access_token "return=representation"

$event = First-Item `
  (Invoke-RestMethod -Method Get -Uri "$ProjectUrl/rest/v1/events?select=*&limit=1" -Headers $participantHeaders) `
  "event"

$runId = Get-Date -Format "yyyyMMddHHmmss"
$existingMembership = Invoke-RestMethod `
  -Method Get `
  -Uri "$ProjectUrl/rest/v1/team_members?user_id=eq.$($participant.user.id)&select=team_id,teams(*)&limit=1" `
  -Headers $participantHeaders

if (@($existingMembership).Count -gt 0) {
  $team = (First-Item $existingMembership "existing team membership").teams
} else {
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
}

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

  $judgeNotificationBody = @{
    user_id = $judge.user.id
    title = "Private judge notification $runId"
    content = "Participant must not read this notification."
    notification_type = "system"
  } | ConvertTo-Json
  $judgeNotification = First-Item `
    (Invoke-RestMethod -Method Post -Uri "$ProjectUrl/rest/v1/notifications?select=*" -Headers $serviceHeaders -Body $judgeNotificationBody) `
    "judge notification"

  Assert-Blocked -Name "participant cannot read another user's notification" -Action {
    Invoke-RestMethod `
      -Method Get `
      -Uri "$ProjectUrl/rest/v1/notifications?id=eq.$($judgeNotification.id)&select=*" `
      -Headers $participantHeaders
  }

  $privateMessageBody = @{
    sender_id = $judge.user.id
    receiver_id = $mentor.user.id
    message = "Private judge mentor message $runId"
  } | ConvertTo-Json
  $privateMessage = First-Item `
    (Invoke-RestMethod -Method Post -Uri "$ProjectUrl/rest/v1/messages?select=*" -Headers $serviceHeaders -Body $privateMessageBody) `
    "private message"

  Assert-Blocked -Name "participant cannot read another user's message" -Action {
    Invoke-RestMethod `
      -Method Get `
      -Uri "$ProjectUrl/rest/v1/messages?id=eq.$($privateMessage.id)&select=*" `
      -Headers $participantHeaders
  }

  $otherTeamBody = @{
    name = "Other Team $runId"
    leader_id = $judge.user.id
    event_id = $event.id
  } | ConvertTo-Json
  $otherTeam = First-Item `
    (Invoke-RestMethod -Method Post -Uri "$ProjectUrl/rest/v1/teams?select=*" -Headers $serviceHeaders -Body $otherTeamBody) `
    "other team"

  Assert-Blocked -Name "participant cannot update another team" -Action {
    Invoke-RestMethod `
      -Method Patch `
      -Uri "$ProjectUrl/rest/v1/teams?id=eq.$($otherTeam.id)&select=*" `
      -Headers $participantReturnHeaders `
      -Body (@{ name = "Hijacked Team $runId" } | ConvertTo-Json)
  }

  $otherSubmissionBody = @{
    team_id = $otherTeam.id
    project_name = "Other Project $runId"
    github_url = "https://github.com/seal-demo/other-project"
    video_url = "https://example.com/other-demo"
    description = "Submission owned by another team."
    status = "submitted"
  } | ConvertTo-Json
  $otherSubmission = First-Item `
    (Invoke-RestMethod -Method Post -Uri "$ProjectUrl/rest/v1/submissions?select=*" -Headers $serviceHeaders -Body $otherSubmissionBody) `
    "other submission"

  Assert-Blocked -Name "participant cannot update another team's submission" -Action {
    Invoke-RestMethod `
      -Method Patch `
      -Uri "$ProjectUrl/rest/v1/submissions?id=eq.$($otherSubmission.id)&select=*" `
      -Headers $participantReturnHeaders `
      -Body (@{ project_name = "Hijacked Project $runId" } | ConvertTo-Json)
  }

  $outsiderEmail = "outsider-$runId@seal.test"
  $outsiderAuthBody = @{
    email = $outsiderEmail
    password = $Password
    email_confirm = $true
  } | ConvertTo-Json
  $outsiderAuth = Invoke-RestMethod `
    -Method Post `
    -Uri "$ProjectUrl/auth/v1/admin/users" `
    -Headers $serviceHeaders `
    -Body $outsiderAuthBody
  $outsiderProfileBody = @{
    id = $outsiderAuth.id
    full_name = "Outside Participant $runId"
    email = $outsiderEmail
    role = "participant"
    university = "Negative Test"
  } | ConvertTo-Json
  Invoke-RestMethod `
    -Method Post `
    -Uri "$ProjectUrl/rest/v1/users" `
    -Headers $serviceHeaders `
    -Body $outsiderProfileBody | Out-Null

  $blockedMentorMessageBody = @{
    sender_id = $mentor.user.id
    receiver_id = $outsiderAuth.id
    message = "Mentor should not message unrelated participant $runId"
  } | ConvertTo-Json

  Assert-Blocked -Name "mentor cannot chat with unrelated participant" -Action {
    Invoke-RestMethod `
      -Method Post `
      -Uri "$ProjectUrl/rest/v1/messages?select=*" `
      -Headers $mentorReturnHeaders `
      -Body $blockedMentorMessageBody
  }

  Assert-Blocked -Name "participant cannot promote own role to organizer" -Action {
    Invoke-RestMethod `
      -Method Patch `
      -Uri "$ProjectUrl/rest/v1/users?id=eq.$($participant.user.id)&select=*" `
      -Headers $participantReturnHeaders `
      -Body (@{ role = "organizer" } | ConvertTo-Json)
  }

  $closedEventId = "00000000-0000-4000-8000-000000009999"
  $closedEventBody = @{
    id = $closedEventId
    title = "Closed Lifecycle Event $runId"
    description = "Closed event for lifecycle negative smoke."
    start_date = "2020-06-01T08:00:00"
    end_date = "2020-06-03T18:00:00"
    location = "HCMC"
    banner_url = "https://example.com/closed.jpg"
    registration_deadline = "2020-06-01T23:59:00"
    max_team_size = 5
    rules = "Closed"
    prize = "Closed"
    latitude = 10.8411
    longitude = 106.8100
  } | ConvertTo-Json -Depth 4
  Invoke-RestMethod `
    -Method Post `
    -Uri "$ProjectUrl/rest/v1/events" `
    -Headers $serviceHeaders `
    -Body $closedEventBody | Out-Null

  Assert-Blocked -Name "participant cannot create team when registration closed" -Action {
    Invoke-RestMethod `
      -Method Post `
      -Uri "$ProjectUrl/rest/v1/teams?select=*" `
      -Headers $participantReturnHeaders `
      -Body (@{
        name = "Closed Registration Team $runId"
        leader_id = $participant.user.id
        event_id = $closedEventId
      } | ConvertTo-Json)
  }

  $upcomingEventId = "00000000-0000-4000-8000-000000009998"
  $upcomingStart = (Get-Date).AddDays(30).ToString("yyyy-MM-ddTHH:mm:ss")
  $upcomingEnd = (Get-Date).AddDays(32).ToString("yyyy-MM-ddTHH:mm:ss")
  $upcomingDeadline = (Get-Date).AddDays(29).ToString("yyyy-MM-ddTHH:mm:ss")
  $upcomingEventBody = @{
    id = $upcomingEventId
    title = "Upcoming Lifecycle Event $runId"
    description = "Upcoming event for judging negative smoke."
    start_date = $upcomingStart
    end_date = $upcomingEnd
    location = "HCMC"
    banner_url = "https://example.com/upcoming.jpg"
    registration_deadline = $upcomingDeadline
    max_team_size = 5
    rules = "Upcoming"
    prize = "Upcoming"
    latitude = 10.8411
    longitude = 106.8100
  } | ConvertTo-Json -Depth 4
  Invoke-RestMethod `
    -Method Post `
    -Uri "$ProjectUrl/rest/v1/events" `
    -Headers $serviceHeaders `
    -Body $upcomingEventBody | Out-Null

  $upcomingTeamBody = @{
    name = "Upcoming Team $runId"
    leader_id = $participant.user.id
    event_id = $upcomingEventId
  } | ConvertTo-Json
  $upcomingTeam = First-Item `
    (Invoke-RestMethod `
      -Method Post `
      -Uri "$ProjectUrl/rest/v1/teams?select=*" `
      -Headers $serviceHeaders `
      -Body $upcomingTeamBody) `
    "upcoming team"

  Invoke-RestMethod `
    -Method Post `
    -Uri "$ProjectUrl/rest/v1/team_members" `
    -Headers $serviceHeaders `
    -Body (@{
      team_id = $upcomingTeam.id
      user_id = $participant.user.id
    } | ConvertTo-Json) | Out-Null

  $upcomingSubmissionBody = @{
    team_id = $upcomingTeam.id
    project_name = "Upcoming Project $runId"
    github_url = "https://github.com/seal-demo/upcoming"
    video_url = "https://example.com/upcoming-demo"
    description = "Submission for upcoming judging negative smoke."
    status = "submitted"
  } | ConvertTo-Json
  $upcomingSubmission = First-Item `
    (Invoke-RestMethod `
      -Method Post `
      -Uri "$ProjectUrl/rest/v1/submissions?select=*" `
      -Headers $serviceHeaders `
      -Body $upcomingSubmissionBody) `
    "upcoming submission"

  Assert-Blocked -Name "judge cannot score before event starts" -Action {
    Invoke-RestMethod `
      -Method Post `
      -Uri "$ProjectUrl/rest/v1/scores?select=*" `
      -Headers $judgeReturnHeaders `
      -Body (@{
        submission_id = $upcomingSubmission.id
        judge_id = $judge.user.id
        technical_score = 8
        ui_score = 8
        innovation_score = 8
        feedback = "Too early to score."
        average_score = 8
      } | ConvertTo-Json)
  }
} else {
  Write-Output "SKIP: judge update negative case requires SUPABASE_SERVICE_ROLE_KEY."
}
