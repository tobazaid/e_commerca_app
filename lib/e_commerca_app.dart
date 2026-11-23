import 'package:e_commerce_app/feature/auth/login/ui/login_screen.dart';
import 'package:e_commerce_app/feature/auth/register/ui/register_screen.dart';
import 'package:e_commerce_app/feature/home/ui/home_screen.dart';
import 'package:flutter/material.dart';

class ECommercaApp extends StatelessWidget {
  const ECommercaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      
      initialRoute: LoginScreen.routeName,
      routes: {
        LoginScreen.routeName:(context) => LoginScreen(),
        RegisterScreen.routeName:(context) => RegisterScreen(),
        HomeScreen.routeName:(context) => HomeScreen()
      },
    );
  }
}