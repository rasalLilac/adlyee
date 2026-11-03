import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solofy_vendor_app/application/core/route/app_route.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/scale.dart';
import 'package:solofy_vendor_app/application/core/utils/alert_dialog.dart';
import 'package:solofy_vendor_app/application/core/utils/app_assets.dart';
import 'package:solofy_vendor_app/application/core/utils/string_file.dart';
import 'package:solofy_vendor_app/presentation/main/widgets/side_menu_scope.dart';
import 'package:solofy_vendor_app/presentation/widgets/app_logo.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    super.key,
    required this.locationText,
    required this.unreadCount,
    this.language = 'English',
    this.onMenuPressed,
    this.onNotificationPressed,
    this.onLocationPressed,
    this.onLanguagePressed,
  });

  final String locationText;
  final int unreadCount;
  final String language;
  final VoidCallback? onMenuPressed;
  final VoidCallback? onNotificationPressed;
  final VoidCallback? onLocationPressed;
  final VoidCallback? onLanguagePressed;

  // Named private constants in design px, scaled with .s (Figma Fix B)
  static const double paddingH = 16.0;
  static const double paddingTop = 8.0;
  static const double paddingBottom = 0.0;
  static const double logoBoxSize = 28.0;
  static const double logoSize = 14.0;
  static const double menuIconSize = 24.0;
  static const double bellIconSize = 24.0;
  static const double badgeSize = 14.0;
  static const double locationPinSize = 14.0;
  static const double chevronSize = 18.0;
  static const double rowGap = 14.0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          paddingH.s,
          paddingTop.s,
          paddingH.s,
          paddingBottom.s,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Menu icon, AppLogo (28px circle) + "Adlyee" (Poppins 18 w600), Notification bell
            Row(
              children: [
                IconButton(
                  onPressed: onMenuPressed ??
                      () {
                        final scope = SideMenuScope.maybeOf(context);
                        if (scope != null) {
                          scope.toggle();
                        } else {
                          Scaffold.of(context).openDrawer();
                        }
                      },
                  icon: SvgPicture.asset(
                    AppAssets.menuSvg,
                    width: menuIconSize.s,
                    height: menuIconSize.s,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                SizedBox(width: 10.s),
                Container(
                  width: logoBoxSize.s,
                  height: logoBoxSize.s,
                  decoration: const BoxDecoration(
                    color: ColorResources.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: AppLogo(size: logoSize.s, color: ColorResources.primary),
                  ),
                ),
                SizedBox(width: 8.s),
                Text(
                  StringFile.appName,
                  style: GoogleFonts.poppins(
                    fontSize: 18.s,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onNotificationPressed ??
                      () => AppRoute.pushNamed('notifications'),
                  behavior: HitTestBehavior.opaque,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      SvgPicture.asset(
                        AppAssets.notificationSvg,
                        width: bellIconSize.s,
                        height: bellIconSize.s,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                      if (unreadCount > 0)
                        Positioned(
                          right: -3.s,
                          top: -3.s,
                          child: Container(
                            width: badgeSize.s,
                            height: badgeSize.s,
                            decoration: const BoxDecoration(
                              color: ColorResources.red,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '$unreadCount',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8.s,
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
            SizedBox(height: rowGap.s),

            // Row 2: Location icon + "Palazhi , Calicut" + chevron (left), "English" + chevron (right)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: GestureDetector(
                    onTap: onLocationPressed ??
                        () {
                          CustomAlertDialog.showCustomDialog(
                            title: 'Location Selector',
                            subtitle: 'Location picker coming soon.',
                          );
                        },
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          AppAssets.locationSvg,
                          width: locationPinSize.s,
                          height: locationPinSize.s,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(width: 6.s),
                        Flexible(
                          child: Text(
                            locationText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 13.5.s,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              height: 1.2,
                            ),
                          ),
                        ),
                        SizedBox(width: 4.s),
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: chevronSize.s,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 8.s),
                GestureDetector(
                  onTap: onLanguagePressed ??
                      () {
                        CustomAlertDialog.showCustomDialog(
                          title: 'Language',
                          subtitle: 'Multi-language support coming soon.',
                        );
                      },
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        language,
                        style: GoogleFonts.poppins(
                          fontSize: 13.5.s,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(width: 4.s),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: chevronSize.s,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
