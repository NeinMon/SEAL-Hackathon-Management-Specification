import 'package:flutter_test/flutter_test.dart';
import 'package:seal_hackathon_app/main.dart';
import 'package:seal_hackathon_app/features/organizer/widgets/organizer_announcement_dialog.dart';
import 'package:seal_hackathon_app/features/organizer/widgets/organizer_user_roles_dialog.dart';
import 'package:seal_hackathon_app/features/teams/widgets/team_invite_flow.dart';

ChangeNotifierProvider<ActiveEventProvider> _activeEventProvider() =>
    ChangeNotifierProvider<ActiveEventProvider>(
      create: (_) => ActiveEventProvider(),
    );

void main() {
  testWidgets('Login screen fits landscape with form fields', (tester) async {
    tester.view.physicalSize = const Size(844, 390);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AuthProvider(restoreSession: false),
        child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('vi'),
        home: LoginScreen()),
      ),
    );
    await tester.pump();

    expect(find.text('SEAL Hackathon'), findsWidgets);
    expect(find.byType(TextField), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('Login form validates before calling auth flow', (tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AuthProvider(restoreSession: false),
        child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('vi'),
        home: LoginScreen()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('auth_submit_button')));
    await tester.pump();

    expect(find.text('Nhập email.'), findsOneWidget);
    expect(find.text('Nhập mật khẩu.'), findsOneWidget);
  });

  testWidgets('Register form validates required profile fields', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AuthProvider(restoreSession: false),
        child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('vi'),
        home: LoginScreen()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Tạo tài khoản mới'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('auth_submit_button')));
    await tester.pump();

    expect(find.text('Nhập họ tên.'), findsOneWidget);
    expect(find.text('Nhập trường.'), findsOneWidget);
    expect(find.text('Nhập email.'), findsOneWidget);
    expect(find.text('Nhập mật khẩu.'), findsOneWidget);
    expect(find.text('Nhập lại mật khẩu.'), findsOneWidget);
  });

  testWidgets('Register form rejects mismatched confirm password', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AuthProvider(restoreSession: false),
        child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('vi'),
        home: LoginScreen()),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tạo tài khoản mới'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'Nguyen Van A');
    await tester.enterText(find.byType(TextFormField).at(1), 'FPT University');
    await tester.enterText(find.byType(TextFormField).at(2), 'new@seal.test');
    await tester.enterText(find.byType(TextFormField).at(3), '123456');
    await tester.enterText(
      find.byKey(const Key('register_confirm_password')),
      '654321',
    );
    await tester.tap(find.byKey(const Key('auth_submit_button')));
    await tester.pump();

    expect(find.text('Mật khẩu nhập lại không khớp.'), findsOneWidget);
  });

  testWidgets('Event list exposes sort dropdown', (tester) async {
    final provider = TestEventProvider()
      ..events = [
        _event(id: 'campus', title: 'Campus Innovation', location: 'HCMC'),
      ];

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          _activeEventProvider(),
          ChangeNotifierProvider<AuthProvider>.value(
            value: AuthProvider(restoreSession: false),
          ),
          ChangeNotifierProvider<EventProvider>.value(
            value: provider,
          ),
        ],
        child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('vi'),
        home: Scaffold(body: EventListScreen())),
      ),
    );
    await tester.pump();

    expect(find.byKey(const Key('event_sort_dropdown')), findsOneWidget);
    expect(find.text('Còn đăng ký'), findsOneWidget);
  });

  testWidgets('Event list filters by search keyword', (tester) async {
    final provider = TestEventProvider()
      ..events = [
        _event(id: 'campus', title: 'Campus Innovation', location: 'HCMC'),
        _event(id: 'finance', title: 'Fintech Sprint', location: 'Da Nang'),
      ];

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          _activeEventProvider(),
          ChangeNotifierProvider<AuthProvider>.value(
            value: AuthProvider(restoreSession: false),
          ),
          ChangeNotifierProvider<EventProvider>.value(
            value: provider,
          ),
        ],
        child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('vi'),
        home: Scaffold(body: EventListScreen())),
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
      MultiProvider(
        providers: [
          _activeEventProvider(),
          ChangeNotifierProvider<AuthProvider>.value(
            value: AuthProvider(restoreSession: false),
          ),
          ChangeNotifierProvider<EventProvider>.value(
            value: provider,
          ),
        ],
        child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('vi'),
        home: Scaffold(body: EventListScreen())),
      ),
    );
    await tester.pump();

    expect(
      find.bySemanticsLabel('Mở sự kiện Campus Innovation'),
      findsOneWidget,
    );
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
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('vi'),
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
    final teams = TestTeamProvider()
      ..teams = [
        _team(
          id: 'team-id',
          eventId: 'event-id',
          leaderId: 'leader-id',
          name: 'Seal Builders',
        ),
      ];
    final events = TestEventProvider()
      ..events = [
        _event(id: 'event-id', title: 'SEAL Hackathon', location: 'HCMC'),
      ];

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          _activeEventProvider(),
          ChangeNotifierProvider<AuthProvider>.value(value: auth),
          ChangeNotifierProvider<EventProvider>.value(value: events),
          ChangeNotifierProvider<SubmissionProvider>.value(value: submissions),
          ChangeNotifierProvider<ScoreProvider>.value(
            value: TestScoreProvider(),
          ),
          ChangeNotifierProvider<TeamProvider>.value(value: teams),
          ChangeNotifierProvider<NotificationProvider>.value(
            value: NotificationProvider(),
          ),
        ],
        child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('vi'),
        home: Scaffold(body: JudgeScreen())),
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

    expect(find.text('Cần nhập nhận xét trước khi gửi điểm.'), findsOneWidget);
  });

  testWidgets('Submission screen shows submitted lifecycle and history', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(900, 844);
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

    final events = TestEventProvider()
      ..events = [
        _event(id: 'event-id', title: 'SEAL Hackathon', location: 'HCMC'),
      ];

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          _activeEventProvider(),
          ChangeNotifierProvider<AuthProvider>.value(value: auth),
          ChangeNotifierProvider<EventProvider>.value(value: events),
          ChangeNotifierProvider<TeamProvider>.value(value: teams),
          ChangeNotifierProvider<SubmissionProvider>.value(value: submissions),
          ChangeNotifierProvider<ScoreProvider>.value(
            value: TestScoreProvider(),
          ),
          ChangeNotifierProvider<NotificationProvider>.value(
            value: NotificationProvider(),
          ),
        ],
        child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('vi'),
        home: Scaffold(body: SubmissionScreen())),
      ),
    );
    await tester.pump();

    expect(find.text('Draft'), findsNothing);
    expect(find.text('Save mode'), findsNothing);
    expect(find.text('Thông tin dự án'), findsWidgets);
    expect(find.text('Liên kết'), findsWidgets);
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
          _activeEventProvider(),
          ChangeNotifierProvider<AuthProvider>.value(value: auth),
          ChangeNotifierProvider<EventProvider>.value(value: events),
          ChangeNotifierProvider<TeamProvider>.value(value: teams),
        ],
        child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('vi'),
        home: Scaffold(body: TeamScreen())),
      ),
    );
    await tester.pump();

    expect(find.text('Đội của tôi'), findsOneWidget);
    expect(find.text('Mời'), findsOneWidget);
    expect(find.text('Mời thành viên'), findsNothing);
  });

  testWidgets('Team screen shows pending invitations with response actions', (
    tester,
  ) async {
    final auth = AuthProvider(restoreSession: false)
      ..user = const AppUser(
        id: 'invitee-id',
        fullName: 'Invitee',
        email: 'invitee@seal.test',
        role: AppRoles.participant,
        university: 'FPT University',
      );
    final event = _event(
      id: 'event-id',
      title: 'SEAL Hackathon',
      location: 'HCMC',
    );
    final team = const Team(
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
    );
    final events = TestEventProvider()..events = [event];
    final teams = TestTeamProvider()
      ..teams = [team]
      ..invitations = [
        TeamInvitation(
          id: 'invitation-id',
          teamId: 'team-id',
          inviterId: 'leader-id',
          inviteeId: 'invitee-id',
          status: 'pending',
          createdAt: DateTime(2026, 7),
          team: team,
          inviter: const AppUser(
            id: 'leader-id',
            fullName: 'Leader',
            email: 'leader@seal.test',
            role: AppRoles.participant,
            university: 'FPT University',
          ),
        ),
      ];

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          _activeEventProvider(),
          ChangeNotifierProvider<AuthProvider>.value(value: auth),
          ChangeNotifierProvider<EventProvider>.value(value: events),
          ChangeNotifierProvider<TeamProvider>.value(value: teams),
        ],
        child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('vi'),
        home: Scaffold(body: TeamScreen())),
      ),
    );
    await tester.pump();

    expect(find.text(L10nService.strings.pendingInvitationsTitle), findsOneWidget);
    expect(find.text(L10nService.strings.acceptInvitationButton), findsOneWidget);
    expect(find.text(L10nService.strings.declineInvitationButton), findsOneWidget);
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
          _activeEventProvider(),
          ChangeNotifierProvider<AuthProvider>.value(value: auth),
          ChangeNotifierProvider<ChatProvider>.value(value: chat),
        ],
        child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('vi'),
        home: Scaffold(body: ChatScreen())),
      ),
    );
    await tester.pump();

    expect(find.text('Chat mentor'), findsOneWidget);
    expect(find.text('Chưa có tin nhắn.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Map screen gives recoverable empty state', (tester) async {
    final provider = TestEventProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          _activeEventProvider(),
          ChangeNotifierProvider<AuthProvider>.value(
            value: AuthProvider(restoreSession: false),
          ),
          ChangeNotifierProvider<EventProvider>.value(value: provider),
          ChangeNotifierProvider<TeamProvider>.value(value: TestTeamProvider()),
        ],
        child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('vi'),
        home: Scaffold(body: MapScreen())),
      ),
    );
    await tester.pump();

    expect(find.text('Địa điểm'), findsOneWidget);
    expect(find.text('Chưa có địa điểm sự kiện.'), findsOneWidget);
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
          _activeEventProvider(),
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
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('vi'),
        home: Scaffold(body: OrganizerDashboardScreen()),
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.text(L10nService.strings.organizerShowDetailsButton));
    await tester.pump();
    await tester.tap(find.text('Vận hành'));
    await tester.pump();
    expect(find.text('Tạo sự kiện'), findsOneWidget);

    await tester.tap(find.text('Đội'));
    await tester.pump();
    expect(find.text('Chi tiết đội'), findsOneWidget);
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
    final teams = TestTeamProvider()
      ..teams = [
        _team(
          id: 'team-a',
          eventId: 'event-id',
          leaderId: 'leader-a',
          name: 'Team A',
        ),
        _team(
          id: 'team-b',
          eventId: 'event-id',
          leaderId: 'leader-b',
          name: 'Team B',
        ),
      ];

    final events = TestEventProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          _activeEventProvider(),
          ChangeNotifierProvider<AuthProvider>.value(value: auth),
          ChangeNotifierProvider<EventProvider>.value(value: events),
          ChangeNotifierProvider<SubmissionProvider>.value(value: submissions),
          ChangeNotifierProvider<ScoreProvider>.value(value: scores),
          ChangeNotifierProvider<TeamProvider>.value(value: teams),
          ChangeNotifierProvider<NotificationProvider>.value(
            value: NotificationProvider(),
          ),
        ],
        child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('vi'),
        home: Scaffold(body: JudgeScreen())),
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
          _activeEventProvider(),
          ChangeNotifierProvider<AuthProvider>.value(value: auth),
          ChangeNotifierProvider<NotificationProvider>.value(
            value: notifications,
          ),
          ChangeNotifierProvider<TeamProvider>.value(value: TestTeamProvider()),
        ],
        child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('vi'),
        home: Scaffold(body: NotificationScreen())),
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
      MultiProvider(
        providers: [
          _activeEventProvider(),
          ChangeNotifierProvider<AuthProvider>.value(value: auth),
          ChangeNotifierProvider<ThemeProvider>.value(value: ThemeProvider()),
          ChangeNotifierProvider<LocaleProvider>.value(value: LocaleProvider()),
        ],
        child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('vi'),
        home: Scaffold(body: ProfileScreen())),
      ),
    );
    await tester.pump();

    final saveButton = find.text(L10nService.strings.saveProfileButton);
    await tester.scrollUntilVisible(saveButton, 120);
    await tester.pump();

    final filledSave = find.ancestor(
      of: saveButton,
      matching: find.byType(FilledButton),
    );
    expect(tester.widget<FilledButton>(filledSave).onPressed, isNull);

    await tester.enterText(find.byType(TextFormField).first, 'Participant One');
    await tester.pump();

    expect(tester.widget<FilledButton>(filledSave).onPressed, isNotNull);
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
    final events = TestEventProvider()
      ..events = [
        _event(id: 'event-id', title: 'SEAL Hackathon', location: 'HCMC'),
      ];

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          _activeEventProvider(),
          ChangeNotifierProvider<AuthProvider>.value(value: auth),
          ChangeNotifierProvider<EventProvider>.value(value: events),
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
        child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('vi'),
        home: Scaffold(body: SubmissionScreen())),
      ),
    );
    await tester.pump();
    expect(find.text('Nộp bài'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          _activeEventProvider(),
          ChangeNotifierProvider<AuthProvider>.value(value: auth),
          ChangeNotifierProvider<ThemeProvider>.value(value: ThemeProvider()),
          ChangeNotifierProvider<LocaleProvider>.value(value: LocaleProvider()),
        ],
        child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('vi'),
        home: Scaffold(body: ProfileScreen())),
      ),
    );
    await tester.pump();
    expect(find.text('Hồ sơ'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('Announcement dialog uses mobile sheet and preview', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final events = TestEventProvider()
      ..events = [
        _event(id: 'event-id', title: 'SEAL Hackathon', location: 'HCMC'),
      ];

    await tester.pumpWidget(
      ChangeNotifierProvider<EventProvider>.value(
        value: events,
        child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('vi'),
        home: Scaffold(
            body: Builder(
              builder: (context) => FilledButton(
                onPressed: () => OrganizerAnnouncementDialog.show(
                  context,
                  initialUsers: const [
                    AppUser(
                      id: 'participant-id',
                      fullName: 'Participant',
                      email: 'participant@seal.test',
                      role: AppRoles.participant,
                      university: 'FPT University',
                    ),
                  ],
                ),
                child: const Text('open announcement'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open announcement'));
    await tester.pumpAndSettle();

    expect(find.text(L10nService.strings.sendAnnouncementDialogTitle), findsOneWidget);
    expect(find.byType(BottomSheet), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextFormField, L10nService.strings.notificationTitleLabel),
      'Kickoff',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, L10nService.strings.notificationContentLabel),
      'Welcome teams',
    );
    await tester.tap(find.text(L10nService.strings.sendButton));
    await tester.pumpAndSettle();

    expect(find.text(L10nService.strings.announcementPreviewTitle), findsOneWidget);
    expect(find.text(L10nService.strings.recipientCountValue(1)), findsOneWidget);
  });

  testWidgets('User roles dialog supports search and role filter', (
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
    await tester.pumpWidget(
      ChangeNotifierProvider<AuthProvider>.value(
        value: auth,
        child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('vi'),
        home: Scaffold(
            body: Builder(
              builder: (context) => FilledButton(
                onPressed: () => OrganizerUserRolesDialog.show(
                  context,
                  initialUsers: const [
                    AppUser(
                      id: 'judge-id',
                      fullName: 'Judge Jane',
                      email: 'judge@seal.test',
                      role: AppRoles.judge,
                      university: 'SEAL Lab',
                    ),
                    AppUser(
                      id: 'mentor-id',
                      fullName: 'Mentor Minh',
                      email: 'mentor@seal.test',
                      role: AppRoles.mentor,
                      university: 'SEAL Lab',
                    ),
                  ],
                ),
                child: const Text('open roles'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open roles'));
    await tester.pumpAndSettle();

    expect(find.text('Judge Jane'), findsOneWidget);
    expect(find.text('Mentor Minh'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextField, L10nService.strings.userSearchLabel),
      'mentor',
    );
    await tester.pump();
    expect(find.text('Judge Jane'), findsNothing);
    expect(find.text('Mentor Minh'), findsOneWidget);
  });

  testWidgets('Invite member flow uses mobile bottom sheet', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final team = _team(
      id: 'team-id',
      eventId: 'event-id',
      leaderId: 'leader-id',
      name: 'Seal Builders',
    );
    final event = _event(
      id: 'event-id',
      title: 'SEAL Hackathon',
      location: 'HCMC',
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('vi'),
        home: Scaffold(
          body: Builder(
            builder: (context) => FilledButton(
              onPressed: () =>
                  TeamInviteFlow.show(context, team: team, event: event),
              child: const Text('open invite'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open invite'));
    await tester.pumpAndSettle();

    expect(find.byType(BottomSheet), findsOneWidget);
    expect(find.text(L10nService.strings.inviteMemberTitle), findsOneWidget);
    expect(find.text('SEAL Hackathon'), findsOneWidget);
  });

  testWidgets('Event detail hero shows quick action', (tester) async {
    final auth = AuthProvider(restoreSession: false)
      ..user = const AppUser(
        id: 'participant-id',
        fullName: 'Participant',
        email: 'participant@seal.test',
        role: AppRoles.participant,
        university: 'FPT University',
      );
    final events = TestEventProvider()
      ..events = [
        _event(id: 'event-id', title: 'SEAL Hackathon', location: 'HCMC'),
      ];

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          _activeEventProvider(),
          ChangeNotifierProvider<AuthProvider>.value(value: auth),
          ChangeNotifierProvider<EventProvider>.value(value: events),
          ChangeNotifierProvider<TeamProvider>.value(value: TestTeamProvider()),
          ChangeNotifierProvider<SubmissionProvider>.value(
            value: TestSubmissionProvider(),
          ),
          ChangeNotifierProvider<ScoreProvider>.value(
            value: TestScoreProvider(),
          ),
        ],
        child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('vi'),
        home: Scaffold(body: EventDetailScreen(eventId: 'event-id')),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('SEAL Hackathon'), findsOneWidget);
    expect(find.text(L10nService.strings.eventQuickActionsTitle), findsOneWidget);
    expect(find.text(L10nService.strings.joinOrCreateTeamButton), findsWidgets);
  });
}

class TestEventProvider extends EventProvider {
  @override
  Future<void> loadEvents() async {}
}

class TestSubmissionProvider extends SubmissionProvider {
  @override
  Future<void> loadSubmissions({String? eventId}) async {}
}

class TestScoreProvider extends ScoreProvider {
  @override
  Future<void> loadScores({String? eventId}) async {}
}

class TestTeamProvider extends TeamProvider {
  @override
  Future<void> loadTeams({String? eventId}) async {}

  @override
  Future<void> loadInvitations(AppUser? user) async {}

  @override
  Future<void> loadTeamWorkspace(AppUser? user) async {}
}

class TestChatProvider extends ChatProvider {
  @override
  Future<void> loadContacts(AppUser currentUser, {String? eventId}) async {}

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
  final now = DateTime.now();
  return HackathonEvent(
    id: id,
    title: title,
    description: 'Build practical products.',
    startDate: now.subtract(const Duration(days: 2)),
    endDate: now.add(const Duration(days: 30)),
    location: location,
    bannerUrl: 'https://example.com/banner.jpg',
    registrationDeadline: now.add(const Duration(days: 20)),
    submissionDeadline: now.subtract(const Duration(hours: 1)),
    maxTeamSize: 5,
    rules: 'Submit repository and demo video.',
    prize: 'Mentorship.',
    latitude: 10,
    longitude: 106,
  );
}

Team _team({
  required String id,
  required String eventId,
  required String leaderId,
  required String name,
}) {
  return Team(
    id: id,
    name: name,
    leaderId: leaderId,
    eventId: eventId,
    members: [
      AppUser(
        id: leaderId,
        fullName: 'Member',
        email: 'member@seal.test',
        role: AppRoles.participant,
        university: 'FPT University',
      ),
    ],
  );
}
