import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/app_helpers.dart';
import '../core/supabase_config.dart';
import '../models/app_notification.dart';
import '../models/app_user.dart';
import '../models/chat_message.dart';
import '../models/hackathon_event.dart';
import '../models/project_score.dart';
import '../models/project_submission.dart';
import '../models/team.dart';
import '../models/team_invitation.dart';

class RegisterResult {
  const RegisterResult({
    this.user,
    this.requiresEmailVerification = false,
    required this.email,
  });

  final AppUser? user;
  final bool requiresEmailVerification;
  final String email;
}

class AuthService {
  const AuthService();

  Future<AppUser?> currentUserProfile() async {
    return AppOperation.run('auth.current_profile', () async {
      final authUser = SupabaseGateway.client.auth.currentUser;
      if (authUser == null) return null;
      return _profileForAuthUser(authUser);
    });
  }

  Future<AppUser> login(String email, String password) async {
    return AppOperation.run('auth.login', () async {
      final response = await SupabaseGateway.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final authUser = response.user;
      if (authUser == null) {
        throw const AuthException('Unable to create a user session.');
      }
      return _profileForAuthUser(authUser);
    });
  }

  Future<AppUser> _fetchProfile(String userId) async {
    final profile = await SupabaseGateway.client
        .from('users')
        .select()
        .eq('id', userId)
        .maybeSingle();
    if (profile == null) {
      throw const AuthException(
        'This account does not have a user profile yet.',
      );
    }
    return AppUser.fromJson(profile);
  }

  Future<AppUser> _profileForAuthUser(User authUser) async {
    try {
      return await _fetchProfile(authUser.id);
    } on AuthException {
      await _backfillProfile(authUser);
      return _fetchProfile(authUser.id);
    }
  }

  Future<void> _backfillProfile(User authUser) async {
    final metadata = authUser.userMetadata ?? {};
    final email = authUser.email ?? '';
    await SupabaseGateway.client.from('users').upsert({
      'id': authUser.id,
      'full_name': metadata['full_name'] ?? email.split('@').first,
      'email': email,
      'role': 'participant',
      'university': metadata['university'],
    }, onConflict: 'id');
  }

  Future<RegisterResult> register({
    required String fullName,
    required String email,
    required String password,
    required String university,
  }) async {
    return AppOperation.run('auth.register', () async {
      final response = await SupabaseGateway.client.auth.signUp(
        email: email,
        password: password,
        emailRedirectTo: SupabaseConfig.authRedirectUrl,
        data: {'full_name': fullName, 'university': university},
      );
      final authUser = response.user;
      if (authUser == null) {
        throw const AuthException('Unable to create an account.');
      }
      if (response.session == null) {
        final identities = authUser.identities;
        if (identities == null || identities.isEmpty) {
          throw const AuthException(
            'Email này đã được đăng ký. Hãy đăng nhập hoặc dùng "Quên mật khẩu".',
          );
        }
        return RegisterResult(requiresEmailVerification: true, email: email);
      }
      final profile = await _profileForAuthUser(authUser);
      return RegisterResult(user: profile, email: email);
    });
  }

  Future<AppUser> verifySignupOtp({
    required String email,
    required String otp,
  }) async {
    return AppOperation.run('auth.verify_signup_otp', () async {
      final response = await SupabaseGateway.client.auth.verifyOTP(
        type: OtpType.signup,
        email: email.trim(),
        token: otp.trim(),
      );
      final authUser = response.user;
      if (authUser == null) {
        throw const AuthException('Mã OTP không hợp lệ hoặc đã hết hạn.');
      }
      return _profileForAuthUser(authUser);
    });
  }

  Future<void> requestPasswordReset(String email) {
    return AppOperation.run('auth.reset_password', () async {
      await SupabaseGateway.client.auth.resetPasswordForEmail(
        email.trim(),
        redirectTo: SupabaseConfig.authRedirectUrl,
      );
    });
  }

  Future<AppUser> updateProfile({
    required String userId,
    required String fullName,
    required String university,
  }) async {
    return AppOperation.run('auth.update_profile', () async {
      final row = await SupabaseGateway.client
          .from('users')
          .update({'full_name': fullName, 'university': university})
          .eq('id', userId)
          .select()
          .single();
      return AppUser.fromJson(row);
    });
  }

  Future<void> logout() {
    return SupabaseGateway.client.auth.signOut();
  }
}

class UserDirectoryService {
  const UserDirectoryService();

  Future<AppUser?> findByEmail(String email) async {
    return AppOperation.run('users.find_by_email', () async {
      final row = await SupabaseGateway.client
          .from('users')
          .select()
          .eq('email', email.trim())
          .maybeSingle();
      if (row == null) return null;
      return AppUser.fromJson(row);
    });
  }

