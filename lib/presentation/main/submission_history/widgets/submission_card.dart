import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solofy_vendor_app/application/core/route/app_route.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/scale.dart';
import 'package:solofy_vendor_app/application/core/utils/app_assets.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/submission.dart';
import 'package:solofy_vendor_app/presentation/ads/my_ad_detail/my_ad_detail_screen.dart';
import 'package:solofy_vendor_app/presentation/widgets/ad_status_chip.dart';

class SubmissionCard extends StatelessWidget {
  const SubmissionCard({
    super.key,
    required this.submission,
    this.onTap,
  });

  final Submission submission;
  final VoidCallback? onTap;

  static const double cardRadius = 12.0;
  static const double paddingH = 16.0;
  static const double paddingV = 12.0;
  static const double iconSize = 14.0;
  static const double iconGap = 4.0;
  static const double dividerSpacing = 6.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ??
          () {
            AppRoute.pushNamed(
              MyAdDetailScreen.routeName,
              arguments: submission,
            );
          },
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: ColorResources.white,
          borderRadius: BorderRadius.circular(cardRadius.s),
          border: Border.all(
            color: ColorResources.borderColor,
            width: 1.s,
          ),
          boxShadow: [
            BoxShadow(
              color: ColorResources.primaryShadow.withValues(alpha: 0.08),
              blurRadius: 8.s,
              offset: Offset(0, 2.s),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(
          horizontal: paddingH.s,
          vertical: paddingV.s,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Row 1: Ad Ref left + StatusChip right
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: RichText(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      text: 'Ad Ref : ',
                      style: GoogleFonts.poppins(
                        fontSize: 12.s,
                        fontWeight: FontWeight.w400,
                        color: ColorResources.grey,
                        height: 1.2,
                      ),
                      children: [
                        TextSpan(
                          text: submission.adRef,
                          style: GoogleFonts.poppins(
                            fontSize: 12.s,
                            fontWeight: FontWeight.w500,
                            color: ColorResources.textColor,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 8.s),
                StatusChip(status: submission.status),
              ],
            ),
            SizedBox(height: 8.s),

            // Title: e.g. "Rent House" Poppins 14 w600
            Text(
              submission.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 14.s,
                fontWeight: FontWeight.w600,
                color: ColorResources.textColor,
                height: 1.2,
              ),
            ),
            SizedBox(height: 8.s),

            // Date & View count row
            Row(
              children: [
                SvgPicture.asset(
                  AppAssets.calendarSvg,
                  width: iconSize.s,
                  height: iconSize.s,
                  colorFilter: const ColorFilter.mode(
                    ColorResources.grey,
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(width: iconGap.s),
                Text(
                  submission.postedAt,
                  style: GoogleFonts.poppins(
                    fontSize: 11.s,
                    fontWeight: FontWeight.w400,
                    color: ColorResources.textColor,
                    height: 1.2,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.visibility_outlined,
                  size: iconSize.s,
                  color: ColorResources.grey,
                ),
                SizedBox(width: iconGap.s),
                Text(
                  '${submission.viewCount}',
                  style: GoogleFonts.poppins(
                    fontSize: 11.s,
                    fontWeight: FontWeight.w400,
                    color: ColorResources.grey,
                    height: 1.2,
                  ),
                ),
              ],
            ),

            // Hairline divider 1
            SizedBox(height: dividerSpacing.s),
            Container(height: 1.s, color: ColorResources.borderColor),
            SizedBox(height: dividerSpacing.s),

            // Description: 1 line, ellipsis, 11 grey
            Text(
              submission.description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 11.s,
                fontWeight: FontWeight.w400,
                color: ColorResources.grey,
                height: 1.2,
              ),
            ),

            // Hairline divider 2
            SizedBox(height: dividerSpacing.s),
            Container(height: 1.s, color: ColorResources.borderColor),
            SizedBox(height: dividerSpacing.s),

            // Footer row: location left + interested count right
            Row(
              children: [
                SvgPicture.asset(
                  AppAssets.locationSvg,
                  width: iconSize.s,
                  height: iconSize.s,
                  colorFilter: const ColorFilter.mode(
                    ColorResources.grey,
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(width: iconGap.s),
                Expanded(
                  child: Text(
                    submission.locationLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 11.s,
                      fontWeight: FontWeight.w400,
                      color: ColorResources.grey,
                      height: 1.2,
                    ),
                  ),
                ),
                SizedBox(width: 8.s),
                RichText(
                  text: TextSpan(
                    text: 'Interested : ',
                    style: GoogleFonts.poppins(
                      fontSize: 11.s,
                      fontWeight: FontWeight.w400,
                      color: ColorResources.grey,
                      height: 1.2,
                    ),
                    children: [
                      TextSpan(
                        text: '${submission.interestedCount}',
                        style: GoogleFonts.poppins(
                          fontSize: 11.s,
                          fontWeight: FontWeight.w700,
                          color: ColorResources.textColor,
                          height: 1.2,
                        ),
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
