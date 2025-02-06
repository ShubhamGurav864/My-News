class NewsHeadlinesModel {
  String? status;
  int? totalResults;
  List<NewsArticle>? articles;

  NewsHeadlinesModel({this.status, this.totalResults, this.articles});

  factory NewsHeadlinesModel.fromJson(Map<String, dynamic> json) {
    return NewsHeadlinesModel(
      status: json['status'],
      totalResults: json['totalResults'],
      articles: json['articles'] != null
          ? List<NewsArticle>.from(
              json['articles'].map((article) => NewsArticle.fromJson(article)))
          : [],
    );
  }
}

class NewsArticle {
  Source? source;
  String? author;
  String? title;
  String? description;
  String? url;
  String? urlToImage;
  String? publishedAt;
  String? content;

  NewsArticle({
    this.source,
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      source: json['source'] != null ? Source.fromJson(json['source']) : null,
      author: json['author'],
      title: json['title'],
      description: json['description'],
      url: json['url'],
      urlToImage: json['urlToImage'],
      publishedAt: json['publishedAt'],
      content: json['content'],
    );
  }
}

class Source {
  String? id;
  String? name;

  Source({this.id, this.name});

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
