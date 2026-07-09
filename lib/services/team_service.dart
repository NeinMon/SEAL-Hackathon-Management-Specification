import '../core/l10n/l10n_service.dart';
import '../core/app_helpers.dart';
import '../core/supabase_config.dart';
import '../models/team.dart';
import '../models/team_invitation.dart';

class TeamService {
  const TeamService();

  Future<List<Team>> fetchTeams({String? eventId}) async {
    return AppOperation.run('teams.fetch', () async {
      var query = SupabaseGateway.client
          .from('teams')
          .select(
            'id,name,leader_id,event_id,team_members(users(id,full_name,email,role,university))',
          );
      if (eventId != null && eventId.isNotEmpty) {
        query = query.eq('event_id', eventId);
      }
      final rows = await query.order('created_at');
      return rows.whereType<Map<String, dynamic>>().map(Team.fromJson).toList();
    });
  }

  Future<void> createTeam({
    required String name,
    required String eventId,
    required String leaderId,
  }) async {
    AppLogger.action('team.create', {
      'event_id': eventId,
      'leader_id': leaderId,
    });
    return AppOperation.run('teams.create', () async {
      final row = await SupabaseGateway.client
          .from('teams')
          .insert({'name': name, 'leader_id': leaderId, 'event_id': eventId})
          .select()
          .single();
      await SupabaseGateway.client.from('team_members').upsert({
        'team_id': row['id'],
        'user_id': leaderId,
      });
    });
  }

  Future<void> joinTeam(String teamId, String userId) {
    AppLogger.action('team.join', {'team_id': teamId, 'user_id': userId});
    return AppOperation.run('teams.join', () {
      return SupabaseGateway.client.from('team_members').upsert({
        'team_id': teamId,
        'user_id': userId,
      });
    });
  }

  Future<void> inviteMemberByEmail(String teamId, String email) async {
    AppLogger.action('team.invite', {'team_id': teamId, 'email': email});
    return AppOperation.run('teams.invite', () async {
      final user = await SupabaseGateway.client
          .from('users')
          .select('id')
          .eq('email', email)
          .maybeSingle();
      if (user == null) {
        throw Exception(L10nService.strings.inviteUserNotFound);
      }
      final inviterId = SupabaseGateway.client.auth.currentUser?.id;
      if (inviterId == null) {
        throw Exception(L10nService.strings.notLoggedInMessage);
      }
      await SupabaseGateway.client.from('team_invitations').insert({
        'team_id': teamId,
        'inviter_id': inviterId,
        'invitee_id': user['id'],
      });
    });
  }

  Future<List<TeamInvitation>> fetchInvitationsForUser(String userId) {
    return AppOperation.run('team_invitations.fetch', () async {
      final rows = await SupabaseGateway.client
          .from('team_invitations')
          .select(
            '*,team:teams(id,name,leader_id,event_id,team_members(users(id,full_name,email,role,university))),inviter:users!team_invitations_inviter_id_fkey(id,full_name,email,role,university)',
          )
          .eq('invitee_id', userId)
          .order('created_at', ascending: false);
      return rows
          .whereType<Map<String, dynamic>>()
          .map(TeamInvitation.fromJson)
          .toList();
    });
  }

  Future<void> acceptInvitation(TeamInvitation invitation) {
    return AppOperation.run('team_invitations.accept', () async {
      await SupabaseGateway.client.from('team_members').upsert({
        'team_id': invitation.teamId,
        'user_id': invitation.inviteeId,
      });
      await SupabaseGateway.client
          .from('team_invitations')
          .update({
            'status': 'accepted',
            'responded_at': DateTime.now().toUtc().toIso8601String(),
          })
          .eq('id', invitation.id);
    });
  }

  Future<void> declineInvitation(String invitationId) {
    return AppOperation.run('team_invitations.decline', () {
      return SupabaseGateway.client
          .from('team_invitations')
          .update({
            'status': 'declined',
            'responded_at': DateTime.now().toUtc().toIso8601String(),
          })
          .eq('id', invitationId);
    });
  }

  Future<void> updateTeamName(String teamId, String name) {
    AppLogger.action('team.rename', {'team_id': teamId});
    return AppOperation.run('teams.update_name', () {
      return SupabaseGateway.client
          .from('teams')
          .update({'name': name})
          .eq('id', teamId);
    });
  }

  Future<void> leaveTeam(String teamId, String userId) {
    AppLogger.action('team.leave', {'team_id': teamId, 'user_id': userId});
    return AppOperation.run('teams.leave', () {
      return SupabaseGateway.client
          .from('team_members')
          .delete()
          .eq('team_id', teamId)
          .eq('user_id', userId);
    });
  }
}
