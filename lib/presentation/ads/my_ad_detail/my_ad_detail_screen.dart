import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solofy_vendor_app/application/bloc/my_ad_detail_cubit/my_ad_detail_cubit.dart';
import 'package:solofy_vendor_app/application/bloc/my_ad_detail_cubit/my_ad_detail_state.dart';
import 'package:solofy_vendor_app/application/core/route/app_route.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/scale.dart';
import 'package:solofy_vendor_app/application/core/utils/alert_dialog.dart';
import 'package:solofy_vendor_app/application/core/utils/string_file.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/submission.dart';
import 'package:solofy_vendor_app/presentation/ads/ad_detail/widgets/ad_image_carousel.dart';
import 'package:solofy_vendor_app/presentation/ads/ad_detail/widgets/ad_location_row.dart';
import 'package:solofy_vendor_app/presentation/ads/ad_detail/widgets/ad_tag_pill.dart';
import 'package:solofy_vendor_app/presentation/ads/interested_contacts/interested_contacts_screen.dart';
import 'package:solofy_vendor_app/presentation/ads/my_ad_detail/my_ad_detail_config.dart';
import 'package:solofy_vendor_app/presentation/ads/my_ad_detail/widgets/delete_ad_dialog.dart';
import 'package:solofy_vendor_app/presentation/ads/my_ad_detail/widgets/re_post_ad_dialog.dart';
import 'package:solofy_vendor_app/presentation/ads/my_ad_detail/widgets/stop_ad_dialog.dart';
import 'package:solofy_vendor_app/presentation/widgets/ad_status_chip.dart';
import 'package:solofy_vendor_app/presentation/widgets/app_header_bar.dart';
import 'package:solofy_vendor_app/presentation/widgets/custom_dropdown_field.dart';
import 'package:solofy_vendor_app/presentation/widgets/interested_contact_row.dart';
import 'package:solofy_vendor_app/presentation/widgets/outlined_app_button.dart';
import 'package:solofy_vendor_app/presentation/widgets/primary_button.dart';

class MyAdDetailScreen extends StatelessWidget {
  const MyAdDetailScreen({
    super.key,
    required this.ad,
  });

  final Submission ad;

  static const routeName = 'my-ad-detail';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MyAdDetailCubit(ad: ad),
      child: const _MyAdDetailView(),
    );
  }
}

class _MyAdDetailView extends StatelessWidget {
  const _MyAdDetailView();

  void _onStopAd(BuildContext context) {
    final cubit = context.read<MyAdDetailCubit>();
    StopAdDialog.show(
      context,
      onConfirm: () async {
        await cubit.stopAd();
        CustomAlertDialog.showCustomDialog(
          title: StringFile.adStopped,
          subtitle: 'Your Ad has been stopped.',
        );
      },
    );
  }

  void _onEditOrUpdate(BuildContext context, Submission ad) {
    AppRoute.pushNamed('edit-ad', arguments: ad);
  }

  void _onModify(BuildContext context, Submission ad) {
    AppRoute.pushNamed('modify-ad', arguments: ad);
  }

  void startRePostFlow(BuildContext context, Submission ad) {
    RePostAdDialog.show(
      context,
      days: 4,
      onConfirm: () {
        AppRoute.pushReplacementNamed('ad-post-success');
      },
    );
  }

