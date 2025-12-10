part of 'auth_bloc.dart';

@immutable
sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String userId;
  final String username;

  const AuthSuccess({
    required this.userId,
    required this.username,
  });
}


final class AuthFailure extends AuthState {
  final String message;
  const AuthFailure(this.message);
}
