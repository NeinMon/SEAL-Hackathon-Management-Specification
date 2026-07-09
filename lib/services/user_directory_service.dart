import '../core/l10n/l10n_service.dart';
import '../core/app_helpers.dart';
import '../core/supabase_config.dart';
import '../models/app_user.dart';

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

  Future<List<AppUser>> fetchUsersByRole(String role) async {
    final users = await fetchUsers();
    return users.where((user) => user.role == role).toList();
  }

  Future<List<AppUser>> fetchUsersForEvent({
    required String eventId,
    String? role,
  }) async {
    return AppOperation.run('users.fetch_for_event', () async {
      final ids = <String>{};

      if (role == null || role == 'all' || role == AppRoles.participant) {
        final memberRows = await SupabaseGateway.client
            .from('team_members')
            .select('user_id, teams!inner(event_id)')
            .eq('teams.event_id', eventId);
        for (final row in memberRows.whereType<Map<String, dynamic>>()) {
          final userId = (row['user_id'] ?? '').toString();
          if (userId.isNotEmpty) ids.add(userId);
        }
      }

      if (role == null || role == 'all' || role == AppRoles.mentor) {
        final mentorRows = await SupabaseGateway.client
            .from('event_mentors')
            .select('mentor_id')
            .eq('event_id', eventId);
        for (final row in mentorRows.whereType<Map<String, dynamic>>()) {
          final mentorId = (row['mentor_id'] ?? '').toString();
          if (mentorId.isNotEmpty) ids.add(mentorId);
        }
      }

      if (role == null || role == 'all' || role == AppRoles.judge) {
        final judgeRows = await SupabaseGateway.client
            .from('users')
            .select('id')
            .eq('role', AppRoles.judge);
        for (final row in judgeRows.whereType<Map<String, dynamic>>()) {
          final judgeId = (row['id'] ?? '').toString();
          if (judgeId.isNotEmpty) ids.add(judgeId);
        }
      }

      if (ids.isEmpty) return const <AppUser>[];

      final userRows = await SupabaseGateway.client
          .from('users')
          .select()
          .inFilter('id', ids.toList())
          .order('full_name');
      final users = userRows
          .whereType<Map<String, dynamic>>()
          .map(AppUser.fromJson)
          .toList();
      if (role == null || role == 'all') return users;
      return users.where((user) => user.role == role).toList();
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
        throw Exception(L10nService.strings.cannotChangeOwnRole);
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

  Future<AppUser> createStaffAccount({
    required String fullName,
    required String email,
    required String password,
    required String role,
    required String university,
  }) {
    return AppOperation.run('users.create_staff', () async {
      final nameError = AppValidators.registerName(fullName);
      final emailError = AppValidators.loginEmail(email);
      final passwordError = AppValidators.loginPassword(password);
      final roleError = role == AppRoles.judge || role == AppRoles.mentor
          ? null
          : L10nService.strings.validationInvalidRole;
      if (nameError != null) throw Exception(nameError);
      if (emailError != null) throw Exception(emailError);
      if (passwordError != null) throw Exception(passwordError);
      if (roleError != null) throw Exception(roleError);

      final response = await SupabaseGateway.client.functions.invoke(
        'admin-create-user',
        body: {
          'full_name': fullName.trim(),
          'email': email.trim().toLowerCase(),
          'password': password,
          'role': role,
          'university': university.trim(),
        },
      );
      final data = response.data;
      if (data is Map && data['user'] is Map) {
        return AppUser.fromJson(Map<String, dynamic>.from(data['user'] as Map));
      }
      throw Exception(L10nService.strings.createStaffAccountFailed);
    });
  }
}
