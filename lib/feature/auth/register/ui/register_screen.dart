
import 'package:e_commerce_app/core/utils/app_color.dart';
import 'package:e_commerce_app/feature/auth/login/ui/login_screen.dart';
import 'package:e_commerce_app/feature/auth/register/ui/widget/full_name_form_field.dart';
import 'package:e_commerce_app/feature/auth/register/ui/widget/mobile_form_field.dart';
import 'package:e_commerce_app/feature/auth/register/ui/widget/register_button.dart';
import 'package:e_commerce_app/feature/auth/register/ui/widget/register_email_form_field.dart';
import 'package:e_commerce_app/feature/auth/register/ui/widget/register_password_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = "register_screen";

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> createAccount() async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await userCredential.user!.updateDisplayName(
        nameController.text.trim(),
      );

      await FirebaseAuth.instance.signOut();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created successfully'),
        ),
      );

      Navigator.pushReplacementNamed(
        context,
        LoginScreen.routeName,
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Registration failed';

      if (e.code == 'email-already-in-use') {
        message = 'This email is already registered';
      } else if (e.code == 'weak-password') {
        message = 'Password is too weak';
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
    nameController.dispose();
    mobileController.dispose();
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

                FullNameFormField(
                  controller: nameController,
                ),

                const SizedBox(height: 35),

                MobileFormField(
                  controller: mobileController,
                ),

                const SizedBox(height: 35),

                RegisterEmailFormField(
                  controller: emailController,
                ),

                const SizedBox(height: 35),

                RegisterPasswordFormField(
                  controller: passwordController,
                ),

                const SizedBox(height: 50),

                RegisterButton(
                  onPressed: createAccount,
                  isLoading: isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
