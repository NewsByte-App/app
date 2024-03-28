import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:newsbyte/utils/shared_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:newsbyte/constants.dart';
import 'package:newsbyte/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthLoginRequested>(_signIn);
    on<AuthUserAuthenicated>(((event, emit) async {
      try {
        emit(AuthLoading());
        PreferenceUtils.setString('user', event.email);
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
        final rawNonce = supabase.auth.generateRawNonce();

        final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

        final credential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          nonce: hashedNonce,
        );
        final idToken = credential.identityToken;
        if (idToken == null) {
          throw const AuthException(
              'Could not find ID Token from generated credential.');
        }
        final AuthResponse res = await supabase.auth.signInWithIdToken(
          provider: OAuthProvider.apple,
          idToken: idToken,
          nonce: rawNonce,
        );
        _createUser(res.user!.email.toString(), event.loginType);
      }
    } on AuthException catch (error) {
      emit(AuthFailure(message: "Something Went Wrong!"));
    } catch (error) {
      emit(AuthFailure(message: "Something Went Wrong!"));
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
