import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:my_news_application/models/categories_news_model.dart';
import 'package:my_news_application/models/news_headlines_model.dart';

class NewsRepository {
  // Use the NewsAPI key and endpoint
  final String apiKey = '823e3c7cf5144215bf42ab53cd2f45d9';
  final String baseUrl = 'https://newsapi.org/v2/';

  /// Fetch top headlines in the US
  Future<NewsHeadlinesModel> fetchNewsHeadlinesApi() async {
    // Using the "top-headlines" endpoint with country=us
    String url = '${baseUrl}top-headlines?country=us&apiKey=$apiKey';
    return await _fetchData<NewsHeadlinesModel>(
        url, NewsHeadlinesModel.fromJson);
  }

  /// Fetch news based on category (for US)
  Future<CategoriesNewsModel> fetchCategoriesNewsApi(String category) async {
    // Using the "top-headlines" endpoint with category filter
    String url =
        '${baseUrl}top-headlines?country=us&category=$category&apiKey=$apiKey';
    return await _fetchData<CategoriesNewsModel>(
        url, CategoriesNewsModel.fromJson);
  }

  /// Generic function to fetch data from the API
  Future<T> _fetchData<T>(
      String url, T Function(Map<String, dynamic>) fromJson) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (kDebugMode) print("API Response: ${response.body}");
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        return fromJson(body);
      } else {
        throw Exception("HTTP Error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to load data: $e");
    }
  }
}
