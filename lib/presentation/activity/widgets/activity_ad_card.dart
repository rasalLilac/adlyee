import 'package:flutter/material.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/diamentions.dart';
import 'package:solofy_vendor_app/application/core/theme/text_styles.dart';
import 'package:solofy_vendor_app/domain/bloc/activity/models/activity_ad_item.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/ad_detail.dart';

class ActivityAdCard extends StatelessWidget {
  const ActivityAdCard({
    super.key,
    required this.ad,
    required this.onTap,
    required this.onRemove,
  });

  final ActivityAdItem ad;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  Widget _buildFeedbackBadge(InterestFeedback feedback) {
    late final String label;
    late final Color textColor;
    late final Color bgColor;

    switch (feedback) {
      case InterestFeedback.suitable:
        label = 'Suitable';
        textColor = ColorResources.statusActiveText;
        bgColor = ColorResources.statusActiveBg;
        break;
      case InterestFeedback.contactAgain:
        label = 'Contact Again';
        textColor = ColorResources.primary;
        bgColor = ColorResources.lightBlue;
        break;
      case InterestFeedback.notSuitable:
        label = 'Not Suitable';
        textColor = ColorResources.red;
        bgColor = ColorResources.statusExpiredBg;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: baseTextStyle.s09.w600.copyWith(color: textColor),
      ),
    );
  }

  Widget _buildRemoveButton() {
    return GestureDetector(
      onTap: onRemove,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 18,
        height: 18,
        decoration: const BoxDecoration(
          color: ColorResources.red,
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: Icon(
            Icons.close,
            color: ColorResources.white,
            size: 11,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: ColorResources.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ColorResources.borderColor),
          boxShadow: [
            BoxShadow(
              color: ColorResources.primaryShadow.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Section
            if (ad.feedback != null) ...[
              // Interests tab has feedback badge on the left & remove button on the right
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildFeedbackBadge(ad.feedback!),
                  _buildRemoveButton(),
                ],
              ),
              gap6,
              // Title + Status dot
              Row(
                children: [
                  Expanded(
                    child: Text(
                      ad.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: baseTextStyle.s13.w700.black,
                    ),
                  ),
                  gap4,
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: ad.dotColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ] else ...[
              // Favourites & Viewed tabs: Title + Status dot on left, remove button on right
              Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            ad.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: baseTextStyle.s13.w700.black,
                          ),
                        ),
                        gap4,
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: ad.dotColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  gap4,
                  _buildRemoveButton(),
                ],
              ),
            ],
            gap6,

            // Metadata: Date & Views
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 11,
                  color: ColorResources.grey,
                ),
                gap4,
                Text(
                  ad.date,
                  style: baseTextStyle.s10.w400.grey,
                ),
                gap8,
                const Icon(
                  Icons.visibility_outlined,
                  size: 11,
                  color: ColorResources.grey,
                ),
                gap4,
                Text(
                  '${ad.views}',
                  style: baseTextStyle.s10.w400.grey,
                ),
              ],
            ),
            gap6,

            // Description
            Text(
              ad.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: baseTextStyle.s10.w400.copyWith(
                color: ColorResources.textColor,
                height: 1.35,
              ),
            ),
            gap8,
            const Divider(color: ColorResources.borderColor, height: 1),
            gap8,

            // Location
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 11,
                  color: ColorResources.grey,
                ),
                gap4,
                Expanded(
                  child: Text(
                    ad.location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: baseTextStyle.s10.w400.grey,
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
