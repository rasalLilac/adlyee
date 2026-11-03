import 'package:flutter/material.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';

/// Floating pill bottom navigation bar with 3 tabs and a circular '+' action button (Image 1 & 3).
class AdlyeeBottomNavBar extends StatelessWidget {
  const AdlyeeBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.onAddPressed,
  });

  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final VoidCallback onAddPressed;

  static const _unselectedColor = Color(0xFFC2D6E7);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: ColorResources.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE4EBFF),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: ColorResources.primaryShadow.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          // 3 navigation tabs on the left & center
          Padding(
            padding: const EdgeInsets.only(left: 14, right: 74),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavTab(
                  icon: Icons.home_rounded,
                  isSelected: selectedIndex == 0,
                  onTap: () => onTabSelected(0),
                ),
                _NavTab(
                  icon: Icons.favorite_rounded,
                  isSelected: selectedIndex == 1,
                  onTap: () => onTabSelected(1),
                ),
                _NavTab(
                  icon: Icons.play_circle_fill_rounded,
                  isSelected: selectedIndex == 2,
                  onTap: () => onTabSelected(2),
                ),
              ],
            ),
          ),

          // The circular '+' button on the right with light halo
          Positioned(
            right: -2,
            child: GestureDetector(
              onTap: onAddPressed,
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                width: 80,
                height: 80,
                child: Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: ColorResources.primary.withValues(alpha: 0.16),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          color: ColorResources.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: ColorResources.primaryShadow.withValues(alpha: 0.45),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: CustomPaint(
                            size: Size(24, 24),
                            painter: _PlusIconPainter(
                              color: ColorResources.white,
                              strokeWidth: 2.4,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlusIconPainter extends CustomPainter {
  const _PlusIconPainter({
    required this.color,
    required this.strokeWidth,
  });

  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final half = size.width / 2;

    // Horizontal arm
    canvas.drawLine(Offset(cx - half, cy), Offset(cx + half, cy), paint);
    // Vertical arm
    canvas.drawLine(Offset(cx, cy - half), Offset(cx, cy + half), paint);
  }

  @override
  bool shouldRepaint(covariant _PlusIconPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
}

class _NavTab extends StatelessWidget {
  const _NavTab({
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 48,
        height: 48,
        child: Center(
          child: Icon(
            icon,
            size: 28,
            color: isSelected ? ColorResources.primary : AdlyeeBottomNavBar._unselectedColor,
          ),
        ),
      ),
    );
  }
}

