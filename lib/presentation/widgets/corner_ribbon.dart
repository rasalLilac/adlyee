import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:solofy_vendor_app/application/core/theme/scale.dart';
import 'package:solofy_vendor_app/application/core/theme/text_styles.dart';

/// Diagonal banner across the top-right corner of an ad card (New, Featured, Urgent).
class CornerRibbon extends StatelessWidget {
  const CornerRibbon({
    super.key,
    required this.text,
    required this.color,
  });

  final String text;
  final Color color;

  static const _top = 10.0;
  static const _right = -26.0;
  static const _width = 90.0;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: _top.s,
      right: _right.s,
      child: Transform.rotate(
        angle: math.pi / 4,
        child: Container(
          width: _width.s,
          padding: EdgeInsets.symmetric(vertical: 2.s),
          decoration: BoxDecoration(
            color: color,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: 4.s,
                offset: Offset(0, 1.s),
              ),
            ],
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: baseTextStyle.s09.w700.white.h12.copyWith(
              letterSpacing: 0.3.s,
            ),
          ),
        ),
      ),
    );
  }
}