  Future<List<AppUser>> fetchUsers() {
    return AppOperation.run('users.fetch_all', () async {
      final rows = await SupabaseGateway.client
          .from('users')
          .select()
          .order('full_name');
      return rows
          .whereType<Map<String, dynamic>>()
          .map(AppUser.fromJson)
          .toList();
    });
  }

  Future<AppUser> updateUserRole({
    required String userId,
    required String role,
  }) {
    return AppOperation.run('users.update_role', () async {
      final userError = AppValidators.requireUserId(userId);
      if (userError != null) {
        throw Exception(userError);
      }
      final roleError = AppValidators.userRole(role);
      if (roleError != null) {
        throw Exception(roleError);
      }
      final currentUserId = SupabaseGateway.client.auth.currentUser?.id;
      if (currentUserId != null && currentUserId == userId) {
        throw Exception(AppStrings.cannotChangeOwnRole);
      }
      final row = await SupabaseGateway.client
          .from('users')
          .update({'role': role})
          .eq('id', userId)
          .select()
          .single();
      return AppUser.fromJson(row);
    });
  }
}

// Admin demo reset functionality removed. If you need to re-enable,
// restore `AdminService.resetDemoData()` and related edge function.

class EventService {
  const EventService();

  Future<List<HackathonEvent>> fetchEvents() async {
    return AppOperation.run('events.fetch', () async {
      final rows = await SupabaseGateway.client
          .from('events')
          .select()
          .order('start_date');
      return rows
          .whereType<Map<String, dynamic>>()
          .map(HackathonEvent.fromJson)
          .toList();
    });
  }

  Future<void> saveEvent(HackathonEvent event, {String? existingEventId}) {
    final payload = event.toJson();
    AppLogger.action('event.save', {
      'event_id': existingEventId ?? event.id,
      'mode': existingEventId == null ? 'create' : 'update',
    });
    return AppOperation.run('events.save', () {
      if (existingEventId == null) {
        return SupabaseGateway.client.from('events').insert(payload);
      }
      return SupabaseGateway.client
          .from('events')
          .update(payload)
          .eq('id', existingEventId);
    });
  }
}

class TeamService {
  const TeamService();

