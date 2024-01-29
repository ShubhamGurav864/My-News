import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:my_news_application/models/categories_news_model.dart';
import 'package:my_news_application/models/news_headlines_model.dart';



class NewsRepository {
  Future<NewsHeadlinesModel> fetchNewsHeadlinesApi() async {
    String url =
        'https://newsapi.org/v2/top-headlines?country=in&apiKey=e71b5f2a215b4cbfa52e5b30d1fb5d32';
    final response = await http.get(Uri.parse(url));
    if (kDebugMode) {
      print(response.body);
    }
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return NewsHeadlinesModel.fromJson(body);
    }
    throw Exception('Error');
  }

  Future<CategoriesNewsModel> fetchCategoriesNewsApi(String category) async {
    String url =
        'https://newsapi.org/v2/everything?q=${category}&apiKey=e71b5f2a215b4cbfa52e5b30d1fb5d32';
    final response = await http.get(Uri.parse(url));
    if (kDebugMode) {
      print(response.body);
    }
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return CategoriesNewsModel.fromJson(body);
    }
    throw Exception('Error');
  }


}
