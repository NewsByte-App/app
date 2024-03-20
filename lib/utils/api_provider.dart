import 'package:dio/dio.dart';
import 'package:newsbyte/constants.dart';
import 'package:newsbyte/models/article_model.dart';
import 'package:newsbyte/models/news_model.dart';
import 'package:newsbyte/models/user_behavior.dart';

class ApiProvider {
  final Dio _dio = Dio();
  late String backendUrl = 'http://localhost:8000';

  // In ApiProvider
  Future<List<NewsModel>?> fetchNews(String? category, int page) async {
    try {
      String url = '$backendUrl/get_news?page=$page';
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

  void updateBehavior(UserBehaviorModel userBehavior) async {
    try {
      String url = '$backendUrl/update_behavior';
      Map<String, dynamic> data = userBehavior.toMap();
      await _dio.post(url, data: data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return null;
    }
  }

  Future<List<NewsModel>?> recommended_news(String email) async {
    try {
      String url = '$backendUrl/recommend_news/$email';
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
