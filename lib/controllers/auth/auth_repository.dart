import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRepository {
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String displayName,
  });

  Future<AuthResponse> signIn({required String email, required String password});

  Future<void> signOut();
}
