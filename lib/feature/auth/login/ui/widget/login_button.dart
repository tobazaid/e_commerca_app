
import 'package:e_commerce_app/core/utils/app_color.dart';
import 'package:e_commerce_app/core/utils/custem_icon_bottom.dart';
import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const LoginButton({
    super.key,
    required this.onPressed,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return CustemIconBottom(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const CircularProgressIndicator()
          : const Text(
              'Login',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColor.mainColor,
              ),
            ),
    );
  }
}
