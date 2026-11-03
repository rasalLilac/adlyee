import 'package:equatable/equatable.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/ad_mock_data.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/ad_model.dart';

class MainShellState extends Equatable {
  const MainShellState({
    this.selectedTabIndex = 0,
    this.favouriteSubTabIndex = 0,
    this.selectedLocation = 'Palazhi , Calicut',
    this.selectedLanguage = 'English',
    this.unreadNotificationsCount = 3,
    this.homeTodayAds = const [],
    this.homeYesterdayAds = const [],
    this.favouritesAds = const [],
    this.interestsAds = const [],
    this.viewedAds = const [],
    this.pendingRemovalAd,
  });

  final int selectedTabIndex;
  final int favouriteSubTabIndex;
  final String selectedLocation;
  final String selectedLanguage;
  final int unreadNotificationsCount;
  final List<AdModel> homeTodayAds;
  final List<AdModel> homeYesterdayAds;
  final List<AdModel> favouritesAds;
  final List<AdModel> interestsAds;
  final List<AdModel> viewedAds;
  final AdModel? pendingRemovalAd;

  List<AdModel> get activeFavouriteList {
    switch (favouriteSubTabIndex) {
      case 0:
        return favouritesAds;
      case 1:
        return interestsAds;
      case 2:
        return viewedAds;
      default:
        return favouritesAds;
    }
  }

  MainShellState copyWith({
    int? selectedTabIndex,
    int? favouriteSubTabIndex,
    String? selectedLocation,
    String? selectedLanguage,
    int? unreadNotificationsCount,
    List<AdModel>? homeTodayAds,
    List<AdModel>? homeYesterdayAds,
    List<AdModel>? favouritesAds,
    List<AdModel>? interestsAds,
    List<AdModel>? viewedAds,
    AdModel? Function()? pendingRemovalAd,
  }) {
    return MainShellState(
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      favouriteSubTabIndex: favouriteSubTabIndex ?? this.favouriteSubTabIndex,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      unreadNotificationsCount:
          unreadNotificationsCount ?? this.unreadNotificationsCount,
      homeTodayAds: homeTodayAds ?? this.homeTodayAds,
      homeYesterdayAds: homeYesterdayAds ?? this.homeYesterdayAds,
      favouritesAds: favouritesAds ?? this.favouritesAds,
      interestsAds: interestsAds ?? this.interestsAds,
      viewedAds: viewedAds ?? this.viewedAds,
      pendingRemovalAd: pendingRemovalAd != null
          ? pendingRemovalAd()
          : this.pendingRemovalAd,
    );
  }

  factory MainShellState.initial() {
    return MainShellState(
      homeTodayAds: List.of(mockHomeTodayAds),
      homeYesterdayAds: List.of(mockHomeYesterdayAds),
      favouritesAds: List.of(mockFavouritesAds),
      interestsAds: List.of(mockInterestsAds),
      viewedAds: List.of(mockViewedAds),
    );
  }

  @override
  List<Object?> get props => [
        selectedTabIndex,
        favouriteSubTabIndex,
        selectedLocation,
        selectedLanguage,
        unreadNotificationsCount,
        homeTodayAds,
        homeYesterdayAds,
        favouritesAds,
        interestsAds,
        viewedAds,
        pendingRemovalAd,
      ];
}

