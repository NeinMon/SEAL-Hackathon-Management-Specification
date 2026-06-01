# Kich Ban Demo SEAL Hackathon

Kich ban nay dung de demo nhanh UI va nghiep vu chinh tren Android Studio/emulator.
Thoi luong goi y: 5-7 phut.

## Chuan Bi

```powershell
npx supabase start
npx supabase migration up
$env:SUPABASE_SERVICE_ROLE_KEY="<local-service-role-key>"
.\scripts\reset_demo_database.ps1
.\scripts\seed_demo_users.ps1
```

Chay app:

```powershell
flutter run -d emulator-5554 `
  --dart-define=APP_ENV=local `
  --dart-define=SUPABASE_URL=http://10.0.2.2:54321 `
  --dart-define=SUPABASE_ANON_KEY=sb_publishable_ACJWlzQHlZjBrEguHvfOxg_3BJgxAaH
```

Tai khoan demo:

```text
participant@seal.test / 123456
judge@seal.test / 123456
mentor@seal.test / 123456
organizer@seal.test / 123456
```

## Mo Dau

"SEAL Hackathon la app mobile quan ly hackathon tu dau den cuoi: xem su kien,
quan ly team, nop bai, mentor chat, cham diem, thong bao, ban do dia diem va
dashboard organizer. Demo nay dung Supabase local that, co RLS va du lieu mau."

## 1. Participant Flow

Dang nhap:

```text
participant@seal.test / 123456
```

Show nhanh cac tab participant:

1. `Events`
   - Show danh sach event, banner, deadline, location.
   - Mo event detail de show rules, prize, team stats va leaderboard.

2. `Teams`
   - Show team mau `Seal Builders`.
   - Show roster thanh vien, leader badge, nut `Create Team` dang thu gon.
   - Mo nut `Invite to this team` trong card team de thay invite dung team nao.
   - Nut `Submit Project` chi hien khi user da co team.
   - Noi ngan gon: team validate max size va chi leader moi invite/rename.

3. `Submit`
   - Show submission status card.
   - Show form GitHub URL, demo URL, description da auto-fill tu submission hien tai.
   - Show `Latest submission`, timestamp, update history va feedback/score neu co.

4. `Alerts`
   - Show thong bao he thong, score notification, read/unread state.

5. `Chat`
   - Show contact mentor/organizer.
   - Gui mot tin nhan ngan: `Can you review our demo flow?`
   - Noi ngan gon: mentor chat duoc scope theo team lien quan.

6. `Map`
   - Show map venue, marker, address, copy address.
   - Uu tien `Copy address`; `Open in Maps` la tuy chon phu va co confirm.

7. `Profile`
   - Show thong tin user va form update profile.

Noi diem chinh:

"Participant co mot workspace day du tren mobile: xem su kien, lam viec voi
team, nop bai, nhan thong bao, hoi mentor va xem dia diem."

## 2. Judge Flow

Dang nhap:

```text
judge@seal.test / 123456
```

Show man `Judging`:

1. Show queue va dropdown `Submission to score`.
2. Chon card `Campus Copilot`.
3. Show repository/demo buttons.
4. Show rubric:
   - Technical depth
   - UI/UX quality
   - Innovation
5. Keo slider diem va nhap feedback:

```text
Strong mobile workflow, clear UX, and useful mentor flow.
```

6. Show `Current score`, roi submit score.
7. Neu update diem cu, show confirmation truoc khi ghi de.

Noi diem chinh:

"Judge co man cham diem tap trung, co rubric ro rang, feedback bat buoc va
confirmation khi update diem cu."

## 3. Organizer Flow

Dang nhap:

```text
organizer@seal.test / 123456
```

Show man `Organizer`:

1. Show metrics: Events, Active, Teams, Unscored.
2. Show dashboard bars: Teams, Submissions, Scored, Unscored.
3. Show `Create event` de mo event editor.
4. Show `Send announcement`:

```text
Title: Demo announcement
Message: Final judging starts soon. Please keep repositories and demos ready.
```

5. Mo `More actions` de show `Export leaderboard CSV` va `Judging queue`.
6. Show recent submissions va average score.

Noi diem chinh:

"Organizer co the van hanh su kien ngay tren mobile: tao/sua event, gui thong
bao, xem tinh trang judging va export leaderboard."

## 4. Security Va Readiness

Noi ngan gon, khong can chay live neu thoi gian ngan:

"UI role gate chi la lop dau. Database RLS da duoc test bang positive va
negative smoke scripts."

Cac case da test:

- Participant khong tao duoc score.
- Judge khong sua duoc score cua judge khac.
- Participant khong doc duoc notification/message cua user khac.
- Participant khong sua duoc team/submission ngoai team.
- Mentor khong chat duoc voi participant khong lien quan.

Neu can chung minh:

```powershell
.\scripts\smoke_supabase_flow.ps1
.\scripts\smoke_supabase_negative.ps1
```

## Ket Demo

"App da san sang demo tren Android Studio: UI mobile gon, dung du lieu Supabase
that, co role-based flows, co RLS tests, co debug/release APK build trong CI."

## Xu Ly Nhanh

Reset du lieu demo:

```powershell
$env:SUPABASE_SERVICE_ROLE_KEY="<local-service-role-key>"
.\scripts\reset_demo_database.ps1
.\scripts\seed_demo_users.ps1
```

Neu app bao `Supabase connection required`, chay lai app voi day du
`--dart-define`.
