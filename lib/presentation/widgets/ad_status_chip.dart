import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solofy_vendor_app/application/core/theme/scale.dart';
import 'package:solofy_vendor_app/application/core/theme/text_styles.dart';
import 'package:solofy_vendor_app/application/core/utils/string_file.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/ad_detail.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/submission_status.dart';

/// Standalone rounded status chip pill matching Figma design:
/// height 22, horizontal padding 10, Poppins 10 w500, tinted background + coloured text.
class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.status,
  });

  final SubmissionStatus status;

  static const double chipHeight = 22.0;
  static const double paddingH = 10.0;
  static const double chipRadius = 11.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: chipHeight.s,
      padding: EdgeInsets.symmetric(horizontal: paddingH.s),
      decoration: BoxDecoration(
        color: status.bgColor,
        borderRadius: BorderRadius.circular(chipRadius.s),
      ),
      alignment: Alignment.center,
      child: Text(
        status.label,
        style: GoogleFonts.poppins(
          fontSize: 10.s,
          fontWeight: FontWeight.w500,
          color: status.textColor,
          height: 1.2,
        ),
      ),
    );
  }
}

/// Extended shared AdStatusChip:
/// Supports AdDetail row usage (adRef + pill) while delegating pill rendering to StatusChip.
class AdStatusChip extends StatelessWidget {
  const AdStatusChip({
    super.key,
    required this.adRef,
    required this.status,
  });

  final String adRef;
  final AdStatus status;

  @override
  Widget build(BuildContext context) {
    final subStatus = SubmissionStatus.fromAdStatus(status);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
            text: StringFile.adRefPrefix,
            style: baseTextStyle.s11.w400.slateGray,
            children: [
              TextSpan(
                text: adRef,
                style: baseTextStyle.s11.w700.black,
              ),
            ],
          ),
        ),
        StatusChip(status: subStatus),
      ],
    );
  }
}

