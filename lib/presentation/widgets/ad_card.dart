import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solofy_vendor_app/application/core/route/app_route.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/scale.dart';
import 'package:solofy_vendor_app/application/core/utils/app_assets.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/ad_detail.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/ad_model.dart';
import 'package:solofy_vendor_app/presentation/ads/ad_detail/ad_detail_screen.dart';
import 'package:solofy_vendor_app/presentation/widgets/admin_banner_card.dart';
import 'package:solofy_vendor_app/presentation/widgets/corner_ribbon.dart';

/// Unified compact AdCard matching Figma design (175 x 155, or 172 high for Interests).
class AdCard extends StatelessWidget {
  const AdCard({
    super.key,
    required this.ad,
    this.showRibbon,
    this.showUnread,
    this.feedback,
    this.onRemove,
    this.onTap,
  });

  final AdModel ad;
  final bool? showRibbon;
  final bool? showUnread;
  final InterestFeedback? feedback;
  final VoidCallback? onRemove;
  final VoidCallback? onTap;

  // Named private constants in design px, scaled with .s
  static const double cardWidth = 175.0;
  static const double cardHeightNoLabel = 155.0;
  static const double cardHeightWithLabel = 172.0;
  static const double badgeInset = 11.0;
  static const double cardRadius = 12.0;
  static const double paddingH = 12.0;
  static const double paddingV = 10.0;
  static const double dotSize = 8.0;
  static const double dotGap = 8.0;
  static const double iconSize = 14.0;
  static const double iconTextGap = 4.0;
  static const double dividerSpacing = 6.0;
  static const double badgeSize = 22.0;
  static const double badgeIconSize = 12.0;
  static const double badgeTapTarget = 44.0;

  /// Cell height in the grid: includes 11.s extra top spacing when remove badge is present
  static double cellHeight({required bool hasLabel, required bool hasRemove}) {
    final base = hasLabel ? cardHeightWithLabel : cardHeightNoLabel;
    return (hasRemove ? base + badgeInset : base).s;
  }

  Widget _buildFeedbackLabel(InterestFeedback fb) {
    late final String label;
    late final Color textColor;

    switch (fb) {
      case InterestFeedback.suitable:
        label = 'Suitable';
        textColor = ColorResources.statusActiveText;
        break;
      case InterestFeedback.contactAgain:
        label = 'Contact Again';
        textColor = ColorResources.primary;
        break;
      case InterestFeedback.notSuitable:
        label = 'Not Suitable';
        textColor = ColorResources.statusExpiredText;
        break;
    }

    return Text(
      label,
      style: GoogleFonts.poppins(
        fontSize: 10.5.s,
        fontWeight: FontWeight.w500,
        color: textColor,
        height: 1.2,
      ),
      textHeightBehavior: const TextHeightBehavior(
        applyHeightToFirstAscent: false,
        applyHeightToLastDescent: false,
      ),
    );
  }

  Widget? _buildRibbon() {
    if (showRibbon == false || onRemove != null) return null;

    final type = ad.ribbonType;
    if (type == null) return null;

    switch (type) {
      case AdRibbonType.newBadge:
        return const CornerRibbon(text: 'New', color: ColorResources.green);
      case AdRibbonType.featured:
        return const CornerRibbon(text: 'Featured', color: ColorResources.purple);
      case AdRibbonType.urgent:
        return const CornerRibbon(text: 'Urgent', color: ColorResources.red);
    }
  }

