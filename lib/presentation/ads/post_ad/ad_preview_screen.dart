import 'package:flutter/material.dart';
import 'package:solofy_vendor_app/application/core/route/app_route.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/diamentions.dart';
import 'package:solofy_vendor_app/application/core/theme/text_styles.dart';
import 'package:solofy_vendor_app/application/core/utils/app_assets.dart';
import 'package:solofy_vendor_app/application/core/utils/constants.dart';
import 'package:solofy_vendor_app/application/core/utils/string_file.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/ad_detail.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/ad_draft.dart';
import 'package:solofy_vendor_app/presentation/ads/ad_detail/widgets/ad_image_carousel.dart';
import 'package:solofy_vendor_app/presentation/ads/ad_detail/widgets/ad_location_row.dart';
import 'package:solofy_vendor_app/presentation/ads/ad_detail/widgets/ad_status_chip.dart';
import 'package:solofy_vendor_app/presentation/ads/ad_detail/widgets/ad_tag_pill.dart';
import 'package:solofy_vendor_app/presentation/ads/post_ad/ad_post_success_screen.dart';
import 'package:solofy_vendor_app/presentation/ads/report_ad/report_ad_screen.dart';
import 'package:solofy_vendor_app/presentation/widgets/app_header_bar.dart';
import 'package:solofy_vendor_app/presentation/widgets/app_page_scaffold.dart';
import 'package:solofy_vendor_app/presentation/widgets/outlined_app_button.dart';
import 'package:solofy_vendor_app/presentation/widgets/primary_button.dart';

class AdPreviewScreen extends StatefulWidget {
  const AdPreviewScreen({super.key, required this.draft});

  final AdDraft draft;

  static const routeName = 'ad-preview';

  @override
  State<AdPreviewScreen> createState() => _AdPreviewScreenState();
}

class _AdPreviewScreenState extends State<AdPreviewScreen> {
  bool _isPaying = false;

  Future<void> _onPay() async {
    if (_isPaying) return;
    setState(() => _isPaying = true);

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    setState(() => _isPaying = false);

    AppRoute.pushReplacementNamed(
      AdPostSuccessScreen.routeName,
      arguments: {'adRef': widget.draft.adRef},
    );
  }

  void _onReportAd() {
    AppRoute.pushNamed(
      ReportAdScreen.routeName,
      arguments: {'adRef': widget.draft.adRef},
    );
  }

  String _formatTitle() {
    final cat = widget.draft.category.trim();
    final sub = widget.draft.subCategory.trim();
    if (cat.isEmpty) return 'Ad Preview';
    if (sub.isEmpty || sub.toLowerCase() == 'all') return cat;
    if (cat.toLowerCase().contains(sub.toLowerCase())) return cat;
    return '$cat For $sub';
  }

  @override
  Widget build(BuildContext context) {
    final draft = widget.draft;
    final isUrgent = draft.plan == AdPlan.urgent;
    final images = draft.images.isNotEmpty
        ? draft.images
        : const [AppAssets.housePng];
    final description = draft.description.isNotEmpty
        ? draft.description
        : (draft.displayDescription.isNotEmpty
            ? draft.displayDescription
            : 'Lorem Ipsum Is Simply Dummy Text Of The Printing And Typesetting Industry.');

    return AppPageScaffold(
      horizontalPadding: 18,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Bar with back arrow and centered title
          const AppHeaderBar(
            title: StringFile.previewOfYourAd,
          ),
          gap16,

          // Ad Ref + Status Chip
          AdStatusChip(
            adRef: draft.adRef,
            status: AdStatus.active,
          ),
                    gap12,

                    // Title row + New/Urgent tags + Views count
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  _formatTitle(),
                                  style: baseTextStyle.s16.w700.black,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              gap8,
                              const AdTagPill(
                                label: StringFile.newTag,
                                color: ColorResources.green,
                              ),
                              if (isUrgent) ...[
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
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.visibility_outlined,
                              size: 16,
                              color: ColorResources.grey,
                            ),
                            gap4,
                            Text(
                              '0',
                              style: baseTextStyle.s12.w400.grey,
                            ),
                          ],
                        ),
                      ],
                    ),
                    gap6,

                    // Posted date/time
                    Text(
                      'Posted : 22 Jul 2025 | 10:00 AM',
                      style: baseTextStyle.s11.w400.grey,
                    ),
                    gap12,
                    const Divider(color: ColorResources.borderColor, height: 1),
                    gap12,

                    // Description
                    Text(
                      description,
                      style: baseTextStyle.s12.w400.copyWith(
                        color: ColorResources.textColor,
                        height: 1.45,
                      ),
                    ),
                    gap16,

                    // Horizontal image carousel with dots indicator
                    AdImageCarousel(images: images),
                    gap12,

                    // Location row with pin and round Google Map button
                    AdLocationRow(
                      locationLabel: draft.localityOrPincode.isNotEmpty
                          ? draft.localityOrPincode
                          : 'Pincode, Palazhi , Calicut',
                      latitude: 11.2468,
                      longitude: 75.8343,
                    ),
                    gap12,
                    const Divider(color: ColorResources.borderColor, height: 1),
                    gap12,

                    // Phone numbers
                    if (draft.alternatePhone.isNotEmpty) ...[
                      RichText(
                        text: TextSpan(
                          text: '${StringFile.alternateNumberPrefix} : ',
                          style: baseTextStyle.s11.w400.slateGray,
                          children: [
                            TextSpan(
                              text: '+91 ${draft.alternatePhone}',
                              style: baseTextStyle.s11.w700.black,
                            ),
                          ],
                        ),
                      ),
                      gap8,
                    ],
                    RichText(
                      text: TextSpan(
                        text: '${StringFile.contactNumberPrefix} : ',
                        style: baseTextStyle.s11.w400.slateGray,
                        children: [
                          TextSpan(
                            text: AppConstants.defaultVendorPhone,
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
                        RichText(
                          text: TextSpan(
                            text: StringFile.expiringInPrefix,
                            style: baseTextStyle.s11.w400.slateGray,
                            children: [
                              TextSpan(
                                text: '${draft.runDays} Days',
                                style: baseTextStyle.s11.w700.black,
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: _onReportAd,
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
                    gap24,

                    // Bottom Buttons: Edit (pops back) + Pay ₹price (proceeds to success)
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedAppButton(
                            label: StringFile.edit,
                            onPressed: () => AppRoute.pop(),
                          ),
                        ),
                        gap16,
                        Expanded(
                          child: PrimaryButton(
                            label: '${StringFile.pay} ₹${draft.price}',
                            isLoading: _isPaying,
                            onPressed: _onPay,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
    );
  }
}
