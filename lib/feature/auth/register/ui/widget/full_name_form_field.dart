
import 'package:e_commerce_app/core/utils/app_color.dart';
import 'package:e_commerce_app/core/utils/app_text_style.dart';
import 'package:e_commerce_app/core/utils/custem_text_form_field.dart';
import 'package:flutter/material.dart';

class FullNameFormField extends StatelessWidget {
  final TextEditingController controller;

  const FullNameFormField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Full Name", style: AppTextStyle.style18500White),
        const SizedBox(height: 26),
        CustemTextFormField(
          controller: controller,
          fillColor: Colors.white,
          hintText: 'enter your name',
          prefixIcon: const Icon(
            Icons.person,
            color: AppColor.mainColor,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your full name';
            }
            return null;
          },
        ),
      ],
    );
  }
}
