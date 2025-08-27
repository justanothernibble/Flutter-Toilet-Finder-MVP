import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/utils/logger.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  late final SupabaseClient _client;

  SupabaseClient get client => _client;
  GoTrueClient get auth => _client.auth;
  User? get currentUser => _client.auth.currentUser;
  bool get isAuthenticated => _client.auth.currentUser != null;

  Future<void> initialize({String? url, String? anonKey}) async {
    try {
      final rawUrl = (url ?? const String.fromEnvironment('SUPABASE_URL', defaultValue: '')).trim();
      final rawKey = (anonKey ?? const String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '')).trim();

      if (rawUrl.isEmpty || rawKey.isEmpty) {
        throw Exception('Missing SUPABASE_URL or SUPABASE_ANON_KEY in .env');
      }

      final parsed = Uri.tryParse(rawUrl);
      if (parsed == null || !parsed.hasScheme || parsed.scheme != 'https') {
        throw Exception('SUPABASE_URL must be a valid https URL, got: $rawUrl');
      }
      if ((parsed.host.isEmpty) || !parsed.host.endsWith('supabase.co')) {
        throw Exception('SUPABASE_URL host must end with supabase.co, got: ${parsed.host}');
      }

      await Supabase.initialize(
        url: rawUrl,
        anonKey: rawKey,
      );
      _client = Supabase.instance.client;
      Logger.i('Supabase initialized successfully');
    } catch (e, stackTrace) {
      Logger.e(
        'Failed to initialize Supabase',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  // Email/Password Authentication
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );
      Logger.i('User signed up with email: $email');
      return response;
    } catch (e, stackTrace) {
      Logger.e('Sign up failed', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      Logger.i('User signed in with email: $email');
      return response;
    } catch (e, stackTrace) {
      Logger.e('Sign in failed', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  // Password Reset
  Future<void> resetPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
      Logger.i('Password reset email sent to $email');
    } catch (e, stackTrace) {
      Logger.e('Password reset failed', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
      Logger.i('User signed out');
    } catch (e, stackTrace) {
      Logger.e('Sign out failed', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  // Database Operations
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final userId = currentUser?.id;
      if (userId == null) throw Exception('No user is signed in');

      final response = await _client
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();

      return response as Map<String, dynamic>;
    } catch (e, stackTrace) {
      Logger.e(
        'Failed to fetch user profile',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<void> updateUserProfile(Map<String, dynamic> updates) async {
    try {
      final userId = currentUser?.id;
      if (userId == null) throw Exception('No user is signed in');

      await _client.from('profiles').update(updates).eq('id', userId);

      Logger.i('User profile updated');
    } catch (e, stackTrace) {
      Logger.e(
        'Failed to update user profile',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
