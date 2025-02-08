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
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    // Initialize connectivity monitoring
    _initConnectivity();
    // Start the splash screen timer
    Timer(const Duration(seconds: 3), () {
      if (!_hasNavigated) {
        _checkConnectivity();
      }
    });
  }

  Future<void> _initConnectivity() async {
    // Listen to connectivity changes
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      // Check if any of the connectivity results indicate a connection
      bool hasConnection =
          results.any((result) => result != ConnectivityResult.none);

      if (!hasConnection) {
        _showNoConnectionDialog();
      } else {
        // If we're showing a no connection dialog, dismiss it
        Navigator.of(context).popUntil((route) => route.isFirst);
        if (!_hasNavigated) {
          _navigateUser();
        }
      }
    });

    // Check current connectivity status
    await _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    try {
      final results = await Connectivity().checkConnectivity();
      bool hasConnection = results != ConnectivityResult.none;

      if (!hasConnection) {
        _showNoConnectionDialog();
      } else if (!_hasNavigated) {
        _navigateUser();
      }
    } catch (e) {
      debugPrint('Error checking connectivity: $e');
    }
  }

  void _showNoConnectionDialog() {
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false, // Prevent back button dismissal
        child: AlertDialog(
          title: const Text("No Internet Connection"),
          content:
              const Text("Please check your network settings and try again."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _checkConnectivity();
              },
              child: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateUser() {
    if (!mounted || _hasNavigated) return;

    setState(() {
      _hasNavigated = true;
    });

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
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
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
