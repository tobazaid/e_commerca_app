
import 'package:e_commerce_app/core/utils/app_color.dart';
import 'package:e_commerce_app/feature/auth/login/ui/widget/create_account_row.dart';
import 'package:e_commerce_app/feature/auth/login/ui/widget/email_form_field.dart';
import 'package:e_commerce_app/feature/auth/login/ui/widget/forgot_password.dart';
import 'package:e_commerce_app/feature/auth/login/ui/widget/login_button.dart';
import 'package:e_commerce_app/feature/auth/login/ui/widget/login_header.dart';
import 'package:e_commerce_app/feature/auth/login/ui/widget/password_form_field.dart';
import 'package:e_commerce_app/feature/home/ui/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "Login_screen";

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!mounted) return;

      Navigator.pushReplacementNamed(
        context,
        HomeScreen.routeName,
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Login failed';

      if (e.code == 'user-not-found') {
        message = 'No account found with this email';
      } else if (e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        message = 'Email or password is incorrect';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email address';
      } else if (e.code == 'network-request-failed') {
        message = 'Check your internet connection';
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.mainColor,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80),

                const LoginHeader(),

                const SizedBox(height: 50),

                EmailFormField(
                  controller: emailController,
                ),

                const SizedBox(height: 35),

                PasswordFormField(
                  controller: passwordController,
                ),

                const SizedBox(height: 33),

                const ForgotPassword(),

                const SizedBox(height: 60),

                LoginButton(
                  onPressed: login,
                  isLoading: isLoading,
                ),

                const SizedBox(height: 40),

                const CreateAccountRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
