
import 'package:e_commerce_app/core/utils/app_color.dart';
import 'package:e_commerce_app/core/utils/app_text_style.dart';
import 'package:e_commerce_app/core/utils/custem_text_form_field.dart';
import 'package:flutter/material.dart';

class PasswordFormField extends StatelessWidget {
  final TextEditingController controller;

  const PasswordFormField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Password", style: AppTextStyle.style18500White),
        const SizedBox(height: 26),
        CustemTextFormField(
          controller: controller,
          hintText: 'Enter your password',
          isPassword: true,
          showPasswordToggle: true,
          prefixIcon: const Icon(
            Icons.password,
            color: AppColor.mainColor,
          ),
          fillColor: Colors.white,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }

            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }

            return null;
          },
        ),
      ],
    );
  }
}