  Future<List<Team>> fetchTeams() async {
    return AppOperation.run('teams.fetch', () async {
      final rows = await SupabaseGateway.client
          .from('teams')
          .select(
            'id,name,leader_id,event_id,team_members(users(id,full_name,email,role,university))',
          )
          .order('created_at');
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
        throw Exception(AppStrings.inviteUserNotFound);
      }
      final inviterId = SupabaseGateway.client.auth.currentUser?.id;
      if (inviterId == null) {
        throw Exception(AppStrings.notLoggedInMessage);
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

class SubmissionService {
  const SubmissionService();

  Future<List<ProjectSubmission>> fetchSubmissions() async {
    return AppOperation.run('submissions.fetch', () async {
      final rows = await SupabaseGateway.client
          .from('submissions')
          .select()
          .order('submitted_at', ascending: false);
      return rows
          .whereType<Map<String, dynamic>>()
          .map(ProjectSubmission.fromJson)
          .toList();
    });
  }

  Future<void> saveSubmission(
    ProjectSubmission submission, {
    String? existingSubmissionId,
  }) {
    final payload = {
      'team_id': submission.teamId,
      'github_url': submission.githubUrl,
      'video_url': submission.videoUrl,
      'project_name': submission.projectName,
      'description': submission.description,
      'status': submission.status,
    };
    AppLogger.action('submission.save', {
      'submission_id': existingSubmissionId ?? submission.id,
      'team_id': submission.teamId,
      'status': submission.status,
      'mode': existingSubmissionId == null ? 'create' : 'update',
    });
    return AppOperation.run('submissions.save', () {
      if (existingSubmissionId != null) {
        return SupabaseGateway.client
            .from('submissions')
            .update(payload)
            .eq('id', existingSubmissionId);
      }
      return SupabaseGateway.client.from('submissions').insert(payload);
    });
  }

  Future<List<SubmissionHistory>> fetchHistory() {
    return AppOperation.run('submission_history.fetch', () async {
      final rows = await SupabaseGateway.client
          .from('submission_history')
          .select()
          .order('changed_at', ascending: false);
      return rows
          .whereType<Map<String, dynamic>>()
          .map(SubmissionHistory.fromJson)
          .toList();
    });
  }
}

class ScoreService {
  const ScoreService();

  Future<List<ProjectScore>> fetchScores() async {
    return AppOperation.run('scores.fetch', () async {
      final rows = await SupabaseGateway.client.from('scores').select();
      return rows
          .whereType<Map<String, dynamic>>()
          .map(ProjectScore.fromJson)
          .toList();
    });
  }

  Future<void> createScore(ProjectScore score) {
    AppLogger.action('score.upsert', {
      'submission_id': score.submissionId,
      'judge_id': score.judgeId,
      'average': score.average,
    });
    return AppOperation.run('scores.upsert', () {
      return SupabaseGateway.client.from('scores').upsert({
        'submission_id': score.submissionId,
        'judge_id': score.judgeId,
        'technical_score': score.technicalScore,
        'ui_score': score.uiScore,
        'innovation_score': score.innovationScore,
        'feedback': score.feedback,
        'average_score': score.average,
      }, onConflict: 'submission_id,judge_id');
    });
  }
}

class NotificationService {
  const NotificationService();

  Future<List<AppNotification>> fetchForUser(String userId) async {
    return AppOperation.run('notifications.fetch', () async {
      final rows = await SupabaseGateway.client
          .from('notifications')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      return rows
          .whereType<Map<String, dynamic>>()
          .map(AppNotification.fromJson)
          .toList();
    });
  }

  Future<void> create({
    required String userId,
    required String title,
    required String content,
    required String type,
  }) {
    AppLogger.action('notification.create', {'user_id': userId, 'type': type});
    return AppOperation.run('notifications.create', () {
      return SupabaseGateway.client.from('notifications').insert({
        'user_id': userId,
        'title': title,
        'content': content,
        'notification_type': type,
      });
    });
  }

  Future<void> markRead(String id) {
    return AppOperation.run('notifications.mark_read', () {
      return SupabaseGateway.client
          .from('notifications')
          .update({'is_read': true})
          .eq('id', id);
    });
  }

  Future<void> deleteNotification(String id) {
    return AppOperation.run('notifications.delete', () {
      return SupabaseGateway.client.from('notifications').delete().eq('id', id);
    });
  }
}

class ChatService {
  const ChatService();

  Future<List<AppUser>> fetchContacts(AppUser currentUser) async {
    return AppOperation.run('chat.contacts', () async {
      final rows = await SupabaseGateway.client
          .from('users')
          .select()
          .neq('id', currentUser.id)
          .order('full_name');
      final users = rows
          .whereType<Map<String, dynamic>>()
          .map(AppUser.fromJson)
          .toList();

      switch (currentUser.role) {
        case AppRoles.participant:
          return users
              .where(
                (user) =>
                    user.role == AppRoles.mentor ||
                    user.role == AppRoles.organizer,
              )
              .toList();
        case AppRoles.mentor:
          final memberRows = await SupabaseGateway.client
              .from('team_members')
              .select('team_id,user_id');
          final teamsForMentor = memberRows
              .whereType<Map<String, dynamic>>()
              .where((row) => row['user_id'] == currentUser.id)
              .map((row) => row['team_id'] as String)
              .toSet();
          final relatedUserIds = memberRows
              .whereType<Map<String, dynamic>>()
              .where((row) => teamsForMentor.contains(row['team_id']))
              .map((row) => row['user_id'] as String)
              .toSet();
          return users
              .where(
                (user) =>
                    user.role == AppRoles.organizer ||
                    (user.role == AppRoles.participant &&
                        relatedUserIds.contains(user.id)),
              )
              .toList();
        case AppRoles.organizer:
          return users;
        default:
          return const [];
      }
    });
  }

  Future<List<ChatMessage>> fetchConversation(
    String userId,
    String receiverId,
  ) async {
    return AppOperation.run('chat.conversation', () async {
      final rows = await SupabaseGateway.client
          .from('messages')
          .select('*,sender:users!messages_sender_id_fkey(full_name)')
          .or(
            'and(sender_id.eq.$userId,receiver_id.eq.$receiverId),and(sender_id.eq.$receiverId,receiver_id.eq.$userId)',
          )
          .order('created_at');
      return rows
          .whereType<Map<String, dynamic>>()
          .map((row) => ChatMessage.fromJson(row, userId))
          .toList();
    });
  }

  Future<void> send({
    required String senderId,
    required String receiverId,
    required String message,
  }) {
    AppLogger.action('chat.send', {
      'sender_id': senderId,
      'receiver_id': receiverId,
    });
    return AppOperation.run('chat.send', () {
      return SupabaseGateway.client.from('messages').insert({
        'sender_id': senderId,
        'receiver_id': receiverId,
        'message': message.trim(),
      });
    });
  }

  Future<void> deleteMessage(String id) {
    return AppOperation.run('chat.delete', () {
      return SupabaseGateway.client.from('messages').delete().eq('id', id);
    });
  }
}
