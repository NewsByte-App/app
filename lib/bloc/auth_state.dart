part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthSuccess extends AuthState {
  final String email;

  AuthSuccess({required this.email});
}

final class AuthFailure extends AuthState {
  final String message;

  AuthFailure({required this.message});
}

final class AuthEmailSent extends AuthState {}

final class AuthSocialRequested extends AuthState {}

final class AuthLoading extends AuthState {}
