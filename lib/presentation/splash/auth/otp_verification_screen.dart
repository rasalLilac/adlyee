import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:solofy_vendor_app/application/core/route/app_route.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/diamentions.dart';
import 'package:solofy_vendor_app/application/core/theme/text_styles.dart';
import 'package:solofy_vendor_app/application/core/utils/constants.dart';
import 'package:solofy_vendor_app/application/core/utils/string_file.dart';
import 'package:solofy_vendor_app/application/core/utils/validators.dart';
import 'package:solofy_vendor_app/presentation/splash/auth/user_details_screen.dart';
import 'package:solofy_vendor_app/presentation/splash/auth/widgets/auth_card.dart';
import 'package:solofy_vendor_app/presentation/splash/auth/widgets/auth_scaffold.dart';
import 'package:solofy_vendor_app/presentation/widgets/custom_text_field.dart';
import 'package:solofy_vendor_app/presentation/widgets/primary_button.dart';
import 'package:solofy_vendor_app/presentation/widgets/text_link_button.dart';

/// Screen 3 - "OTP Verification!": enter the OTP, resend after the timer ends.
class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key, required this.phone});

  static const routeName = 'otp-verification';

  /// Number the OTP was sent to (passed from the login screen).
  final String phone;

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  Timer? _timer;
  int _secondsLeft = AppConstants.otpResendSeconds;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _secondsLeft = AppConstants.otpResendSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() => _secondsLeft--);
      if (_secondsLeft <= 0) timer.cancel();
    });
  }

  String get _timerText {
    final minutes = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsLeft % 60).toString().padLeft(2, '0');
    return '($minutes:$seconds)';
  }

  void _onResend() {
    // TODO(auth): context.read<AuthBloc>().add(AuthEvent.sendOTP(phone: widget.phone))
    _otpController.clear();
    _startTimer();
    setState(() {});
  }

  void _onConfirm() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    // TODO(auth): context.read<AuthBloc>().add(AuthEvent.verifyOTP(phone: widget.phone, otp: ...))
    // Existing user -> Home, new user -> details screen (decide from the API response).
    AppRoute.pushReplacementNamed(
      UserDetailsScreen.routeName,
      arguments: {'phone': widget.phone},
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      card: AuthCard(
        title: StringFile.otpVerification,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: _otpController,
                hintText: StringFile.enterOtp,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                maxLength: AppConstants.otpLength,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: Validators.otp,
                onFieldSubmitted: (_) => _onConfirm(),
              ),
              gap4,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _timerText,
                    style: baseTextStyle.s11.w400.copyWith(
                      color: ColorResources.grey,
                    ),
                  ),
                  TextLinkButton(
                    label: StringFile.resend,
                    color: ColorResources.primary,
                    enabled: _secondsLeft <= 0,
                    onPressed: _onResend,
                  ),
                ],
              ),
              gap8,
              PrimaryButton(label: StringFile.confirm, onPressed: _onConfirm),
            ],
          ),
        ),
      ),
    );
  }
}
