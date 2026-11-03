import 'package:flutter/material.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/scale.dart';

// TODO: Replace AdLocationMapPreview placeholder with GoogleMap once google_maps_flutter is added.
class AdLocationMapPreview extends StatelessWidget {
  const AdLocationMapPreview({
    super.key,
    this.height,
  });

  final double? height;

  @override
  Widget build(BuildContext context) {
    final mapHeight = height ?? 190.s;
    return Container(
      height: mapHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFECEFF1),
        borderRadius: BorderRadius.circular(12.s),
        border: Border.all(color: ColorResources.borderColor, width: 1.s),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.s),
        child: Stack(
          children: [
            // Road layout placeholder lines
            CustomPaint(
              size: Size(double.infinity, mapHeight),
              painter: const _MapGridPainter(),
            ),
            // Centered blue location pin
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: ColorResources.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: ColorResources.primary, width: 3.5),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 2.5,
                    height: 10,
                    color: ColorResources.black,
                  ),
                  Container(
                    width: 5,
                    height: 5,
                    decoration: const BoxDecoration(
                      color: ColorResources.black,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  const _MapGridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;

    final path = Path()
      ..moveTo(size.width * 0.1, -10)
      ..lineTo(size.width * 0.45, size.height + 10)
      ..moveTo(size.width * 0.5, -10)
      ..lineTo(size.width * 0.85, size.height + 10)
      ..moveTo(-10, size.height * 0.3)
      ..lineTo(size.width + 10, size.height * 0.7)
      ..moveTo(-10, size.height * 0.65)
      ..lineTo(size.width + 10, size.height * 0.4);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

