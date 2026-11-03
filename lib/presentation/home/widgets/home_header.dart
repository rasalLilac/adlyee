import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/diamentions.dart';
import 'package:solofy_vendor_app/application/core/theme/text_styles.dart';
import 'package:solofy_vendor_app/application/core/utils/app_assets.dart';
import 'package:solofy_vendor_app/application/core/utils/string_file.dart';
import 'package:solofy_vendor_app/presentation/widgets/admin_banner_card.dart';
import 'package:solofy_vendor_app/presentation/widgets/app_logo.dart';

/// Top header section for Home screen:
/// App bar with logo & notifications, Location & Language row, Search input, and top Banner.
class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
    this.onMenuPressed,
    this.onNotificationPressed,
    this.onLocationPressed,
    this.onLanguagePressed,
  });

  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback? onMenuPressed;
  final VoidCallback? onNotificationPressed;
  final VoidCallback? onLocationPressed;
  final VoidCallback? onLanguagePressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF2368A8),
            Color(0xFF2E75B5),
            Color(0xFF4C8CC7),
            ColorResources.white,
          ],
          stops: [0.0, 0.45, 0.85, 1.0],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar: Menu, Logo + Title, Notification
              Row(
                children: [
                  IconButton(
                    onPressed: onMenuPressed ?? () {},
                    icon: SvgPicture.asset(
                      AppAssets.menuSvg,
                      width: 26,
                      height: 26,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  gap12,
                  // Circular logo badge
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: ColorResources.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: AppLogo(size: 16, color: ColorResources.primary),
                    ),
                  ),
                  gap8,
                  Text(
                    StringFile.appName,
                    style: baseTextStyle.s18.w700.white,
                  ),
                  const Spacer(),
                  // Notification bell with badge
                  GestureDetector(
                    onTap: onNotificationPressed ?? () {},
                    behavior: HitTestBehavior.opaque,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        SvgPicture.asset(
                          AppAssets.notificationSvg,
                          width: 26,
                          height: 26,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                        Positioned(
                          right: -3,
                          top: -3,
                          child: Container(
                            width: 15,
                            height: 15,
                            decoration: const BoxDecoration(
                              color: ColorResources.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Text(
                                '3',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              gap12,

              // Location & Language row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: onLocationPressed ?? () {},
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          AppAssets.locationSvg,
                          width: 16,
                          height: 16,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                        gap4,
                        Text(
                          'Palazhi , Calicut',
                          style: baseTextStyle.s12.w400.white,
                        ),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: onLanguagePressed ?? () {},
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      children: [
                        Text(
                          'English',
                          style: baseTextStyle.s12.w400.white,
                        ),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              gap12,

              // Search Bar
              Container(
                height: 44,
                decoration: BoxDecoration(
                  color: ColorResources.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: onSearchChanged,
                  cursorColor: ColorResources.primary,
                  style: baseTextStyle.s13.w400.black,
                  decoration: InputDecoration(
                    hintText: StringFile.search,
                    hintStyle: baseTextStyle.s12.w400.slateGray,
                    prefixIcon: const Icon(
                      Icons.search,
                      color: ColorResources.grey,
                      size: 20,
                    ),
                    suffixIcon: searchController.text.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              searchController.clear();
                              onSearchChanged('');
                            },
                            child: const Icon(
                              Icons.cancel,
                              color: ColorResources.grey,
                              size: 18,
                            ),
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              gap16,

              // Top Carousel Banner using AdminBannerCard and ads.svg
              const AdminBannerCard(height: 124, iconHeight: 44),
            ],
          ),
        ),
      ),
    );
  }
}