  Widget? _buildStatusChip() {
    final shouldShow = showUnread ?? (onRemove == null && feedback == null);
    if (!shouldShow) return null;

    final isUnread = ad.isUnread;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.s, vertical: 2.s),
      decoration: BoxDecoration(
        color: ColorResources.white,
        borderRadius: BorderRadius.circular(10.s),
        border: Border.all(color: ColorResources.borderColor, width: 1.s),
      ),
      child: Text(
        isUnread ? 'Unread' : 'Viewed',
        style: GoogleFonts.poppins(
          fontSize: 9.5.s,
          fontWeight: FontWeight.w500,
          color: isUnread ? ColorResources.primary : ColorResources.grey,
          height: 1.2,
        ),
      ),
    );
  }

  void _handleTap() {
    if (onTap != null) {
      onTap!();
      return;
    }
    AppRoute.pushNamed(
      AdDetailScreen.routeName,
      arguments: {
        'ad': ad.toAdDetail(),
        'isInterested': (feedback ?? ad.feedback) != null,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (ad.isBanner) {
      return const AdminBannerCard(height: double.infinity, iconHeight: 32);
    }

    final effectiveFeedback = feedback ?? ad.feedback;
    final hasLabel = effectiveFeedback != null;
    final ribbon = _buildRibbon();
    final statusChip = _buildStatusChip();
    final targetCardHeight = (hasLabel ? cardHeightWithLabel : cardHeightNoLabel).s;

    // The visible white card with exact borders, shadow and content
    final visibleCard = Container(
      height: targetCardHeight,
      decoration: BoxDecoration(
        color: ColorResources.white,
        borderRadius: BorderRadius.circular(cardRadius.s),
        border: Border.all(color: ColorResources.borderColor, width: 1.s),
        boxShadow: [
          BoxShadow(
            color: ColorResources.primaryShadow.withValues(alpha: 0.06),
            blurRadius: 8.s,
            offset: Offset(0, 2.s),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(cardRadius.s),
        child: Stack(
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _handleTap,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: paddingH.s,
                    vertical: paddingV.s,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 1. Optional plain colored label (Interests only) or status chip (Home only)
                      if (hasLabel) ...[
                        _buildFeedbackLabel(effectiveFeedback),
                        SizedBox(height: 2.s),
                      ] else if (statusChip != null) ...[
                        statusChip,
                        SizedBox(height: 2.s),
                      ],

                      // 2. Title + status dot IMMEDIATELY after title (Row: Flexible(title) + 8 gap + dot)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              ad.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: 14.s,
                                fontWeight: FontWeight.w600,
                                color: ColorResources.black,
                                height: 1.2,
                              ),
                              textHeightBehavior: const TextHeightBehavior(
                                applyHeightToFirstAscent: false,
                                applyHeightToLastDescent: false,
                              ),
                            ),
                          ),
                          if (ribbon == null) ...[
                            SizedBox(width: dotGap.s),
                            Container(
                              width: dotSize.s,
                              height: dotSize.s,
                              decoration: BoxDecoration(
                                color: ad.dotColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 4.s),

                      // 3. Date & View count row
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
                          SizedBox(width: iconTextGap.s),
                          Flexible(
                            child: Text(
                              ad.postedAt,
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
                          const Spacer(),
                          Icon(
                            Icons.visibility_outlined,
                            size: iconSize.s,
                            color: ColorResources.grey,
                          ),
                          SizedBox(width: iconTextGap.s),
                          Text(
                            '${ad.viewCount}',
                            style: GoogleFonts.poppins(
                              fontSize: 11.s,
                              fontWeight: FontWeight.w400,
                              color: ColorResources.grey,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),

                      // 4. Divider 1 with 6 spacing
                      SizedBox(height: dividerSpacing.s),
                      Container(
                        height: 1.s,
                        color: ColorResources.borderColor,
                      ),
                      SizedBox(height: dividerSpacing.s),

                      // 5. Description: 12 regular, line height 1.35, maxLines 3
                      Expanded(
                        child: Text(
                          ad.description,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 12.s,
                            fontWeight: FontWeight.w400,
                            color: ColorResources.textColor,
                            height: 1.35,
                          ),
                        ),
                      ),

                      // 6. Divider 2 with 6 spacing
                      SizedBox(height: dividerSpacing.s),
                      Container(
                        height: 1.s,
                        color: ColorResources.borderColor,
                      ),
                      SizedBox(height: dividerSpacing.s),

                      // 7. Location row: pin icon + location text 11 grey
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
                          SizedBox(width: iconTextGap.s),
                          Expanded(
                            child: Text(
                              ad.locationLabel,
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
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            if (ribbon != null) ribbon,
          ],
        ),
      ),
    );

    // If there is no remove callback (e.g. Home tab), return visibleCard directly
    if (onRemove == null) {
      return visibleCard;
    }

    // When onRemove is provided (Favourites/Interests/Viewed tab - FIX D):
    // Grid cell has 11 extra at the top and 11 extra at the right.
    // Card is positioned at left: 0, bottom: 0, top: 11.s, right: 11.s.
    // Badge is positioned at top: 0, right: 0 (center is at x = cellWidth - 11, y = 11),
    // wrapped in a 44x44 transparent GestureDetector for effortless tapping.
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: 0,
          bottom: 0,
          top: badgeInset.s,
          right: badgeInset.s,
          child: visibleCard,
        ),
        Positioned(
          top: 0,
          right: 0,
          width: badgeTapTarget.s,
          height: badgeTapTarget.s,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onRemove,
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                width: badgeSize.s,
                height: badgeSize.s,
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ColorResources.white,
                    width: 1.5.s,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 4.s,
                      offset: Offset(0, 1.5.s),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.close_rounded,
                    size: badgeIconSize.s,
                    color: ColorResources.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
