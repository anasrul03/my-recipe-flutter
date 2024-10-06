import 'dart:async';

import 'package:my_recipe_flutter/controllers/auth/auth_repository.dart';
import 'package:my_recipe_flutter/controllers/local_storage/local_storage_controller.dart';
import 'package:my_recipe_flutter/models/user_data_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController implements AuthRepository {
  final client = Supabase.instance.client;
  final LocalStorageController localStorageController =
      LocalStorageController();

  late final StreamSubscription authSubscription;

  void startAuthStateListener() {
    authSubscription =
        Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      print('event: $event, session: $session');

      switch (event) {
        case AuthChangeEvent.initialSession:
          print("Initial session detected");
          break;
        case AuthChangeEvent.signedIn:
          print("User signed in: $session");
          break;
        case AuthChangeEvent.signedOut:
          print("User signed out");
          break;
        case AuthChangeEvent.passwordRecovery:
          print("Password recovery in progress");
          break;
        case AuthChangeEvent.tokenRefreshed:
          print("Token refreshed: $session");
          break;
        case AuthChangeEvent.userUpdated:
          print("User updated: $session");
          break;
        case AuthChangeEvent.userDeleted:
          print("User deleted");
          break;
        case AuthChangeEvent.mfaChallengeVerified:
          print("MFA challenge verified");
          break;
      }
    });
  }

  void dispose() {
    authSubscription.cancel();
  }

  @override
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async =>
      client.auth.signInWithPassword(email: email, password: password);

  @override
  Future<void> signOut() async => client.auth.signOut();

  @override
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final AuthResponse response = await client.auth.signUp(
      email: email,
      password: password,
      data: UserDataModel(displayName: displayName).toJson(),
    );

    return response;
  }
}
