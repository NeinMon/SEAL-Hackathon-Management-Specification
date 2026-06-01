import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
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

    expect(find.text('Access Restricted'), findsOneWidget);
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

    await tester.tap(find.text('Submit score'));
    await tester.pump();

    expect(
      find.text('Feedback is required before publishing a score.'),
      findsOneWidget,
    );
  });

  testWidgets('Submission screen exposes draft lifecycle and history', (
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

    expect(find.text('Draft'), findsOneWidget);
    expect(find.text('Submitted'), findsWidgets);
    await tester.scrollUntilVisible(
      find.text('Update history'),
      260,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Update history'), findsOneWidget);
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
    expect(find.text('No messages yet'), findsOneWidget);
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

    expect(find.text('Venue'), findsOneWidget);
    expect(find.text('No event location available.'), findsOneWidget);
    expect(find.text('Reload venue'), findsOneWidget);
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
