class BookmarkedArticle {
  final String title;
  final String source;
  final String image;
  final String date;
  final String description;
  final String content;

  BookmarkedArticle({
    required this.title,
    required this.source,
    required this.image,
    required this.date,
    required this.description,
    required this.content,
  });
}

// Global variable to hold bookmarks (for demonstration purposes).
List<BookmarkedArticle> globalBookmarks = [];
