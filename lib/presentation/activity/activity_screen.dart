import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solofy_vendor_app/application/bloc/activity_cubit/activity_cubit.dart';
import 'package:solofy_vendor_app/application/bloc/activity_cubit/activity_state.dart';
import 'package:solofy_vendor_app/application/core/route/app_route.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/diamentions.dart';
import 'package:solofy_vendor_app/application/core/theme/scale.dart';
import 'package:solofy_vendor_app/application/core/theme/text_styles.dart';
import 'package:solofy_vendor_app/application/core/utils/alert_dialog.dart';
import 'package:solofy_vendor_app/application/core/utils/string_file.dart';
import 'package:solofy_vendor_app/domain/bloc/activity/models/activity_ad_item.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/ad_mock.dart';
import 'package:solofy_vendor_app/presentation/activity/widgets/activity_ad_card.dart';
import 'package:solofy_vendor_app/presentation/activity/widgets/activity_filter_row.dart';
import 'package:solofy_vendor_app/presentation/activity/widgets/activity_search_bar.dart';
import 'package:solofy_vendor_app/presentation/activity/widgets/activity_tab_bar.dart';
import 'package:solofy_vendor_app/presentation/activity/widgets/remove_ad_dialog.dart';
import 'package:solofy_vendor_app/presentation/ads/ad_detail/ad_detail_screen.dart';
import 'package:solofy_vendor_app/presentation/ads/post_ad/post_ad_screen.dart';
import 'package:solofy_vendor_app/presentation/home/models/ad_item.dart';
import 'package:solofy_vendor_app/presentation/home/widgets/bottom_nav_bar.dart';
import 'package:solofy_vendor_app/presentation/home/widgets/filter_modal.dart';

import 'package:solofy_vendor_app/presentation/main/main_shell.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({
    super.key,
    this.initialTab = ActivityTab.favourites,
    this.showBottomNav = true,
    this.onHomeNavTap,
  });

  final ActivityTab initialTab;
  final bool showBottomNav;
  final VoidCallback? onHomeNavTap;

  static const routeName = 'activity';

  @override
  Widget build(BuildContext context) {
    return const MainShell(initialTab: 1);
  }
}

class ActivityView extends StatefulWidget {
  const ActivityView({
    super.key,
    this.showBottomNav = true,
    this.onHomeNavTap,
  });

  final bool showBottomNav;
  final VoidCallback? onHomeNavTap;

  @override
  State<ActivityView> createState() => _ActivityViewState();
}

class _ActivityViewState extends State<ActivityView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onAdTapped(ActivityAdItem item) {
    final base = item.category.toLowerCase().contains('job')
        ? AdMock.jobExpiringSoon
        : AdMock.propertyActive;

    final detail = base.copyWith(
      adRef: item.adRef,
      title: item.title,
      description: item.description,
      locationLabel: item.location,
      status: item.status,
    );

    AppRoute.pushNamed(
      AdDetailScreen.routeName,
      arguments: {
        'ad': detail,
        'isInterested': item.feedback != null,
      },
    );
  }

  void _onPromptRemove(BuildContext context, ActivityCubit cubit, ActivityAdItem ad) {
    cubit.promptRemove(ad);
    RemoveAdDialog.show(
      context,
      onConfirm: () => cubit.confirmRemove(),
    );
  }

  void _openFilterModal(BuildContext context, ActivityCubit cubit) {
    FilterModal.show(
      context: context,
      initialFilter: const AdFilter(),
      onApply: (filter) {
        cubit.setCategory(filter.category);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ActivityCubit>();

    return Scaffold(
      backgroundColor: ColorResources.white,
      body: SafeArea(
        child: Stack(
          children: [
            BlocBuilder<ActivityCubit, ActivityState>(
              builder: (context, state) {
                final items = state.activeList;

                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    18.s,
                    14.s,
                    18.s,
                    widget.showBottomNav ? 90.s : 24.s,
                  ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 1. Search Bar with filter sliders icon
                            ActivitySearchBar(
                              controller: _searchController,
                              onChanged: (q) => cubit.updateSearch(q),
                              onFilterTap: () => _openFilterModal(context, cubit),
                            ),
                            gap12,

                            // 2. 3 Pill Tabs: Favourites / Interests / Viewed
                            ActivityTabBar(
                              selectedTab: state.selectedTab,
                              onTabSelected: (tab) => cubit.selectTab(tab),
                            ),
                            gap12,

                            // 3. Dropdowns & Results Count
                            ActivityFilterRow(
                              resultCount: items.length,
                              selectedCategory: state.selectedCategory,
                              selectedSort: state.selectedSort,
                              selectedFilter: state.selectedFilter,
                              onCategoryTap: () => _openFilterModal(context, cubit),
                              onSortTap: () {
                                final next = state.selectedSort == 'Latest'
                                    ? 'Oldest'
                                    : 'Latest';
                                cubit.setSort(next);
                              },
                              onFilterTap: () => _openFilterModal(context, cubit),
                            ),
                            gap12,

                            // 4. Ad Cards Grid
                            if (items.isEmpty) ...[
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 60),
                                child: Center(
                                  child: Column(
                                    children: [
                                      const Icon(
                                        Icons.favorite_border,
                                        size: 48,
                                        color: ColorResources.grey,
                                      ),
                                      gap12,
                                      Text(
                                        state.selectedTab == ActivityTab.favourites
                                            ? StringFile.noFavouritesYet
                                            : (state.selectedTab == ActivityTab.interests
                                                ? StringFile.noInterestsYet
                                                : StringFile.noViewedYet),
                                        style: baseTextStyle.s13.w500.grey,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ] else ...[
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 0.74,
                                ),
                                itemCount: items.length,
                                itemBuilder: (context, index) {
                                  final ad = items[index];
                                  return ActivityAdCard(
                                    ad: ad,
                                    onTap: () => _onAdTapped(ad),
                                    onRemove: () =>
                                        _onPromptRemove(context, cubit, ad),
                                  );
                                },
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),

                  // Floating Bottom Nav Bar
                  if (widget.showBottomNav)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 16,
                      child: AdlyeeBottomNavBar(
                        selectedIndex: 1, // Heart tab active
                        onTabSelected: (index) {
                          if (index == 0) {
                            if (widget.onHomeNavTap != null) {
                              widget.onHomeNavTap!();
                            } else {
                              AppRoute.pop();
                            }
                          } else if (index == 2) {
                            CustomAlertDialog.showCustomDialog(
                              title: StringFile.comingSoon,
                            );
                          }
                        },
                        onAddPressed: () {
                          AppRoute.pushNamed(PostAdScreen.routeName);
                        },
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
