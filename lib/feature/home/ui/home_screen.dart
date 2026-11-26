
import 'package:e_commerce_app/core/utils/custom_bottom_nav_bar.dart';
import 'package:e_commerce_app/feature/categories/ui/categories_screen.dart';
import 'package:e_commerce_app/feature/favorites/ui/favorites_screen.dart';
import 'package:e_commerce_app/feature/home/ui/profile/ui/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_app/feature/home/ui/home_tab.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'home';

  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const HomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomeTab(),
      const CategoriesScreen(),
      const FavoritesScreen(),
      ProfileScreen(
        isDarkMode: widget.isDarkMode,
        onThemeChanged: widget.onThemeChanged,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
