import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Diagonal banner across the top-right corner of an ad card (New, Featured, Urgent).
class CornerRibbon extends StatelessWidget {
  const CornerRibbon({
    super.key,
    required this.text,
    required this.color,
  });

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      right: -26,
      child: Transform.rotate(
        angle: math.pi / 4,
        child: Container(
          width: 90,
          padding: const EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
            color: color,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}

