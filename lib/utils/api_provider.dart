import 'package:dio/dio.dart';
import 'package:newsbyte/constants.dart';
import 'package:newsbyte/models/article_model.dart';
import 'package:newsbyte/models/news_model.dart';

class ApiProvider {
  final Dio _dio = Dio();
  late String _url = 'http://127.0.0.1:8000/get_news';

  // In ApiProvider
  Future<List<NewsModel>?> fetchNews(String? category, int page) async {
    try {
      String url = 'http://127.0.0.1:8000/get_news?page=$page';
      if (category != null) {
        url += '&category=$category';
      }
      Response response = await _dio.get(url);
      List<NewsModel> newsList = (response.data as List<dynamic>)
          .map(
              (dynamic item) => NewsModel.fromMap(item as Map<String, dynamic>))
          .toList();
      return newsList;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return null;
    }
  }
}
