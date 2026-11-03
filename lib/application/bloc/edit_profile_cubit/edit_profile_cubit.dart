import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solofy_vendor_app/application/bloc/edit_profile_cubit/edit_profile_state.dart';
import 'package:solofy_vendor_app/application/bloc/profile_cubit/user_profile.dart';
import 'package:solofy_vendor_app/application/core/utils/constants.dart';
import 'package:solofy_vendor_app/application/core/utils/validators.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit({required UserProfile profile})
      : super(
          EditProfileState(
            name: profile.name,
            phone: profile.phone,
            email: profile.email,
            otp: '',
            initialName: profile.name,
            initialPhone: profile.phone,
            initialEmail: profile.email,
          ),
        );

  void onNameChanged(String val) {
    emit(state.copyWith(name: val, errorMessage: null));
  }

  void onPhoneChanged(String val) {
    final cleaned = val.trim();
    EditProfileStep nextStep = state.step;
    if (cleaned.length == AppConstants.phoneLength && cleaned != state.initialPhone) {
      nextStep = EditProfileStep.phoneChanged;
    } else if (cleaned == state.initialPhone) {
      nextStep = EditProfileStep.idle;
    }
    emit(state.copyWith(phone: cleaned, step: nextStep, errorMessage: null));
  }

  void onEmailChanged(String val) {
    emit(state.copyWith(email: val.trim(), errorMessage: null));
  }

  void onOtpChanged(String val) {
    emit(state.copyWith(otp: val.trim(), errorMessage: null));
  }

  void enablePhoneEditing() {
    emit(state.copyWith(isPhoneEditing: true));
  }

  void enableEmailEditing() {
    emit(state.copyWith(isEmailEditing: true));
  }

  Future<void> sendOtp() async {
    if (!state.canSendOtp) return;
    emit(state.copyWith(isLoading: true, errorMessage: null));
    // TODO(api): Request OTP from auth service
    await Future<void>.delayed(const Duration(milliseconds: 600));
    emit(state.copyWith(isLoading: false, step: EditProfileStep.otpSent));
  }

  Future<bool> confirmOtp() async {
    if (!state.canConfirmOtp) return false;
    emit(state.copyWith(isLoading: true, errorMessage: null));
    // TODO(api): Verify OTP with backend
    await Future<void>.delayed(const Duration(milliseconds: 600));

    // Validate OTP using AppConstants.otpLength or basic check
    final err = Validators.otp(state.otp);
    if (err != null && state.otp != '1234') { // Support 1234 mock from Figma or 6-digit
      emit(state.copyWith(isLoading: false, errorMessage: err));
      return false;
    }

    emit(
      state.copyWith(
        isLoading: false,
        initialPhone: state.phone,
        step: EditProfileStep.idle,
        otp: '',
        isPhoneEditing: false,
      ),
    );
    return true;
  }
}

