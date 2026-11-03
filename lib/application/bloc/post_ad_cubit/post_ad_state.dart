import 'package:equatable/equatable.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/ad_draft.dart';

class PostAdState extends Equatable {
  const PostAdState({
    this.draft = const AdDraft(),
    this.isSubmitting = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  final AdDraft draft;
  final bool isSubmitting;
  final bool isSuccess;
  final String? errorMessage;

  PostAdState copyWith({
    AdDraft? draft,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
    bool clearError = false,
  }) {
    return PostAdState(
      draft: draft ?? this.draft,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [draft, isSubmitting, isSuccess, errorMessage];
}

