import 'package:flutter/material.dart';
import 'package:my_news_application/view/profile_screen.dart';
import 'home_screen.dart';
import 'categories_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  // List of screens to display
  final List<Widget> _screens = const [
    HomeScreen(),
    CategoriesScreen(),
    ProfileScreen(),
  ];

  // Handle navigation tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Using an IndexedStack to preserve each screen's state
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      // Bottom Navigation Bar with a black and white theme
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.black, // Black background
        selectedItemColor: Colors.white, // White for selected items
        unselectedItemColor:
            Colors.grey[400], // Light grey for unselected items
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
