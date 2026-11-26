
import 'package:e_commerce_app/core/utils/app_color.dart';
import 'package:e_commerce_app/feature/auth/login/ui/login_screen.dart';
import 'package:e_commerce_app/feature/auth/register/ui/register_screen.dart';
import 'package:e_commerce_app/feature/home/ui/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ECommercaApp extends StatefulWidget {
  const ECommercaApp({super.key});

  @override
  State<ECommercaApp> createState() => _ECommercaAppState();
}

class _ECommercaAppState extends State<ECommercaApp> {
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    loadTheme();
  }

  // Load saved theme
  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();

    final savedTheme = prefs.getBool('isDarkMode') ?? false;

    if (!mounted) return;

    setState(() {
      isDarkMode = savedTheme;
    });
  }

  // Change and save theme
  void toggleTheme(bool value) async {
    setState(() {
      isDarkMode = value;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,

      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColor.mainColor,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColor.mainColor,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF121212),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardColor: const Color(0xFF1E1E1E),
      ),

      initialRoute: LoginScreen.routeName,

      routes: {
        LoginScreen.routeName: (context) => LoginScreen(),
        RegisterScreen.routeName: (context) => RegisterScreen(),
        HomeScreen.routeName: (context) => HomeScreen(
          isDarkMode: isDarkMode,
          onThemeChanged: toggleTheme,
        ),
      },
    );
  }
}
