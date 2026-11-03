import 'package:flutter/material.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';

/// Draws a smooth vertical background gradient behind [child] (the scrolling header block).
/// - Top to [fadeStart]: solid [ColorResources.primary]
/// - [fadeStart] to [fadeEnd]: smooth linear fade from [ColorResources.primary] to [Colors.white]
/// - [fadeEnd] downwards: pure [Colors.white]
class GradientHeaderBackground extends StatelessWidget {
  const GradientHeaderBackground({
    super.key,
    required this.child,
    required this.fadeStart,
    required this.fadeEnd,
  });

  final Widget child;
  final double fadeStart;
  final double fadeEnd;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _HeaderGradientPainter(
        fadeStart: fadeStart,
        fadeEnd: fadeEnd,
      ),
      child: child,
    );
  }
}

class _HeaderGradientPainter extends CustomPainter {
  const _HeaderGradientPainter({
    required this.fadeStart,
    required this.fadeEnd,
  });

  final double fadeStart;
  final double fadeEnd;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final s1 = (fadeStart / size.height).clamp(0.0, 1.0);
    final s2 = (fadeEnd / size.height).clamp(0.0, 1.0);
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: const [
          ColorResources.primary,
          ColorResources.primary,
          Colors.white,
          Colors.white,
        ],
        stops: [0.0, s1, s2, 1.0],
      ).createShader(rect);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant _HeaderGradientPainter oldDelegate) {
    return oldDelegate.fadeStart != fadeStart || oldDelegate.fadeEnd != fadeEnd;
  }
}
