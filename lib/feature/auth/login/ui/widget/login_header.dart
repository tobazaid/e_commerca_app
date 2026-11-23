
import 'package:e_commerce_app/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Welcome Back", style: AppTextStyle.style24White),
        const SizedBox(height: 10),
        Text(
          "Please sign in with your mail",
          style: AppTextStyle.style16300White,
        ),
      ],
    );
  }
}
