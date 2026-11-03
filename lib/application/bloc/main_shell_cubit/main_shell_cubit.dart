import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solofy_vendor_app/application/bloc/main_shell_cubit/main_shell_state.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/ad_model.dart';

class MainShellCubit extends Cubit<MainShellState> {
  MainShellCubit() : super(MainShellState.initial());

  void selectTab(int index) {
    if (state.selectedTabIndex != index) {
      emit(state.copyWith(selectedTabIndex: index));
    }
  }

  void setFavouriteSubTab(int subTabIndex) {
    emit(state.copyWith(favouriteSubTabIndex: subTabIndex));
  }

  void updateLocation(String location) {
    emit(state.copyWith(selectedLocation: location));
  }

  void updateLanguage(String language) {
    emit(state.copyWith(selectedLanguage: language));
  }

  void promptRemove(AdModel ad) {
    emit(state.copyWith(pendingRemovalAd: () => ad));
  }

  void cancelRemove() {
    emit(state.copyWith(pendingRemovalAd: () => null));
  }

  void confirmRemove() {
    final ad = state.pendingRemovalAd;
    if (ad == null) return;

    final subTab = state.favouriteSubTabIndex;
    if (subTab == 0) {
      final updated = state.favouritesAds.where((a) => a.id != ad.id).toList();
      emit(state.copyWith(
        favouritesAds: updated,
        pendingRemovalAd: () => null,
      ));
    } else if (subTab == 1) {
      final updated = state.interestsAds.where((a) => a.id != ad.id).toList();
      emit(state.copyWith(
        interestsAds: updated,
        pendingRemovalAd: () => null,
      ));
    } else if (subTab == 2) {
      final updated = state.viewedAds.where((a) => a.id != ad.id).toList();
      emit(state.copyWith(
        viewedAds: updated,
        pendingRemovalAd: () => null,
      ));
    }
  }
}

