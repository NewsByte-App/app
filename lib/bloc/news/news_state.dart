part of 'news_bloc.dart';

sealed class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object> get props => [];
}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<NewsModel> news;
  const NewsLoaded(this.news);

  @override
  List<Object> get props => [news];
}

class NewsError extends NewsState {
  final String? message;
  const NewsError(this.message);
}
