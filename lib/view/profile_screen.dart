import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'bookmark_screen.dart'; // Import the bookmark screen

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 54),
              // Profile details.
              Text(
                "John Doe",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "johndoe@example.com",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              const Divider(thickness: 1),
              // Profile options (Only Bookmarks and Log Out).
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.bookmark_border,
                          color: Colors.black54),
                      title: Text(
                        "My Bookmarks",
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios,
                          size: 16, color: Colors.black54),
                      onTap: () {
                        // Navigate to BookmarkScreen.
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BookmarkScreen()),
                        );
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.logout, color: Colors.black54),
                      title: Text(
                        "Log Out",
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios,
                          size: 16, color: Colors.black54),
                      onTap: () {
                        // Handle logout.
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
