
import 'package:e_commerce_app/core/utils/app_color.dart';
import 'package:e_commerce_app/core/utils/app_text_style.dart';
import 'package:e_commerce_app/core/utils/custem_text_form_field.dart';
import 'package:flutter/material.dart';

class MobileFormField extends StatelessWidget {
  final TextEditingController controller;

  const MobileFormField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Mobile Number", style: AppTextStyle.style18500White),
        const SizedBox(height: 26),
        CustemTextFormField(
          controller: controller,
          fillColor: Colors.white,
          hintText: 'enter your mobile',
          keyboardType: TextInputType.phone,
          prefixIcon: const Icon(
            Icons.phone_android,
            color: AppColor.mainColor,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your mobile number';
            }

            if (!RegExp(r'^[0-9]{11}$').hasMatch(value)) {
              return 'Mobile number must be 11 digits';
            }

            return null;
          },
        ),
      ],
    );
  }
}
