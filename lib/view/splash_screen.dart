import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_news_application/view/bottomnavbar.dart';
import 'package:my_news_application/view/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Start the timer and then check connectivity.
    Timer(const Duration(seconds: 3), _checkConnectivity);
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      _showNoConnectionDialog();
    } else {
      _navigateUser();
    }
  }

  void _showNoConnectionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissal by tapping outside.
      builder: (context) => AlertDialog(
        title: const Text("No Internet Connection"),
        content:
            const Text("Please check your network settings and try again."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _checkConnectivity(); // Retry checking connectivity.
            },
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }

  void _navigateUser() {
    // Check if the user is logged in.
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BottomNavBar()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: height * 0.03),
            Image.asset(
              'images/splash_pic.jpg',
              fit: BoxFit.cover,
              height: height * 0.5,
            ),
            SizedBox(height: height * 0.04),
            Text(
              'TOP HEADLINES',
              style: GoogleFonts.anton(
                  letterSpacing: 1, color: Colors.grey.shade700, fontSize: 20),
            ),
            SizedBox(height: height * 0.07),
            const SpinKitChasingDots(
              color: Colors.black,
              size: 40,
            ),
          ],
        ),
      ),
    );
  }
}
