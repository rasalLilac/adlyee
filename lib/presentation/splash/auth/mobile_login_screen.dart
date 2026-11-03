import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:solofy_vendor_app/application/core/route/app_route.dart';
import 'package:solofy_vendor_app/application/core/theme/diamentions.dart';
import 'package:solofy_vendor_app/application/core/utils/constants.dart';
import 'package:solofy_vendor_app/application/core/utils/string_file.dart';
import 'package:solofy_vendor_app/application/core/utils/validators.dart';
import 'package:solofy_vendor_app/presentation/home/home_screen.dart';
import 'package:solofy_vendor_app/presentation/splash/auth/otp_verification_screen.dart';
import 'package:solofy_vendor_app/presentation/splash/auth/widgets/auth_card.dart';
import 'package:solofy_vendor_app/presentation/splash/auth/widgets/auth_scaffold.dart';
import 'package:solofy_vendor_app/presentation/splash/auth/widgets/country_code_prefix.dart';
import 'package:solofy_vendor_app/presentation/widgets/custom_text_field.dart';
import 'package:solofy_vendor_app/presentation/widgets/primary_button.dart';
import 'package:solofy_vendor_app/presentation/widgets/text_link_button.dart';

/// Screen 2 - "Welcome Back!": enter mobile number, send OTP, or continue as guest.
class MobileLoginScreen extends StatefulWidget {
  const MobileLoginScreen({super.key});

  static const routeName = 'mobile-login';

  @override
  State<MobileLoginScreen> createState() => _MobileLoginScreenState();
}

class _MobileLoginScreenState extends State<MobileLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _onSendOtp() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final phone = _phoneController.text.trim();
    // TODO(auth): context.read<AuthBloc>().add(AuthEvent.sendOTP(phone: phone))
    // and navigate from a BlocListener when otpSendStatus == ApiStatus.success.
    AppRoute.pushNamed(
      OtpVerificationScreen.routeName,
      arguments: {'phone': phone},
    );
  }

  void _onContinueAsGuest() {
    AppRoute.pushReplacementNamed(HomeScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      card: AuthCard(
        title: StringFile.welcomeBack,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: _phoneController,
                hintText: StringFile.enterMobileNumber,
                prefix: const CountryCodePrefix(),
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                maxLength: AppConstants.phoneLength,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: Validators.phone,
                onFieldSubmitted: (_) => _onSendOtp(),
              ),
              gap16,
              PrimaryButton(label: StringFile.sendOtp, onPressed: _onSendOtp),
              gap8,
              TextLinkButton(
                label: StringFile.continueAsGuest,
                onPressed: _onContinueAsGuest,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
