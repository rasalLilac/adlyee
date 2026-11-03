import 'package:flutter/material.dart';
import 'package:solofy_vendor_app/application/core/route/app_route.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/diamentions.dart';
import 'package:solofy_vendor_app/application/core/theme/text_styles.dart';
import 'package:solofy_vendor_app/application/core/utils/alert_dialog.dart';
import 'package:solofy_vendor_app/application/core/utils/string_file.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/ad_detail.dart';
import 'package:solofy_vendor_app/presentation/ads/report_ad/report_ad_screen.dart';

class AdExpiryRow extends StatelessWidget {
  const AdExpiryRow({
    super.key,
    required this.registeredNumber,
    required this.status,
    required this.expiresInDays,
    this.adRef,
    this.onReportAd,
  });

  final String registeredNumber;
  final AdStatus status;
  final int expiresInDays;
  final String? adRef;
  final VoidCallback? onReportAd;

  void _handleReportAd() {
    if (onReportAd != null) {
      onReportAd!();
      return;
    }
    if (adRef != null && adRef!.isNotEmpty) {
      AppRoute.pushNamed(
        ReportAdScreen.routeName,
        arguments: {'adRef': adRef},
      );
      return;
    }
    CustomAlertDialog.showCustomDialog(
      title: StringFile.reportAd,
      subtitle: 'Thank you for reporting. Our team will review this ad.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final isExpired = status == AdStatus.expired;
    final isExpiringSoon = status == AdStatus.expiringSoon;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(color: ColorResources.borderColor, height: 1),
        gap12,

        // Registered number row
        RichText(
          text: TextSpan(
            text: StringFile.myRegisteredNumberPrefix,
            style: baseTextStyle.s11.w400.slateGray,
            children: [
              TextSpan(
                text: registeredNumber,
                style: baseTextStyle.s11.w700.black,
              ),
            ],
          ),
        ),
        gap12,
        const Divider(color: ColorResources.borderColor, height: 1),
        gap12,

        // Expiry row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (isExpired)
              Text(
                StringFile.adIsExpired,
                style: baseTextStyle.s11.w700.red,
              )
            else
              RichText(
                text: TextSpan(
                  text: StringFile.expiringInPrefix,
                  style: baseTextStyle.s11.w400.slateGray,
                  children: [
                    TextSpan(
                      text: '$expiresInDays Days',
                      style: baseTextStyle.s11.w700.copyWith(
                        color: isExpiringSoon
                            ? ColorResources.red
                            : ColorResources.black,
                      ),
                    ),
                  ],
                ),
              ),
            GestureDetector(
              onTap: _handleReportAd,
              behavior: HitTestBehavior.opaque,
              child: Text(
                StringFile.reportAd,
                style: baseTextStyle.s11.w400.copyWith(
                  color: ColorResources.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

