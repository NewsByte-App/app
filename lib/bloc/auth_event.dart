part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String loginType;

  AuthLoginRequested({required this.loginType, required this.email});
}

class AuthLogoutRequested extends AuthEvent {}

class AuthUserAuthenicated extends AuthEvent {
  final String email;

  AuthUserAuthenicated({required this.email});
}
