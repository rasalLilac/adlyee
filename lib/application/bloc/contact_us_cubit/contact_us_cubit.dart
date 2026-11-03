import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solofy_vendor_app/application/bloc/contact_us_cubit/contact_us_state.dart';
import 'package:solofy_vendor_app/application/core/utils/alert_dialog.dart';
import 'package:solofy_vendor_app/application/core/utils/string_file.dart';

class ContactUsCubit extends Cubit<ContactUsState> {
  ContactUsCubit() : super(const ContactUsState());

  void updateReason(String? reason) {
    emit(state.copyWith(reason: reason));
  }

  void updateComments(String comments) {
    emit(state.copyWith(comments: comments));
  }

  Future<void> submit(BuildContext context) async {
    if (!state.isValid || state.isSubmitting) return;

    emit(state.copyWith(isSubmitting: true));

    // Simulate submission delay
    await Future<void>.delayed(const Duration(milliseconds: 600));

    emit(state.copyWith(isSubmitting: false, isSuccess: true));

    CustomAlertDialog.showCustomDialog(
      title: StringFile.feedbackSubmitted,
      subtitle: StringFile.feedbackSubmittedMsg,
    );

    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
}
