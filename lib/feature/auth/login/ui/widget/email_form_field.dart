
import 'package:e_commerce_app/core/utils/app_color.dart';
import 'package:e_commerce_app/core/utils/app_text_style.dart';
import 'package:e_commerce_app/core/utils/custem_text_form_field.dart';
import 'package:flutter/material.dart';

class EmailFormField extends StatelessWidget {
  final TextEditingController controller;

  const EmailFormField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("E-mail address", style: AppTextStyle.style18500White),
        const SizedBox(height: 26),
        CustemTextFormField(
          controller: controller,
          fillColor: Colors.white,
          hintText: 'Enter your email',
          keyboardType: TextInputType.emailAddress,
          prefixIcon: const Icon(
            Icons.email,
            color: AppColor.mainColor,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your email';
            }

            if (!RegExp(
              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
            ).hasMatch(value.trim())) {
              return 'Please enter a valid email';
            }

            return null;
          },
        ),
      ],
    );
  }
}
