import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solofy_vendor_app/application/bloc/activity_cubit/activity_state.dart';
import 'package:solofy_vendor_app/domain/bloc/activity/models/activity_ad_item.dart';
import 'package:solofy_vendor_app/domain/bloc/activity/models/activity_mock.dart';

class ActivityCubit extends Cubit<ActivityState> {
  ActivityCubit({
    List<ActivityAdItem>? initialFavourites,
    List<ActivityAdItem>? initialInterests,
    List<ActivityAdItem>? initialViewed,
    ActivityTab initialTab = ActivityTab.favourites,
  }) : super(ActivityState(
          selectedTab: initialTab,
          favourites: initialFavourites ?? ActivityMock.favourites,
          interests: initialInterests ?? ActivityMock.interests,
          viewed: initialViewed ?? ActivityMock.viewed,
        ));

  void selectTab(ActivityTab tab) {
    emit(state.copyWith(selectedTab: tab));
  }

  void updateSearch(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void setCategory(String? category) {
    emit(state.copyWith(selectedCategory: category));
  }

  void setSort(String? sort) {
    emit(state.copyWith(selectedSort: sort));
  }

  void setFilter(String? filter) {
    emit(state.copyWith(selectedFilter: filter));
  }

  void promptRemove(ActivityAdItem ad) {
    emit(state.copyWith(adPendingRemove: ad));
  }

  void cancelRemove() {
    emit(state.copyWith(clearPendingRemove: true));
  }

  void confirmRemove() {
    final ad = state.adPendingRemove;
    if (ad == null) return;

    switch (state.selectedTab) {
      case ActivityTab.favourites:
        final updated =
            state.favourites.where((item) => item.id != ad.id).toList();
        emit(state.copyWith(
          favourites: updated,
          clearPendingRemove: true,
        ));
        break;
      case ActivityTab.interests:
        final updated =
            state.interests.where((item) => item.id != ad.id).toList();
        emit(state.copyWith(
          interests: updated,
          clearPendingRemove: true,
        ));
        break;
      case ActivityTab.viewed:
        final updated =
            state.viewed.where((item) => item.id != ad.id).toList();
        emit(state.copyWith(
          viewed: updated,
          clearPendingRemove: true,
        ));
        break;
    }
  }
}
