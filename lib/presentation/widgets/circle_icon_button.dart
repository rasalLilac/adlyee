import 'package:flutter/material.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';

class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    super.key,
    required this.child,
    required this.onTap,
    this.size = 40,
    this.backgroundColor = ColorResources.primary,
    this.boxShadow,
  });

  final Widget child;
  final VoidCallback onTap;
  final double size;
  final Color backgroundColor;
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          boxShadow: boxShadow,
        ),
        child: Center(child: child),
      ),
    );
  }
}

