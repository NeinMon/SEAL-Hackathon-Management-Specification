# Kich Ban Demo SEAL Hackathon

Tai lieu nay dung de demo day du UI tren Android Studio/emulator.
Thoi luong goi y: 7-10 phut. Ban day du: 12-15 phut.

## Chuan Bi Truoc Khi Demo

Chay cac lenh nay trong PowerShell tai thu muc project:

```powershell
npx supabase start
npx supabase migration up
$env:SUPABASE_SERVICE_ROLE_KEY="<local-service-role-key>"
.\scripts\reset_demo_database.ps1
.\scripts\seed_demo_users.ps1
```

Chay app tren Android emulator:

```powershell
flutter run -d emulator-5554 `
  --dart-define=APP_ENV=local `
  --dart-define=SUPABASE_URL=http://10.0.2.2:54321 `
  --dart-define=SUPABASE_ANON_KEY=sb_publishable_ACJWlzQHlZjBrEguHvfOxg_3BJgxAaH
```

Neu `flutter run` bi cham, build va cai APK truc tiep:

```powershell
flutter build apk --debug `
  --dart-define=APP_ENV=local `
  --dart-define=SUPABASE_URL=http://10.0.2.2:54321 `
  --dart-define=SUPABASE_ANON_KEY=sb_publishable_ACJWlzQHlZjBrEguHvfOxg_3BJgxAaH

