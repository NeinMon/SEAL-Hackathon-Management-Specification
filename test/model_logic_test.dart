import 'package:flutter_test/flutter_test.dart';
import 'package:seal_hackathon_app/main.dart';
import 'package:supabase/supabase.dart';

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
    expect(AppValidators.scoreError(11, 5, 10), contains('between 0 and 10'));
  });

  test('FriendlyErrorMapper hides raw PostgrestException details', () {
    final message = FriendlyErrorMapper.message(
      const PostgrestException(
        message: 'new row violates row-level security policy',
        code: '42501',
      ),
    );

    expect(message, contains('Permission denied'));
    expect(message, isNot(contains('PostgrestException')));
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

    expect(provider.error, contains('already full'));
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

      expect(provider.error, 'Message cannot be empty.');
    },
  );
}
