
import 'package:e_commerce_app/core/utils/app_text_style.dart';
import 'package:e_commerce_app/feature/auth/register/ui/register_screen.dart';
import 'package:flutter/material.dart';

class CreateAccountRow extends StatelessWidget {
  const CreateAccountRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don’t have an account?",
          style: AppTextStyle.style18500White,
        ),
        InkWell(
          onTap: () {
            Navigator.pushReplacementNamed(
              context,
              RegisterScreen.routeName,
            );
          },
          child: Text(
            " Create Account",
            style: AppTextStyle.style18500White,
          ),
        ),
      ],
    );
  }
}
