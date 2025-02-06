import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../models/bookmarked.dart'; // Should define BookmarkedArticle and globalBookmarks.

class NewsDetailScreen extends StatefulWidget {
  final String image, title, date, description, content, source;
  const NewsDetailScreen({
    super.key,
    required this.image,
    required this.title,
    required this.date,
    required this.description,
    required this.content,
    required this.source,
  });

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  final DateFormat format = DateFormat('MMMM dd, yyyy');
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    // Check if the article is already bookmarked (using title as identifier).
    isBookmarked = globalBookmarks.any((b) => b.title == widget.title);
  }

  void toggleBookmark() {
    final newBookmark = BookmarkedArticle(
      title: widget.title,
      source: widget.source,
      image: widget.image,
      date: widget.date,
      description: widget.description,
      content: widget.content,
    );

    setState(() {
      if (isBookmarked) {
        // Remove bookmark.
        globalBookmarks.removeWhere((b) => b.title == widget.title);
        isBookmarked = false;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Bookmark removed")),
        );
      } else {
        // Add bookmark.
        globalBookmarks.add(newBookmark);
        isBookmarked = true;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Article bookmarked")),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime datetime = DateTime.parse(widget.date);
    return SafeArea(
      child: Scaffold(
        // Bottom navigation bar for share and bookmark.
        bottomNavigationBar: Container(
          color: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: 54,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white, size: 30),
                onPressed: () {
                  Share.share("${widget.title}\n\nBy, Shubham Gurav.");
                },
              ),
              SizedBox(
                width: 8,
              ),
              IconButton(
                icon: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: toggleBookmark,
              ),
            ],
          ),
        ),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              backgroundColor: Colors.transparent,
              // Removed share and bookmark from app bar actions.
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  widget.source,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background: CachedNetworkImage(
                  imageUrl: widget.image,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Divider(),
                    Row(
                      children: [
                        Text(
                          widget.source,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          format.format(datetime),
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.description,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.content,
                      style: GoogleFonts.poppins(
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
