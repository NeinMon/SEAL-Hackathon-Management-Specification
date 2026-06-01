part of '../main.dart';

class AuthService {
  const AuthService();

  Future<AppUser?> currentUserProfile() async {
    return AppOperation.run('auth.current_profile', () async {
      final authUser = SupabaseGateway.client.auth.currentUser;
      if (authUser == null) return null;
      return _fetchProfile(authUser.id);
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
      return _fetchProfile(authUser.id);
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

  Future<AppUser> register({
    required String fullName,
    required String email,
    required String password,
    required String role,
    required String university,
  }) async {
    return AppOperation.run('auth.register', () async {
      final response = await SupabaseGateway.client.auth.signUp(
        email: email,
        password: password,
      );
      final authUser = response.user;
      if (authUser == null) {
        throw const AuthException('Unable to create an account.');
      }
      final profile = AppUser(
        id: authUser.id,
        fullName: fullName,
        email: email,
        role: role,
        university: university,
      );
      await SupabaseGateway.client.from('users').upsert(profile.toJson());
      return profile;
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
}

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
    return AppOperation.run('teams.join', () {
      return SupabaseGateway.client.from('team_members').upsert({
        'team_id': teamId,
        'user_id': userId,
      });
    });
  }

  Future<void> inviteMemberByEmail(String teamId, String email) async {
    return AppOperation.run('teams.invite', () async {
      final user = await SupabaseGateway.client
          .from('users')
          .select('id')
          .eq('email', email)
          .maybeSingle();
      if (user == null) {
        throw Exception('No user was found with email $email.');
      }
      await SupabaseGateway.client.from('team_members').upsert({
        'team_id': teamId,
        'user_id': user['id'],
      });
    });
  }

  Future<void> updateTeamName(String teamId, String name) {
    return AppOperation.run('teams.update_name', () {
      return SupabaseGateway.client
          .from('teams')
          .update({'name': name})
          .eq('id', teamId);
    });
  }

  Future<void> leaveTeam(String teamId, String userId) {
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
