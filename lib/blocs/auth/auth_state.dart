import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthenticationState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class AuthInitialState extends AuthenticationState {}

final class AuthSignedIn extends AuthenticationState {
  AuthSignedIn({required this.user});

  final User user;

  @override
  List<Object?> get props => [user];
}

final class AuthSignedOut extends AuthenticationState {}

final class AuthLoadingState extends AuthenticationState {}

final class AuthErrorState extends AuthenticationState {
  AuthErrorState({required this.error});

  final AuthException error;

  @override
  List<Object?> get props => [error];
}
