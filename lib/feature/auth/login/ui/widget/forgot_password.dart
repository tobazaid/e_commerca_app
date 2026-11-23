
import 'package:e_commerce_app/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        "Forgot password",
        style: AppTextStyle.style18400White,
      ),
    );
  }
}
