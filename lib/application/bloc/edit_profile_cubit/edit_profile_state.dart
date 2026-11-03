import 'package:equatable/equatable.dart';
import 'package:solofy_vendor_app/application/core/utils/constants.dart';
import 'package:solofy_vendor_app/application/core/utils/validators.dart';

enum EditProfileStep {
  idle,         // Normal state: button is "Save" (disabled until dirty & valid)
  phoneChanged, // Phone number was edited to new 10-digit number -> button is "Send OTP", Email replaced by OTP field
  otpSent,      // "Send OTP" tapped & succeeded -> button is "Confirm"
}

class EditProfileState extends Equatable {
  const EditProfileState({
    required this.name,
    required this.phone,
    required this.email,
    required this.otp,
    required this.initialName,
    required this.initialPhone,
    required this.initialEmail,
    this.step = EditProfileStep.idle,
    this.isPhoneEditing = false,
    this.isEmailEditing = false,
    this.isLoading = false,
    this.errorMessage,
  });

  final String name;
  final String phone;
  final String email;
  final String otp;
  final String initialName;
  final String initialPhone;
  final String initialEmail;
  final EditProfileStep step;
  final bool isPhoneEditing;
  final bool isEmailEditing;
  final bool isLoading;
  final String? errorMessage;

  bool get isDirty =>
      name.trim() != initialName.trim() ||
      email.trim().toLowerCase() != initialEmail.trim().toLowerCase() ||
      (phone.trim() != initialPhone.trim() && step == EditProfileStep.idle);

  bool get isValid =>
      name.trim().isNotEmpty &&
      (step == EditProfileStep.idle ? (Validators.email(email) == null) : true);

  bool get canSave =>
      step == EditProfileStep.idle && isDirty && isValid && !isLoading;

  bool get canSendOtp =>
      step == EditProfileStep.phoneChanged &&
      phone.trim().length == AppConstants.phoneLength &&
      !isLoading;

  bool get canConfirmOtp =>
      step == EditProfileStep.otpSent && otp.trim().isNotEmpty && !isLoading;

  EditProfileState copyWith({
    String? name,
    String? phone,
    String? email,
    String? otp,
    String? initialName,
    String? initialPhone,
    String? initialEmail,
    EditProfileStep? step,
    bool? isPhoneEditing,
    bool? isEmailEditing,
    bool? isLoading,
    String? errorMessage,
  }) {
    return EditProfileState(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      otp: otp ?? this.otp,
      initialName: initialName ?? this.initialName,
      initialPhone: initialPhone ?? this.initialPhone,
      initialEmail: initialEmail ?? this.initialEmail,
      step: step ?? this.step,
      isPhoneEditing: isPhoneEditing ?? this.isPhoneEditing,
      isEmailEditing: isEmailEditing ?? this.isEmailEditing,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        name,
        phone,
        email,
        otp,
        initialName,
        initialPhone,
        initialEmail,
        step,
        isPhoneEditing,
        isEmailEditing,
        isLoading,
        errorMessage,
      ];
}