  void _onDeleteAd(BuildContext context) {
    final cubit = context.read<MyAdDetailCubit>();
    DeleteAdDialog.show(
      context,
      onConfirm: () async {
        await cubit.deleteAd();
        CustomAlertDialog.showCustomDialog(
          title: StringFile.adDeleted,
          subtitle: 'Your ad has been deleted.',
        );
        AppRoute.pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomSafe = MediaQuery.paddingOf(context).bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: ColorResources.white,
        body: SafeArea(
          bottom: false,
          child: BlocBuilder<MyAdDetailCubit, MyAdDetailState>(
            builder: (context, state) {
              final ad = state.ad;
              final config = MyAdDetailConfig.fromAd(ad);
              final interestedUsers = state.interestedUsers;
              final previewUsers = interestedUsers.take(4).toList();
              final cubit = context.read<MyAdDetailCubit>();

              return Stack(
                children: [
                  // 1. Scrollable Content Body
                  Positioned.fill(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(
                        16.s,
                        12.s,
                        16.s,
                        // Bottom inset so content scrolls fully above pinned action bar
                        config.actionType == MyAdDetailActionType.none
                            ? 24.s + bottomSafe
                            : 80.s + bottomSafe,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header: Back arrow + centered title
                          AppHeaderBar(
                            title: config.headerTitle,
                            onBack: () => AppRoute.pop(),
                          ),
                          SizedBox(height: 16.s),

                          // Row 1: Ad Ref left + StatusChip right
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text.rich(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  TextSpan(
                                    text: 'Ad Ref : ',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12.s,
                                      fontWeight: FontWeight.w400,
                                      color: ColorResources.grey,
                                      height: 1.2,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: ad.adRef,
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
                              StatusChip(status: config.statusChip),
                            ],
                          ),
                          SizedBox(height: 12.s),

                          // Title Row: Title bold + Tag pills + View count
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        ad.title,
                                        style: GoogleFonts.poppins(
                                          fontSize: 16.s,
                                          fontWeight: FontWeight.w700,
                                          color: ColorResources.textColor,
                                          height: 1.2,
                                        ),
                                      ),
                                    ),
                                    if (ad.plan.toLowerCase() == 'urgent') ...[
                                      SizedBox(width: 8.s),
                                      const AdTagPill(
                                        label: 'Urgent',
                                        color: ColorResources.red,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              SizedBox(width: 8.s),
                              Icon(
                                Icons.visibility_outlined,
                                size: 16.s,
                                color: ColorResources.grey,
                              ),
                              SizedBox(width: 4.s),
                              Text(
                                '${config.overrideViewsCount ?? ad.viewCount}',
                                style: GoogleFonts.poppins(
                                  fontSize: 12.s,
                                  fontWeight: FontWeight.w400,
                                  color: ColorResources.grey,
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6.s),

                          // Posted date row: "Posted : 22 Jul 2025 | 10:00 AM"
                          Text(
                            'Posted : ${ad.postedAt} | 10:00 AM',
                            style: GoogleFonts.poppins(
                              fontSize: 11.s,
                              fontWeight: FontWeight.w400,
                              color: ColorResources.grey,
                              height: 1.2,
                            ),
                          ),
                          if (config.showRePostedRow) ...[
                            SizedBox(height: 4.s),
                            Text(
                              'Re-Posted : ${config.rePostedText}',
                              style: GoogleFonts.poppins(
                                fontSize: 11.s,
                                fontWeight: FontWeight.w400,
                                color: ColorResources.grey,
                                height: 1.2,
                              ),
                            ),
                          ],
                          SizedBox(height: 12.s),

                          // Hairline Divider
                          Container(height: 1.s, color: ColorResources.borderColor),
                          SizedBox(height: 12.s),

                          // Description
                          Text(
                            ad.description,
                            style: GoogleFonts.poppins(
                              fontSize: 12.s,
                              fontWeight: FontWeight.w400,
                              color: ColorResources.textColor,
                              height: 1.45,
                            ),
                          ),
                          SizedBox(height: 16.s),

                          // Image Carousel
                          AdImageCarousel(
                            images: ad.photos.isNotEmpty
                                ? ad.photos
                                : const ['assets/images/pngs/house.png'],
                          ),
                          SizedBox(height: 12.s),

                          // Location Row with Map button
                          AdLocationRow(
                            locationLabel: ad.locationLabel,
                            latitude: 11.2588,
                            longitude: 75.7804,
                          ),
                          SizedBox(height: 12.s),

                          // Divider before owner rows
                          Container(height: 1.s, color: ColorResources.borderColor),
                          SizedBox(height: 12.s),

                          // Phone info row
                          Text.rich(
                            TextSpan(
                              text: config.phoneLabel,
                              style: GoogleFonts.poppins(
                                fontSize: 12.s,
                                fontWeight: FontWeight.w400,
                                color: ColorResources.grey,
                                height: 1.2,
                              ),
                              children: [
                                TextSpan(
                                  text: '+91 ${ad.contactNumber}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12.s,
                                    fontWeight: FontWeight.w600,
                                    color: ColorResources.textColor,
                                    height: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Stopped At row
                          if (config.showStoppedAtRow) ...[
                            SizedBox(height: 12.s),
                            Container(height: 1.s, color: ColorResources.borderColor),
                            SizedBox(height: 12.s),
                            Text.rich(
                              TextSpan(
                                text: StringFile.stoppedAtPrefix,
                                style: GoogleFonts.poppins(
                                  fontSize: 12.s,
                                  fontWeight: FontWeight.w400,
                                  color: ColorResources.grey,
                                  height: 1.2,
                                ),
                                children: [
                                  TextSpan(
                                    text: config.stoppedAtText ?? '',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12.s,
                                      fontWeight: FontWeight.w600,
                                      color: ColorResources.red,
                                      height: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],

                          // Rejection Reason row
                          if (config.showRejectionReason) ...[
                            SizedBox(height: 12.s),
                            Container(height: 1.s, color: ColorResources.borderColor),
                            SizedBox(height: 12.s),
                            Text(
                              StringFile.reasonForRejectionPrefix,
                              style: GoogleFonts.poppins(
                                fontSize: 12.s,
                                fontWeight: FontWeight.w700,
                                color: ColorResources.red,
                                height: 1.2,
                              ),
                            ),
                            SizedBox(height: 8.s),
                            Text(
                              config.rejectionReasonText ?? '',
                              style: GoogleFonts.poppins(
                                fontSize: 12.s,
                                fontWeight: FontWeight.w400,
                                color: ColorResources.textColor,
                                height: 1.4,
                              ),
                            ),
                          ],

                          // Interested Section
                          if (config.showInterestedSection) ...[
                            if (config.showPostingRounds && ad.rounds.isNotEmpty) ...[
                              // Re-Posted Active view (Figma Screenshots 1 + 2)
                              SizedBox(height: 12.s),
                              Container(height: 1.s, color: ColorResources.borderColor),
                              SizedBox(height: 12.s),
                              Text.rich(
                                TextSpan(
                                  text: StringFile.interestedPrefix,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12.s,
                                    fontWeight: FontWeight.w400,
                                    color: ColorResources.grey,
                                    height: 1.2,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '${ad.interestedCount}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12.s,
                                        fontWeight: FontWeight.w700,
                                        color: ColorResources.textColor,
                                        height: 1.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10.s),
                              // Duration picker field from Figma
                              // TODO(design): Connect to duration picker functionality
                              CustomDropdownField<int>(
                                hintText: StringFile.runAdForDaysHint,
                                items: const [1, 2, 3, 4, 5, 7, 10, 15, 30]
                                    .map((d) => DropdownMenuItem(value: d, child: Text('$d Days')))
                                    .toList(),
                                onChanged: (val) {},
                              ),
                              // Section per posting round
                              ...ad.rounds.map((round) {
                                final roundContacts = round.contacts;
                                final previewRoundContacts = roundContacts.take(5).toList();

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 16.s),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text.rich(
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            TextSpan(
                                              text: 'Interested From ${round.ordinalLabel} Post : ',
                                              style: GoogleFonts.poppins(
                                                fontSize: 12.s,
                                                fontWeight: FontWeight.w400,
                                                color: ColorResources.grey,
                                                height: 1.2,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: '${roundContacts.length}',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 12.s,
                                                    fontWeight: FontWeight.w700,
                                                    color: ColorResources.textColor,
                                                    height: 1.2,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        if (roundContacts.length > 5)
                                          GestureDetector(
                                            onTap: () async {
                                              await AppRoute.pushNamed(
                                                InterestedContactsScreen.routeName,
                                                arguments: {
                                                  'ad': ad,
                                                  'roundNumber': round.number,
                                                },
                                              );
                                              if (context.mounted) {
                                                cubit.refreshContacts();
                                              }
                                            },
                                            behavior: HitTestBehavior.opaque,
                                            child: Text(
                                              StringFile.viewAll,
                                              style: GoogleFonts.poppins(
                                                fontSize: 12.s,
                                                fontWeight: FontWeight.w500,
                                                color: ColorResources.primary,
                                                decoration: TextDecoration.underline,
                                                decorationColor: ColorResources.primary,
                                                height: 1.2,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    SizedBox(height: 10.s),
                                    ...previewRoundContacts.map(
                                      (contact) => Padding(
                                        padding: EdgeInsets.only(bottom: 8.s),
                                        child: InterestedContactRow(
                                          key: ValueKey('${round.number}_${contact.id}'),
                                          user: contact,
                                          onMarkChanged: (mark) {
                                            cubit.setMark(contact.id, mark);
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ] else ...[
                              // Standard single list view (Screenshot 5)
                              SizedBox(height: 12.s),
                              Container(height: 1.s, color: ColorResources.borderColor),
                              SizedBox(height: 12.s),

                              // Interested count + View All row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      text: StringFile.interestedPrefix,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12.s,
                                        fontWeight: FontWeight.w400,
                                        color: ColorResources.grey,
                                        height: 1.2,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: '${ad.interestedCount}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 12.s,
                                            fontWeight: FontWeight.w700,
                                            color: ColorResources.textColor,
                                            height: 1.2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (ad.interestedCount > 0 && interestedUsers.isNotEmpty)
                                    GestureDetector(
                                      onTap: () async {
                                        await AppRoute.pushNamed(
                                          InterestedContactsScreen.routeName,
                                          arguments: ad,
                                        );
                                        if (context.mounted) {
                                          cubit.refreshContacts();
                                        }
                                      },
                                      behavior: HitTestBehavior.opaque,
                                      child: Text(
                                        StringFile.viewAll,
                                        style: GoogleFonts.poppins(
                                          fontSize: 12.s,
                                          fontWeight: FontWeight.w500,
                                          color: ColorResources.primary,
                                          decoration: TextDecoration.underline,
                                          decorationColor: ColorResources.primary,
                                          height: 1.2,
                                        ),
                                      ),
                                    ),
                                ],
                              ),

                              // Preview contacts (first 4)
                              if (ad.interestedCount > 0 && previewUsers.isNotEmpty) ...[
                                SizedBox(height: 12.s),
                                ...previewUsers.map(
                                  (user) => Padding(
                                    padding: EdgeInsets.only(bottom: 8.s),
                                    child: InterestedContactRow(
                                      key: ValueKey(user.id),
                                      user: user,
                                      onMarkChanged: (mark) {
                                        cubit.setMark(user.id, mark);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ],
                        ],
                      ),
                    ),
                  ),

                  // 2. Pinned Bottom Action Bar
                  if (config.actionType == MyAdDetailActionType.stopAd)
                    Positioned(
                      left: 16.s,
                      right: 16.s,
                      bottom: 16.s + bottomSafe,
                      child: PrimaryButton(
                        label: StringFile.stopThisAd,
                        onPressed: () => _onStopAd(context),
                      ),
                    )
                  else if (config.actionType == MyAdDetailActionType.editOrUpdateAndStop)
                    Positioned(
                      left: 16.s,
                      right: 16.s,
                      bottom: 16.s + bottomSafe,
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedAppButton(
                              label: StringFile.editOrUpdate,
                              borderColor: ColorResources.borderColor,
                              textColor: ColorResources.primary,
                              backgroundColor: ColorResources.white,
                              onPressed: () => _onEditOrUpdate(context, ad),
                            ),
                          ),
                          SizedBox(width: 14.s),
                          Expanded(
                            child: PrimaryButton(
                              label: StringFile.stopThisAd,
                              onPressed: () => _onStopAd(context),
                            ),
                          ),
                        ],
                      ),
                    )
                  else if (config.actionType == MyAdDetailActionType.modifyAndRePost)
                    Positioned(
                      left: 16.s,
                      right: 16.s,
                      bottom: 16.s + bottomSafe,
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedAppButton(
                              label: StringFile.modify,
                              borderColor: ColorResources.borderColor,
                              textColor: ColorResources.primary,
                              backgroundColor: ColorResources.white,
                              onPressed: () => _onModify(context, ad),
                            ),
                          ),
                          SizedBox(width: 14.s),
                          Expanded(
                            child: PrimaryButton(
                              label: StringFile.rePost,
                              onPressed: () => startRePostFlow(context, ad),
                            ),
                          ),
                        ],
                      ),
                    )
                  else if (config.actionType == MyAdDetailActionType.reRunAd)
                    Positioned(
                      left: 16.s,
                      right: 16.s,
                      bottom: 16.s + bottomSafe,
                      child: PrimaryButton(
                        label: StringFile.reRunThisAd,
                        onPressed: () => startRePostFlow(context, ad),
                      ),
                    )
                  else if (config.actionType == MyAdDetailActionType.deleteAndModify)
                    Positioned(
                      left: 16.s,
                      right: 16.s,
                      bottom: 16.s + bottomSafe,
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedAppButton(
                              label: StringFile.delete,
                              borderColor: ColorResources.red,
                              textColor: ColorResources.red,
                              backgroundColor: ColorResources.white,
                              onPressed: () => _onDeleteAd(context),
                            ),
                          ),
                          SizedBox(width: 14.s),
                          Expanded(
                            child: PrimaryButton(
                              label: StringFile.modify,
                              onPressed: () => _onModify(context, ad),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    const SizedBox.shrink(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
