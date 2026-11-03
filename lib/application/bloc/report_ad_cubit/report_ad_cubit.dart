import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solofy_vendor_app/application/bloc/report_ad_cubit/report_ad_state.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/ad_draft.dart';

class ReportAdCubit extends Cubit<ReportAdState> {
  ReportAdCubit({required String adRef}) : super(ReportAdState(adRef: adRef));

  void selectReason(ReportReason reason) {
    emit(state.copyWith(selectedReason: reason));
  }

  void updateOtherReason(String reason) {
    emit(state.copyWith(otherReason: reason));
  }

  Future<void> submitReport() async {
    if (!state.isValid) return;
    emit(state.copyWith(isSubmitting: true));
    // TODO(api): call report API
    await Future<void>.delayed(const Duration(milliseconds: 600));
    emit(state.copyWith(isSubmitting: false, isSuccess: true));
  }
}

