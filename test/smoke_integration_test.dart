import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:seal_hackathon_app/main.dart';

/// Smoke / integration-style checks that do not require a live Supabase project.
void main() {
  group('HackathonEvent venue & submission fields', () {
    test('parses support_hotline and opening_hours from database rows', () {
      final event = HackathonEvent.fromJson({
        'id': 'event-venue',
        'title': 'Venue Event',
        'description': 'Demo',
        'start_date': '2026-07-01T08:00:00',
        'end_date': '2026-07-03T18:00:00',
        'location': 'FPT HCM',
        'banner_url': 'https://example.com/banner.jpg',
        'registration_deadline': '2026-06-28T23:59:00',
        'submission_deadline': '2026-07-02T12:00:00',
        'max_team_size': 4,
        'rules': 'Rules',
        'prize': 'Prize',
        'latitude': 10.77,
        'longitude': 106.70,
        'support_hotline': '1900 1234',
        'opening_hours': '08:00 – 22:00 hàng ngày',
      });

      expect(event.supportHotline, '1900 1234');
      expect(event.openingHours, '08:00 – 22:00 hàng ngày');
      expect(event.displayHotline, '1900 1234');
      expect(event.displayOpeningHours, '08:00 – 22:00 hàng ngày');
    });

    test('display getters fall back to app defaults when fields are empty', () {
      final event = HackathonEvent(
        id: 'event-defaults',
        title: 'Defaults',
        description: 'Demo',
        startDate: DateTime(2026, 7, 1),
        endDate: DateTime(2026, 7, 3),
        location: 'HCM',
        bannerUrl: 'https://example.com/banner.jpg',
        registrationDeadline: DateTime(2026, 6, 28),
        maxTeamSize: 4,
        rules: 'Rules',
        prize: 'Prize',
        latitude: 10.0,
        longitude: 106.0,
      );

      expect(event.displayHotline, L10nService.strings.defaultHotline);
      expect(event.displayOpeningHours, L10nService.strings.defaultOpeningHours);
    });

    test('serializes optional venue fields in toJson', () {
      final event = HackathonEvent(
        id: 'event-json',
        title: 'JSON',
        description: 'Demo',
        startDate: DateTime(2026, 7, 1),
        endDate: DateTime(2026, 7, 3),
        location: 'HCM',
        bannerUrl: 'https://example.com/banner.jpg',
        registrationDeadline: DateTime(2026, 6, 28),
        maxTeamSize: 4,
        rules: 'Rules',
        prize: 'Prize',
        latitude: 10.0,
        longitude: 106.0,
        supportHotline: '028 1234 5678',
        openingHours: '09:00 – 18:00',
      );

      final json = event.toJson();
      expect(json['support_hotline'], '028 1234 5678');
      expect(json['opening_hours'], '09:00 – 18:00');
    });
  });

  group('Notification deep links (system / mentor request)', () {
    test('organizer system notification routes to event dashboard', () {
      final notification = AppNotification(
        id: 'n1',
        title: 'Yêu cầu mentor',
        content: NotificationLink.encodeEvent(
          eventId: 'event-42',
          content: L10nService.strings.chatMentorRequestTemplate,
        ),
        type: 'system',
        isRead: false,
        createdAt: DateTime.now(),
      );

      expect(
        NotificationLink.routeFor(notification, role: AppRoles.organizer),
        RouteQuery.organizerForEvent('event-42'),
      );
    });

    test('participant system notification without team routes to teams', () {
      final notification = AppNotification(
        id: 'n2',
        title: 'Nhắc nộp bài',
        content: NotificationLink.encodeEvent(
          eventId: 'event-42',
          content: 'Hãy nộp bài trước hạn.',
        ),
        type: 'system',
        isRead: false,
        createdAt: DateTime.now(),
      );

      expect(
        NotificationLink.routeFor(
          notification,
          role: AppRoles.participant,
          userId: 'user-1',
          teams: const [],
        ),
        RouteQuery.teamsForEvent('event-42'),
      );
    });
  });

  group('Supabase migration smoke checks', () {
    final migrationDir = Directory('supabase/migrations');

    test('pending P0–D migration files exist', () {
      const required = [
        '20260706000300_demo_reset_hardening.sql',
        '20260706000400_notification_action_fields.sql',
        '20260706000500_p0_demo_reset_and_invitation_rls.sql',
        '20260706000600_p1_submission_judging_phases.sql',
        '20260706000700_d_venue_fields.sql',
      ];
      for (final name in required) {
        expect(File('${migrationDir.path}/$name').existsSync(), isTrue, reason: name);
      }
    });

    test('demo reset RPC does not delete users table', () {
      final sql = File(
        '${migrationDir.path}/20260706000500_p0_demo_reset_and_invitation_rls.sql',
      ).readAsStringSync();
      expect(sql.toLowerCase(), isNot(contains('delete from public.users')));
      expect(sql.toLowerCase(), isNot(contains('delete from users')));
    });

    test('venue migration adds support_hotline and opening_hours', () {
      final sql = File(
        '${migrationDir.path}/20260706000700_d_venue_fields.sql',
      ).readAsStringSync();
      expect(sql, contains('support_hotline'));
      expect(sql, contains('opening_hours'));
    });

    test('submission judging migration defines submission_deadline', () {
      final sql = File(
        '${migrationDir.path}/20260706000600_p1_submission_judging_phases.sql',
      ).readAsStringSync();
      expect(sql, contains('submission_deadline'));
      expect(sql, contains('event_submission_open'));
      expect(sql, contains('event_judging_open'));
    });
  });

  group('Participant journey smoke scenarios', () {
    test('missed submission when window closed without submission', () {
      final now = DateTime(2026, 7, 5, 12);
      final event = HackathonEvent(
        id: 'e1',
        title: 'Hack',
        description: 'D',
        location: 'HCM',
        bannerUrl: 'https://example.com/b.jpg',
        latitude: 10,
        longitude: 106,
        startDate: now.subtract(const Duration(days: 3)),
        endDate: now.add(const Duration(days: 2)),
        registrationDeadline: now.subtract(const Duration(days: 4)),
        submissionDeadline: now.subtract(const Duration(hours: 1)),
        maxTeamSize: 4,
        rules: 'R',
        prize: 'P',
      );
      final team = Team(
        id: 't1',
        name: 'Alpha',
        leaderId: 'u1',
        eventId: 'e1',
        members: const [
          AppUser(
            id: 'u1',
            fullName: 'User',
            email: 'u@example.com',
            role: AppRoles.participant,
            university: 'FPT',
          ),
        ],
      );

      final journey = ParticipantJourney.forUser(
        event: event,
        userId: 'u1',
        teams: [team],
        submissions: const [],
        scores: ScoreProvider(),
      );

      expect(journey?.step, ParticipantJourneyStep.missedSubmission);
    });

    test('registration closed journey step when deadline passed', () {
      final now = DateTime(2026, 7, 5);
      final event = HackathonEvent(
        id: 'e2',
        title: 'Hack',
        description: 'D',
        location: 'HCM',
        bannerUrl: 'https://example.com/b.jpg',
        latitude: 10,
        longitude: 106,
        startDate: now.add(const Duration(days: 5)),
        endDate: now.add(const Duration(days: 7)),
        registrationDeadline: now.subtract(const Duration(days: 1)),
        maxTeamSize: 4,
        rules: 'R',
        prize: 'P',
      );

      final journey = ParticipantJourney.forUser(
        event: event,
        userId: 'u2',
        teams: const [],
        submissions: const [],
        scores: ScoreProvider(),
      );

      expect(journey?.step, ParticipantJourneyStep.registrationClosed);
    });
  });
}
