import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_news_application/view/login_screen.dart';
import 'bookmark_screen.dart'; // Import the bookmark screen

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user;
  StreamSubscription<User?>? _authSubscription;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser; // Initial fetch

    // Listen for auth state changes
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen(
      (User? updatedUser) {
        if (mounted) {
          // Only update UI if widget is still mounted
          setState(() {
            user = updatedUser;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _authSubscription?.cancel(); // Cancel the listener to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String displayName = user?.displayName ?? "John Doe";
    final String email = user?.email ?? "johndoe@example.com";

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 54),
              // Profile details.
              Text(
                displayName,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                email,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              const Divider(thickness: 1),
              // Profile options (Bookmarks and Log Out).
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BookmarkScreen()),
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
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
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
