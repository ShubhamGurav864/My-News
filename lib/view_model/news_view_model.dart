import 'package:my_news_application/models/categories_news_model.dart';
import 'package:my_news_application/models/news_headlines_model.dart';
import 'package:my_news_application/repository/news_repository.dart';



class NewsViewModel {
  final _rep = NewsRepository();
  Future<NewsHeadlinesModel> fetchNewsHeadlinesApi() async {
    final response = await _rep.fetchNewsHeadlinesApi();
    return response;
  }
  


   Future<CategoriesNewsModel> fetchCategoriesNewsApi(String category) async {
    final response = await _rep.fetchCategoriesNewsApi(category);
    return response;
  }
}
