import 'package:newsbyte/models/news_model.dart';
import 'package:newsbyte/utils/api_provider.dart';

class ApiRepository {
  final _provider = ApiProvider();

  Future<List<NewsModel>?> fetchNewsList({String? category, int page = 1}) {
    return _provider.fetchNews(category, page);
  }
}

class NetworkError extends Error {}
