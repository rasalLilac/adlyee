import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/scale.dart';

class DropdownChip extends StatelessWidget {
  const DropdownChip({
    super.key,
    required this.label,
    required this.onTap,
    this.isActive = false,
    this.height = 30.0,
    this.fontSize,
  });

  final String label;
  final VoidCallback onTap;
  final bool isActive;
  final double height;
  final double? fontSize;

  // Named constants in design px, scaled with .s
  static const double chipRadius = 8.0;
  static const double paddingH = 6.0;
  static const double iconSize = 16.0;
  static const double iconGap = 2.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: height.s,
        padding: EdgeInsets.symmetric(horizontal: paddingH.s),
        decoration: BoxDecoration(
          color: isActive
              ? ColorResources.primary.withValues(alpha: 0.08)
              : ColorResources.white,
          borderRadius: BorderRadius.circular(chipRadius.s),
          border: Border.all(
            color: isActive
                ? ColorResources.primary
                : ColorResources.borderColor,
            width: 1.s,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: (fontSize ?? 11.5).s,
                  fontWeight: FontWeight.w400,
                  color: ColorResources.grey,
                  height: 1.2,
                ),
              ),
            ),
            SizedBox(width: iconGap.s),
            Icon(
              Icons.keyboard_arrow_down,
              size: iconSize.s,
              color: ColorResources.grey,
            ),
          ],
        ),
      ),
    );
  }
}
