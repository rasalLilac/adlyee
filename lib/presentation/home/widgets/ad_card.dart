import 'package:flutter/material.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/diamentions.dart';
import 'package:solofy_vendor_app/application/core/theme/text_styles.dart';
import 'package:solofy_vendor_app/presentation/home/models/ad_item.dart';
import 'package:solofy_vendor_app/presentation/home/widgets/corner_ribbon.dart';
import 'package:solofy_vendor_app/presentation/widgets/admin_banner_card.dart';

/// Renders either a standard ad card or an in-feed promo banner card.
class AdCard extends StatelessWidget {
  const AdCard({
    super.key,
    required this.ad,
    this.onTap,
  });

  final AdItem ad;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (ad.isBanner) {
      return const AdminBannerCard(height: double.infinity, iconHeight: 32);
    }

    return Container(
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Top row: status chip + dot indicator (if present)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _StatusChip(status: ad.status),
                        if (ad.dotColor != null)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: ad.dotColor,
                              shape: BoxShape.circle,
                            ),
                          )
                        else
                          const SizedBox(width: 8, height: 8),
                      ],
                    ),
                    gap8,

                    // Title
                    Text(
                      ad.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: baseTextStyle.s13.w700.black,
                    ),
                    gap4,

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
                          style: baseTextStyle.s10.w400.slateGray,
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.visibility_outlined,
                          size: 12,
                          color: ColorResources.grey,
                        ),
                        gap4,
                        Text(
                          '${ad.views}',
                          style: baseTextStyle.s10.w400.slateGray,
                        ),
                      ],
                    ),
                    gap8,

                    // Description
                    Text(
                      ad.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: baseTextStyle.s10.w400.copyWith(
                        color: const Color(0xFF555555),
                        height: 1.3,
                      ),
                    ),
                    gap8,

                    const Divider(
                      height: 1,
                      thickness: 0.8,
                      color: ColorResources.borderColor,
                    ),
                    gap6,

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
                            style: baseTextStyle.s09.w400.slateGray,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Top-right corner ribbon (New, Featured, Urgent)
            if (ad.ribbon != null) _buildRibbon(ad.ribbon!),
          ],
        ),
      ),
    );
  }

  Widget _buildRibbon(AdRibbon ribbon) {
    switch (ribbon) {
      case AdRibbon.newBadge:
        return const CornerRibbon(text: 'New', color: ColorResources.green);
      case AdRibbon.featured:
        return const CornerRibbon(text: 'Featured', color: Color(0xFF9C27B0));
      case AdRibbon.urgent:
        return const CornerRibbon(text: 'Urgent', color: ColorResources.red);
    }
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final AdStatus status;

  @override
  Widget build(BuildContext context) {
    late final String label;
    late final Color color;

    switch (status) {
      case AdStatus.viewed:
        label = 'Viewed';
        color = ColorResources.primary;
        break;
      case AdStatus.unread:
        label = 'Unread';
        color = const Color(0xFF5A6E85);
        break;
      case AdStatus.suitable:
        label = 'Suitable';
        color = ColorResources.green;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 0.8),
      ),
      child: Text(
        label,
        style: baseTextStyle.s09.w500.copyWith(color: color),
      ),
    );
  }
}

