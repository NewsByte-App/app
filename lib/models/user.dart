// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:newsbyte/constants.dart';

class UserModel {
  final String email;
  final String loginType;
  final Map<dynamic, dynamic> user_preferences;
  UserModel({
    required this.email,
    required this.loginType,
    required this.user_preferences,
  });

  UserModel copyWith({
    String? email,
    String? loginType,
    Map<dynamic, dynamic>? user_preferences,
    DateTime? created_at,
  }) {
    return UserModel(
      email: email ?? this.email,
      loginType: loginType ?? this.loginType,
      user_preferences: user_preferences ?? this.user_preferences,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'loginType': loginType,
      'user_preferences': user_preferences,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] as String,
      loginType: map['loginType'] as String,
      user_preferences: map['user_preferences'] as Map<dynamic, dynamic>,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(email: $email, loginType: $loginType, user_preferences: $user_preferences)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.email == email &&
        other.loginType == loginType &&
        mapEquals(other.user_preferences, user_preferences);
  }

  @override
  int get hashCode {
    return email.hashCode ^ loginType.hashCode ^ user_preferences.hashCode;
  }
}
