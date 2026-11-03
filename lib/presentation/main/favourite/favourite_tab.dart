import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solofy_vendor_app/application/bloc/main_shell_cubit/main_shell_cubit.dart';
import 'package:solofy_vendor_app/application/bloc/main_shell_cubit/main_shell_state.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/scale.dart';
import 'package:solofy_vendor_app/application/core/utils/app_assets.dart';
import 'package:solofy_vendor_app/application/core/utils/constants.dart';
import 'package:solofy_vendor_app/application/core/utils/enums.dart';
import 'package:solofy_vendor_app/application/core/utils/string_file.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/ad_model.dart';
import 'package:solofy_vendor_app/presentation/home/models/ad_item.dart';
import 'package:solofy_vendor_app/presentation/home/widgets/filter_modal.dart';
import 'package:solofy_vendor_app/presentation/widgets/ad_card.dart';
import 'package:solofy_vendor_app/presentation/widgets/dropdown_chip.dart';
import 'package:solofy_vendor_app/presentation/widgets/dropdown_chip_menu.dart';
import 'package:solofy_vendor_app/presentation/widgets/remove_ad_dialog.dart';


class FavouriteTab extends StatefulWidget {
  const FavouriteTab({super.key});

  @override
  State<FavouriteTab> createState() => _FavouriteTabState();
}

class _FavouriteTabState extends State<FavouriteTab> {
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  String _searchQuery = '';
  String _selectedCategory = 'Category';
  SortOrder _sortOrder = SortOrder.latest;
  bool _featuredOnly = false;
  bool _isSearchFocused = false;
  

