import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/diamentions.dart';
import 'package:solofy_vendor_app/application/core/theme/text_styles.dart';
import 'package:solofy_vendor_app/application/core/utils/app_assets.dart';
import 'package:solofy_vendor_app/application/core/utils/string_file.dart';

/// Reusable blue promo banner card displaying the [ads.svg] icon and dots indicator.
/// Used on the Home header, in-feed grid slot, and Ad Detail view.
class AdminBannerCard extends StatelessWidget {
  const AdminBannerCard({
    super.key,
    this.height = 120,
    this.iconHeight = 38,
    this.showDots = true,
  });

  final double height;
  final double iconHeight;
  final bool showDots;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF266FB1),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: ColorResources.primaryShadow.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          // ADS SVG vector
          SvgPicture.asset(
            AppAssets.adsSvg,
            height: iconHeight,
          ),
          gap8,
          Text(
            StringFile.adminBannerText,
            textAlign: TextAlign.center,
            style: baseTextStyle.s10.w400.white.copyWith(height: 1.2),
          ),
          const Spacer(),
          if (showDots)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                final isActive = index == 0;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2.5),
                  width: isActive ? 10 : 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              }),
            ),
        ],
      ),
    );
  }
}

