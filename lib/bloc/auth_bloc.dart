import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:newsbyte/constants.dart';
import 'package:newsbyte/main.dart';
import 'package:newsbyte/models/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthLoginRequested>(_signIn);
    on<AuthUserAuthenicated>(((event, emit) async {
      try {
        emit(AuthLoading());
        _createUser(event.email, "email");
        emit(AuthSuccess());
      } catch (e) {
        emit(AuthFailure(message: e.toString()));
      }
    }));
    on<AuthLogoutRequested>(_logout);
  }

  void _signIn(AuthLoginRequested event, Emitter<AuthState> emit) async {
    try {
      if (event.loginType == LoginType.email.toString()) {
        await supabase.auth.signInWithOtp(
          email: event.email,
          emailRedirectTo:
              kIsWeb ? null : 'io.supabase.newsbyte://login-callback/',
        );
      } else if (event.loginType == LoginType.google.toString()) {
        await supabase.auth.signInWithOtp(
          email: event.email,
          emailRedirectTo:
              kIsWeb ? null : 'io.supabase.newsbyte://login-callback/',
        );
      } else {
        await supabase.auth.signInWithOtp(
          email: event.email,
          emailRedirectTo:
              kIsWeb ? null : 'io.supabase.newsbyte://login-callback/',
        );
      }
      emit(AuthEmailSent());
    } on AuthException catch (error) {
      emit(AuthFailure(message: error.toString()));
    } catch (error) {
      emit(AuthFailure(message: error.toString()));
    }
  }

  Future<void> _createUser(String email, String loginType) async {
    await http.post(
      Uri.parse('$backendUrl/create-user'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'email': email,
        'loginType': loginType.toString(),
        'user_preferences': {}
      }),
    );
  }

  Future<FutureOr<void>> _logout(
      AuthLogoutRequested event, Emitter<AuthState> emit) async {
    await supabase.auth.signOut();
    emit(AuthInitial());
  }
}
