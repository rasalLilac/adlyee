import 'package:equatable/equatable.dart';
import 'package:solofy_vendor_app/domain/bloc/activity/models/activity_ad_item.dart';

class ActivityState extends Equatable {
  const ActivityState({
    this.selectedTab = ActivityTab.favourites,
    this.searchQuery = '',
    this.selectedCategory,
    this.selectedSort,
    this.selectedFilter,
    this.favourites = const [],
    this.interests = const [],
    this.viewed = const [],
    this.adPendingRemove,
  });

  final ActivityTab selectedTab;
  final String searchQuery;
  final String? selectedCategory;
  final String? selectedSort;
  final String? selectedFilter;
  final List<ActivityAdItem> favourites;
  final List<ActivityAdItem> interests;
  final List<ActivityAdItem> viewed;
  final ActivityAdItem? adPendingRemove;

  List<ActivityAdItem> get activeList {
    List<ActivityAdItem> base;
    switch (selectedTab) {
      case ActivityTab.favourites:
        base = favourites;
        break;
      case ActivityTab.interests:
        base = interests;
        break;
      case ActivityTab.viewed:
        base = viewed;
        break;
    }

    if (searchQuery.trim().isEmpty &&
        selectedCategory == null &&
        selectedFilter == null) {
      return base;
    }

    return base.where((ad) {
      final q = searchQuery.trim().toLowerCase();
      final matchQuery = q.isEmpty ||
          ad.title.toLowerCase().contains(q) ||
          ad.location.toLowerCase().contains(q) ||
          ad.category.toLowerCase().contains(q);

      final matchCat = selectedCategory == null ||
          selectedCategory == 'All' ||
          ad.category.toLowerCase() == selectedCategory!.toLowerCase();

      return matchQuery && matchCat;
    }).toList();
  }

  ActivityState copyWith({
    ActivityTab? selectedTab,
    String? searchQuery,
    String? selectedCategory,
    String? selectedSort,
    String? selectedFilter,
    List<ActivityAdItem>? favourites,
    List<ActivityAdItem>? interests,
    List<ActivityAdItem>? viewed,
    ActivityAdItem? adPendingRemove,
    bool clearPendingRemove = false,
  }) {
    return ActivityState(
      selectedTab: selectedTab ?? this.selectedTab,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedSort: selectedSort ?? this.selectedSort,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      favourites: favourites ?? this.favourites,
      interests: interests ?? this.interests,
      viewed: viewed ?? this.viewed,
      adPendingRemove: clearPendingRemove
          ? null
          : (adPendingRemove ?? this.adPendingRemove),
    );
  }

  @override
  List<Object?> get props => [
        selectedTab,
        searchQuery,
        selectedCategory,
        selectedSort,
        selectedFilter,
        favourites,
        interests,
        viewed,
        adPendingRemove,
      ];
}
