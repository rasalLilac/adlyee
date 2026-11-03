import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/diamentions.dart';
import 'package:solofy_vendor_app/application/core/theme/text_styles.dart';
import 'package:solofy_vendor_app/application/core/utils/alert_dialog.dart';
import 'package:solofy_vendor_app/application/core/utils/app_assets.dart';
import 'package:url_launcher/url_launcher.dart';

class AdLocationRow extends StatelessWidget {
  const AdLocationRow({
    super.key,
    required this.locationLabel,
    required this.latitude,
    required this.longitude,
  });

  final String locationLabel;
  final double latitude;
  final double longitude;

  Future<void> _openMap() async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
    );
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        CustomAlertDialog.showCustomDialog(
          title: 'Location',
          subtitle: locationLabel,
        );
      }
    } catch (_) {
      CustomAlertDialog.showCustomDialog(
        title: 'Location',
        subtitle: locationLabel,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(color: ColorResources.borderColor, height: 1),
        gap12,
        Row(
          children: [
            const Icon(
              Icons.location_on_outlined,
              size: 16,
              color: ColorResources.grey,
            ),
            gap6,
            Expanded(
              child: Text(
                locationLabel,
                style: baseTextStyle.s11.w400.black,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            gap8,
            GestureDetector(
              onTap: _openMap,
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: ColorResources.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: SvgPicture.asset(
                    AppAssets.googleMapSvg,
                    width: 18,
                    height: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

