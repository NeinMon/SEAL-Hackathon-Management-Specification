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
}
$upsertHeaders = $headers + @{ Prefer = "resolution=merge-duplicates,return=representation" }

function Invoke-Upsert([string]$Table, [hashtable]$Body, [string]$Label) {
  $payload = $Body | ConvertTo-Json -Depth 8
  Invoke-RestMethod `
    -Method Post `
    -Uri "$ProjectUrl/rest/v1/$Table" `
    -Headers $upsertHeaders `
    -Body $payload | Out-Null
  Write-Output "Ready: $Label"
}

function Get-DemoUser([string]$Email) {
  $result = Invoke-RestMethod `
    -Method Get `
    -Uri "$ProjectUrl/rest/v1/users?email=eq.$Email&select=*" `
    -Headers $headers
  @($result)[0]
}

$users = @(
  @{ email = "participant@seal.test"; password = "123456"; full_name = "Participant Demo"; role = "participant"; university = "FPT University" },
  @{ email = "judge@seal.test"; password = "123456"; full_name = "Judge Demo"; role = "judge"; university = "FPT University" },
  @{ email = "mentor@seal.test"; password = "123456"; full_name = "SEAL Mentor"; role = "mentor"; university = "SEAL Lab" },
  @{ email = "organizer@seal.test"; password = "123456"; full_name = "SEAL Organizer"; role = "organizer"; university = "SEAL Lab" }
)

foreach ($user in $users) {
  try {
    $authBody = @{
      email = $user.email
      password = $user.password
      email_confirm = $true
      user_metadata = @{
        full_name = $user.full_name
        role = $user.role
      }
    } | ConvertTo-Json -Depth 4
    $created = Invoke-RestMethod `
      -Method Post `
      -Uri "$ProjectUrl/auth/v1/admin/users" `
      -Headers $headers `
      -Body $authBody
    $id = $created.id
  } catch {
    $list = Invoke-RestMethod `
      -Method Get `
      -Uri "$ProjectUrl/auth/v1/admin/users" `
      -Headers $headers
    $existing = $list.users |
      Where-Object { $_.email -eq $user.email } |
      Select-Object -First 1
    $id = $existing.id
  }

  if (-not $id) {
    throw "Could not create or find demo user $($user.email)."
  }

  Invoke-Upsert "users" @{
    id = $id
    full_name = $user.full_name
    email = $user.email
    role = $user.role
    university = $user.university
  } "$($user.email) / 123456 ($($user.role))"
}

$participant = Get-DemoUser "participant@seal.test"
$judge = Get-DemoUser "judge@seal.test"
$mentor = Get-DemoUser "mentor@seal.test"
$organizer = Get-DemoUser "organizer@seal.test"

$eventId = "00000000-0000-4000-8000-000000000001"
$teamId = "11111111-1111-4111-8111-111111111111"
$otherTeamId = "11111111-1111-4111-8111-111111111112"
$submissionId = "22222222-2222-4222-8222-222222222222"
$scoreId = "22222222-2222-4222-8222-222222222223"
$messageId = "33333333-3333-4333-8333-333333333333"
$questionId = "33333333-3333-4333-8333-333333333334"

Invoke-Upsert "events" @{
  id = $eventId
  title = "SEAL Innovation Hackathon 2026"
  description = "Xay dung san pham cong nghe thuc te cho giao duc, cong dong va smart campus."
  start_date = "2026-06-12T08:00:00"
  end_date = "2026-06-14T18:00:00"
  location = "FPT University HCMC"
  banner_url = "https://images.unsplash.com/photo-1517048676732-d65bc937f952?w=1200"
  registration_deadline = "2026-06-05T23:59:00"
  max_team_size = 5
  rules = "Team nop GitHub repository, video demo va pitch cuoi truoc deadline."
  prize = "Giai nhat 20,000,000 VND, goi mentorship va ho tro incubation."
  latitude = 10.8411
  longitude = 106.8100
} "event SEAL Innovation Hackathon 2026"

Invoke-Upsert "teams" @{
  id = $teamId
  name = "Seal Builders"
  leader_id = $participant.id
  event_id = $eventId
} "team Seal Builders"

Invoke-Upsert "teams" @{
  id = $otherTeamId
  name = "Campus Makers"
  leader_id = $organizer.id
  event_id = $eventId
} "team Campus Makers"

foreach ($memberId in @($participant.id, $mentor.id)) {
  Invoke-Upsert "team_members" @{
    team_id = $teamId
    user_id = $memberId
  } "member $memberId in Seal Builders"
}

Invoke-Upsert "team_members" @{
  team_id = $otherTeamId
  user_id = $organizer.id
} "organizer demo team member"

Invoke-Upsert "submissions" @{
  id = $submissionId
  team_id = $teamId
  project_name = "Campus Copilot"
  github_url = "https://github.com/seal-demo/campus-copilot"
  video_url = "https://youtube.com/watch?v=seal-demo"
  description = "Mobile assistant ho tro thi sinh, mentor, giam khao va ban to chuc trong hackathon."
  status = "reviewed"
  submitted_at = "2026-06-01T08:30:00"
} "reviewed submission Campus Copilot"

Invoke-Upsert "scores" @{
  id = $scoreId
  submission_id = $submissionId
  judge_id = $judge.id
  technical_score = 8.5
  ui_score = 8.0
  innovation_score = 9.0
  feedback = "Luong mobile ro, tach role tot va trien khai Supabase RLS thuc te."
  average_score = 8.5
} "judge score for Campus Copilot"

Invoke-Upsert "messages" @{
  id = $messageId
  sender_id = $mentor.id
  receiver_id = $participant.id
  message = "Chao mung den voi SEAL Hackathon. Ban co the gui cau hoi ve repository hoac bai nop tai day."
  created_at = "2026-06-01T01:34:00"
} "mentor welcome message"

Invoke-Upsert "messages" @{
  id = $questionId
  sender_id = $participant.id
  receiver_id = $mentor.id
  message = "Mentor review giup team em repo va demo flow duoc khong?"
  created_at = "2026-06-01T11:50:00"
} "participant mentor question"

$notifications = @(
  @{
    id = "44444444-4444-4444-8444-444444444444"
    user_id = $participant.id
    title = "Demo workspace san sang"
    content = "Seal Builders va Campus Copilot da san sang cho demo."
    notification_type = "system"
    is_read = $false
    created_at = "2026-06-01T01:34:00"
  },
  @{
    id = "44444444-4444-4444-8444-444444444445"
    user_id = $participant.id
    title = "Da cong bo diem"
    content = "Campus Copilot da co feedback tu giam khao."
    notification_type = "score"
    is_read = $false
    created_at = "2026-06-01T09:15:00"
  },
  @{
    id = "44444444-4444-4444-8444-444444444446"
    user_id = $participant.id
    title = "Loi moi vao team"
    content = "Seal Builders da san sang moi them thanh vien."
    notification_type = "invitation"
    is_read = $true
    created_at = "2026-05-31T13:43:00"
  },
  @{
    id = "44444444-4444-4444-8444-444444444447"
    user_id = $judge.id
    title = "Hang cho cham da san sang"
    content = "Campus Copilot dang co trong queue cham diem."
    notification_type = "announcement"
    is_read = $false
    created_at = "2026-06-01T09:00:00"
  }
)

foreach ($notification in $notifications) {
  Invoke-Upsert "notifications" $notification "notification $($notification.title)"
}

Write-Output "Clean demo backend ready."
Write-Output "Accounts: participant@seal.test, judge@seal.test, mentor@seal.test, organizer@seal.test / 123456"
