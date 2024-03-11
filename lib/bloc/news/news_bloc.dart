import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:newsbyte/bloc/news/api_repository.dart';
import 'package:newsbyte/models/news_model.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsBloc() : super(NewsInitial()) {
    final ApiRepository apiRepository = ApiRepository();
    int _currentPage = 1;
    bool _hasReachedMax = false;
    on<GetNewsList>((event, emit) async {
      try {
        _currentPage = 1;
        _hasReachedMax = false;
        emit(NewsLoading());
        final newsList = await apiRepository.fetchNewsList(page: _currentPage);
        if (newsList == null || newsList.isEmpty) {
          _hasReachedMax = true;
          emit(const NewsError("No news found."));
        } else {
          emit(NewsLoaded(newsList));
        }
      } on NetworkError {
        emit(const NewsError("Failed to fetch data. is your device online?"));
      }
    });
    on<FetchMoreNews>((event, emit) async {
      if (!_hasReachedMax && state is NewsLoaded) {
        _currentPage++;
        try {
          final newsList =
              await apiRepository.fetchNewsList(page: _currentPage);
          if (newsList == null || newsList.isEmpty) {
            _hasReachedMax = true;
          } else {
            final currentState = state as NewsLoaded;
            emit(NewsLoaded(currentState.news + newsList));
          }
        } catch (error) {
          emit(const NewsError("Failed to fetch more news."));
        }
      }
    });
    on<GetNewsByCategory>((event, emit) async {
      try {
        emit(NewsLoading());
        final newsList =
            await apiRepository.fetchNewsList(category: event.category);
        emit(NewsLoaded(newsList!));
      } on NetworkError {
        emit(const NewsError("Failed to fetch data. is your device online?"));
      }
    });
    on<FetchMoreNewsByCategory>((event, emit) async {
      if (!_hasReachedMax && state is NewsLoaded) {
        _currentPage++;
        try {
          print("HERE");
          final newsList = await apiRepository.fetchNewsList(
              page: _currentPage, category: event.category);
          print(newsList);
          if (newsList == null || newsList.isEmpty) {
            _hasReachedMax = true;
          } else {
            print("HERE2");
            final currentState = state as NewsLoaded;
            print((currentState.news + newsList).length);
            emit(NewsLoaded(currentState.news + newsList));
          }
        } catch (error) {
          emit(const NewsError("Failed to fetch more news."));
        }
      }
    });
  }
}
