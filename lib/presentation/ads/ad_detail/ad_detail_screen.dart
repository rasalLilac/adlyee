import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solofy_vendor_app/application/bloc/ad_detail_cubit/ad_detail_cubit.dart';
import 'package:solofy_vendor_app/application/bloc/ad_detail_cubit/ad_detail_state.dart';
import 'package:solofy_vendor_app/application/core/theme/diamentions.dart';
import 'package:solofy_vendor_app/application/core/utils/alert_dialog.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/ad_detail.dart';
import 'package:solofy_vendor_app/presentation/ads/ad_detail/widgets/ad_banner_carousel.dart';
import 'package:solofy_vendor_app/presentation/ads/ad_detail/widgets/ad_expiry_row.dart';
import 'package:solofy_vendor_app/presentation/ads/ad_detail/widgets/ad_header_bar.dart';
import 'package:solofy_vendor_app/presentation/ads/ad_detail/widgets/ad_image_carousel.dart';
import 'package:solofy_vendor_app/presentation/ads/ad_detail/widgets/ad_info_row.dart';
import 'package:solofy_vendor_app/presentation/ads/ad_detail/widgets/ad_interested_section.dart';
import 'package:solofy_vendor_app/presentation/ads/ad_detail/widgets/ad_job_details.dart';
import 'package:solofy_vendor_app/presentation/ads/ad_detail/widgets/ad_location_row.dart';
import 'package:solofy_vendor_app/presentation/ads/ad_detail/widgets/ad_status_chip.dart';
import 'package:solofy_vendor_app/presentation/widgets/app_page_scaffold.dart';

class AdDetailScreen extends StatelessWidget {
  const AdDetailScreen({
    super.key,
    required this.ad,
    this.initialInterested = false,
  });

  final AdDetail ad;
  final bool initialInterested;

  static const routeName = 'ad-detail';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdDetailCubit(
        ad: ad,
        initialInterested: initialInterested,
      ),
      child: const _AdDetailView(),
    );
  }
}

class _AdDetailView extends StatelessWidget {
  const _AdDetailView();

  void _onShare(BuildContext context, String title) {
    CustomAlertDialog.showCustomDialog(
      title: 'Share Ad',
      subtitle: 'Link for "$title" copied to clipboard.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      horizontalPadding: 18,
      child: BlocBuilder<AdDetailCubit, AdDetailState>(
        builder: (context, state) {
          final ad = state.ad;
          final cubit = context.read<AdDetailCubit>();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header row
              AdHeaderBar(
                isFavorite: state.isFavorite,
                onFavoriteTap: () {
                  cubit.toggleFavorite();
                  CustomAlertDialog.showCustomDialog(
                    title: state.isFavorite
                        ? 'Removed from Favourites'
                        : 'Added to Favourites',
                    subtitle: ad.title,
                  );
                },
                onShareTap: () => _onShare(context, ad.title),
              ),
              gap12,

              // 2. Ad Ref & Status Chip
              AdStatusChip(
                adRef: ad.adRef,
                status: ad.status,
              ),
              gap10,

              // 3. Title row, Tags, View count, 4. Posted date, 5. Description
              AdInfoRow(ad: ad),
              gap12,

              // 6. Body by AdType (Property Image Carousel vs Job Details)
              if (ad.type == AdType.property) ...[
                AdImageCarousel(images: ad.images),
                gap12,
              ] else ...[
                AdJobDetails(
                  skills: ad.skills,
                  otherInfo: ad.otherInfo,
                ),
              ],

              // 7. Divider + Location row with Map button
              AdLocationRow(
                locationLabel: ad.locationLabel,
                latitude: ad.latitude,
                longitude: ad.longitude,
              ),
              gap12,

              // 8. Registered Number, 9. Expiry row
              AdExpiryRow(
                registeredNumber: ad.registeredNumber,
                status: ad.status,
                expiresInDays: ad.expiresInDays,
                adRef: ad.adRef,
              ),

              // 10. Bottom Area based on state (Interested / Contact / Expired)
              AdInterestedSection(
                ad: ad,
                isInterested: state.isInterested,
                feedback: state.feedback,
                onInterestTap: () => cubit.markInterested(),
                onFeedbackChanged: (feedback) => cubit.setFeedback(feedback),
              ),
              gap20,

              // 11. Admin Banner Carousel (auto-scroll every 3s)
              const AdBannerCarousel(),
            ],
          );
        },
      ),
    );
  }
}

