import 'package:flutter_test/flutter_test.dart';
import 'package:seal_hackathon_app/main.dart';

void main() {
  testWidgets('Login screen fits landscape with form fields', (tester) async {
    tester.view.physicalSize = const Size(844, 390);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AuthProvider(restoreSession: false),
        child: const MaterialApp(home: LoginScreen()),
      ),
    );
    await tester.pump();

    expect(find.text('SEAL Hackathon'), findsWidgets);
    expect(find.byType(TextField), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('Login form validates before calling auth flow', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AuthProvider(restoreSession: false),
        child: const MaterialApp(home: LoginScreen()),
      ),
    );
    await tester.pump();

    await tester.tap(find.byType(FilledButton));
    await tester.pump();

    expect(find.text('Nhập email hợp lệ.'), findsOneWidget);
    expect(find.text('Mật khẩu cần ít nhất 6 ký tự.'), findsOneWidget);
  });

  testWidgets('Event list filters by search keyword', (tester) async {
    final provider = TestEventProvider()
      ..events = [
        _event(id: 'campus', title: 'Campus Innovation', location: 'HCMC'),
        _event(id: 'finance', title: 'Fintech Sprint', location: 'Da Nang'),
      ];

    await tester.pumpWidget(
      ChangeNotifierProvider<EventProvider>.value(
        value: provider,
        child: const MaterialApp(home: Scaffold(body: EventListScreen())),
      ),
    );
    await tester.pump();

    expect(find.text('Campus Innovation'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'fintech');
    await tester.pump();

    expect(find.text('Fintech Sprint'), findsOneWidget);
    expect(find.text('Campus Innovation'), findsNothing);
  });

  testWidgets('Event cards expose semantic open labels', (tester) async {
    final provider = TestEventProvider()
      ..events = [
        _event(id: 'campus', title: 'Campus Innovation', location: 'HCMC'),
      ];

    await tester.pumpWidget(
      ChangeNotifierProvider<EventProvider>.value(
        value: provider,
        child: const MaterialApp(home: Scaffold(body: EventListScreen())),
      ),
    );
    await tester.pump();

    expect(find.bySemanticsLabel('Mở event Campus Innovation'), findsOneWidget);
  });

  testWidgets('RoleGate blocks users without allowed role', (tester) async {
    final auth = AuthProvider(restoreSession: false)
      ..user = const AppUser(
        id: 'participant',
        fullName: 'Participant',
        email: 'participant@seal.test',
        role: AppRoles.participant,
        university: 'FPT University',
      );

    await tester.pumpWidget(
      ChangeNotifierProvider<AuthProvider>.value(
        value: auth,
        child: const MaterialApp(
          home: Scaffold(
            body: RoleGate(
              allowedRoles: {AppRoles.judge},
              child: Text('Secret scoring'),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Không có quyền truy cập'), findsOneWidget);
    expect(find.text('Secret scoring'), findsNothing);
  });

  testWidgets('Judge screen shows inline feedback validation', (tester) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final auth = AuthProvider(restoreSession: false)
      ..user = const AppUser(
        id: 'judge-id',
        fullName: 'Judge',
        email: 'judge@seal.test',
        role: AppRoles.judge,
        university: 'FPT University',
      );
    final submissions = TestSubmissionProvider()
      ..submissions = [
        ProjectSubmission(
          id: 'submission-id',
          teamId: 'team-id',
          projectName: 'Campus Copilot',
          githubUrl: 'https://github.com/seal-demo/campus',
          videoUrl: 'https://example.com/demo',
          description: 'Demo project',
        ),
      ];

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>.value(value: auth),
          ChangeNotifierProvider<SubmissionProvider>.value(value: submissions),
          ChangeNotifierProvider<ScoreProvider>.value(
            value: TestScoreProvider(),
          ),
          ChangeNotifierProvider<TeamProvider>.value(value: TestTeamProvider()),
          ChangeNotifierProvider<NotificationProvider>.value(
            value: NotificationProvider(),
          ),
        ],
        child: const MaterialApp(home: Scaffold(body: JudgeScreen())),
      ),
    );
    await tester.pump();

    await tester.scrollUntilVisible(
      find.text('Gửi điểm'),
      500,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.drag(find.byType(ListView), const Offset(0, -180));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Gửi điểm'));
    await tester.pump();

    expect(find.text('Cần nhập feedback trước khi gửi điểm.'), findsOneWidget);
  });

  testWidgets('Submission screen shows submitted lifecycle and history', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final auth = AuthProvider(restoreSession: false)
      ..user = const AppUser(
        id: 'participant-id',
        fullName: 'Participant',
        email: 'participant@seal.test',
        role: AppRoles.participant,
        university: 'FPT University',
      );
    final teams = TestTeamProvider()
      ..teams = const [
        Team(
          id: 'team-id',
          name: 'Seal Builders',
          leaderId: 'participant-id',
          eventId: 'event-id',
          members: [
            AppUser(
              id: 'participant-id',
              fullName: 'Participant',
              email: 'participant@seal.test',
              role: AppRoles.participant,
              university: 'FPT University',
            ),
          ],
        ),
      ];
    final submissions = TestSubmissionProvider()
      ..submissions = [
        ProjectSubmission(
          id: 'submission-id',
          teamId: 'team-id',
          projectName: 'Campus Copilot',
          githubUrl: 'https://github.com/seal-demo/campus',
          videoUrl: 'https://example.com/demo',
          description: 'Demo project',
          status: 'submitted',
          submittedAt: DateTime(2026, 6, 1, 8),
        ),
      ]
      ..history = [
        SubmissionHistory(
          id: 'history-id',
          submissionId: 'submission-id',
          status: 'submitted',
          projectName: 'Campus Copilot',
          changedAt: DateTime(2026, 6, 1, 8),
        ),
      ];

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>.value(value: auth),
          ChangeNotifierProvider<TeamProvider>.value(value: teams),
          ChangeNotifierProvider<SubmissionProvider>.value(value: submissions),
          ChangeNotifierProvider<ScoreProvider>.value(
            value: TestScoreProvider(),
          ),
          ChangeNotifierProvider<NotificationProvider>.value(
            value: NotificationProvider(),
          ),
        ],
        child: const MaterialApp(home: Scaffold(body: SubmissionScreen())),
      ),
    );
    await tester.pump();

    expect(find.text('Draft'), findsNothing);
    expect(find.text('Save mode'), findsNothing);
    expect(find.text('Thông tin project'), findsOneWidget);
    expect(find.text('Links'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Lịch sử cập nhật'),
      260,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Lịch sử cập nhật'), findsOneWidget);
  });

  testWidgets('Team invite action is scoped to a concrete team card', (
    tester,
  ) async {
    final auth = AuthProvider(restoreSession: false)
      ..user = const AppUser(
        id: 'leader-id',
        fullName: 'Leader',
        email: 'leader@seal.test',
        role: AppRoles.participant,
        university: 'FPT University',
      );
    final events = TestEventProvider()
      ..events = [
        _event(id: 'event-id', title: 'SEAL Hackathon', location: 'HCMC'),
      ];
    final teams = TestTeamProvider()
      ..teams = const [
        Team(
          id: 'team-id',
          name: 'Seal Builders',
          leaderId: 'leader-id',
          eventId: 'event-id',
          members: [
            AppUser(
              id: 'leader-id',
              fullName: 'Leader',
              email: 'leader@seal.test',
              role: AppRoles.participant,
              university: 'FPT University',
            ),
          ],
        ),
      ];

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>.value(value: auth),
          ChangeNotifierProvider<EventProvider>.value(value: events),
          ChangeNotifierProvider<TeamProvider>.value(value: teams),
        ],
        child: const MaterialApp(home: Scaffold(body: TeamScreen())),
      ),
    );
    await tester.pump();

    expect(find.text('Team của tôi'), findsOneWidget);
    expect(find.text('Mời'), findsOneWidget);
    expect(find.text('Mời thành viên'), findsNothing);
  });

  testWidgets('Chat screen renders empty conversation without overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final auth = AuthProvider(restoreSession: false)
      ..user = const AppUser(
        id: 'participant-id',
        fullName: 'Participant',
        email: 'participant@seal.test',
        role: AppRoles.participant,
        university: 'FPT University',
      );
    final chat = TestChatProvider()
      ..contacts = const [
        AppUser(
          id: 'mentor-id',
          fullName: 'SEAL Mentor',
          email: 'mentor@seal.test',
          role: AppRoles.mentor,
          university: 'SEAL Lab',
        ),
      ];
    chat.selectedContact = chat.contacts.first;

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>.value(value: auth),
          ChangeNotifierProvider<ChatProvider>.value(value: chat),
        ],
        child: const MaterialApp(home: Scaffold(body: ChatScreen())),
      ),
    );
    await tester.pump();

    expect(find.text('Mentor Chat'), findsOneWidget);
    expect(find.text('Chưa có tin nhắn.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Map screen gives recoverable empty state', (tester) async {
    final provider = TestEventProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider<EventProvider>.value(
        value: provider,
        child: const MaterialApp(home: Scaffold(body: MapScreen())),
      ),
    );
    await tester.pump();

    expect(find.text('Địa điểm'), findsOneWidget);
    expect(find.text('Chưa có địa điểm event.'), findsOneWidget);
    expect(find.text('Reload venue'), findsNothing);
  });

  testWidgets('Organizer section picker shows operations and teams sections', (
    tester,
  ) async {
    final auth = AuthProvider(restoreSession: false)
      ..user = const AppUser(
        id: 'organizer-id',
        fullName: 'Organizer',
        email: 'organizer@seal.test',
        role: AppRoles.organizer,
        university: 'SEAL Lab',
      );
    final events = TestEventProvider()
      ..events = [
        _event(id: 'event-id', title: 'SEAL Hackathon', location: 'HCMC'),
      ];
    final teams = TestTeamProvider()
      ..teams = const [
        Team(
          id: 'team-id',
          name: 'Seal Builders',
          leaderId: 'leader-id',
          eventId: 'event-id',
          members: [],
        ),
      ];

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>.value(value: auth),
          ChangeNotifierProvider<EventProvider>.value(value: events),
          ChangeNotifierProvider<TeamProvider>.value(value: teams),
          ChangeNotifierProvider<SubmissionProvider>.value(
            value: TestSubmissionProvider(),
          ),
          ChangeNotifierProvider<ScoreProvider>.value(
            value: TestScoreProvider(),
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(body: OrganizerDashboardScreen()),
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Vận hành'));
    await tester.pump();
    expect(find.text('Tạo event'), findsOneWidget);

    await tester.tap(find.text('Team'));
    await tester.pump();
    expect(find.text('Chi tiết team'), findsOneWidget);
  });

  testWidgets('Judge search filters queue and exposes next unscored action', (
    tester,
  ) async {
    final auth = AuthProvider(restoreSession: false)
      ..user = const AppUser(
        id: 'judge-id',
        fullName: 'Judge',
        email: 'judge@seal.test',
        role: AppRoles.judge,
        university: 'FPT University',
      );
    final submissions = TestSubmissionProvider()
      ..submissions = [
        ProjectSubmission(
          id: 'campus-id',
          teamId: 'team-a',
          projectName: 'Campus Copilot',
          githubUrl: 'https://github.com/seal-demo/campus',
          videoUrl: 'https://example.com/demo-a',
          description: 'Campus assistant',
        ),
        ProjectSubmission(
          id: 'health-id',
          teamId: 'team-b',
          projectName: 'Health Desk',
          githubUrl: 'https://github.com/seal-demo/health',
          videoUrl: 'https://example.com/demo-b',
          description: 'Health assistant',
        ),
      ];
    final scores = TestScoreProvider()
      ..scores = const [
        ProjectScore(
          submissionId: 'campus-id',
          judgeId: 'other-judge',
          technicalScore: 8,
          uiScore: 8,
          innovationScore: 8,
          feedback: 'Good.',
        ),
      ];

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>.value(value: auth),
          ChangeNotifierProvider<SubmissionProvider>.value(value: submissions),
          ChangeNotifierProvider<ScoreProvider>.value(value: scores),
          ChangeNotifierProvider<TeamProvider>.value(value: TestTeamProvider()),
          ChangeNotifierProvider<NotificationProvider>.value(
            value: NotificationProvider(),
          ),
        ],
        child: const MaterialApp(home: Scaffold(body: JudgeScreen())),
      ),
    );
    await tester.pump();

    expect(find.text('Bài chưa chấm tiếp theo'), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, 'health');
    await tester.pump();

    expect(find.text('Health Desk'), findsWidgets);
    expect(find.text('Campus Copilot'), findsNothing);
  });

  testWidgets('Notifications show type-specific icons', (tester) async {
    final auth = AuthProvider(restoreSession: false)
      ..user = const AppUser(
        id: 'participant-id',
        fullName: 'Participant',
        email: 'participant@seal.test',
        role: AppRoles.participant,
        university: 'FPT University',
      );
    final notifications = TestNotificationProvider()
      ..notifications = [
        AppNotification(
          id: 'score-id',
          title: 'Score',
          content: 'Score update',
          type: 'score',
          createdAt: DateTime(2026, 6, 1),
        ),
        AppNotification(
          id: 'invite-id',
          title: 'Invite',
          content: 'Team invite',
          type: 'invitation',
          createdAt: DateTime(2026, 6, 1),
        ),
        AppNotification(
          id: 'announcement-id',
          title: 'Announcement',
          content: 'Event note',
          type: 'announcement',
          createdAt: DateTime(2026, 6, 1),
        ),
      ];

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>.value(value: auth),
          ChangeNotifierProvider<NotificationProvider>.value(
            value: notifications,
          ),
        ],
        child: const MaterialApp(home: Scaffold(body: NotificationScreen())),
      ),
    );
    await tester.pump();

    expect(find.byIcon(Icons.leaderboard_outlined), findsOneWidget);
    expect(find.byIcon(Icons.group_add_outlined), findsOneWidget);
    expect(find.byIcon(Icons.campaign_outlined), findsOneWidget);
  });

  testWidgets('Profile save stays disabled until fields change', (
    tester,
  ) async {
    final auth = AuthProvider(restoreSession: false)
      ..user = const AppUser(
        id: 'participant-id',
        fullName: 'Participant',
        email: 'participant@seal.test',
        role: AppRoles.participant,
        university: 'FPT University',
      );

    await tester.pumpWidget(
      ChangeNotifierProvider<AuthProvider>.value(
        value: auth,
        child: const MaterialApp(home: Scaffold(body: ProfileScreen())),
      ),
    );
    await tester.pump();

    final saveButton = find.widgetWithText(FilledButton, 'Lưu hồ sơ');
    expect(tester.widget<FilledButton>(saveButton).onPressed, isNull);

    await tester.enterText(find.byType(TextFormField).first, 'Participant One');
    await tester.pump();

    expect(tester.widget<FilledButton>(saveButton).onPressed, isNotNull);
  });

  testWidgets('Submit and Profile fit a small phone viewport', (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final auth = AuthProvider(restoreSession: false)
      ..user = const AppUser(
        id: 'participant-id',
        fullName: 'Participant',
        email: 'participant@seal.test',
        role: AppRoles.participant,
        university: 'FPT University',
      );

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>.value(value: auth),
          ChangeNotifierProvider<TeamProvider>.value(value: TestTeamProvider()),
          ChangeNotifierProvider<SubmissionProvider>.value(
            value: TestSubmissionProvider(),
          ),
          ChangeNotifierProvider<ScoreProvider>.value(
            value: TestScoreProvider(),
          ),
          ChangeNotifierProvider<NotificationProvider>.value(
            value: NotificationProvider(),
          ),
        ],
        child: const MaterialApp(home: Scaffold(body: SubmissionScreen())),
      ),
    );
    await tester.pump();
    expect(find.text('Nộp bài'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(
      ChangeNotifierProvider<AuthProvider>.value(
        value: auth,
        child: const MaterialApp(home: Scaffold(body: ProfileScreen())),
      ),
    );
    await tester.pump();
    expect(find.text('Hồ sơ'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

class TestEventProvider extends EventProvider {
  @override
  Future<void> loadEvents() async {}
}

class TestSubmissionProvider extends SubmissionProvider {
  @override
  Future<void> loadSubmissions() async {}
}

class TestScoreProvider extends ScoreProvider {
  @override
  Future<void> loadScores() async {}
}

class TestTeamProvider extends TeamProvider {
  @override
  Future<void> loadTeams() async {}
}

class TestChatProvider extends ChatProvider {
  @override
  Future<void> loadContacts(AppUser currentUser) async {}

  @override
  Future<void> load(String userId, String receiverId) async {}
}

class TestNotificationProvider extends NotificationProvider {
  @override
  Future<void> loadForUser(String userId) async {}
}

HackathonEvent _event({
  required String id,
  required String title,
  required String location,
}) {
  return HackathonEvent(
    id: id,
    title: title,
    description: 'Build practical products.',
    startDate: DateTime(2026, 6, 12),
    endDate: DateTime(2026, 6, 14),
    location: location,
    bannerUrl: 'https://example.com/banner.jpg',
    registrationDeadline: DateTime(2026, 6, 5),
    maxTeamSize: 5,
    rules: 'Submit repository and demo video.',
    prize: 'Mentorship.',
    latitude: 10,
    longitude: 106,
  );
}
