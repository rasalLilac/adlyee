import 'package:flutter/material.dart';
import 'package:solofy_vendor_app/application/core/route/app_route.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/scale.dart';
import 'package:solofy_vendor_app/presentation/ads/post_ad/post_ad_screen.dart';

/// Floating pill bottom navigation bar with 3 tabs and an overlapping circular '+' action button.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
    this.onAddPressed,
  });

  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final VoidCallback? onAddPressed;

  // Named private constants in design px, scaled with .s
  static const double navHeight = 52.0;
  static const double navRadius = 16.0;
  static const double marginH = 16.0;
  static const double marginB = 16.0;
  static const double navIconSize = 24.0;
  static const double fabSize = 80.0;
  static const double fabInnerSize = 58.0;
  static const double fabIconSize = 24.0;
  static const double fabStrokeWidth = 2.4;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: navHeight.s,
      margin: EdgeInsets.only(left: marginH.s, right: marginH.s, bottom: marginB.s),
      decoration: BoxDecoration(
        color: ColorResources.white,
        borderRadius: BorderRadius.circular(navRadius.s),
        border: Border.all(
          color: ColorResources.navBorder,
          width: 1.s,
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.centerLeft,
        children: [
          // 3 navigation tabs on the left & center
          Padding(
            padding: EdgeInsets.only(left: 12.s, right: 76.s),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavTab(
                  iconWidget: _HomeNavIcon(
                    isSelected: selectedIndex == 0,
                    size: navIconSize.s,
                  ),
                  isSelected: selectedIndex == 0,
                  onTap: () => onTabSelected(0),
                ),
                _NavTab(
                  icon: Icons.favorite_rounded,
                  iconSize: navIconSize.s,
                  isSelected: selectedIndex == 1,
                  onTap: () => onTabSelected(1),
                ),
                _NavTab(
                  iconWidget: _PlayNavIcon(
                    isSelected: selectedIndex == 2,
                    size: navIconSize.s,
                  ),
                  isSelected: selectedIndex == 2,
                  onTap: () => onTabSelected(2),
                ),
              ],
            ),
          ),

          // The circular '+' button on the right with light halo
          Positioned(
            right: -3.s,
            child: GestureDetector(
              onTap: onAddPressed ??
                  () {
                    AppRoute.pushNamed(PostAdScreen.routeName);
                  },
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                width: fabSize.s,
                height: fabSize.s,
                child: Center(
                  child: Container(
                    width: fabSize.s,
                    height: fabSize.s,
                    decoration: BoxDecoration(
                      color: ColorResources.primary.withValues(alpha: 0.16),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Container(
                        width: fabInnerSize.s,
                        height: fabInnerSize.s,
                        decoration: BoxDecoration(
                          color: ColorResources.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: ColorResources.primary.withValues(alpha: 0.35),
                              blurRadius: 8.s,
                              offset: Offset(0, 3.s),
                            ),
                          ],
                        ),
                        child: Center(
                          child: CustomPaint(
                            size: Size(fabIconSize.s, fabIconSize.s),
                            painter: _PlusIconPainter(
                              color: ColorResources.white,
                              strokeWidth: fabStrokeWidth.s,
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
    this.icon,
    this.iconSize,
    this.iconWidget,
    required this.isSelected,
    required this.onTap,
  });

  final IconData? icon;
  final double? iconSize;
  final Widget? iconWidget;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 38.s,
        height: 38.s,
        alignment: Alignment.center,
        child: iconWidget ??
            Icon(
              icon,
              size: iconSize ?? 24.s,
              color: isSelected
                  ? ColorResources.primary
                  : ColorResources.navInactive,
            ),
      ),
    );
  }
}

class _HomeNavIcon extends StatelessWidget {
  const _HomeNavIcon({
    required this.isSelected,
    required this.size,
  });

  final bool isSelected;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? ColorResources.primary : ColorResources.navInactive;
    return CustomPaint(
      size: Size(size, size),
      painter: _HomeIconPainter(color: color),
    );
  }
}

class _HomeIconPainter extends CustomPainter {
  const _HomeIconPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final path = Path();
    path.moveTo(w * 0.44, h * 0.12);
    path.quadraticBezierTo(w * 0.5, h * 0.05, w * 0.56, h * 0.12);
    path.lineTo(w * 0.88, h * 0.42);
    path.quadraticBezierTo(w * 0.94, h * 0.47, w * 0.90, h * 0.54);
    path.lineTo(w * 0.84, h * 0.88);
    path.quadraticBezierTo(w * 0.82, h * 0.94, w * 0.74, h * 0.94);
    path.lineTo(w * 0.26, h * 0.94);
    path.quadraticBezierTo(w * 0.18, h * 0.94, w * 0.16, h * 0.88);
    path.lineTo(w * 0.10, h * 0.54);
    path.quadraticBezierTo(w * 0.06, h * 0.47, w * 0.12, h * 0.42);
    path.close();

    canvas.drawPath(path, paint);

    // Door slit in center bottom
    final slitPaint = Paint()
      ..color = ColorResources.white
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final slitRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(w * 0.5, h * 0.76),
        width: w * 0.07,
        height: h * 0.20,
      ),
      Radius.circular(w * 0.035),
    );
    canvas.drawRRect(slitRect, slitPaint);
  }

  @override
  bool shouldRepaint(covariant _HomeIconPainter oldDelegate) => oldDelegate.color != color;
}

class _PlayNavIcon extends StatelessWidget {
  const _PlayNavIcon({
    required this.isSelected,
    required this.size,
  });

  final bool isSelected;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.play_circle_fill_rounded,
      size: size,
      color: isSelected ? ColorResources.primary : ColorResources.navInactive,
    );
  }
}
