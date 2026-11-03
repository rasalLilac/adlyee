import 'package:flutter/material.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/diamentions.dart';
import 'package:solofy_vendor_app/application/core/theme/text_styles.dart';
import 'package:solofy_vendor_app/application/core/utils/string_file.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/ad_detail.dart';
import 'package:solofy_vendor_app/presentation/ads/ad_detail/widgets/ad_tag_pill.dart';

class AdInfoRow extends StatelessWidget {
  const AdInfoRow({super.key, required this.ad});

  final AdDetail ad;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title, New/Urgent tags, and View Count
        Row(
          children: [
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      ad.title,
                      style: baseTextStyle.s16.w700.black,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (ad.isNew) ...[
                    gap8,
                    const AdTagPill(
                      label: StringFile.newTag,
                      color: ColorResources.green,
                    ),
                  ],
                  if (ad.isUrgent) ...[
                    gap6,
                    const AdTagPill(
                      label: StringFile.urgentTag,
                      color: ColorResources.red,
                    ),
                  ],
                ],
              ),
            ),
            gap8,
            Row(
              children: [
                const Icon(
                  Icons.visibility_outlined,
                  size: 14,
                  color: ColorResources.grey,
                ),
                gap4,
                Text(
                  '${ad.viewCount}',
                  style: baseTextStyle.s12.w400.slateGray,
                ),
              ],
            ),
          ],
        ),
        gap4,

        // Posted date
        RichText(
          text: TextSpan(
            text: StringFile.postedPrefix,
            style: baseTextStyle.s10.w400.slateGray,
            children: [
              TextSpan(
                text: ad.postedAt,
                style: baseTextStyle.s10.w500.black,
              ),
            ],
          ),
        ),
        gap12,
        const Divider(color: ColorResources.borderColor, height: 1),
        gap12,

        // Description text
        Text(
          ad.description,
          style: baseTextStyle.s11.w400.copyWith(
            color: ColorResources.textSecondary,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}

