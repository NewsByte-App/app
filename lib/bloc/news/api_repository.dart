import 'package:newsbites/bloc/news/news_bloc.dart';
import 'package:newsbites/models/news_model.dart';
import 'package:newsbites/models/user_behavior.dart';
import 'package:newsbites/utils/api_provider.dart';

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
