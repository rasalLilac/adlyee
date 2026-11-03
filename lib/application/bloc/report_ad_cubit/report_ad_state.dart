import 'package:equatable/equatable.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/ad_draft.dart';

class ReportAdState extends Equatable {
  const ReportAdState({
    required this.adRef,
    this.selectedReason,
    this.otherReason = '',
    this.isSubmitting = false,
    this.isSuccess = false,
  });

  final String adRef;
  final ReportReason? selectedReason;
  final String otherReason;
  final bool isSubmitting;
  final bool isSuccess;

  bool get isValid {
    if (selectedReason == null) return false;
    if (selectedReason == ReportReason.other) {
      return otherReason.trim().isNotEmpty;
    }
    return true;
  }

  ReportAdState copyWith({
    String? adRef,
    ReportReason? selectedReason,
    String? otherReason,
    bool? isSubmitting,
    bool? isSuccess,
  }) {
    return ReportAdState(
      adRef: adRef ?? this.adRef,
      selectedReason: selectedReason ?? this.selectedReason,
      otherReason: otherReason ?? this.otherReason,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props => [
        adRef,
        selectedReason,
        otherReason,
        isSubmitting,
        isSuccess,
      ];
}

