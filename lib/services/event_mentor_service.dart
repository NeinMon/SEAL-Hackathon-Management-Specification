import '../core/app_helpers.dart';
import '../core/supabase_config.dart';
import '../models/app_user.dart';

class EventMentorService {
  const EventMentorService();

  Future<List<String>> fetchMentorIdsForEvent(String eventId) async {
    return AppOperation.run('event_mentors.fetch', () async {
      final rows = await SupabaseGateway.client
          .from('event_mentors')
          .select('mentor_id')
          .eq('event_id', eventId);
      return rows
          .whereType<Map<String, dynamic>>()
          .map((row) => (row['mentor_id'] ?? '').toString())
          .where((id) => id.isNotEmpty)
          .toList();
    });
  }

  Future<void> saveMentorsForEvent({
    required String eventId,
    required List<String> mentorIds,
  }) {
    AppLogger.action('event_mentors.save', {
      'event_id': eventId,
      'count': mentorIds.length,
    });
    return AppOperation.run('event_mentors.save', () async {
      await SupabaseGateway.client
          .from('event_mentors')
          .delete()
          .eq('event_id', eventId);
      if (mentorIds.isEmpty) return;
      await SupabaseGateway.client.from('event_mentors').insert([
        for (final mentorId in mentorIds)
          {'event_id': eventId, 'mentor_id': mentorId},
      ]);
    });
  }

  Future<List<AppUser>> fetchMentorsForParticipant(String userId) async {
    return AppOperation.run('event_mentors.participant_contacts', () async {
      final rows = await SupabaseGateway.client
          .from('team_members')
          .select('teams!inner(event_id)')
          .eq('user_id', userId);
      final eventIds = rows
          .whereType<Map<String, dynamic>>()
          .map((row) {
            final teams = row['teams'];
            if (teams is Map<String, dynamic>) {
              return (teams['event_id'] ?? '').toString();
            }
            return '';
          })
          .where((id) => id.isNotEmpty)
          .toSet()
          .toList();
      if (eventIds.isEmpty) return const <AppUser>[];

      final mentorRows = await SupabaseGateway.client
          .from('event_mentors')
          .select('mentor_id, users!event_mentors_mentor_id_fkey(*)')
          .inFilter('event_id', eventIds);
      final mentors = <AppUser>[];
      final seen = <String>{};
      for (final row in mentorRows.whereType<Map<String, dynamic>>()) {
        final userJson = row['users'];
        if (userJson is! Map<String, dynamic>) continue;
        final mentor = AppUser.fromJson(userJson);
        if (seen.add(mentor.id)) mentors.add(mentor);
      }
      mentors.sort((a, b) => a.fullName.compareTo(b.fullName));
      return mentors;
    });
  }

  Future<List<AppUser>> fetchMentorsForParticipantOnEvent({
    required String userId,
    required String eventId,
  }) async {
    return AppOperation.run('event_mentors.participant_event_contacts', () async {
      final membership = await SupabaseGateway.client
          .from('team_members')
          .select('team_id, teams!inner(event_id)')
          .eq('user_id', userId)
          .eq('teams.event_id', eventId)
          .maybeSingle();
      if (membership == null) return const <AppUser>[];

      final mentorRows = await SupabaseGateway.client
          .from('event_mentors')
          .select('mentor_id, users!event_mentors_mentor_id_fkey(*)')
          .eq('event_id', eventId);
      final mentors = <AppUser>[];
      final seen = <String>{};
      for (final row in mentorRows.whereType<Map<String, dynamic>>()) {
        final userJson = row['users'];
        if (userJson is! Map<String, dynamic>) continue;
        final mentor = AppUser.fromJson(userJson);
        if (seen.add(mentor.id)) mentors.add(mentor);
      }
      mentors.sort((a, b) => a.fullName.compareTo(b.fullName));
      return mentors;
    });
  }

  Future<List<AppUser>> fetchParticipantsForMentorOnEvent({
    required String mentorId,
    required String eventId,
  }) async {
    return AppOperation.run('event_mentors.mentor_event_contacts', () async {
      final assignment = await SupabaseGateway.client
          .from('event_mentors')
          .select('event_id')
          .eq('mentor_id', mentorId)
          .eq('event_id', eventId)
          .maybeSingle();
      if (assignment == null) return const <AppUser>[];

      final teamRows = await SupabaseGateway.client
          .from('teams')
          .select('id')
          .eq('event_id', eventId);
      final teamIds = teamRows
          .whereType<Map<String, dynamic>>()
          .map((row) => (row['id'] ?? '').toString())
          .where((id) => id.isNotEmpty)
          .toList();
      if (teamIds.isEmpty) return const <AppUser>[];

      final memberRows = await SupabaseGateway.client
          .from('team_members')
          .select('users!team_members_user_id_fkey(*)')
          .inFilter('team_id', teamIds);
      final participants = <AppUser>[];
      final seen = <String>{};
      for (final row in memberRows.whereType<Map<String, dynamic>>()) {
        final userJson = row['users'];
        if (userJson is! Map<String, dynamic>) continue;
        final user = AppUser.fromJson(userJson);
        if (user.id == mentorId) continue;
        if (user.role != AppRoles.participant) continue;
        if (seen.add(user.id)) participants.add(user);
      }
      participants.sort((a, b) => a.fullName.compareTo(b.fullName));
      return participants;
    });
  }

  Future<List<AppUser>> fetchParticipantsForMentor(String mentorId) async {
    return AppOperation.run('event_mentors.mentor_contacts', () async {
      final assignmentRows = await SupabaseGateway.client
          .from('event_mentors')
          .select('event_id')
          .eq('mentor_id', mentorId);
      final eventIds = assignmentRows
          .whereType<Map<String, dynamic>>()
          .map((row) => (row['event_id'] ?? '').toString())
          .where((id) => id.isNotEmpty)
          .toSet()
          .toList();
      if (eventIds.isEmpty) return const <AppUser>[];

      final teamRows = await SupabaseGateway.client
          .from('teams')
          .select('id')
          .inFilter('event_id', eventIds);
      final teamIds = teamRows
          .whereType<Map<String, dynamic>>()
          .map((row) => (row['id'] ?? '').toString())
          .where((id) => id.isNotEmpty)
          .toList();
      if (teamIds.isEmpty) return const <AppUser>[];

      final memberRows = await SupabaseGateway.client
          .from('team_members')
          .select('users!team_members_user_id_fkey(*)')
          .inFilter('team_id', teamIds);
      final participants = <AppUser>[];
      final seen = <String>{};
      for (final row in memberRows.whereType<Map<String, dynamic>>()) {
        final userJson = row['users'];
        if (userJson is! Map<String, dynamic>) continue;
        final user = AppUser.fromJson(userJson);
        if (user.id == mentorId) continue;
        if (user.role != AppRoles.participant) continue;
        if (seen.add(user.id)) participants.add(user);
      }
      participants.sort((a, b) => a.fullName.compareTo(b.fullName));
      return participants;
    });
  }
}
