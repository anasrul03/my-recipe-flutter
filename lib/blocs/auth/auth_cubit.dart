import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_recipe_flutter/blocs/auth/auth_state.dart';
import 'package:my_recipe_flutter/controllers/auth/auth_controller.dart';
import 'package:my_recipe_flutter/controllers/local_storage/local_storage_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthCubit extends Cubit<AuthenticationState> {
  AuthCubit() : super(AuthInitialState()) {
    _startAuthSubscription();
  }

  final AuthController authController = AuthController();
  final LocalStorageController localStorageController =
      LocalStorageController();

  void _startAuthSubscription() {
    authController.authSubscription =
        Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      switch (event) {
        case AuthChangeEvent.initialSession:
          if (session != null) {
            emit(AuthSignedIn(user: session.user));
            break;
          }
          emit(AuthInitialState());
        case AuthChangeEvent.signedIn:
          if (session?.user != null) {
            emit(AuthSignedIn(user: session!.user));
          } else {
            emit(AuthErrorState(
                error: const AuthException(
                    'User signed in, but no session found')));
          }
          break;
        case AuthChangeEvent.signedOut:
          localStorageController.clearOnLogout();
          emit(AuthSignedOut());
          break;
        default:
          emit(AuthErrorState(
              error: AuthException('Unhandled auth event: $event')));
      }
    });
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    emit(AuthLoadingState());
    try {
      final response =
          await authController.signIn(email: email, password: password);
      final User? user = response.user;
      if (user != null) {
        localStorageController.saveUser(user);
        emit(AuthSignedIn(user: user));
      }
    } on AuthException catch (error) {
      emit(AuthErrorState(error: error));
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    emit(AuthLoadingState());
    try {
      final response = await authController.signUp(
        email: email,
        password: password,
        displayName: displayName,
      );
      final User? user = response.user;
      if (user != null) {
        emit(AuthSignedIn(user: user));
      } else {
        emit(AuthErrorState(
            error: const AuthException("Error no user returned")));
      }
    } on AuthException catch (error) {
      emit(AuthErrorState(error: error));
    }
  }

  Future<void> signOut() async {
    emit(AuthLoadingState());
    try {
      await authController.signOut();
      emit(AuthSignedOut());
    } on AuthException catch (error) {
      emit(AuthErrorState(error: error));
    }
  }

  @override
  Future<void> close() {
    authController.dispose();
    return super.close();
  }
}
