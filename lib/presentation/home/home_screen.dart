import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solofy_vendor_app/application/core/route/app_route.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/diamentions.dart';
import 'package:solofy_vendor_app/application/core/theme/text_styles.dart';
import 'package:solofy_vendor_app/application/core/utils/alert_dialog.dart';
import 'package:solofy_vendor_app/application/core/utils/string_file.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/ad_detail.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/ad_mock.dart';
import 'package:solofy_vendor_app/application/bloc/activity_cubit/activity_cubit.dart';
import 'package:solofy_vendor_app/presentation/activity/activity_screen.dart';
import 'package:solofy_vendor_app/presentation/ads/ad_detail/ad_detail_screen.dart';
import 'package:solofy_vendor_app/presentation/ads/post_ad/post_ad_screen.dart';
import 'package:solofy_vendor_app/presentation/home/models/ad_item.dart';
import 'package:solofy_vendor_app/presentation/home/widgets/ad_card.dart';
import 'package:solofy_vendor_app/presentation/home/widgets/bottom_nav_bar.dart';
import 'package:solofy_vendor_app/presentation/home/widgets/filter_modal.dart';
import 'package:solofy_vendor_app/presentation/home/widgets/home_header.dart';

import 'package:solofy_vendor_app/presentation/main/main_shell.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const routeName = 'home';

  @override
  Widget build(BuildContext context) {
    return const MainShell(initialTab: 0);
  }
}

class _OldHomeScreen extends StatefulWidget {
  const _OldHomeScreen();

