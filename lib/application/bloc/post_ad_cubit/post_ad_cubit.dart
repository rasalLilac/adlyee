import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solofy_vendor_app/application/bloc/post_ad_cubit/post_ad_state.dart';
import 'package:solofy_vendor_app/application/core/utils/constants.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/ad_draft.dart';

class PostAdCubit extends Cubit<PostAdState> {
  PostAdCubit({AdDraft? initialDraft})
      : super(PostAdState(draft: initialDraft ?? const AdDraft()));

  void updateCategory(String category) {
    emit(state.copyWith(draft: state.draft.copyWith(category: category)));
  }

  void updateSubCategory(String subCategory) {
    emit(state.copyWith(draft: state.draft.copyWith(subCategory: subCategory)));
  }

  void updateLocality(String locality) {
    emit(state.copyWith(
      draft: state.draft.copyWith(localityOrPincode: locality),
    ));
  }

  void updatePlan(AdPlan plan) {
    emit(state.copyWith(draft: state.draft.copyWith(plan: plan)));
  }

  void updateDisplayDescription(String desc) {
    emit(state.copyWith(
      draft: state.draft.copyWith(displayDescription: desc),
    ));
  }

  void updateDescription(String desc) {
    emit(state.copyWith(draft: state.draft.copyWith(description: desc)));
  }

  void toggleShowRegisteredNumber(bool val) {
    emit(state.copyWith(
      draft: state.draft.copyWith(showRegisteredNumber: val),
    ));
  }

  void updateAlternatePhone(String phone) {
    emit(state.copyWith(draft: state.draft.copyWith(alternatePhone: phone)));
  }

  void updateConnectWhatsApp(bool val) {
    emit(state.copyWith(
      draft: state.draft.copyWith(connectUsingWhatsApp: val),
    ));
  }

  void updateGetInterestedContactDetails(bool val) {
    emit(state.copyWith(
      draft: state.draft.copyWith(getInterestedContactDetails: val),
    ));
  }

  void addImages(List<String> newPaths) {
    final current = List<String>.from(state.draft.images);
    for (final p in newPaths) {
      if (current.length < AppConstants.maxImages && !current.contains(p)) {
        current.add(p);
      }
    }
    emit(state.copyWith(draft: state.draft.copyWith(images: current)));
  }

  void removeImage(int index) {
    final current = List<String>.from(state.draft.images);
    if (index >= 0 && index < current.length) {
      current.removeAt(index);
      emit(state.copyWith(draft: state.draft.copyWith(images: current)));
    }
  }

  void updateRunDays(int days) {
    emit(state.copyWith(draft: state.draft.copyWith(runDays: days)));
  }

  void updateAdditionalDays(int days) {
    emit(state.copyWith(draft: state.draft.copyWith(additionalDays: days)));
  }

  void toggleAgreeTerms(bool val) {
    emit(state.copyWith(draft: state.draft.copyWith(agreeTerms: val)));
  }

  void restoreDraft(AdDraft draft) {
    emit(state.copyWith(draft: draft));
  }
}

