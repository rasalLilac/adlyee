import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solofy_vendor_app/application/core/route/app_route.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/diamentions.dart';
import 'package:solofy_vendor_app/application/core/utils/app_assets.dart';

class AdHeaderBar extends StatelessWidget {
  const AdHeaderBar({
    super.key,
    required this.isFavorite,
    required this.onFavoriteTap,
    required this.onShareTap,
  });

  final bool isFavorite;
  final VoidCallback onFavoriteTap;
  final VoidCallback onShareTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => AppRoute.pop(),
          icon: const Icon(
            Icons.arrow_back,
            color: ColorResources.black,
            size: 24,
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onFavoriteTap,
          behavior: HitTestBehavior.opaque,
          child: SvgPicture.asset(
            AppAssets.favouriteSvg,
            width: 44,
            height: 44,
          ),
        ),
        gap8,
        GestureDetector(
          onTap: onShareTap,
          behavior: HitTestBehavior.opaque,
          child: SvgPicture.asset(
            AppAssets.shareSvg,
            width: 44,
            height: 44,
          ),
        ),
      ],
    );
  }
}