  @override
  State<_OldHomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<_OldHomeScreen> {
  final _searchController = TextEditingController();
  late final ActivityCubit _activityCubit;
  int _selectedNavIndex = 0;
  AdFilter _filter = const AdFilter();

  late List<AdItem> _allAds;

  @override
  void initState() {
    super.initState();
    _allAds = AdItem.initialMockAds;
    _activityCubit = ActivityCubit();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _activityCubit.close();
    super.dispose();
  }

  List<AdItem> get _filteredAds {
    final query = _filter.searchQuery.toLowerCase().trim();
    final category = _filter.category;
    final maxDistance = _filter.maxDistanceKm;
    final pincode = _filter.pincode.trim();
    final filterDate = _filter.selectedDate;

    final results = _allAds.where((ad) {
      if (ad.isBanner) return true;

      // Text search
      if (query.isNotEmpty) {
        final matchesTitle = ad.title.toLowerCase().contains(query);
        final matchesDesc = ad.description.toLowerCase().contains(query);
        final matchesLoc = ad.location.toLowerCase().contains(query);
        if (!matchesTitle && !matchesDesc && !matchesLoc) return false;
      }

      // Category filter
      if (category != 'All' && ad.category.isNotEmpty) {
        if (!ad.category.toLowerCase().contains(category.toLowerCase())) {
          return false;
        }
      }

      // Distance filter
      if (ad.distanceKm > maxDistance) {
        return false;
      }

      // Pincode filter
      if (pincode.isNotEmpty && !ad.pincode.startsWith(pincode)) {
        return false;
      }

      // Date filter
      if (filterDate != null) {
        if (ad.dateTime.year != filterDate.year ||
            ad.dateTime.month != filterDate.month ||
            ad.dateTime.day != filterDate.day) {
          return false;
        }
      }

      return true;
    }).toList();

    // Sorting
    if (_filter.sort == 'Featured') {
      results.sort((a, b) {
        if (a.isBanner) return -1;
        if (b.isBanner) return 1;
        final aFeatured = a.ribbon == AdRibbon.featured ? 1 : 0;
        final bFeatured = b.ribbon == AdRibbon.featured ? 1 : 0;
        return bFeatured.compareTo(aFeatured);
      });
    } else {
      // Default: Latest
      results.sort((a, b) {
        if (a.isBanner) return -1;
        if (b.isBanner) return 1;
        return b.dateTime.compareTo(a.dateTime);
      });
    }

    return results;
  }

  void _onCategorySelect() {
    final categories = ['All', 'House', 'Car', 'Property', 'Electronics'];
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Select Category', style: baseTextStyle.s16.w600.black),
              ),
              ...categories.map(
                (cat) => ListTile(
                  title: Text(cat, style: baseTextStyle.s14.w500.black),
                  trailing: _filter.category == cat
                      ? const Icon(Icons.check, color: ColorResources.primary)
                      : null,
                  onTap: () {
                    setState(() => _filter = _filter.copyWith(category: cat));
                    Navigator.of(ctx).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onSortSelect() {
    final options = ['Latest', 'Featured'];
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Sort By', style: baseTextStyle.s16.w600.black),
              ),
              ...options.map(
                (opt) => ListTile(
                  title: Text(opt, style: baseTextStyle.s14.w500.black),
                  trailing: _filter.sort == opt
                      ? const Icon(Icons.check, color: ColorResources.primary)
                      : null,
                  onTap: () {
                    setState(() => _filter = _filter.copyWith(sort: opt));
                    Navigator.of(ctx).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openFilterModal() {
    FilterModal.show(
      context: context,
      initialFilter: _filter,
      onApply: (newFilter) {
        setState(() => _filter = newFilter);
      },
    );
  }

  void _onAddPressed() {
    AppRoute.pushNamed(PostAdScreen.routeName);
  }

  void _onAdTapped(AdItem ad) {
    late final AdDetail detail;
    if (ad.category == 'Job' || ad.title.contains('Job')) {
      detail = AdMock.jobExpiringSoon;
    } else {
      detail = AdMock.propertyActive;
    }
    AppRoute.pushNamed(
      AdDetailScreen.routeName,
      arguments: {'ad': detail, 'isInterested': false},
    );
  }

  void _showDevStatePicker() {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Dev: Preview Ad Detail States',
                  style: baseTextStyle.s16.w700.black,
                  textAlign: TextAlign.center,
                ),
                gap16,
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    AppRoute.pushNamed(
                      AdDetailScreen.routeName,
                      arguments: {'ad': AdMock.propertyActive, 'isInterested': false},
                    );
                  },
                  child: const Text('1. Property (Active) - Screenshot 1'),
                ),
                gap8,
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    AppRoute.pushNamed(
                      AdDetailScreen.routeName,
                      arguments: {'ad': AdMock.jobExpiringSoon, 'isInterested': false},
                    );
                  },
                  child: const Text('2. Job (Expiring Soon) - Screenshot 2'),
                ),
                gap8,
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    AppRoute.pushNamed(
                      AdDetailScreen.routeName,
                      arguments: {'ad': AdMock.jobExpired, 'isInterested': false},
                    );
                  },
                  child: const Text('3. Job (Expired) - Screenshot 3'),
                ),
                gap8,
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    AppRoute.pushNamed(
                      AdDetailScreen.routeName,
                      arguments: {'ad': AdMock.propertyInterested, 'isInterested': true},
                    );
                  },
                  child: const Text('4. Property (Interested) - Screenshot 4'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredAds;
    final todayAds = filtered.where((a) => a.section == AdSection.today).toList();
    final yesterdayAds = filtered.where((a) => a.section == AdSection.yesterday).toList();
    final totalCount = filtered.where((a) => !a.isBanner).length;

    return Scaffold(
      backgroundColor: ColorResources.white,
      body: Stack(
        children: [
          if (_selectedNavIndex == 1)
            BlocProvider.value(
              value: _activityCubit,
              child: ActivityView(
                showBottomNav: false,
                onHomeNavTap: () => setState(() => _selectedNavIndex = 0),
              ),
            )
          else
            CustomScrollView(
              slivers: [
                // Top Header with blue gradient, app bar, search and banner
                SliverToBoxAdapter(
                  child: HomeHeader(
                    searchController: _searchController,
                    onSearchChanged: (val) {
                      setState(() => _filter = _filter.copyWith(searchQuery: val));
                    },
                    onMenuPressed: _showDevStatePicker,
                    onNotificationPressed: () {
                      CustomAlertDialog.showCustomDialog(title: 'Notifications (3 Unread)');
                    },
                  ),
                ),

              // Filter Chips row (Category, Latest, Featured, Filter icon)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Row(
                    children: [
                      _FilterDropdownChip(
                        label: _filter.category == 'All'
                            ? StringFile.category
                            : _filter.category,
                        onTap: _onCategorySelect,
                        isActive: _filter.category != 'All',
                      ),
                      gap8,
                      _FilterDropdownChip(
                        label: _filter.sort,
                        onTap: _onSortSelect,
                      ),
                      gap8,
                      _FilterDropdownChip(
                        label: StringFile.featured,
                        onTap: () {
                          final newSort = _filter.sort == 'Featured' ? 'Latest' : 'Featured';
                          setState(() => _filter = _filter.copyWith(sort: newSort));
                        },
                        isActive: _filter.sort == 'Featured',
                      ),
                      const Spacer(),
                      // Filter icon button
                      GestureDetector(
                        onTap: _openFilterModal,
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: ColorResources.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: (_filter.selectedDate != null ||
                                      _filter.pincode.isNotEmpty ||
                                      _filter.maxDistanceKm < 100)
                                  ? ColorResources.primary
                                  : const Color(0xFFE4EBFF),
                              width: 1.2,
                            ),
                          ),
                          child: Icon(
                            Icons.tune_rounded,
                            size: 18,
                            color: (_filter.selectedDate != null ||
                                    _filter.pincode.isNotEmpty ||
                                    _filter.maxDistanceKm < 100)
                                ? ColorResources.primary
                                : ColorResources.textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // "Today" Section Header + "Total X Results"
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        StringFile.today,
                        style: baseTextStyle.s14.w700.black,
                      ),
                      Text(
                        'Total $totalCount Results',
                        style: baseTextStyle.s11.w400.slateGray,
                      ),
                    ],
                  ),
                ),
              ),

              // Empty results state
              if (filtered.isEmpty || (todayAds.isEmpty && yesterdayAds.isEmpty))
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.search_off_rounded,
                          size: 48,
                          color: ColorResources.grey,
                        ),
                        gap12,
                        Text(
                          StringFile.noResults,
                          textAlign: TextAlign.center,
                          style: baseTextStyle.s13.w500.slateGray,
                        ),
                        gap16,
                        OutlinedButton(
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _filter = const AdFilter());
                          },
                          child: Text(
                            StringFile.resetFilters,
                            style: baseTextStyle.s12.w500.copyWith(color: ColorResources.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Today section grid (2 columns)
              if (todayAds.isNotEmpty)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.76,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final ad = todayAds[index];
                        return AdCard(
                          ad: ad,
                          onTap: () => _onAdTapped(ad),
                        );
                      },
                      childCount: todayAds.length,
                    ),
                  ),
                ),

              // "Yesterday" Section Header (if present)
              if (yesterdayAds.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
                    child: Text(
                      StringFile.yesterday,
                      style: baseTextStyle.s14.w700.black,
                    ),
                  ),
                ),

                // Yesterday section grid (2 columns)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.76,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final ad = yesterdayAds[index];
                        return AdCard(
                          ad: ad,
                          onTap: () => _onAdTapped(ad),
                        );
                      },
                      childCount: yesterdayAds.length,
                    ),
                  ),
                ),
              ],

              // Bottom Spacer to give room above floating bottom nav bar
              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          ),

          // Floating Bottom Navigation Bar (Image 1 & 3)
          Positioned(
            left: 0,
            right: 0,
            bottom: 16,
            child: AdlyeeBottomNavBar(
              selectedIndex: _selectedNavIndex,
              onTabSelected: (index) {
                if (index == 2) {
                  CustomAlertDialog.showCustomDialog(title: StringFile.comingSoon);
                  return;
                }
                setState(() => _selectedNavIndex = index);
              },
              onAddPressed: _onAddPressed,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterDropdownChip extends StatelessWidget {
  const _FilterDropdownChip({
    required this.label,
    required this.onTap,
    this.isActive = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: isActive ? ColorResources.primary.withValues(alpha: 0.08) : ColorResources.white,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
            color: isActive ? ColorResources.primary : const Color(0xFFE4EBFF),
            width: 1.1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: baseTextStyle.s11.w500.copyWith(
                color: isActive ? ColorResources.primary : ColorResources.textColor,
              ),
            ),
            gap4,
            Icon(
              Icons.keyboard_arrow_down,
              size: 14,
              color: isActive ? ColorResources.primary : ColorResources.grey,
            ),
          ],
        ),
      ),
    );
  }
}
