import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../repository/firestore_services.dart';

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
  final FirestoreService _firestoreService = FirestoreService();
  bool isBookmarked = false;
  String userId =
      FirebaseAuth.instance.currentUser!.uid; // Get logged-in user ID

  @override
  void initState() {
    super.initState();
    _checkIfBookmarked();
  }

  Future<void> _checkIfBookmarked() async {
    List<Map<String, dynamic>> bookmarks =
        await _firestoreService.getUserBookmarks(userId);
    setState(() {
      isBookmarked =
          bookmarks.any((article) => article["title"] == widget.title);
    });
  }

  void _toggleBookmark() async {
    Map<String, dynamic> article = {
      "title": widget.title,
      "source": widget.source,
      "image": widget.image,
      "date": widget.date,
      "description": widget.description,
      "content": widget.content,
    };

    if (isBookmarked) {
      await _firestoreService.removeBookmark(userId, article);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Bookmark removed")));
    } else {
      await _firestoreService.addBookmark(userId, article);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Article bookmarked")));
    }

    setState(() {
      isBookmarked = !isBookmarked;
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime datetime = DateTime.parse(widget.date);
    return SafeArea(
      child: Scaffold(
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
                  Share.share("${widget.title}\n\nBy, My News App.");
                },
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: _toggleBookmark,
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
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  widget.source,
                  style: GoogleFonts.poppins(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                background: CachedNetworkImage(
                  imageUrl: widget.image,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error_outline, color: Colors.red),
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
                      topRight: Radius.circular(25)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.title,
                        style: GoogleFonts.poppins(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    const Divider(),
                    Row(
                      children: [
                        Text(widget.source,
                            style: GoogleFonts.poppins(
                                fontSize: 12, color: Colors.grey[700])),
                        const Spacer(),
                        Text(format.format(datetime),
                            style: GoogleFonts.poppins(
                                fontSize: 10, color: Colors.grey[600])),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(widget.description,
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 20),
                    Text(widget.content,
                        style: GoogleFonts.poppins(color: Colors.black54)),
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
