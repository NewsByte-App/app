import 'package:newsbyte/bloc/news/news_bloc.dart';
import 'package:newsbyte/models/news_model.dart';
import 'package:newsbyte/models/user_behavior.dart';
import 'package:newsbyte/utils/api_provider.dart';

class ApiRepository {
  final _provider = ApiProvider();

  Future<List<NewsModel>?> fetchNewsList({String? category, int page = 1}) {
    return _provider.fetchNews(category, page);
  }

  void updateUserBehavior(UserBehaviorModel userBehavior) {
    return _provider.updateBehavior(userBehavior);
  }

  Future<List<NewsModel>?> recommended_news(String email) {
    return _provider.recommended_news(email);
  }
}

class NetworkError extends Error {}
