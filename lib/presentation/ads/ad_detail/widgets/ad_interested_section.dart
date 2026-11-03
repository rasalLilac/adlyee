import 'package:flutter/material.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/diamentions.dart';
import 'package:solofy_vendor_app/application/core/theme/text_styles.dart';
import 'package:solofy_vendor_app/application/core/utils/string_file.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/ad_detail.dart';
import 'package:solofy_vendor_app/presentation/ads/ad_detail/widgets/ad_owner_contact_card.dart';
import 'package:solofy_vendor_app/presentation/widgets/primary_button.dart';

class AdInterestedSection extends StatelessWidget {
  const AdInterestedSection({
    super.key,
    required this.ad,
    required this.isInterested,
    required this.feedback,
    required this.onInterestTap,
    required this.onFeedbackChanged,
  });

  final AdDetail ad;
  final bool isInterested;
  final InterestFeedback? feedback;
  final VoidCallback onInterestTap;
  final ValueChanged<InterestFeedback> onFeedbackChanged;

  @override
  Widget build(BuildContext context) {
    if (ad.status == AdStatus.expired) {
      return const SizedBox.shrink();
    }

    if (!isInterested) {
      return Column(
        children: [
          gap16,
          Text(
            StringFile.numberSharedDisclaimer,
            textAlign: TextAlign.center,
            style: baseTextStyle.s10.w400.copyWith(
              fontStyle: FontStyle.italic,
              color: ColorResources.textSecondary,
            ),
          ),
          gap16,
          PrimaryButton(
            label: StringFile.iAmInterested,
            onPressed: onInterestTap,
          ),
        ],
      );
    }

    // When isInterested == true
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        gap16,
        AdOwnerContactCard(
          posterName: ad.posterName,
          posterPhone: ad.posterPhone,
          posterOnWhatsApp: ad.posterOnWhatsApp,
          posterAvatarUrl: ad.posterAvatarUrl,
        ),
        gap16,

        // "This Ad is listed in your interested list"
        Text(
          StringFile.adInInterestedList,
          style: baseTextStyle.s10.w400.slateGray,
        ),
        gap10,

        // 3 Radio options in one row (Suitable / Contact Again / Not Suitable)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _SelectableRadio(
              label: StringFile.suitable,
              isSelected: feedback == InterestFeedback.suitable,
              onTap: () => onFeedbackChanged(InterestFeedback.suitable),
            ),
            _SelectableRadio(
              label: StringFile.contactAgain,
              isSelected: feedback == InterestFeedback.contactAgain,
              onTap: () => onFeedbackChanged(InterestFeedback.contactAgain),
            ),
            _SelectableRadio(
              label: StringFile.notSuitable,
              isSelected: feedback == InterestFeedback.notSuitable,
              onTap: () => onFeedbackChanged(InterestFeedback.notSuitable),
            ),
          ],
        ),
      ],
    );
  }
}

class _SelectableRadio extends StatelessWidget {
  const _SelectableRadio({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? ColorResources.primary : ColorResources.grey,
                width: 1.5,
              ),
            ),
            child: isSelected
              ? Center(
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: ColorResources.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                )
              : null,
          ),
          gap6,
          Text(
            label,
            style: baseTextStyle.s10.w500.copyWith(
              color: isSelected ? ColorResources.black : ColorResources.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