  // Named private constants in design px, scaled with .s (Figma Fix D & E)
  static const double screenPaddingH = 16.0;
  static const double gridPaddingRight = 5.0; // 16 - 11 = 5 (Fix D)
  static const double gapSearchToTabs = 12.0;
  static const double tabGap = 8.0;
  static const double gapTabsToChips = 12.0;
  static const double chipGap = 8.0;
  static const double gapChipsToResults = 8.0;
  static const double gapResultsToGrid = 6.0;
  static const double bottomNavHeight = 52.0;
  static const double fabOverlap = 8.0;

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      setState(() => _isSearchFocused = _searchFocusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
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
      _featuredOnly = !_featuredOnly;
    });
  }

  List<AdModel> _filterAds(List<AdModel> ads) {
    var list = ads;
    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.trim().toLowerCase();
      list = list.where((a) {
        return a.title.toLowerCase().contains(q) ||
            a.description.toLowerCase().contains(q) ||
            a.locationLabel.toLowerCase().contains(q);
      }).toList();
    }

    if (_selectedCategory != 'Category' && _selectedCategory != 'All') {
      list = list.where((a) {
        return a.category.toLowerCase() == _selectedCategory.toLowerCase();
      }).toList();
    }

    if (_featuredOnly) {
      list = list.where((a) => a.isFeatured).toList();
    }

    if (_sortOrder == SortOrder.oldest) {
      list = list.reversed.toList();
    }

    return list;
  }

  void _onRemoveTapped(BuildContext context, MainShellCubit cubit, AdModel ad) {
    cubit.promptRemove(ad);
    RemoveAdDialog.show(
      context,
      onConfirm: () => cubit.confirmRemove(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MainShellCubit>();
    final topSafe = MediaQuery.paddingOf(context).top;
    final bottomInset = bottomNavHeight.s +
        fabOverlap.s +
        MediaQuery.paddingOf(context).bottom +
        16.s;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark, // Dark icons on plain white (Fix A)
        statusBarBrightness: Brightness.light,
      ),
      child: Container(
        color: ColorResources.white,
        width: double.infinity,
        child: BlocBuilder<MainShellCubit, MainShellState>(
          builder: (context, state) {
            final currentSubTab = state.favouriteSubTabIndex;
            final rawAds = state.activeFavouriteList;
            final ads = _filterAds(rawAds);
            final hasLabel = currentSubTab == 1; // Interests tab has plain colored labels

            return RefreshIndicator(
              color: ColorResources.primary,
              onRefresh: () async {
                // TODO(api): Trigger real backend refresh here
                await Future<void>.delayed(const Duration(milliseconds: 500));
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                slivers: [
                  // Top padding under the status bar: safe area + 12 (Fix A & E)
                  SliverToBoxAdapter(
                    child: SizedBox(height: topSafe + 12.s),
                  ),

                  // Heading: "Favourite" (centered, same style as the Submission History title)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 16.s),
                      child: Center(
                        child: Text(
                          StringFile.favouriteTitle,
                          style: GoogleFonts.poppins(
                            fontSize: 16.s,
                            fontWeight: FontWeight.w600,
                            color: ColorResources.black,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // 1. Search Bar (height 40, radius 12, 1px light border + soft shadow, filter icon at right)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        screenPaddingH.s,
                        0,
                        screenPaddingH.s,
                        gapSearchToTabs.s,
                      ),
                      child: Container(
                        height: 40.s,
                        decoration: BoxDecoration(
                          color: ColorResources.white,
                          borderRadius: BorderRadius.circular(12.s),
                          border: Border.all(
                            color: _isSearchFocused
                                ? ColorResources.primary
                                : ColorResources.borderColor,
                            width: 1.s,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: ColorResources.primaryShadow.withValues(alpha: 0.08),
                              blurRadius: 8.s,
                              offset: Offset(0, 2.s),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 12.s),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              AppAssets.searchNormalSvg,
                              width: 16.s,
                              height: 16.s,
                              colorFilter: const ColorFilter.mode(
                                ColorResources.grey,
                                BlendMode.srcIn,
                              ),
                            ),
                            SizedBox(width: 8.s),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                focusNode: _searchFocusNode,
                                onChanged: (val) => setState(() => _searchQuery = val),
                                style: GoogleFonts.poppins(
                                  fontSize: 13.s,
                                  fontWeight: FontWeight.w400,
                                  color: ColorResources.black,
                                  height: 1.2,
                                ),
                                decoration: InputDecoration(
                                  hintText: StringFile.search,
                                  hintStyle: GoogleFonts.poppins(
                                    fontSize: 13.s,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF9E9E9E),
                                    height: 1.2,
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: _openFilterModal,
                              behavior: HitTestBehavior.opaque,
                              child: Icon(
                                Icons.tune_rounded,
                                size: 16.s,
                                color: ColorResources.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // 2. Tab Pills: 3 Expanded equal pills, height 32, gap 8, fully rounded (Fix E)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenPaddingH.s),
                      child: Row(
                        children: [
                          Expanded(
                            child: _SegmentedTabPill(
                              label: StringFile.favourites,
                              isSelected: currentSubTab == 0,
                              onTap: () => cubit.setFavouriteSubTab(0),
                            ),
                          ),
                          SizedBox(width: tabGap.s),
                          Expanded(
                            child: _SegmentedTabPill(
                              label: StringFile.interests,
                              isSelected: currentSubTab == 1,
                              onTap: () => cubit.setFavouriteSubTab(1),
                            ),
                          ),
                          SizedBox(width: tabGap.s),
                          Expanded(
                            child: _SegmentedTabPill(
                              label: StringFile.viewed,
                              isSelected: currentSubTab == 2,
                              onTap: () => cubit.setFavouriteSubTab(2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 3. Dropdown Chips: 3 Expanded equal chips filling row, height 30, gap 8, labelled "Category" (Fix E)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        screenPaddingH.s,
                        gapTabsToChips.s,
                        screenPaddingH.s,
                        gapChipsToResults.s,
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
                              isActive: _selectedCategory != 'Category' &&
                                  _selectedCategory != 'All',
                              onChanged: (cat) {
                                setState(() => _selectedCategory = cat);
                              },
                            ),
                          ),
                          SizedBox(width: chipGap.s),
                          Expanded(
                            child: DropdownChipMenu<SortOrder>(
                              value: _sortOrder,
                              items: const [SortOrder.latest, SortOrder.oldest],
                              itemLabel: (o) => o.label,
                              isActive: _sortOrder != SortOrder.latest,
                              onChanged: (order) {
                                setState(() => _sortOrder = order);
                              },
                            ),
                          ),
                          SizedBox(width: chipGap.s),
                          Expanded(
                            child: DropdownChip(
                              label: 'Featured',
                              isActive: _featuredOnly,
                              onTap: _onFeaturedToggle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 4. Results Count Row ("20 Results", Poppins 11 grey, right-aligned)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        screenPaddingH.s,
                        0,
                        screenPaddingH.s,
                        gapResultsToGrid.s,
                      ),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${ads.length} Results',
                          style: GoogleFonts.poppins(
                            fontSize: 11.s,
                            fontWeight: FontWeight.w400,
                            color: ColorResources.grey,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // 5. SliverGrid of cards OR Empty state
                  if (ads.isEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(top: 60.s),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.favorite_border_rounded,
                                size: 48.s,
                                color: ColorResources.navInactive,
                              ),
                              SizedBox(height: 12.s),
                              Text(
                                'No ads here yet',
                                style: GoogleFonts.poppins(
                                  fontSize: 14.s,
                                  fontWeight: FontWeight.w500,
                                  color: ColorResources.grey,
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      // Left 16, Right 5 (= 16 - 11 extra in cell). Cross-spacing 0, main-spacing 0 (Fix D)
                      padding: EdgeInsets.only(
                        left: screenPaddingH.s,
                        right: gridPaddingRight.s,
                      ),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 0,
                          mainAxisSpacing: 0,
                          mainAxisExtent: AdCard.cellHeight(
                            hasLabel: hasLabel,
                            hasRemove: true,
                          ),
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final ad = ads[index];
                            return AdCard(
                              ad: ad,
                              showRibbon: false,
                              showUnread: false,
                              feedback: currentSubTab == 1 ? ad.feedback : null,
                              onRemove: () => _onRemoveTapped(context, cubit, ad),
                            );
                          },
                          childCount: ads.length,
                        ),
                      ),
                    ),

                  // Bottom padding ensuring the last row is fully visible above floating bottom nav
                  SliverToBoxAdapter(
                    child: SizedBox(height: bottomInset),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SegmentedTabPill extends StatelessWidget {
  const _SegmentedTabPill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  static const double pillHeight = 32.0;
  static const double pillRadius = 16.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: pillHeight.s,
        decoration: BoxDecoration(
          color: isSelected
              ? ColorResources.primary
              : const Color(0xFFEFF5FF),
          borderRadius: BorderRadius.circular(pillRadius.s),
          border: Border.all(
            color: isSelected ? ColorResources.primary : const Color(0xFFE4EBFF),
            width: 1.s,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: ColorResources.primary.withValues(alpha: 0.2),
                    blurRadius: 6.s,
                    offset: Offset(0, 2.s),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12.s,
              fontWeight: FontWeight.w500,
              color: isSelected ? ColorResources.white : const Color(0xFF4A6882),
              height: 1.2,
            ),
            textHeightBehavior: const TextHeightBehavior(
              applyHeightToFirstAscent: false,
              applyHeightToLastDescent: false,
            ),
          ),
        ),
      ),
    );
  }
}