// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserBehaviorModel {
  final String userEmail;
  final String category;
  final String duration;
  final String news_id;
  UserBehaviorModel({
    required this.userEmail,
    required this.category,
    required this.duration,
    required this.news_id,
  });

  UserBehaviorModel copyWith({
    String? userEmail,
    String? category,
    String? duration,
    String? news_id,
  }) {
    return UserBehaviorModel(
      userEmail: userEmail ?? this.userEmail,
      category: category ?? this.category,
      duration: duration ?? this.duration,
      news_id: news_id ?? this.news_id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userEmail': userEmail,
      'category': category,
      'duration': duration,
      'news_id': news_id,
    };
  }

  factory UserBehaviorModel.fromMap(Map<String, dynamic> map) {
    return UserBehaviorModel(
      userEmail: map['userEmail'] as String,
      category: map['category'] as String,
      duration: map['duration'] as String,
      news_id: map['news_id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserBehaviorModel.fromJson(String source) =>
      UserBehaviorModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserBehaviorModel(userEmail: $userEmail, category: $category, duration: $duration, news_id: $news_id)';
  }

  @override
  bool operator ==(covariant UserBehaviorModel other) {
    if (identical(this, other)) return true;

    return other.userEmail == userEmail &&
        other.category == category &&
        other.duration == duration &&
        other.news_id == news_id;
  }

  @override
  int get hashCode {
    return userEmail.hashCode ^
        category.hashCode ^
        duration.hashCode ^
        news_id.hashCode;
  }
}
