part of 'news_bloc.dart';

sealed class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object> get props => [];
}

class GetNewsList extends NewsEvent {}

class GetNewsByCategory extends NewsEvent {
  final String category;

  const GetNewsByCategory(this.category);
}

class FetchMoreNewsByCategory extends NewsEvent {
  final String category;

  const FetchMoreNewsByCategory(this.category);
}

class FetchMoreNews extends NewsEvent {}

class FetchRecommendedNews extends NewsEvent {
  final String email;

  const FetchRecommendedNews(this.email);
}

class ResetCurrentPage extends NewsEvent {}

class UpdateUserBehavior extends NewsEvent {
  final String email;
  final String category;
  final String duration;
  final String news_id;

  const UpdateUserBehavior(
      this.email, this.category, this.duration, this.news_id);
}
