import 'package:flutter/material.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';

class DotsIndicator extends StatelessWidget {
  const DotsIndicator({
    super.key,
    required this.itemCount,
    required this.currentIndex,
    this.activeColor = ColorResources.primary,
    this.inactiveColor = const Color(0xFFC7D8E8),
    this.dotHeight = 5,
    this.activeWidth = 10,
    this.inactiveWidth = 5,
    this.spacing = 2.5,
  });

  final int itemCount;
  final int currentIndex;
  final Color activeColor;
  final Color inactiveColor;
  final double dotHeight;
  final double activeWidth;
  final double inactiveWidth;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        final isActive = index == currentIndex;
        return Container(
          margin: EdgeInsets.symmetric(horizontal: spacing),
          width: isActive ? activeWidth : inactiveWidth,
          height: dotHeight,
          decoration: BoxDecoration(
            color: isActive ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(dotHeight / 2),
          ),
        );
      }),
    );
  }
}

