import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:solofy_vendor_app/application/bloc/edit_profile_cubit/edit_profile_cubit.dart';
import 'package:solofy_vendor_app/application/bloc/edit_profile_cubit/edit_profile_state.dart';
import 'package:solofy_vendor_app/application/bloc/profile_cubit/profile_cubit.dart';
import 'package:solofy_vendor_app/application/core/route/app_route.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/scale.dart';
import 'package:solofy_vendor_app/application/core/utils/alert_dialog.dart';
import 'package:solofy_vendor_app/application/core/utils/app_assets.dart';
import 'package:solofy_vendor_app/application/core/utils/constants.dart';
import 'package:solofy_vendor_app/application/core/utils/string_file.dart';
import 'package:solofy_vendor_app/application/core/utils/validators.dart';
import 'package:solofy_vendor_app/presentation/splash/auth/widgets/country_code_prefix.dart';
import 'package:solofy_vendor_app/presentation/widgets/app_header_bar.dart';
import 'package:solofy_vendor_app/presentation/widgets/app_page_scaffold.dart';
import 'package:solofy_vendor_app/presentation/widgets/custom_text_field.dart';
import 'package:solofy_vendor_app/presentation/widgets/primary_button.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  static const routeName = 'edit-profile';

  @override
  Widget build(BuildContext context) {
    final profileCubit = ProfileCubit.instance;
    return BlocProvider(
      create: (_) => EditProfileCubit(profile: profileCubit.state),
      child: const _EditProfileView(),
    );
  }
}

class _EditProfileView extends StatefulWidget {
  const _EditProfileView();

  @override
  State<_EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<_EditProfileView> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _otpController;

  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final cubit = context.read<EditProfileCubit>();
    _nameController = TextEditingController(text: cubit.state.name);
    _phoneController = TextEditingController(text: cubit.state.phone);
    _emailController = TextEditingController(text: cubit.state.email);
    _otpController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _otpController.dispose();
    _phoneFocusNode.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  void _onSave(BuildContext context, EditProfileState state) {
    if (!state.canSave) return;
    final profileCubit = ProfileCubit.instance;
    profileCubit.updateProfile(
      name: state.name.trim(),
      phone: state.phone.trim(),
      email: state.email.trim(),
    );
    CustomAlertDialog.showCustomDialog(
      title: StringFile.profileUpdated,
      subtitle: StringFile.profileUpdatedSuccess,
    );
    AppRoute.pop();
  }

  Future<void> _onConfirmOtp(BuildContext context, EditProfileCubit cubit) async {
    final success = await cubit.confirmOtp();
    if (!context.mounted) return;
    if (success) {
      _otpController.clear();
      final profileCubit = ProfileCubit.instance;
      profileCubit.updateProfile(phone: cubit.state.phone);
    } else if (cubit.state.errorMessage != null) {
      CustomAlertDialog.showCustomDialog(
        title: 'Invalid OTP',
        subtitle: cubit.state.errorMessage!,
      );
    }
  }

  Widget _buildAvatar(String? avatarUrl) {
    return Center(
      child: Container(
        width: 96.s,
        height: 96.s,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ColorResources.lightBlue,
          border: Border.all(
            color: ColorResources.textFieldBorderColor,
            width: 1.s,
          ),
        ),
        child: ClipOval(
          child: avatarUrl != null && avatarUrl.isNotEmpty
              ? Image.network(
                  avatarUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _buildAvatarFallback(),
                )
              : _buildAvatarFallback(),
        ),
      ),
    );
  }

  Widget _buildAvatarFallback() {
    return Center(
      child: Icon(
        Icons.person,
        color: ColorResources.primary,
        size: 52.s,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomSafe = MediaQuery.paddingOf(context).bottom;

    return BlocConsumer<EditProfileCubit, EditProfileState>(
      listener: (context, state) {
        // Sync phone controller if updated via confirm OTP
        if (state.step == EditProfileStep.idle &&
            _phoneController.text != state.phone) {
          _phoneController.text = state.phone;
        }
      },
      builder: (context, state) {
        final cubit = context.read<EditProfileCubit>();
        final profile = ProfileCubit.instance.state;

        // Pinned Bottom Button definition
        Widget bottomButton;
        switch (state.step) {
          case EditProfileStep.idle:
            bottomButton = PrimaryButton(
              label: StringFile.save,
              isEnabled: state.canSave,
              isLoading: state.isLoading,
              onPressed: () => _onSave(context, state),
            );
          case EditProfileStep.phoneChanged:
            bottomButton = PrimaryButton(
              label: StringFile.sendOtp,
              isEnabled: state.canSendOtp,
              isLoading: state.isLoading,
              onPressed: () => cubit.sendOtp(),
            );
          case EditProfileStep.otpSent:
            bottomButton = PrimaryButton(
              label: StringFile.confirm,
              isEnabled: state.canConfirmOtp,
              isLoading: state.isLoading,
              onPressed: () => _onConfirmOtp(context, cubit),
            );
        }

        return AppPageScaffold(
          scrollable: true,
          horizontalPadding: 18,
          bottomBar: Padding(
            padding: EdgeInsets.fromLTRB(
              18.s,
              8.s,
              18.s,
              16.s + bottomSafe,
            ),
            child: bottomButton,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Back arrow left + centered "Edit Profile"
              const AppHeaderBar(title: StringFile.editProfile),
              Gap(20.s),

              // Big Circular Avatar (96px, no camera badge)
              _buildAvatar(profile.avatarUrl),
              Gap(28.s),

              // 1. Name Field (plain editable text field)
              CustomTextField(
                controller: _nameController,
                hintText: StringFile.name,
                textCapitalization: TextCapitalization.words,
                onChanged: (v) => cubit.onNameChanged(v),
                validator: (v) => Validators.name(v),
              ),
              Gap(12.s),

              // 2. Phone Field: "+91 |" prefix + number, edit pencil on right
              CustomTextField(
                controller: _phoneController,
                readOnly: !state.isPhoneEditing,
                focusNode: _phoneFocusNode,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(AppConstants.phoneLength),
                ],
                prefix: const CountryCodePrefix(),
                hintText: StringFile.enterMobileNumber,
                suffixIcon: IconButton(
                  icon: SvgPicture.asset(
                    AppAssets.editSvg,
                    width: 20.s,
                    height: 20.s,
                  ),
                  onPressed: () {
                    cubit.enablePhoneEditing();
                    _phoneFocusNode.requestFocus();
                  },
                ),
                onChanged: (v) => cubit.onPhoneChanged(v),
                validator: (v) => Validators.phone(v),
              ),
              Gap(12.s),

              // 3. Email Field OR Enter OTP Field
              if (state.step == EditProfileStep.idle)
                CustomTextField(
                  controller: _emailController,
                  readOnly: !state.isEmailEditing,
                  focusNode: _emailFocusNode,
                  keyboardType: TextInputType.emailAddress,
                  hintText: StringFile.email,
                  suffixIcon: IconButton(
                    icon: SvgPicture.asset(
                      AppAssets.editSvg,
                      width: 20.s,
                      height: 20.s,
                    ),
                    onPressed: () {
                      cubit.enableEmailEditing();
                      _emailFocusNode.requestFocus();
                    },
                  ),
                  onChanged: (v) => cubit.onEmailChanged(v),
                  validator: (v) => Validators.email(v),
                )
              else
                CustomTextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(AppConstants.otpLength),
                  ],
                  hintText: StringFile.enterOtpHint,
                  onChanged: (v) => cubit.onOtpChanged(v),
                  validator: (v) => Validators.otp(v),
                ),
            ],
          ),
        );
      },
    );
  }
}

