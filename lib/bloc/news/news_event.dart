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
