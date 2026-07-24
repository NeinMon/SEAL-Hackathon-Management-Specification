import '../core/l10n/l10n_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/app_helpers.dart';
import '../core/supabase_config.dart';
import '../models/app_user.dart';

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
        emailRedirectTo: SupabaseConfig.signupRedirectUrl,
        data: {'full_name': fullName, 'university': university},
      );
      final authUser = response.user;
      if (authUser == null) {
        throw const AuthException('Unable to create an account.');
      }
      if (response.session != null) {
        await SupabaseGateway.client.auth.signOut();
      }
      if (response.session == null) {
        final identities = authUser.identities;
        if (identities == null || identities.isEmpty) {
          throw AuthException(L10nService.strings.errorDuplicateRecord);
        }
        return RegisterResult(requiresEmailVerification: true, email: email);
      }
      return RegisterResult(requiresEmailVerification: true, email: email);
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
        throw AuthException(L10nService.strings.errorInvalidOtp);
      }
      return _profileForAuthUser(authUser);
    });
  }

  Future<void> requestPasswordReset(String email) {
    return AppOperation.run('auth.reset_password', () async {
      await SupabaseGateway.client.auth.resetPasswordForEmail(
        email.trim(),
        redirectTo: SupabaseConfig.passwordRecoveryRedirectUrl,
      );
    });
  }

  Future<AppUser> updatePassword(String password) {
    return AppOperation.run('auth.update_password', () async {
      final response = await SupabaseGateway.client.auth.updateUser(
        UserAttributes(password: password),
      );
      final authUser = response.user;
      if (authUser == null) {
        throw const AuthException('Unable to update password.');
      }
      return _profileForAuthUser(authUser);
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
}
