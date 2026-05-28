param(
  [string]$ProjectUrl = "http://127.0.0.1:54321",
  [string]$ServiceRoleKey = $env:SUPABASE_SERVICE_ROLE_KEY
)

if (-not $ServiceRoleKey) {
  throw "Set SUPABASE_SERVICE_ROLE_KEY before running this script."
}

$projectUrl = $ProjectUrl
$secret = $ServiceRoleKey
$headers = @{
  apikey = $secret
  Authorization = "Bearer $secret"
  "Content-Type" = "application/json"
}

$users = @(
  @{ email = "participant@seal.test"; password = "123456"; full_name = "Participant Demo"; role = "participant"; university = "FPT University" },
  @{ email = "judge@seal.test"; password = "123456"; full_name = "Judge Demo"; role = "judge"; university = "FPT University" },
  @{ email = "mentor@seal.test"; password = "123456"; full_name = "SEAL Mentor"; role = "mentor"; university = "SEAL Lab" },
  @{ email = "organizer@seal.test"; password = "123456"; full_name = "SEAL Organizer"; role = "organizer"; university = "SEAL Lab" }
)

foreach ($user in $users) {
  try {
    $body = @{
      email = $user.email
      password = $user.password
      email_confirm = $true
      user_metadata = @{
        full_name = $user.full_name
        role = $user.role
      }
    } | ConvertTo-Json -Depth 4
    $created = Invoke-RestMethod -Method Post -Uri "$projectUrl/auth/v1/admin/users" -Headers $headers -Body $body
    $id = $created.id
  } catch {
    $list = Invoke-RestMethod -Method Get -Uri "$projectUrl/auth/v1/admin/users" -Headers $headers
    $existing = $list.users | Where-Object { $_.email -eq $user.email } | Select-Object -First 1
    $id = $existing.id
  }

  if ($id) {
    $profile = @{
      id = $id
      full_name = $user.full_name
      email = $user.email
      role = $user.role
      university = $user.university
    } | ConvertTo-Json
    Invoke-RestMethod -Method Post -Uri "$projectUrl/rest/v1/users" -Headers ($headers + @{ Prefer = "resolution=merge-duplicates" }) -Body $profile | Out-Null
    Write-Output "Ready: $($user.email) / 123456 ($($user.role))"
  }
}

$participant = (Invoke-RestMethod -Method Get -Uri "$projectUrl/rest/v1/users?email=eq.participant@seal.test&select=*" -Headers $headers)[0]
$mentor = (Invoke-RestMethod -Method Get -Uri "$projectUrl/rest/v1/users?email=eq.mentor@seal.test&select=*" -Headers $headers)[0]
$judge = (Invoke-RestMethod -Method Get -Uri "$projectUrl/rest/v1/users?email=eq.judge@seal.test&select=*" -Headers $headers)[0]
$event = (Invoke-RestMethod -Method Get -Uri "$projectUrl/rest/v1/events?select=*&limit=1" -Headers $headers)[0]

$teamId = "11111111-1111-4111-8111-111111111111"
$submissionId = "22222222-2222-4222-8222-222222222222"

$upsertHeaders = $headers + @{ Prefer = "resolution=merge-duplicates,return=representation" }

$team = @{
  id = $teamId
  name = "Seal Builders"
  leader_id = $participant.id
  event_id = $event.id
} | ConvertTo-Json
Invoke-RestMethod -Method Post -Uri "$projectUrl/rest/v1/teams" -Headers $upsertHeaders -Body $team | Out-Null

foreach ($memberId in @($participant.id, $mentor.id)) {
  $member = @{
    team_id = $teamId
    user_id = $memberId
  } | ConvertTo-Json
  Invoke-RestMethod -Method Post -Uri "$projectUrl/rest/v1/team_members" -Headers $upsertHeaders -Body $member | Out-Null
}

$submission = @{
  id = $submissionId
  team_id = $teamId
  project_name = "Campus Copilot"
  github_url = "https://github.com/seal-demo/campus-copilot"
  video_url = "https://youtube.com/watch?v=seal-demo"
  description = "A mobile assistant for hackathon participants, mentors, and organizers."
  status = "submitted"
} | ConvertTo-Json
Invoke-RestMethod -Method Post -Uri "$projectUrl/rest/v1/submissions" -Headers $upsertHeaders -Body $submission | Out-Null

$message = @{
  id = "33333333-3333-4333-8333-333333333333"
  sender_id = $mentor.id
  receiver_id = $participant.id
  message = "Welcome to SEAL Hackathon. Send repository or submission questions here."
} | ConvertTo-Json
Invoke-RestMethod -Method Post -Uri "$projectUrl/rest/v1/messages" -Headers $upsertHeaders -Body $message | Out-Null

$notification = @{
  id = "44444444-4444-4444-8444-444444444444"
  user_id = $participant.id
  title = "Demo workspace ready"
  content = "Seal Builders and Campus Copilot are ready for the demo workflow."
  notification_type = "system"
  is_read = $false
} | ConvertTo-Json
Invoke-RestMethod -Method Post -Uri "$projectUrl/rest/v1/notifications" -Headers $upsertHeaders -Body $notification | Out-Null

Write-Output "Demo data ready: team, submission, message, notification."
