import 'package:solofy_vendor_app/application/core/utils/constants.dart';
import 'package:solofy_vendor_app/application/core/utils/string_file.dart';
import 'package:solofy_vendor_app/domain/core/failures/value_object/value_object.dart';

/// Form-field validators. Each returns an error message, or `null` when valid,
/// so they plug straight into `TextFormField.validator`.
class Validators {
  static final _digitsOnly = RegExp(r'^\d+$');

  static String? phone(String? value) {
    final v = value?.trim() ?? '';
    return v.length == AppConstants.phoneLength && _digitsOnly.hasMatch(v)
        ? null
        : StringFile.invalidPhone;
  }

  static String? otp(String? value) {
    final v = value?.trim() ?? '';
    return v.length == AppConstants.otpLength && _digitsOnly.hasMatch(v)
        ? null
        : StringFile.invalidOtp;
  }

  static String? name(String? value) =>
      (value?.trim().isNotEmpty ?? false) ? null : StringFile.invalidName;

  /// Re-uses the domain `Mail` value object so the email rule lives in one place.
  static String? email(String? value) =>
      Mail(value?.trim() ?? '').isValid() ? null : StringFile.invalidEmail;

  static String? pincode(String? value) {
    final v = value?.trim() ?? '';
    return v.length == AppConstants.pincodeLength && _digitsOnly.hasMatch(v)
        ? null
        : StringFile.invalidPincode;
  }

  static String? requiredField(String? value, [String? message]) =>
      (value?.trim().isNotEmpty ?? false)
          ? null
          : (message ?? 'This field is required');
}
