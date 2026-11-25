import 'package:e_commerce_app/core/utils/app_color.dart';
import 'package:flutter/material.dart';

class CustomCartIcon extends StatelessWidget {
  final VoidCallback? onTap;
  final int count; // عدد المنتجات في الكارت (0 = من غير بادج)

  const CustomCartIcon({super.key, this.onTap, this.count = 0});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Badge(
          isLabelVisible: count > 0,
          label: Text('$count'),
          child: Icon(
            Icons.shopping_cart_outlined,
            color: AppColor.mainColor,
            size: 28,
          ),
        ),
      ),
    );
  }
}