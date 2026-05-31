part of '../main.dart';

class AuthService {
  const AuthService();

  Future<AppUser?> currentUserProfile() async {
    final authUser = SupabaseGateway.client.auth.currentUser;
    if (authUser == null) return null;
    return _fetchProfile(authUser.id);
  }

  Future<AppUser> login(String email, String password) async {
    final response = await SupabaseGateway.client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    final authUser = response.user;
    if (authUser == null) {
      throw const AuthException('Unable to create a user session.');
    }
    return _fetchProfile(authUser.id);
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
  }

  Future<AppUser> updateProfile({
    required String userId,
    required String fullName,
    required String university,
  }) async {
    final row = await SupabaseGateway.client
        .from('users')
        .update({'full_name': fullName, 'university': university})
        .eq('id', userId)
        .select()
        .single();
    return AppUser.fromJson(row);
  }

  Future<void> logout() {
    return SupabaseGateway.client.auth.signOut();
  }
}

class UserDirectoryService {
  const UserDirectoryService();

  Future<AppUser?> findByEmail(String email) async {
    final row = await SupabaseGateway.client
        .from('users')
        .select()
        .eq('email', email.trim())
        .maybeSingle();
    if (row == null) return null;
    return AppUser.fromJson(row);
  }
}

class EventService {
  const EventService();

  Future<List<HackathonEvent>> fetchEvents() async {
    final rows = await SupabaseGateway.client
        .from('events')
        .select()
        .order('start_date');
    return rows
        .whereType<Map<String, dynamic>>()
        .map(HackathonEvent.fromJson)
        .toList();
  }
}

class TeamService {
  const TeamService();

  Future<List<Team>> fetchTeams() async {
    final rows = await SupabaseGateway.client
        .from('teams')
        .select(
          'id,name,leader_id,event_id,team_members(users(id,full_name,email,role,university))',
        )
        .order('created_at');
    return rows.whereType<Map<String, dynamic>>().map(Team.fromJson).toList();
  }

  Future<void> createTeam({
    required String name,
    required String eventId,
    required String leaderId,
  }) async {
    final row = await SupabaseGateway.client
        .from('teams')
        .insert({'name': name, 'leader_id': leaderId, 'event_id': eventId})
        .select()
        .single();
    await SupabaseGateway.client.from('team_members').upsert({
      'team_id': row['id'],
      'user_id': leaderId,
    });
  }

  Future<void> joinTeam(String teamId, String userId) {
    return SupabaseGateway.client.from('team_members').upsert({
      'team_id': teamId,
      'user_id': userId,
    });
  }

  Future<void> inviteMemberByEmail(String teamId, String email) async {
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
  }

  Future<void> updateTeamName(String teamId, String name) {
    return SupabaseGateway.client
        .from('teams')
        .update({'name': name})
        .eq('id', teamId);
  }

  Future<void> leaveTeam(String teamId, String userId) {
    return SupabaseGateway.client
        .from('team_members')
        .delete()
        .eq('team_id', teamId)
        .eq('user_id', userId);
  }
}

class SubmissionService {
  const SubmissionService();

  Future<List<ProjectSubmission>> fetchSubmissions() async {
    final rows = await SupabaseGateway.client
        .from('submissions')
        .select()
        .order('submitted_at', ascending: false);
    return rows
        .whereType<Map<String, dynamic>>()
        .map(ProjectSubmission.fromJson)
        .toList();
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
    if (existingSubmissionId != null) {
      return SupabaseGateway.client
          .from('submissions')
          .update(payload)
          .eq('id', existingSubmissionId);
    }
    return SupabaseGateway.client.from('submissions').insert(payload);
  }
}

class ScoreService {
  const ScoreService();

  Future<List<ProjectScore>> fetchScores() async {
    final rows = await SupabaseGateway.client.from('scores').select();
    return rows
        .whereType<Map<String, dynamic>>()
        .map(ProjectScore.fromJson)
        .toList();
  }

  Future<void> createScore(ProjectScore score) {
    return SupabaseGateway.client.from('scores').upsert({
      'submission_id': score.submissionId,
      'judge_id': score.judgeId,
      'technical_score': score.technicalScore,
      'ui_score': score.uiScore,
      'innovation_score': score.innovationScore,
      'feedback': score.feedback,
      'average_score': score.average,
    }, onConflict: 'submission_id,judge_id');
  }
}

class NotificationService {
  const NotificationService();

  Future<List<AppNotification>> fetchForUser(String userId) async {
    final rows = await SupabaseGateway.client
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return rows
        .whereType<Map<String, dynamic>>()
        .map(AppNotification.fromJson)
        .toList();
  }

  Future<void> create({
    required String userId,
    required String title,
    required String content,
    required String type,
  }) {
    return SupabaseGateway.client.from('notifications').insert({
      'user_id': userId,
      'title': title,
      'content': content,
      'notification_type': type,
    });
  }

  Future<void> markRead(String id) {
    return SupabaseGateway.client
        .from('notifications')
        .update({'is_read': true})
        .eq('id', id);
  }

  Future<void> deleteNotification(String id) {
    return SupabaseGateway.client.from('notifications').delete().eq('id', id);
  }
}

class ChatService {
  const ChatService();

  Future<List<AppUser>> fetchContacts(AppUser currentUser) async {
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
  }

  Future<List<ChatMessage>> fetchConversation(
    String userId,
    String receiverId,
  ) async {
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
  }

  Future<void> send({
    required String senderId,
    required String receiverId,
    required String message,
  }) {
    return SupabaseGateway.client.from('messages').insert({
      'sender_id': senderId,
      'receiver_id': receiverId,
      'message': message.trim(),
    });
  }

  Future<void> deleteMessage(String id) {
    return SupabaseGateway.client.from('messages').delete().eq('id', id);
  }
}
