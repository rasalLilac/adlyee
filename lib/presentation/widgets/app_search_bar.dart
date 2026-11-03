import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/scale.dart';
import 'package:solofy_vendor_app/application/core/theme/text_styles.dart';
import 'package:solofy_vendor_app/application/core/utils/app_assets.dart';
import 'package:solofy_vendor_app/application/core/utils/string_file.dart';

class AppSearchBar extends StatelessWidget {
  const AppSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    this.hint = StringFile.search,
    this.trailing,
    this.onTrailingTap,
    this.hasBorder = false,
    this.borderColor,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hint;
  final Widget? trailing;
  final VoidCallback? onTrailingTap;
  final bool hasBorder;
  final Color? borderColor;

  // Named constants in design px, scaled with .s
  static const double barHeight = 40.0;
  static const double barRadius = 12.0;
  static const double iconSize = 16.0;
  static const double paddingH = 12.0;
  static const double iconGap = 8.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: barHeight.s,
      decoration: BoxDecoration(
        color: ColorResources.white,
        borderRadius: BorderRadius.circular(barRadius.s),
        border: borderColor != null
            ? Border.all(color: borderColor!, width: 1.s)
            : (hasBorder
                ? Border.all(color: ColorResources.primary, width: 1.2.s)
                : null),
        boxShadow: [
          BoxShadow(
            color: ColorResources.primaryShadow.withValues(alpha: 0.12),
            blurRadius: 8.s,
            offset: Offset(0, 3.s),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: paddingH.s),
      child: Row(
        children: [
          SvgPicture.asset(
            AppAssets.searchNormalSvg,
            width: iconSize.s,
            height: iconSize.s,
            colorFilter: const ColorFilter.mode(
              ColorResources.grey,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(width: iconGap.s),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: baseTextStyle.s12.w400.black.h12,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: baseTextStyle.s12.w400.grey.h12,
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (trailing != null) ...[
            SizedBox(width: iconGap.s),
            GestureDetector(
              onTap: onTrailingTap,
              behavior: HitTestBehavior.opaque,
              child: trailing!,
            ),
          ],
        ],
      ),
    );
  }
}