& "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe" -s emulator-5554 install -r build\app\outputs\flutter-apk\app-debug.apk
& "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe" -s emulator-5554 shell am start -n vn.seal.hackathon/.MainActivity
```

## Tai Khoan Demo

```text
participant@seal.test / 123456
judge@seal.test / 123456
mentor@seal.test / 123456
organizer@seal.test / 123456
```

## Mo Dau

Noi ngan gon:

"SEAL Hackathon la ung dung mobile-first cho hackathon. App gom day du luong
su kien, doi thi, nop bai, cham diem, thong bao, chat voi mentor, ban do dia
diem va dashboard organizer. Demo nay dung du lieu Supabase that o local, co
RLS va test bao mat."

## Luong 1: Login Va Dieu Huong

1. Mo app tren Android emulator.
2. Dang nhap `participant@seal.test / 123456`.
3. Gioi thieu bottom navigation:
   - Events
   - Teams
   - Submit
   - Alerts
   - Chat
   - Map
   - Profile
4. Noi ro app dieu huong theo role: participant, judge, mentor, organizer.

Noi diem chinh:

"Day khong phai mock UI. App ket noi Supabase, doc session dang nhap va hien
thi cac man hinh phu hop voi tung vai tro."

## Luong 2: Events

1. Vao tab `Events`.
2. Bam nut refresh.
3. Tim kiem voi tu khoa `seal` hoac `campus`.
4. Doi filter: Upcoming, Active, All, Closed.
5. Mo chi tiet event.
6. Gioi thieu cac phan:
   - Banner su kien
   - Ngay bat dau/ket thuc
   - Han dang ky
   - Dia diem
   - Rules
   - Prize
   - Team stats
   - Leaderboard

Noi diem chinh:

"Man Events tap trung vao kha nang scan nhanh tren mobile: co phase chip,
search, filter, deadline va leaderboard trong chi tiet su kien."

## Luong 3: Teams

1. Vao tab `Teams`.
2. Gioi thieu team mau `Seal Builders`.
3. Show metric va roster thanh vien.
4. Bam refresh.
5. Show form tao team.
6. Thu de trong team name de noi ve validation.
7. Bam Invite Member neu co quyen leader va show dialog invite bang email.
8. Noi ve gioi han so thanh vien toi da.

Noi diem chinh:

"Teams ho tro tao doi, join, leave, rename va invite. App chan spam request
bang cach disable nut khi dang xu ly."

## Luong 4: Submission Lifecycle

1. Vao tab `Submit`.
2. Show card trang thai submission hien tai.
3. Doi qua lai giua `Draft` va `Submitted`.
4. Show cac truong:
   - Project name
   - GitHub URL
   - Demo video URL
   - Description
5. Bam refresh.
6. Cap nhat bai `Campus Copilot` voi noi dung:

```text
Project name: Campus Copilot
GitHub URL: https://github.com/seal-demo/campus-copilot
Demo video URL: https://youtube.com/watch?v=seal-demo
Description: Mobile assistant for hackathon participants, mentors, and organizers.
```

7. Cuon xuong `Submitted projects`.
8. Show:
   - Submitted timestamp
   - Update history
   - Judge feedback/scores neu da co diem

Noi diem chinh:

"Submission co lifecycle ro rang: draft, submitted, reviewed. Moi lan update
duoc ghi lai trong history de team va organizer theo doi."

## Luong 5: Alerts, Chat, Map, Profile

1. Vao `Alerts`.
2. Show thong bao duoc group, trang thai read/unread, delete neu co.
3. Vao `Chat`.
4. Chon mentor hoac organizer.
5. Gui tin nhan: `Can you review our demo flow?`
6. Xoa tin nhan va show confirmation.
7. Vao `Map`.
8. Show card dia diem, marker tren ban do, phone/time/location chips.
9. Bam `Copy address`.
10. Chi bam `Open in Maps` neu muon show external navigation.
11. Neu bi mo Google Maps, bam Android Back hoac Recent Apps de quay lai app.
12. Vao `Profile`.
13. Show cap nhat profile va logout.

Noi diem chinh:

"Chat contact duoc scope theo role. Mentor chi chat voi participant lien quan.
RLS o database cung chan conversation khong hop le."

## Luong 6: Judge

1. Logout.
2. Dang nhap `judge@seal.test / 123456`.
3. Vao `Judging`.
4. Bam refresh.
5. Show filters:
   - All
   - Unscored
   - Scored
6. Doi sort:
   - Newest first
   - Project name
   - Team
   - Average score
7. Mo card `Campus Copilot`.
8. Show nut Repository va Demo.
9. Dieu chinh 3 rubric sliders:
   - Technical depth
   - UI/UX quality
   - Innovation
10. Nhap feedback:

```text
Strong mobile workflow, clear UX, and useful mentor flow.
```

11. Submit score.
12. Update score lan nua de show confirmation truoc khi ghi de diem cu.

Noi diem chinh:

"Judge co hang doi cham diem, filter, sort, mo ta rubric va confirmation khi
update score cu de tranh bam nham trong demo."

## Luong 7: Organizer Dashboard

1. Logout.
2. Dang nhap `organizer@seal.test / 123456`.
3. Vao `Organizer`.
4. Bam refresh.
5. Show metrics:
   - Events
   - Active
   - Teams
   - Unscored
6. Show dashboard bars:
   - Teams
   - Submissions
   - Scored
   - Unscored
7. Bam `Create event` va show event editor.
8. Dong dialog hoac save mot thay doi nho.
9. Bam `Send announcement`.
10. Chon audience va nhap:

```text
Title: Demo announcement
Message: Final judging starts soon. Please keep repositories and demos ready.
```

11. Gui announcement.
12. Bam `Export leaderboard CSV` va show snackbar copied.
13. Show recent submissions va score average.

Noi diem chinh:

"Organizer co the van hanh su kien ngay tren mobile: tao/sua event, gui thong
bao, xem dashboard, export leaderboard va theo doi judging queue."

## Luong 8: Role Gate Va Bao Mat

1. Khi dang la organizer, vao `Judge` de show organizer co the preview scoring.
2. Logout va dang nhap participant lai.
3. Neu gap man hinh role-limited, show `Access Restricted`.
4. Giai thich UI gate chi la lop dau; RLS moi la lop bao mat chinh.

Neu muon chung minh bang script:

```powershell
.\scripts\smoke_supabase_flow.ps1
.\scripts\smoke_supabase_negative.ps1
```

Ket qua negative smoke can noi:

- Participant khong tao duoc score.
- Judge khong update duoc score cua judge khac.
- Participant khong doc duoc notification cua user khac.
- Participant khong doc duoc message cua user khac.
- Participant khong sua duoc team/submission ngoai team.
- Mentor khong chat duoc voi participant khong lien quan.

## Phan Mo Rong: Hosted Supabase Va CI

Neu duoc hoi ve production readiness, mo nhanh cac file:

- `docs/HOSTED_SUPABASE.md`
- `scripts/hosted_supabase_check.ps1`
- `.github/workflows/flutter_android.yml`
- `docs/ARCHITECTURE.md`

Noi diem chinh:

"Project da tach local, staging va production bang Dart defines. Khi co key
Supabase hosted that, co the chay hosted smoke test bang mot script. CI dang
chay analyze, test, debug APK va release APK."

## Cau Ket Demo

"Ung dung Android-first, chay duoc tu Android Studio, dung du lieu Supabase
that, co RLS positive/negative tests, co loading/error state, va cover du
luong participant, judge, mentor, organizer."

## Xu Ly Nhanh Khi Demo

Neu du lieu demo bi roi:

```powershell
$env:SUPABASE_SERVICE_ROLE_KEY="<local-service-role-key>"
.\scripts\reset_demo_database.ps1
.\scripts\seed_demo_users.ps1
```

Neu mo external Maps va khong quay lai duoc:

1. Bam Android Back.
2. Hoac bam Recent Apps tren thanh cong cu emulator.
3. Chon lai `SEAL Hackathon`.

Neu app hien `Supabase connection required`, chay lai app voi defines:

```powershell
flutter run -d emulator-5554 `
  --dart-define=APP_ENV=local `
  --dart-define=SUPABASE_URL=http://10.0.2.2:54321 `
  --dart-define=SUPABASE_ANON_KEY=sb_publishable_ACJWlzQHlZjBrEguHvfOxg_3BJgxAaH
```
