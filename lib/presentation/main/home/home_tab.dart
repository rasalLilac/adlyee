import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solofy_vendor_app/application/bloc/main_shell_cubit/main_shell_cubit.dart';
import 'package:solofy_vendor_app/application/bloc/main_shell_cubit/main_shell_state.dart';
import 'package:solofy_vendor_app/application/bloc/notifications_cubit/notifications_cubit.dart';
import 'package:solofy_vendor_app/application/core/route/app_route.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/scale.dart';
import 'package:solofy_vendor_app/application/core/utils/app_assets.dart';
import 'package:solofy_vendor_app/application/core/utils/constants.dart';
import 'package:solofy_vendor_app/application/core/utils/enums.dart';
import 'package:solofy_vendor_app/application/core/utils/string_file.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/ad_model.dart';
import 'package:solofy_vendor_app/presentation/home/models/ad_item.dart';
import 'package:solofy_vendor_app/presentation/home/widgets/filter_modal.dart';
import 'package:solofy_vendor_app/presentation/main/widgets/gradient_header_background.dart';
import 'package:solofy_vendor_app/presentation/main/widgets/home_app_bar.dart';
import 'package:solofy_vendor_app/presentation/widgets/ad_card.dart';
import 'package:solofy_vendor_app/presentation/widgets/admin_banner_card.dart';
import 'package:solofy_vendor_app/presentation/widgets/admin_banner_carousel.dart';
import 'package:solofy_vendor_app/presentation/widgets/dropdown_chip.dart';
import 'package:solofy_vendor_app/presentation/widgets/dropdown_chip_menu.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final _searchController = TextEditingController();
  final ValueNotifier<double> _scrollOffset = ValueNotifier<double>(0.0);
  String _selectedCategory = 'Category';
  SortOrder _sortOrder = SortOrder.latest;
  bool _isFeatured = false;

  // Named constants in design px, scaled with .s (stops for header gradient)
  static const double headerFadeStart = 83.0; // Solid ColorResources.primary until here (under status bar & app bar row)
  static const double headerFadeEnd = 163.0;   // Pure white reached at bottom of search bar (+ ~4px)

  static const double screenPaddingH = 16.0;
  static const double bottomNavHeight = 52.0;
  static const double fabOverlap = 8.0;

  @override
  void dispose() {
    _searchController.dispose();
    _scrollOffset.dispose();
    super.dispose();
  }

  void _openFilterModal() {
    FilterModal.show(
      context: context,
      initialFilter: const AdFilter(),
      onApply: (filter) {
        setState(() => _selectedCategory = filter.category);
      },
    );
  }

  void _onFeaturedToggle() {
    setState(() {
      _isFeatured = !_isFeatured;
    });
  }

  List<AdModel> _filterAndSortAds(List<AdModel> rawList) {
    var list = rawList;
    if (_isFeatured) {
      list = list.where((a) => a.isFeatured).toList();
    }
    if (_selectedCategory != 'Category' && _selectedCategory != 'All') {
      final cat = _selectedCategory.toLowerCase();
      list = list.where((a) => a.category.toLowerCase() == cat).toList();
    }
    if (_sortOrder == SortOrder.oldest) {
      list = list.reversed.toList();
    }
    return list;
  }

  List<AdModel> _buildGridItemsWithBanners(List<AdModel> rawList) {
    final result = <AdModel>[];
    for (int i = 0; i < rawList.length; i++) {
      result.add(rawList[i]);
      // After every 3rd ad, insert an ad banner tile (Fix B)
      if ((i + 1) % 3 == 0) {
        result.add(
          AdModel(
            id: 'banner_${rawList[i].id}',
            adRef: '',
            title: '',
            postedAt: '',
            viewCount: 0,
            description: '',
            locationLabel: '',
            isBanner: true,
          ),
        );
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = bottomNavHeight.s +
        fabOverlap.s +
        MediaQuery.paddingOf(context).bottom +
        16.s;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light, // Light icons on solid blue
        statusBarBrightness: Brightness.dark,
      ),
      child: Container(
        color: ColorResources.white,
        child: Stack(
          children: [
            // 1. Fixed layer behind scroll view: solid primary blue for top ~45% and white below,
            // so overscroll/pull-to-refresh shows solid blue above the header and never a white gap.
            // When scrolling up, it recedes with the header so content below always sits on pure white.
            ValueListenableBuilder<double>(
              valueListenable: _scrollOffset,
              builder: (context, offset, _) {
                final screenH = MediaQuery.sizeOf(context).height;
                final blueHeight = offset <= 0
                    ? (screenH * 0.45 - offset)
                    : (headerFadeEnd.s - offset).clamp(0.0, double.infinity);

                return Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: blueHeight,
                  child: const ColoredBox(color: ColorResources.primary),
                );
              },
            ),

            // 2. Scrollable Body
            BlocBuilder<MainShellCubit, MainShellState>(
              builder: (context, state) {
                final todayItems =
                    _buildGridItemsWithBanners(_filterAndSortAds(state.homeTodayAds));
                final yesterdayItems =
                    _buildGridItemsWithBanners(_filterAndSortAds(state.homeYesterdayAds));

                return RefreshIndicator(
                  color: ColorResources.primary,
                  backgroundColor: ColorResources.white,
                  onRefresh: () async {
                    // TODO(api): Refresh home ads
                    await Future<void>.delayed(const Duration(milliseconds: 500));
                  },
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      _scrollOffset.value = notification.metrics.pixels;
                      return false;
                    },
                    child: CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      slivers: [
                        // Combined Header Block (App Bar + Location Row + Search Bar)
                        // with scrolling vertical gradient decoration
                        SliverToBoxAdapter(
                          child: Builder(
                            builder: (context) {
                              final unread = context
                                  .watch<NotificationsCubit>()
                                  .state
                                  .unreadCount;
                              return GradientHeaderBackground(
                                fadeStart: headerFadeStart.s,
                                fadeEnd: headerFadeEnd.s,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    HomeAppBar(
                                      locationText: state.selectedLocation,
                                      unreadCount: unread,
                                      language: state.selectedLanguage,
                                      onNotificationPressed: () =>
                                          AppRoute.pushNamed('notifications'),
                                    ),
                                    // Search Bar: White rounded rect, height 40, radius 10, 1px border, soft shadow
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(
                                        screenPaddingH.s,
                                        14.s,
                                        screenPaddingH.s,
                                        20.s,
                                      ),
                                      child: Container(
                                        height: 40.s,
                                        decoration: BoxDecoration(
                                          color: ColorResources.white,
                                          borderRadius:
                                              BorderRadius.circular(10.s),
                                          border: Border.all(
                                            color: ColorResources.borderColor,
                                            width: 1.s,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withValues(alpha: 0.06),
                                              blurRadius: 8.s,
                                              offset: Offset(0, 3.s),
                                            ),
                                          ],
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 14.s),
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              AppAssets.searchNormalSvg,
                                              width: 18.s,
                                              height: 18.s,
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                ColorResources.grey,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                            SizedBox(width: 10.s),
                                            Expanded(
                                              child: TextField(
                                                controller: _searchController,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 13.5.s,
                                                  fontWeight: FontWeight.w400,
                                                  color: ColorResources.black,
                                                  height: 1.2,
                                                ),
                                                decoration: InputDecoration(
                                                  hintText: StringFile.search,
                                                  hintStyle:
                                                      GoogleFonts.poppins(
                                                    fontSize: 13.5.s,
                                                    fontWeight:
                                                        FontWeight.w400,
                                                    color:
                                                        const Color(0xFF9E9E9E),
                                                    height: 1.2,
                                                  ),
                                                  border: InputBorder.none,
                                                  isDense: true,
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),

                        // Banner Carousel: Box height ~107, dots outside/below (Fix B)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenPaddingH.s),
                            child: const AdminBannerCarousel(),
                          ),
                        ),

                      // Filter Row: 3 EXPANDED EQUAL-WIDTH chips + 34x34 square outlined filter button (Fix B)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            screenPaddingH.s,
                            14.s,
                            screenPaddingH.s,
                            14.s,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: DropdownChipMenu<String>(
                                  value: _selectedCategory,
                                  chipLabel: (_selectedCategory == 'Category' ||
                                          _selectedCategory == 'All')
                                      ? 'Category'
                                      : _selectedCategory,
                                  items: AppConstants.defaultCategories,
                                  isSelected: (cat) =>
                                      cat == _selectedCategory ||
                                      ((_selectedCategory == 'Category' ||
                                              _selectedCategory == 'All') &&
                                          cat == 'All'),
                                  height: 34.0,
                                  fontSize: 12.0,
                                  isActive: _selectedCategory != 'Category' &&
                                      _selectedCategory != 'All',
                                  onChanged: (cat) {
                                    setState(() => _selectedCategory = cat);
                                  },
                                ),
                              ),
                              SizedBox(width: 8.s),
                              Expanded(
                                child: DropdownChipMenu<SortOrder>(
                                  value: _sortOrder,
                                  items: const [SortOrder.latest, SortOrder.oldest],
                                  itemLabel: (o) => o.label,
                                  height: 34.0,
                                  fontSize: 12.0,
                                  isActive: _sortOrder != SortOrder.latest,
                                  onChanged: (order) {
                                    setState(() => _sortOrder = order);
                                  },
                                ),
                              ),
                              SizedBox(width: 8.s),
                              Expanded(
                                child: DropdownChip(
                                  label: 'Featured',
                                  height: 34.0,
                                  fontSize: 12.0,
                                  isActive: _isFeatured,
                                  onTap: _onFeaturedToggle,
                                ),
                              ),
                              SizedBox(width: 8.s),
                              // 34x34 square outlined filter button (Fix B)
                              GestureDetector(
                                onTap: _openFilterModal,
                                behavior: HitTestBehavior.opaque,
                                child: Container(
                                  width: 34.s,
                                  height: 34.s,
                                  decoration: BoxDecoration(
                                    color: ColorResources.white,
                                    borderRadius: BorderRadius.circular(8.s),
                                    border: Border.all(
                                      color: ColorResources.borderColor,
                                      width: 1.s,
                                    ),
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      AppAssets.setting4Svg,
                                      width: 16.s,
                                      height: 16.s,
                                      colorFilter: const ColorFilter.mode(
                                        ColorResources.textColor,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Today Section Header: "Today" Poppins 13 w500, "Total 100 Results" Poppins 10 (Fix B)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            screenPaddingH.s,
                            0,
                            screenPaddingH.s,
                            10.s,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                StringFile.today,
                                style: GoogleFonts.poppins(
                                  fontSize: 13.5.s,
                                  fontWeight: FontWeight.w600,
                                  color: ColorResources.textColor,
                                  height: 1.2,
                                ),
                              ),
                              Text(
                                'Total 100 Results',
                                style: GoogleFonts.poppins(
                                  fontSize: 10.5.s,
                                  fontWeight: FontWeight.w400,
                                  color: ColorResources.grey,
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Today Ads Grid (shows Viewed/Unread chip + diagonal corner ribbon, no remove badge)
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: screenPaddingH.s),
                        sliver: SliverGrid(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10.s,
                            mainAxisSpacing: 10.s,
                            mainAxisExtent: AdCard.cardHeightNoLabel.s,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final item = todayItems[index];
                              if (item.isBanner) {
                                return const AdminBannerCard(
                                  height: double.infinity,
                                  iconHeight: 32,
                                );
                              }
                              return AdCard(
                                ad: item,
                                showRibbon: true,
                                showUnread: true,
                              );
                            },
                            childCount: todayItems.length,
                          ),
                        ),
                      ),

                      // Yesterday Section Header: "Yesterday" Poppins 13 w500
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            screenPaddingH.s,
                            16.s,
                            screenPaddingH.s,
                            10.s,
                          ),
                          child: Text(
                            StringFile.yesterday,
                            style: GoogleFonts.poppins(
                              fontSize: 13.s,
                              fontWeight: FontWeight.w500,
                              color: ColorResources.textColor,
                              height: 1.2,
                            ),
                          ),
                        ),
                      ),

                      // Yesterday Ads Grid
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: screenPaddingH.s),
                        sliver: SliverGrid(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10.s,
                            mainAxisSpacing: 10.s,
                            mainAxisExtent: AdCard.cardHeightNoLabel.s,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final item = yesterdayItems[index];
                              if (item.isBanner) {
                                return const AdminBannerCard(
                                  height: double.infinity,
                                  iconHeight: 32,
                                );
                              }
                              return AdCard(
                                ad: item,
                                showRibbon: true,
                                showUnread: true,
                              );
                            },
                            childCount: yesterdayItems.length,
                          ),
                        ),
                      ),

                      // Bottom padding ensuring the last row is fully visible above floating bottom nav
                      SliverToBoxAdapter(
                        child: SizedBox(height: bottomInset),
                      ),
                    ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
