import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  // ====== تحكم في الحجم من هنا ======
  static const double navHeight = 56;        // طول الشريط
  static const double navSideMargin = 0;     // المسافة يمين وشمال
  static const double navBottomMargin = 0;   // المسافة من تحت
  static const double circleSize = 40;       // حجم الدايرة البيضاء
  static const double iconSize = 24;         // حجم الأيقونة
  static const double navRadius = 24;        // دايرية الحواف العلوية
  // ==================================

  static const Color navColor = Color(0xFF004182);

  static const List<IconData> _icons = [
    Icons.home_outlined,
    Icons.grid_view_rounded,
    Icons.favorite_border,
    Icons.person_outline,
  ];

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.of(context).padding.bottom;

    return Container(
      height: navHeight + bottomInset,
      margin: const EdgeInsets.fromLTRB(
        navSideMargin,
        0,
        navSideMargin,
        navBottomMargin,
      ),
      padding: EdgeInsets.only(bottom: bottomInset),
      decoration: const BoxDecoration(
        color: navColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(navRadius)),
      ),
      child: Row(
        children: List.generate(_icons.length, (index) {
          final bool selected = index == currentIndex;
          return Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onTap(index),
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                  width: circleSize,
                  height: circleSize,
                  decoration: BoxDecoration(
                    color: selected ? Colors.white : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _icons[index],
                    size: iconSize,
                    color: selected ? navColor : Colors.white,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}