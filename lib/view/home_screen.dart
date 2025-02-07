import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:my_news_application/models/news_headlines_model.dart';
import 'package:my_news_application/models/categories_news_model.dart';
import 'package:my_news_application/view/news_detail_screen.dart';
import 'package:my_news_application/view_model/news_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NewsViewModel newsViewModel = NewsViewModel();
  final ScrollController _controller = ScrollController();
  final DateFormat format = DateFormat('MMMM dd, yyyy');

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: SizedBox(),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          elevation: 0,
          title: Text(
            'Latest News',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        body: ListView(
          controller: _controller,
          physics: const BouncingScrollPhysics(),
          children: [
            _buildHeadlinesSection(height, width),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text("More News",
                  style: GoogleFonts.poppins(
                      fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 10),
            _buildGeneralNewsSection(),
          ],
        ),
      ),
    );
  }

  /// Builds the Top Headlines Section (Horizontal Scroll)
  Widget _buildHeadlinesSection(double height, double width) {
    return SizedBox(
      height: height * 0.45,
      child: FutureBuilder<NewsHeadlinesModel>(
        future: newsViewModel.fetchNewsHeadlinesApi(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SpinKitPulsingGrid(size: 50, color: Colors.black),
            );
          } else if (!snapshot.hasData ||
              snapshot.data!.articles == null ||
              snapshot.data!.articles!.isEmpty) {
            return Center(
              child: Text("No headlines available",
                  style:
                      GoogleFonts.poppins(fontSize: 16, color: Colors.black54)),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.articles!.length,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemBuilder: (context, index) {
              final article = snapshot.data!.articles![index];
              final DateTime dateTime =
                  DateTime.parse(article.publishedAt.toString());

              return _buildHeadlineCard(article, width, height, dateTime);
            },
          );
        },
      ),
    );
  }

  /// Builds each individual Headline Card for the horizontal section.
  Widget _buildHeadlineCard(
      NewsArticle article, double width, double height, DateTime dateTime) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetailScreen(
              image: article.urlToImage.toString(),
              title: article.title.toString(),
              date: article.publishedAt.toString(),
              description: article.description.toString(),
              content: article.content.toString(),
              source: article.source?.name.toString() ?? 'Unknown',
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                imageUrl:
                    article.urlToImage ?? 'https://via.placeholder.com/150',
                width: width * 0.8,
                height: height * 0.45,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const Center(child: SpinKitCircle(color: Colors.black)),
                errorWidget: (context, url, error) => const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                ),
              ),
            ),
            Container(
              width: width * 0.8,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.65),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title.toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        article.source?.name.toString() ?? 'Unknown',
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: Colors.white70),
                      ),
                      Text(
                        format.format(dateTime),
                        style: GoogleFonts.poppins(
                            fontSize: 8, color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the General News Section showing both a grid and then a vertical list.
  Widget _buildGeneralNewsSection() {
    return FutureBuilder<CategoriesNewsModel>(
      future: newsViewModel.fetchCategoriesNewsApi("general"),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: SpinKitFadingCircle(color: Colors.black, size: 40));
        } else if (!snapshot.hasData ||
            snapshot.data!.articles == null ||
            snapshot.data!.articles!.isEmpty) {
          return Center(
              child: Text("No news available",
                  style: GoogleFonts.poppins(
                      fontSize: 16, color: Colors.black54)));
        }
        List<Articles> articles = snapshot.data!.articles!;
        articles.shuffle(); // Randomize the order
        // Split the articles into two halves
        int half = (articles.length / 2).floor();
        List<Articles> gridArticles = articles.sublist(0, half);
        List<Articles> verticalArticles = articles.sublist(half);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Grid Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text("Highlights",
                  style: GoogleFonts.poppins(
                      fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.7,
              ),
              itemCount: gridArticles.length,
              itemBuilder: (context, index) {
                final article = gridArticles[index];
                final DateTime dateTime =
                    DateTime.parse(article.publishedAt.toString());
                return _buildGeneralNewsGridCard(article, dateTime);
              },
            ),
            const SizedBox(height: 20),
            // Vertical List Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text("All News",
                  style: GoogleFonts.poppins(
                      fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: verticalArticles.length,
              itemBuilder: (context, index) {
                final article = verticalArticles[index];
                final DateTime dateTime =
                    DateTime.parse(article.publishedAt.toString());
                return _buildGeneralNewsVerticalCard(article, dateTime);
              },
            )
          ],
        );
      },
    );
  }

  /// Builds each individual General News Grid Card for the grid section.
  Widget _buildGeneralNewsGridCard(Articles article, DateTime dateTime) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetailScreen(
              image: article.urlToImage.toString(),
              title: article.title.toString(),
              date: article.publishedAt.toString(),
              description: article.description.toString(),
              content: article.content.toString(),
              source: article.source?.name.toString() ?? 'Unknown',
            ),
          ),
        );
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image at the top
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              child: CachedNetworkImage(
                imageUrl:
                    article.urlToImage ?? 'https://via.placeholder.com/150',
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const SpinKitCircle(color: Colors.black, size: 30),
                errorWidget: (context, url, error) => const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    article.source?.name ?? 'Unknown',
                    style:
                        GoogleFonts.poppins(fontSize: 10, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    format.format(dateTime),
                    style:
                        GoogleFonts.poppins(fontSize: 10, color: Colors.grey),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  /// Builds each individual General News Vertical Card for the vertical list section.
  Widget _buildGeneralNewsVerticalCard(Articles article, DateTime dateTime) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetailScreen(
              image: article.urlToImage.toString(),
              title: article.title.toString(),
              date: article.publishedAt.toString(),
              description: article.description.toString(),
              content: article.content.toString(),
              source: article.source?.name.toString() ?? 'Unknown',
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl:
                    article.urlToImage ?? 'https://via.placeholder.com/150',
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const SpinKitCircle(color: Colors.black, size: 30),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.error_outline, color: Colors.red),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title ?? '',
                      style: GoogleFonts.poppins(
                          fontSize: 16, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      article.description ?? '',
                      style: GoogleFonts.poppins(
                          fontSize: 9, color: Colors.black87),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 70,
                          child: Text(
                            article.source?.name ?? 'Unknown',
                            style: GoogleFonts.poppins(
                                fontSize: 10, color: Colors.grey),
                          ),
                        ),
                        Text(
                          format.format(dateTime),
                          style: GoogleFonts.poppins(
                              fontSize: 8, color: Colors.grey),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
