import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solofy_vendor_app/application/bloc/submission_history_cubit/submission_history_cubit.dart';
import 'package:solofy_vendor_app/application/bloc/submission_history_cubit/submission_history_state.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/scale.dart';
import 'package:solofy_vendor_app/application/core/utils/app_assets.dart';
import 'package:solofy_vendor_app/application/core/utils/constants.dart';
import 'package:solofy_vendor_app/application/core/utils/string_file.dart';
import 'package:solofy_vendor_app/presentation/main/submission_history/widgets/submission_card.dart';
import 'package:solofy_vendor_app/presentation/main/submission_history/widgets/sort_find_sheet.dart';
import 'package:solofy_vendor_app/presentation/widgets/dropdown_chip_menu.dart';

class SubmissionHistoryTab extends StatelessWidget {
  const SubmissionHistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SubmissionHistoryCubit(),
      child: const _SubmissionHistoryView(),
    );
  }
}

class _SubmissionHistoryView extends StatefulWidget {
  const _SubmissionHistoryView();

  @override
  State<_SubmissionHistoryView> createState() => _SubmissionHistoryViewState();
}

class _SubmissionHistoryViewState extends State<_SubmissionHistoryView> {
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  Timer? _debounceTimer;
  bool _isSearchFocused = false;

  static const double screenPaddingH = 16.0;
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
    _debounceTimer?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query, BuildContext context) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        context.read<SubmissionHistoryCubit>().onSearchChanged(query);
      }
    });
  }

  Future<void> _openFilterSheet(BuildContext context, SubmissionHistoryState state) async {
    final cubit = context.read<SubmissionHistoryCubit>();
    final result = await SortFindSheet.show(
      context,
      initialDate: state.filterDate,
      initialStatus: state.filterStatus,
    );

    if (result != null) {
      cubit.applyPopupFilter(date: result.date, status: result.status);
    }
  }

  @override
  Widget build(BuildContext context) {
    final topSafe = MediaQuery.paddingOf(context).top;
    final bottomInset = bottomNavHeight.s +
        fabOverlap.s +
        MediaQuery.paddingOf(context).bottom +
        16.s;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Container(
        color: ColorResources.white,
        child: BlocBuilder<SubmissionHistoryCubit, SubmissionHistoryState>(
          builder: (context, state) {
            final items = state.filteredSubmissions;

            return RefreshIndicator(
              color: ColorResources.primary,
              onRefresh: () async {
                // TODO(api): Refresh submissions list from backend
                await context.read<SubmissionHistoryCubit>().loadSubmissions();
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                slivers: [
                  // 1. Top Safe Area + Title "Submission History": centered, Poppins 16 w600 dark, 16 above, 16 below
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        screenPaddingH.s,
                        topSafe + 16.s,
                        screenPaddingH.s,
                        16.s,
                      ),
                      child: Center(
                        child: Text(
                          StringFile.submissionHistory,
                          style: GoogleFonts.poppins(
                            fontSize: 16.s,
                            fontWeight: FontWeight.w600,
                            color: ColorResources.textColor,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // 2. Search Bar: white, radius 12, height 40, light border + soft shadow, filter icon inside at right
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        screenPaddingH.s,
                        0,
                        screenPaddingH.s,
                        12.s,
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
                                onChanged: (val) => _onSearchChanged(val, context),
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
                            // Filter icon inside at right with active filter dot
                            GestureDetector(
                              onTap: () => _openFilterSheet(context, state),
                              behavior: HitTestBehavior.opaque,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(4.s),
                                    child: Icon(
                                      Icons.tune_rounded,
                                      size: 18.s,
                                      color: state.hasActivePopupFilter
                                          ? ColorResources.primary
                                          : ColorResources.textColor,
                                    ),
                                  ),
                                  if (state.hasActivePopupFilter)
                                    Positioned(
                                      right: 2.s,
                                      top: 2.s,
                                      child: Container(
                                        width: 6.s,
                                        height: 6.s,
                                        decoration: const BoxDecoration(
                                          color: ColorResources.primary,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // 3. Dropdown chips: 3 expanded equal-width chips (height 30, radius 8, gap 8)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        screenPaddingH.s,
                        0,
                        screenPaddingH.s,
                        12.s,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: DropdownChipMenu<String>(
                              value: state.selectedCategory,
                              chipLabel: (state.selectedCategory == 'Category' ||
                                      state.selectedCategory == 'All')
                                  ? 'Category'
                                  : state.selectedCategory,
                              items: AppConstants.defaultCategories,
                              isSelected: (cat) =>
                                  cat == state.selectedCategory ||
                                  ((state.selectedCategory == 'Category' ||
                                          state.selectedCategory == 'All') &&
                                      cat == 'All'),
                              height: 30.0,
                              fontSize: 12.0,
                              isActive: state.selectedCategory != 'Category' &&
                                  state.selectedCategory != 'All',
                              onChanged: (cat) {
                                context
                                    .read<SubmissionHistoryCubit>()
                                    .selectCategory(cat);
                              },
                            ),
                          ),
                          SizedBox(width: 8.s),
                          Expanded(
                            child: DropdownChipMenu<String>(
                              value: state.selectedSort,
                              items: const ['Latest', 'Oldest'],
                              height: 30.0,
                              fontSize: 12.0,
                              isActive: state.selectedSort != 'Latest',
                              onChanged: (sort) {
                                context
                                    .read<SubmissionHistoryCubit>()
                                    .selectSort(sort);
                              },
                            ),
                          ),
                          SizedBox(width: 8.s),
                          Expanded(
                            child: DropdownChipMenu<String>(
                              value: state.selectedPlan,
                              chipLabel: state.selectedPlan == 'All'
                                  ? 'Featured'
                                  : state.selectedPlan,
                              items: AppConstants.defaultPlans,
                              isSelected: (p) => p == state.selectedPlan,
                              height: 30.0,
                              fontSize: 12.0,
                              isActive: state.selectedPlan != 'All',
                              onChanged: (plan) {
                                context
                                    .read<SubmissionHistoryCubit>()
                                    .selectPlan(plan);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 4. "20 Results" right aligned, small grey
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        screenPaddingH.s,
                        0,
                        screenPaddingH.s,
                        12.s,
                      ),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${items.length} Results',
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

                  // 5. List of SubmissionCard (one column, screen padding 16, gap 12) or Empty State
                  if (items.isEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 60.s),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.inbox_outlined,
                                size: 48.s,
                                color: ColorResources.grey.withValues(alpha: 0.6),
                              ),
                              SizedBox(height: 12.s),
                              Text(
                                StringFile.noSubmissionsFound,
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
                      padding: EdgeInsets.fromLTRB(
                        screenPaddingH.s,
                        0,
                        screenPaddingH.s,
                        bottomInset,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final submission = items[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 12.s),
                              child: SubmissionCard(submission: submission),
                            );
                          },
                          childCount: items.length,
                        ),
                      ),
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

