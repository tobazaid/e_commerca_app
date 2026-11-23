
import 'package:e_commerce_app/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';

class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "Create Account",
      style: AppTextStyle.style24White,
    );
  }
}
