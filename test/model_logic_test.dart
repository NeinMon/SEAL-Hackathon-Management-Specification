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
}
