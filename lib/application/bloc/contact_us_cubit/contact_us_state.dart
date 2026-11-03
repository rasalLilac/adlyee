import 'package:equatable/equatable.dart';

class ContactUsState extends Equatable {
  const ContactUsState({
    this.reason,
    this.comments = '',
    this.isSubmitting = false,
    this.isSuccess = false,
  });

  final String? reason;
  final String comments;
  final bool isSubmitting;
  final bool isSuccess;

  bool get isValid =>
      reason != null && reason!.trim().isNotEmpty && comments.trim().isNotEmpty;

  ContactUsState copyWith({
    String? reason,
    String? comments,
    bool? isSubmitting,
    bool? isSuccess,
  }) {
    return ContactUsState(
      reason: reason ?? this.reason,
      comments: comments ?? this.comments,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props => [reason, comments, isSubmitting, isSuccess];
}

