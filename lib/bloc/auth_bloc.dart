import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:newsbyte/constants.dart';
import 'package:newsbyte/main.dart';
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
        print("Authenticated");
        emit(AuthSuccess(email: event.email));
      } catch (e) {
        emit(AuthFailure(message: e.toString()));
      }
    }));
    on<AuthLogoutRequested>(_logout);
  }

  void _signIn(AuthLoginRequested event, Emitter<AuthState> emit) async {
    try {
      if (event.loginType == email) {
        await supabase.auth.signInWithOtp(
          email: event.email,
          emailRedirectTo:
              kIsWeb ? null : 'io.supabase.newsbyte://login-callback/',
        );
        _createUser(event.email, event.loginType);
        emit(AuthEmailSent());
      } else if (event.loginType == google) {
        final GoogleSignIn googleSignIn = GoogleSignIn(
          clientId: iosClientId,
          serverClientId: webClientId,
        );
        final googleUser = await googleSignIn.signIn();
        final googleAuth = await googleUser!.authentication;
        final googleEmail = googleUser.email;
        final accessToken = googleAuth.accessToken;
        final idToken = googleAuth.idToken;

        if (accessToken == null) {
          throw 'No Access Token found.';
        }
        if (idToken == null) {
          throw 'No ID Token found.';
        }
        await supabase.auth.signInWithIdToken(
          provider: OAuthProvider.google,
          idToken: idToken,
          accessToken: accessToken,
        );
        _createUser(googleEmail, event.loginType);
      } else {
        await supabase.auth.signInWithOtp(
          email: event.email,
          emailRedirectTo:
              kIsWeb ? null : 'io.supabase.newsbyte://login-callback/',
        );
      }
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
        'loginType': [loginType.toString()],
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
