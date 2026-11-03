import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solofy_vendor_app/application/bloc/ad_detail_cubit/ad_detail_state.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/ad_detail.dart';

class AdDetailCubit extends Cubit<AdDetailState> {
  AdDetailCubit({
    required AdDetail ad,
    bool initialInterested = false,
    InterestFeedback initialFeedback = InterestFeedback.suitable,
  }) : super(
          AdDetailState(
            ad: ad,
            isInterested: initialInterested,
            feedback: initialFeedback,
          ),
        );

  void markInterested() {
    emit(state.copyWith(isInterested: true));
  }

  void setFeedback(InterestFeedback feedback) {
    emit(state.copyWith(feedback: feedback));
  }

  void toggleFavorite() {
    emit(state.copyWith(isFavorite: !state.isFavorite));
  }
}

