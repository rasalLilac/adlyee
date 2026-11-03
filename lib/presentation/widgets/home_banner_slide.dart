import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/scale.dart';
import 'package:solofy_vendor_app/application/core/utils/app_assets.dart';
import 'package:solofy_vendor_app/application/core/utils/string_file.dart';

/// Single slide for the Home banner carousel and grid banner tile.
/// - When [imageUrl] is provided: loads the image with [BoxFit.cover] and graceful loading/error states.
/// - Otherwise: renders the default blue promo banner with [AppAssets.adsSvg] and [StringFile.adminBannerText].
/// - [showDotsInside]: if true (used by grid banner tile), renders dots inside at the bottom.
///   For the top carousel, this is ALWAYS false (dots are rendered outside below the carousel).
class HomeBannerSlide extends StatelessWidget {
  const HomeBannerSlide({
    super.key,
    this.imageUrl,
    this.title = StringFile.adminBannerText,
    this.iconHeight = 36.0,
    this.showDotsInside = false,
    this.dotsCount = 4,
    this.activeDotIndex = 0,
    this.onTap,
  });

  final String? imageUrl;
  final String title;
  final double iconHeight;
  final bool showDotsInside;
  final int dotsCount;
  final int activeDotIndex;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (imageUrl != null && imageUrl!.trim().isNotEmpty) {
      content = Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) => _buildDefaultContent(),
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            color: ColorResources.primary,
            child: const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          );
        },
      );
    } else {
      content = _buildDefaultContent();
    }

    if (showDotsInside) {
      content = Stack(
        alignment: Alignment.bottomCenter,
        children: [
          content,
          Positioned(
            bottom: 8.s,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(dotsCount, (index) {
                final isActive = index == activeDotIndex;
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 2.5.s),
                  width: isActive ? 10.s : 4.s,
                  height: 4.s,
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(2.s),
                  ),
                );
              }),
            ),
          ),
        ],
      );
    }

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: ColorResources.primary,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: content,
        ),
      ),
    );
  }

  Widget _buildDefaultContent() {
    return Container(
      color: ColorResources.primary,
      padding: EdgeInsets.symmetric(horizontal: 14.s, vertical: 8.s),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AppAssets.adsSvg,
            height: iconHeight.s,
          ),
          SizedBox(height: 6.s),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 11.s,
              fontWeight: FontWeight.w400,
              color: ColorResources.white,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

