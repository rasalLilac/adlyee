import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:solofy_vendor_app/application/core/route/app_route.dart';
import 'package:solofy_vendor_app/application/core/theme/diamentions.dart';
import 'package:solofy_vendor_app/application/core/utils/constants.dart';
import 'package:solofy_vendor_app/application/core/utils/string_file.dart';
import 'package:solofy_vendor_app/application/core/utils/validators.dart';
import 'package:solofy_vendor_app/presentation/home/home_screen.dart';
import 'package:solofy_vendor_app/presentation/splash/auth/widgets/auth_card.dart';
import 'package:solofy_vendor_app/presentation/splash/auth/widgets/auth_scaffold.dart';
import 'package:solofy_vendor_app/presentation/widgets/custom_text_field.dart';
import 'package:solofy_vendor_app/presentation/widgets/primary_button.dart';

/// Screen 4 - "Enter Your Details!": name, email and pincode for new users.
class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({super.key, required this.phone});

  static const routeName = 'user-details';

  /// Verified mobile number (passed from the OTP screen).
  final String phone;

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _pincodeController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  void _onConfirm() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    AppRoute.pushReplacementNamed(HomeScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      card: AuthCard(
        title: StringFile.enterYourDetails,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: _nameController,
                hintText: StringFile.name,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                validator: Validators.name,
              ),
              gap12,
              CustomTextField(
                controller: _emailController,
                hintText: StringFile.email,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: Validators.email,
              ),
              gap12,
              CustomTextField(
                controller: _pincodeController,
                hintText: StringFile.pincode,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                maxLength: AppConstants.pincodeLength,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: Validators.pincode,
                onFieldSubmitted: (_) => _onConfirm(),
              ),
              gap16,
              PrimaryButton(label: StringFile.confirm, onPressed: _onConfirm),
            ],
          ),
        ),
      ),
    );
  }
}
