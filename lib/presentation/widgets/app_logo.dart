import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/utils/app_assets.dart';

/// The Adlyee mark. One single-colour SVG, tinted with [color]
/// (white on blue backgrounds, primary blue inside the white circle).
class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 60,
    this.color = ColorResources.white,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      AppAssets.logoSvg,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}
