import 'package:flutter_test/flutter_test.dart';
import 'package:seal_hackathon_app/main.dart';

void main() {
  test('AppUser parses Supabase profile rows', () {
    final user = AppUser.fromJson({
      'id': 'user-id',
      'full_name': 'Nguyen Van A',
      'email': 'student@example.com',
      'role': 'participant',
      'university': 'FPT University',
    });

    expect(user.id, 'user-id');
    expect(user.fullName, 'Nguyen Van A');
    expect(user.role, 'participant');
    expect(user.toJson()['email'], 'student@example.com');
  });

  test('HackathonEvent parses database timestamps and coordinates', () {
    final event = HackathonEvent.fromJson({
      'id': 'event-id',
      'title': 'SEAL Hackathon',
      'description': 'Build useful products.',
      'start_date': '2026-06-12T08:00:00',
      'end_date': '2026-06-14T18:00:00',
      'location': 'FPT University HCMC',
      'banner_url': 'https://example.com/banner.jpg',
      'registration_deadline': '2026-06-05T23:59:00',
      'max_team_size': 5,
      'rules': 'Submit repository and demo video.',
      'prize': 'Awards and incubation.',
      'latitude': 10.8411,
      'longitude': 106.81,
    });

    expect(event.title, 'SEAL Hackathon');
    expect(event.maxTeamSize, 5);
    expect(event.latitude, 10.8411);
    expect(event.registrationDeadline.year, 2026);
  });

  test('Team parses nested team member profiles', () {
    final team = Team.fromJson({
      'id': 'team-id',
      'name': 'Team Alpha',
      'leader_id': 'user-id',
      'event_id': 'event-id',
      'team_members': [
        {
          'users': {
            'id': 'user-id',
            'full_name': 'Team Leader',
            'email': 'leader@example.com',
            'role': 'participant',
            'university': 'FPT University',
          },
        },
      ],
    });

    expect(team.name, 'Team Alpha');
    expect(team.members.single.fullName, 'Team Leader');
  });

  test('TeamInvitation parses nested team and inviter profiles', () {
    final invitation = TeamInvitation.fromJson({
      'id': 'invitation-id',
      'team_id': 'team-id',
      'inviter_id': 'leader-id',
      'invitee_id': 'user-id',
      'status': 'pending',
      'created_at': '2026-07-01T08:30:00',
      'team': {
        'id': 'team-id',
        'name': 'Seal Builders',
        'leader_id': 'leader-id',
        'event_id': 'event-id',
        'team_members': const [],
      },
      'inviter': {
        'id': 'leader-id',
        'full_name': 'Team Leader',
        'email': 'leader@example.com',
        'role': 'participant',
        'university': 'FPT University',
      },
    });

    expect(invitation.isPending, isTrue);
    expect(invitation.team?.name, 'Seal Builders');
    expect(invitation.inviter?.fullName, 'Team Leader');
  });

  test('ProjectScore calculates average score', () {
    const score = ProjectScore(
      submissionId: 'submission-id',
      judgeId: 'judge-id',
      technicalScore: 8,
      uiScore: 7,
      innovationScore: 9,
      feedback: 'Strong prototype.',
    );

    expect(score.average, 8);
  });

  test('ScoreProvider averages multiple judge scores for one submission', () {
    final provider = ScoreProvider()
      ..scores = const [
        ProjectScore(
          submissionId: 'submission-id',
          judgeId: 'judge-a',
          technicalScore: 8,
          uiScore: 8,
          innovationScore: 8,
          feedback: 'Good.',
        ),
        ProjectScore(
          submissionId: 'submission-id',
          judgeId: 'judge-b',
          technicalScore: 10,
          uiScore: 9,
          innovationScore: 8,
          feedback: 'Strong.',
        ),
      ];

    expect(provider.averageFor('submission-id'), 8.5);
    expect(provider.averageFor('missing'), 0);
    expect(provider.scoreCountFor('submission-id'), 2);
    expect(provider.scoreFor('submission-id', 'judge-a')?.technicalScore, 8);
  });

  test('AppValidators accepts only clean emails and web URLs', () {
    expect(AppValidators.isValidEmail('participant@seal.test'), isTrue);
    expect(AppValidators.isValidEmail('bad-email'), isFalse);
    expect(AppValidators.isValidWebUrl('https://github.com/seal/app'), isTrue);
    expect(AppValidators.isValidWebUrl('ftp://example.com/file'), isFalse);
    expect(AppValidators.scoreError(0, 5, 10), isNull);
    expect(AppValidators.scoreError(11, 5, 10), contains('0 đến 10'));
  });

  test('AppValidators returns field-specific auth and search errors', () {
    expect(AppValidators.loginEmail(''), 'Nhập email.');
    expect(AppValidators.loginEmail('bad'), 'Nhập email hợp lệ.');
    expect(AppValidators.loginPassword(''), 'Nhập mật khẩu.');
    expect(AppValidators.loginPassword('12345'), contains('6 ký tự'));
    expect(AppValidators.registerName(''), 'Nhập họ tên.');
    expect(AppValidators.registerUniversity(''), 'Nhập trường.');
    expect(AppValidators.eventSearchQuery('x' * 81), contains('80 ký tự'));
    expect(AppValidators.requireSupabaseReady(), contains('kết nối hệ thống'));
  });

  test(
    'AuthProvider rejects login and logout validation before service',
    () async {
      final provider = AuthProvider(restoreSession: false);

      await provider.login('', '');
      expect(provider.error, 'Nhập email.');
      expect(provider.user, isNull);

      await provider.logout();
      expect(provider.error, 'Bạn chưa đăng nhập.');
    },
  );

  test('AuthProvider rejects incomplete register input', () async {
    final provider = AuthProvider(restoreSession: false);

    await provider.register('', '', '', '', '');
    expect(provider.error, 'Nhập họ tên.');
    expect(provider.user, isNull);
  });

  test('AppValidators rejects mismatched confirm password', () {
    expect(
      AppValidators.confirmPassword('123456', '654321'),
      'Mật khẩu nhập lại không khớp.',
    );
    expect(AppValidators.signupOtp('12345'), contains('6 chữ số'));
  });

  test('EventProvider sorts events by title and deadline', () {
    final now = DateTime.now();
    final provider = EventProvider()
      ..events = [
        HackathonEvent(
          id: 'b',
          title: 'Beta Event',
          description: 'B',
          startDate: now.add(const Duration(days: 5)),
          endDate: now.add(const Duration(days: 7)),
          location: 'HN',
          bannerUrl: 'https://example.com/b.jpg',
          registrationDeadline: now.add(const Duration(days: 10)),
          maxTeamSize: 4,
          rules: 'Rules',
          prize: 'Prize',
          latitude: 10,
          longitude: 106,
        ),
        HackathonEvent(
          id: 'a',
          title: 'Alpha Event',
          description: 'A',
          startDate: now.add(const Duration(days: 1)),
          endDate: now.add(const Duration(days: 3)),
          location: 'HCM',
          bannerUrl: 'https://example.com/a.jpg',
          registrationDeadline: now.add(const Duration(days: 2)),
          maxTeamSize: 4,
          rules: 'Rules',
          prize: 'Prize',
          latitude: 10,
          longitude: 106,
        ),
      ];

    provider.updateSort(EventCatalog.sortTitleAsc);
    expect(provider.filteredEvents.first.title, 'Alpha Event');

    provider.updateSort(EventCatalog.sortDeadlineAsc);
    expect(provider.filteredEvents.first.id, 'a');
  });

  test('EventProvider validates long search queries', () {
    final provider = EventProvider()..updateSearch('a' * 81);

    expect(provider.searchError, contains('80 ký tự'));
    expect(provider.search.length, 80);
  });

  test(
    'EventProvider reports missing Supabase config before loading',
    () async {
      final provider = EventProvider();

      await provider.loadEvents();

      expect(provider.error, contains('kết nối hệ thống'));
      expect(provider.isLoading, isFalse);
    },
  );

  test('FriendlyErrorMapper hides raw PostgrestException details', () {
    final message = FriendlyErrorMapper.message(
      const PostgrestException(
        message: 'new row violates row-level security policy',
        code: '42501',
      ),
    );

    expect(message, contains('không có quyền'));
    expect(message, isNot(contains('PostgrestException')));
  });

  test('FriendlyErrorMapper does not show OTP copy for generic auth tokens', () {
    final message = FriendlyErrorMapper.message(
      const AuthException('Auth session token is missing.'),
    );

    expect(message, isNot(AppStrings.errorInvalidOtp));
  });

  test('TeamProvider blocks joining a full team before service call', () async {
    const user = AppUser(
      id: 'new-user',
      fullName: 'New User',
      email: 'new@example.com',
      role: AppRoles.participant,
      university: 'FPT University',
    );
    final event = HackathonEvent(
      id: 'event-id',
      title: 'SEAL Hackathon',
      description: 'Build useful products.',
      startDate: DateTime(2026, 6, 12),
      endDate: DateTime(2026, 6, 14),
      location: 'HCMC',
      bannerUrl: 'https://example.com/banner.jpg',
      registrationDeadline: DateTime(2026, 6, 5),
      maxTeamSize: 1,
      rules: 'Rules',
      prize: 'Prize',
      latitude: 10,
      longitude: 106,
    );
    final provider = TeamProvider()
      ..teams = const [
        Team(
          id: 'team-id',
          name: 'Full Team',
          leaderId: 'leader-id',
          eventId: 'event-id',
          members: [
            AppUser(
              id: 'leader-id',
              fullName: 'Leader',
              email: 'leader@example.com',
              role: AppRoles.participant,
              university: 'FPT University',
            ),
          ],
        ),
      ];

    await provider.joinTeam('team-id', user, event: event);

    expect(provider.error, AppStrings.teamFullForEventError('Full Team'));
  });

  test('TeamProvider blocks joining second team on same event', () async {
    const user = AppUser(
      id: 'user-id',
      fullName: 'Member',
      email: 'member@example.com',
      role: AppRoles.participant,
      university: 'FPT University',
    );
    final event = HackathonEvent(
      id: 'event-id',
      title: 'SEAL Hackathon',
      description: 'Build useful products.',
      startDate: DateTime(2027, 6, 12),
      endDate: DateTime(2027, 6, 14),
      location: 'HCMC',
      bannerUrl: 'https://example.com/banner.jpg',
      registrationDeadline: DateTime(2027, 6, 5),
      maxTeamSize: 5,
      rules: 'Rules',
      prize: 'Prize',
      latitude: 10,
      longitude: 106,
    );
    final provider = TeamProvider()
      ..teams = const [
        Team(
          id: 'team-a',
          name: 'Seal Builders',
          leaderId: 'leader-id',
          eventId: 'event-id',
          members: [
            AppUser(
              id: 'user-id',
              fullName: 'Member',
              email: 'member@example.com',
              role: AppRoles.participant,
              university: 'FPT University',
            ),
          ],
        ),
        Team(
          id: 'team-b',
          name: 'Other Team',
          leaderId: 'leader-2',
          eventId: 'event-id',
          members: [
            AppUser(
              id: 'leader-2',
              fullName: 'Leader 2',
              email: 'leader2@example.com',
              role: AppRoles.participant,
              university: 'FPT University',
            ),
          ],
        ),
      ];

    await provider.joinTeam('team-b', user, event: event);

    expect(
      provider.error,
      AppStrings.alreadyOnEventTeamNamedError('Seal Builders'),
    );
  });

  test('TeamProvider blocks creating second team on same event', () async {
    const user = AppUser(
      id: 'leader-id',
      fullName: 'Leader',
      email: 'leader@example.com',
      role: AppRoles.participant,
      university: 'FPT University',
    );
    final event = HackathonEvent(
      id: 'event-id',
      title: 'SEAL Hackathon',
      description: 'Build useful products.',
      startDate: DateTime(2027, 6, 12),
      endDate: DateTime(2027, 6, 14),
      location: 'HCMC',
      bannerUrl: 'https://example.com/banner.jpg',
      registrationDeadline: DateTime(2027, 6, 5),
      maxTeamSize: 5,
      rules: 'Rules',
      prize: 'Prize',
      latitude: 10,
      longitude: 106,
    );
    final provider = TeamProvider()
      ..teams = const [
        Team(
          id: 'team-a',
          name: 'Seal Builders',
          leaderId: 'leader-id',
          eventId: 'event-id',
          members: [
            AppUser(
              id: 'leader-id',
              fullName: 'Leader',
              email: 'leader@example.com',
              role: AppRoles.participant,
              university: 'FPT University',
            ),
          ],
        ),
      ];

    await provider.createTeam('Second Team', event, user);

    expect(
      provider.error,
      AppStrings.alreadyOnEventTeamNamedError('Seal Builders'),
    );
  });

  test('TeamMembership allows separate teams on different events', () {
    const teams = [
      Team(
        id: 'team-a',
        name: 'Team A',
        leaderId: 'user-id',
        eventId: 'event-a',
        members: [
          AppUser(
            id: 'user-id',
            fullName: 'User',
            email: 'user@example.com',
            role: AppRoles.participant,
            university: 'FPT University',
          ),
        ],
      ),
    ];

    expect(
      TeamMembership.hasTeamOnEvent(
        teams: teams,
        userId: 'user-id',
        eventId: 'event-b',
      ),
      isFalse,
    );
  });

  test(
    'TeamProvider blocks team creation when event registration closed',
    () async {
      const user = AppUser(
        id: 'leader-id',
        fullName: 'Leader',
        email: 'leader@example.com',
        role: AppRoles.participant,
        university: 'FPT University',
      );
      final event = HackathonEvent(
        id: 'event-id',
        title: 'Closed Event',
        description: 'Finished hackathon.',
        startDate: DateTime(2020, 6, 12),
        endDate: DateTime(2020, 6, 14),
        location: 'HCMC',
        bannerUrl: 'https://example.com/banner.jpg',
        registrationDeadline: DateTime(2020, 6, 5),
        maxTeamSize: 5,
        rules: 'Rules',
        prize: 'Prize',
        latitude: 10,
        longitude: 106,
      );
      final provider = TeamProvider();
      final at = DateTime(2026, 6, 20);

      expect(event.registrationOpen(at), isFalse);
      expect(event.registrationBlockReason(at), AppStrings.errorEventEnded);

      await provider.createTeam('Late Team', event, user);

      expect(provider.error, AppStrings.errorEventEnded);
    },
  );

  test(
    'HackathonEvent registration stays open before deadline and end date',
    () {
      final event = HackathonEvent(
        id: 'event-id',
        title: 'Open Event',
        description: 'Active hackathon.',
        startDate: DateTime(2026, 7, 10),
        endDate: DateTime(2026, 7, 12),
        location: 'HCMC',
        bannerUrl: 'https://example.com/banner.jpg',
        registrationDeadline: DateTime(2026, 7, 5),
        maxTeamSize: 5,
        rules: 'Rules',
        prize: 'Prize',
        latitude: 10,
        longitude: 106,
      );
      final at = DateTime(2026, 7, 1);

      expect(event.registrationOpen(at), isTrue);
      expect(event.registrationBlockReason(at), isNull);
    },
  );

  test('SubmissionProvider blocks submit when event ended', () async {
    final event = HackathonEvent(
      id: 'event-id',
      title: 'Closed Event',
      description: 'Finished.',
      startDate: DateTime(2020, 6, 1),
      endDate: DateTime(2020, 6, 3),
      location: 'HCMC',
      bannerUrl: 'https://example.com/banner.jpg',
      registrationDeadline: DateTime(2020, 6, 1),
      maxTeamSize: 5,
      rules: 'Rules',
      prize: 'Prize',
      latitude: 10,
      longitude: 106,
    );
    final provider = SubmissionProvider();
    await provider.submit(
      ProjectSubmission(
        id: 'submission-1',
        teamId: 'team-1',
        projectName: 'Demo Project',
        githubUrl: 'https://github.com/demo/repo',
        videoUrl: 'https://youtube.com/watch?v=demo',
        description: 'Demo description long enough.',
        status: 'submitted',
      ),
      event: event,
    );
    expect(provider.error, AppStrings.errorSubmissionClosed);
  });

  test('ScoreProvider blocks judging before event starts', () async {
    final event = HackathonEvent(
      id: 'event-id',
      title: 'Upcoming Event',
      description: 'Not started.',
      startDate: DateTime(2030, 6, 12),
      endDate: DateTime(2030, 6, 14),
      location: 'HCMC',
      bannerUrl: 'https://example.com/banner.jpg',
      registrationDeadline: DateTime(2030, 6, 5),
      maxTeamSize: 5,
      rules: 'Rules',
      prize: 'Prize',
      latitude: 10,
      longitude: 106,
    );
    final provider = ScoreProvider();
    await provider.addScore(
      ProjectScore(
        submissionId: 'submission-1',
        judgeId: 'judge-1',
        technicalScore: 8,
        uiScore: 8,
        innovationScore: 8,
        feedback: 'Good work overall.',
      ),
      event: event,
    );
    expect(provider.error, AppStrings.errorJudgingNotStarted);
  });

  test('EventProvider filters by phase and search keyword', () {
    final now = DateTime.now();
    final provider = EventProvider()
      ..events = [
        HackathonEvent(
          id: 'upcoming',
          title: 'AI for Campus',
          description: 'Build campus tools.',
          startDate: now.add(const Duration(days: 2)),
          endDate: now.add(const Duration(days: 4)),
          location: 'HCMC',
          bannerUrl: 'https://example.com/upcoming.jpg',
          registrationDeadline: now.add(const Duration(days: 1)),
          maxTeamSize: 5,
          rules: 'Submit a prototype.',
          prize: 'Mentorship.',
          latitude: 10,
          longitude: 106,
        ),
        HackathonEvent(
          id: 'closed',
          title: 'Fintech Sprint',
          description: 'Finance challenge.',
          startDate: now.subtract(const Duration(days: 5)),
          endDate: now.subtract(const Duration(days: 3)),
          location: 'Da Nang',
          bannerUrl: 'https://example.com/closed.jpg',
          registrationDeadline: now.subtract(const Duration(days: 6)),
          maxTeamSize: 4,
          rules: 'Demo required.',
          prize: 'Awards.',
          latitude: 16,
          longitude: 108,
        ),
      ];

    provider.updateFilter('upcoming');
    expect(provider.filteredEvents.single.id, 'upcoming');

    provider.updateFilter('all');
    provider.updateSearch('fintech');
    expect(provider.filteredEvents.single.id, 'closed');
  });

  test('RouteQuery builds event-scoped navigation paths', () {
    expect(
      RouteQuery.teamsForEvent('event-1'),
      '${AppRoutes.teams}?event=event-1',
    );
    expect(
      RouteQuery.judgeForEvent('event-1'),
      '${AppRoutes.judge}?event=event-1',
    );
    expect(
      RouteQuery.submitForTeam('team-1'),
      '${AppRoutes.submit}?team=team-1',
    );
  });

  test('NotificationLink encodes and decodes event deep links', () {
    final encoded = NotificationLink.encodeEvent(
      eventId: 'event-1',
      content: 'Final judging starts soon.',
    );
    expect(NotificationLink.eventId(encoded), 'event-1');
    expect(
      NotificationLink.displayContent(encoded),
      'Final judging starts soon.',
    );
  });

  test('AppNotification parses read state and timestamp', () {
    final notification = AppNotification.fromJson({
      'id': 'notification-id',
      'title': 'Score published',
      'content': 'Your team has a new score.',
      'notification_type': 'score',
      'is_read': true,
      'created_at': '2026-05-30T10:15:00',
    });

    expect(notification.isRead, isTrue);
    expect(notification.type, 'score');
    expect(notification.createdAt.minute, 15);
  });

  test('ChatMessage labels current user as Me', () {
    final message = ChatMessage.fromJson({
      'id': 'message-id',
      'sender_id': 'current-user',
      'message': 'Hello',
      'created_at': '2026-05-28T09:30:00',
      'sender': {'full_name': 'Participant'},
    }, 'current-user');

    expect(message.sender, 'Me');
    expect(message.createdAt.year, 2026);
  });

  test(
    'ChatProvider rejects empty outgoing messages before service call',
    () async {
      final provider = ChatProvider();

      await provider.send(
        'Participant',
        '   ',
        senderId: 'user',
        receiverId: 'mentor',
      );

      expect(provider.error, 'Tin nhắn không được để trống.');
    },
  );

  test(
    'AppValidators covers team, submission, score, event and notification',
    () {
      expect(AppValidators.teamName(''), 'Nhập tên đội.');
      expect(
        AppValidators.eventDateTimeField('bad-date', label: 'Ngày bắt đầu'),
        contains('yyyy-MM-dd HH:mm'),
      );
      expect(
        AppValidators.parseEventDateTime('2026-06-15 09:00'),
        DateTime(2026, 6, 15, 9),
      );
      expect(AppValidators.parseEventDateTime('15/06/2026'), isNull);
      expect(
        AppValidators.submissionPayload(
          teamId: '',
          name: 'App',
          githubUrl: 'https://github.com/a/b',
          videoUrl: 'https://youtu.be/demo',
          description: '1234567890',
        ),
        contains('đội'),
      );
      expect(
        AppValidators.judgeScore(
          submissionId: 'sub',
          judgeId: 'judge',
          technical: 11,
          ui: 5,
          innovation: 5,
          feedback: 'Good',
        ),
        contains('0 đến 10'),
      );
      expect(
        AppValidators.eventPayload(
          title: 'Hack',
          location: 'HCMC',
          bannerUrl: '',
          startDate: DateTime(2026, 6, 14),
          endDate: DateTime(2026, 6, 12),
          registrationDeadline: DateTime(2026, 6, 10),
          maxTeamSize: 4,
          latitude: 10,
          longitude: 106,
        ),
        contains('kết thúc'),
      );
      expect(
        AppValidators.notificationContent(
          title: '',
          content: 'Hello',
          type: 'announcement',
        ),
        contains('tiêu đề'),
      );
      expect(AppValidators.userRole('invalid'), contains('Vai trò'));
    },
  );

  test(
    'SubmissionProvider rejects invalid payload before service call',
    () async {
      final provider = SubmissionProvider();
      await provider.submit(
        ProjectSubmission(
          id: 'submission-1',
          teamId: 'team-1',
          projectName: 'My App',
          githubUrl: 'bad-url',
          videoUrl: 'https://youtu.be/demo',
          description: 'A valid project description.',
        ),
      );
      expect(provider.error, isNotNull);
      expect(provider.error, contains('GitHub'));
    },
  );

  test(
    'ScoreProvider rejects invalid judge score before service call',
    () async {
      final provider = ScoreProvider();
      await provider.addScore(
        const ProjectScore(
          submissionId: 'submission-1',
          judgeId: 'judge-1',
          technicalScore: 8,
          uiScore: 8,
          innovationScore: 8,
          feedback: '',
        ),
      );
      expect(provider.error, contains('nhận xét'));
    },
  );

  test('NotificationProvider rejects invalid announcement payload', () async {
    final provider = NotificationProvider();
    await provider.push('', 'content', 'announcement', userId: 'user-1');
    expect(provider.error, contains('tiêu đề'));
  });
}
