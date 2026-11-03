import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:solofy_vendor_app/application/bloc/post_ad_cubit/post_ad_cubit.dart';
import 'package:solofy_vendor_app/application/bloc/post_ad_cubit/post_ad_state.dart';
import 'package:solofy_vendor_app/application/core/route/app_route.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/scale.dart';
import 'package:solofy_vendor_app/application/core/utils/alert_dialog.dart';
import 'package:solofy_vendor_app/application/core/utils/app_assets.dart';
import 'package:solofy_vendor_app/application/core/utils/constants.dart';
import 'package:solofy_vendor_app/application/core/utils/string_file.dart';
import 'package:solofy_vendor_app/application/core/utils/validators.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/ad_draft.dart';
import 'package:solofy_vendor_app/presentation/ads/post_ad/widgets/ad_location_map_preview.dart';
import 'package:solofy_vendor_app/presentation/splash/auth/widgets/country_code_prefix.dart';
import 'package:solofy_vendor_app/presentation/widgets/app_header_bar.dart';
import 'package:solofy_vendor_app/presentation/widgets/custom_dropdown_field.dart';
import 'package:solofy_vendor_app/presentation/widgets/custom_text_field.dart';
import 'package:solofy_vendor_app/presentation/widgets/image_thumbnail_with_remove.dart';
import 'package:solofy_vendor_app/presentation/widgets/info_note.dart';
import 'package:solofy_vendor_app/presentation/widgets/labeled_radio_group.dart';
import 'package:solofy_vendor_app/presentation/widgets/labeled_switch_row.dart';
import 'package:solofy_vendor_app/presentation/widgets/outlined_app_button.dart';
import 'package:solofy_vendor_app/presentation/widgets/primary_button.dart';

enum AdFormMode { create, edit, modify }

/// Configuration encapsulating all behavior & visual differences between form modes.
class AdFormConfig {
  const AdFormConfig({
    required this.title,
    required this.categoriesEditable,
    required this.showTitleField,
    required this.showUseCurrentLocation,
    required this.isDurationExtension,
    required this.buttonLabel,
    required this.priceRule,
  });

  final String title;
  final bool categoriesEditable;
  final bool showTitleField;
  final bool showUseCurrentLocation;
  final bool isDurationExtension;
  final String Function(AdDraft draft) buttonLabel;
  final int Function(AdDraft draft) priceRule;

  factory AdFormConfig.fromMode(AdFormMode mode) {
    switch (mode) {
      case AdFormMode.create:
        return AdFormConfig(
          title: StringFile.postYourAd,
          categoriesEditable: true,
          showTitleField: false,
          showUseCurrentLocation: true,
          isDurationExtension: false,
          priceRule: (d) => d.runDays * AppConstants.pricePerDay,
          buttonLabel: (_) => StringFile.preview,
        );
      case AdFormMode.edit:
        return AdFormConfig(
          title: StringFile.editYourAd,
          categoriesEditable: false,
          showTitleField: false,
          showUseCurrentLocation: true,
          isDurationExtension: true,
          priceRule: (d) => d.additionalDays * AppConstants.pricePerDay,
          buttonLabel: (d) => d.additionalDays > 0
              ? 'Pay Only ₹${d.additionalDays * AppConstants.pricePerDay}'
              : StringFile.update,
        );
      case AdFormMode.modify:
        return AdFormConfig(
          title: StringFile.modifyYourAd,
          categoriesEditable: true,
          showTitleField: true,
          showUseCurrentLocation: false,
          isDurationExtension: true,
          // TODO(design): whole run is paid again when modifying expired ad
          priceRule: (d) =>
              (d.currentDays + d.additionalDays) * AppConstants.pricePerDay,
          buttonLabel: (d) {
            final total = (d.currentDays + d.additionalDays) * AppConstants.pricePerDay;
            return 'Pay ₹$total';
          },
        );
    }
  }
}

class AdForm extends StatefulWidget {
  const AdForm({
    super.key,
    required this.mode,
    this.onPreview,
    this.onSubmit,
  });

  final AdFormMode mode;
  final VoidCallback? onPreview;
  final VoidCallback? onSubmit;

  @override
  State<AdForm> createState() => _AdFormState();
}

class _AdFormState extends State<AdForm> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  late final TextEditingController _localityController;
  late final TextEditingController _displayDescController;
  late final TextEditingController _descController;
  late final TextEditingController _phoneController;

  bool _isSubmitting = false;

  static const Map<String, List<String>> _mockCategories = {
    'Property': ['Rent', 'Sale', 'Commercial', 'Plot'],
    'Vehicles': ['Cars', 'Bikes', 'Commercial Vehicles'],
    'Electronics': ['Mobiles', 'Laptops', 'Appliances'],
    'Jobs': ['Full-time', 'Part-time', 'Freelance'],
    'Services': ['Cleaning', 'Plumbing', 'Electrician'],
  };

  static const List<int> _daysOptions = [1, 2, 3, 4, 5, 7, 10, 15, 30];
  static const List<int> _additionalDaysOptions = [0, 1, 2, 3, 5, 7, 10, 15, 30];

  @override
  void initState() {
    super.initState();
    final draft = context.read<PostAdCubit>().state.draft;
    _localityController = TextEditingController(text: draft.localityOrPincode);
    _displayDescController = TextEditingController(text: draft.displayDescription);
    _descController = TextEditingController(text: draft.description);
    _phoneController = TextEditingController(text: draft.alternatePhone);
  }

  @override
  void dispose() {
    _localityController.dispose();
    _displayDescController.dispose();
    _descController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImages(PostAdCubit cubit) async {
    try {
      final picked = await _picker.pickMultiImage();
      if (picked.isNotEmpty) {
        cubit.addImages(picked.map((x) => x.path).toList());
      }
    } catch (_) {
      // Fallback for demo/emulator without camera/gallery
      cubit.addImages([AppAssets.housePng]);
    }
  }

  void _useCurrentLocation(PostAdCubit cubit) {
    const loc = 'Palazhi, Calicut - 673014';
    _localityController.text = loc;
    cubit.updateLocality(loc);
    CustomAlertDialog.showCustomDialog(
      title: 'Location Updated',
      subtitle: 'Set to current GPS location: $loc',
    );
  }

  Future<void> _handlePrimaryButton(
    BuildContext context,
    PostAdCubit cubit,
    AdDraft draft,
    AdFormConfig config,
  ) async {
    if (!_formKey.currentState!.validate()) return;

    if (!draft.agreeTerms) {
      CustomAlertDialog.showCustomDialog(
        title: 'Terms Required',
        subtitle: 'Please agree to the terms and conditions to proceed.',
      );
      return;
    }

    if (widget.mode == AdFormMode.create) {
      if (widget.onPreview != null) {
        widget.onPreview!();
      } else {
        AppRoute.pushNamed('ad-preview', arguments: draft);
      }
      return;
    }

    if (widget.onSubmit != null) {
      widget.onSubmit!();
      return;
    }

    setState(() => _isSubmitting = true);
    // TODO(api): Update/Modify ad via backend API
    // TODO(payment): Process payment via payment gateway
    await Future<void>.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;
    setState(() => _isSubmitting = false);

    AppRoute.pushReplacementNamed(
      'ad-post-success',
      arguments: {'adRef': draft.adRef},
    );
  }

  Widget _buildReadOnlyField({required String text}) {
    return Container(
      width: double.infinity,
      height: 44.s,
      padding: EdgeInsets.symmetric(horizontal: 14.s),
      decoration: BoxDecoration(
        color: ColorResources.textFieldColor,
        borderRadius: BorderRadius.circular(10.s),
        border: Border.all(
          color: ColorResources.textFieldBorderColor,
          width: 1.s,
        ),
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 13.s,
          fontWeight: FontWeight.w400,
          color: ColorResources.black,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = AdFormConfig.fromMode(widget.mode);

    return BlocBuilder<PostAdCubit, PostAdState>(
      builder: (context, state) {
        final draft = state.draft;
        final cubit = context.read<PostAdCubit>();
        final subCategories = draft.category.isEmpty
            ? const <String>[]
            : (_mockCategories[draft.category] ?? const <String>[]);

        return Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              18.s,
              16.s,
              18.s,
              24.s + MediaQuery.paddingOf(context).bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header: Back arrow (left) + Location selector (right)
                AppHeaderBar(
                  trailing: GestureDetector(
                    onTap: () {
                      CustomAlertDialog.showCustomDialog(
                        title: 'Location',
                        subtitle: 'Location selector coming soon.',
                      );
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16.s,
                          color: ColorResources.black,
                        ),
                        Gap(4.s),
                        Text(
                          'Palazhi , Calicut',
                          style: GoogleFonts.poppins(
                            fontSize: 12.s,
                            fontWeight: FontWeight.w500,
                            color: ColorResources.black,
                          ),
                        ),
                        Gap(2.s),
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 18.s,
                          color: ColorResources.black,
                        ),
                      ],
                    ),
                  ),
                ),
                Gap(16.s),

                // 2. Title: "Post Your Ad" / "Edit Your Ad" / "Modify Your Ad"
                Text(
                  config.title,
                  style: GoogleFonts.poppins(
                    fontSize: 14.s,
                    fontWeight: FontWeight.w500,
                    color: ColorResources.black,
                  ),
                ),
                Gap(16.s),

                // 3. Category & Sub Category:
                if (!config.categoriesEditable) ...[
                  // Read-only in Edit mode
                  _buildReadOnlyField(text: draft.category),
                  Gap(14.s),
                  _buildReadOnlyField(text: draft.subCategory),
                  Gap(14.s),
                ] else ...[
                  // Editable in Create and Modify modes
                  CustomDropdownField<String>(
                    hintText: StringFile.category,
                    isRequiredStar: true,
                    value: draft.category.isEmpty ? null : draft.category,
                    items: _mockCategories.keys
                        .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                        .toList(),
                    onChanged: (cat) {
                      if (cat != null) {
                        cubit.updateCategory(cat);
                        cubit.updateSubCategory('');
                      }
                    },
                    validator: (v) =>
                        Validators.requiredField(v, 'Category is required'),
                  ),
                  Gap(14.s),
                  CustomDropdownField<String>(
                    hintText: 'Sub Category',
                    isRequiredStar: true,
                    value: (draft.subCategory.isNotEmpty &&
                            subCategories.contains(draft.subCategory))
                        ? draft.subCategory
                        : null,
                    items: subCategories
                        .map((sub) => DropdownMenuItem(value: sub, child: Text(sub)))
                        .toList(),
                    onChanged: (sub) {
                      if (sub != null) cubit.updateSubCategory(sub);
                    },
                    validator: (v) =>
                        Validators.requiredField(v, 'Sub category is required'),
                  ),
                  Gap(14.s),
                ],

                // 4. Auto-generated Ad Title in Modify mode: "<Category> For <Sub Category>"
                if (config.showTitleField) ...[
                  _buildReadOnlyField(text: '${draft.category} For ${draft.subCategory}'),
                  Gap(14.s),
                ],

                // 5. Locality field with location pin icon
                CustomTextField(
                  controller: _localityController,
                  hintText: 'Type Locality or Pin Code.',
                  suffixIcon: Icon(
                    Icons.location_on_outlined,
                    color: ColorResources.grey,
                    size: 20.s,
                  ),
                  onChanged: (val) => cubit.updateLocality(val),
                  validator: (v) => Validators.requiredField(v, 'Locality is required'),
                ),
                Gap(14.s),

                // 6. Use Current Location button (hidden in Modify mode)
                if (config.showUseCurrentLocation) ...[
                  SizedBox(
                    width: double.infinity,
                    height: 44.s,
                    child: ElevatedButton(
                      onPressed: () => _useCurrentLocation(cubit),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorResources.darkButton,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.s),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 14.s),
                        elevation: 0,
                      ),
                      child: Row(
                        children: [
                          Text(
                            StringFile.useCurrentLocation,
                            style: GoogleFonts.poppins(
                              fontSize: 12.s,
                              fontWeight: FontWeight.w500,
                              color: ColorResources.white,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.my_location,
                            size: 18.s,
                            color: ColorResources.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Gap(14.s),
                ],

                // 7. Map Preview
                const AdLocationMapPreview(),
                Gap(14.s),

                // 8. Plan Radio Group (Regular / Featured / Urgent)
                LabeledRadioGroup<AdPlan>(
                  items: const [AdPlan.regular, AdPlan.featured, AdPlan.urgent],
                  labelBuilder: (p) {
                    switch (p) {
                      case AdPlan.regular:
                        return StringFile.regular;
                      case AdPlan.featured:
                        return StringFile.featured;
                      case AdPlan.urgent:
                        return StringFile.urgentTag;
                    }
                  },
                  selectedItem: draft.plan,
                  onChanged: (p) => cubit.updatePlan(p),
                ),
                Gap(14.s),

                // 9. Display Description (Max 50 Chars)
                CustomTextField(
                  controller: _displayDescController,
                  hintText: StringFile.enterDisplayDescription,
                  isRequiredStar: true,
                  maxLength: AppConstants.maxDisplayDescription,
                  innerCounterText: StringFile.max50Chars,
                  maxLines: 2,
                  onChanged: (val) => cubit.updateDisplayDescription(val),
                  validator: (v) =>
                      Validators.requiredField(v, 'Display description is required'),
                ),
                Gap(14.s),

                // 10. Description (Max 150 Chars)
                CustomTextField(
                  controller: _descController,
                  hintText: StringFile.enterDescription,
                  isRequiredStar: true,
                  maxLength: AppConstants.maxDescription,
                  innerCounterText: StringFile.max150Chars,
                  maxLines: 4,
                  onChanged: (val) => cubit.updateDescription(val),
                  validator: (v) => Validators.requiredField(v, 'Description is required'),
                ),
                Gap(14.s),

                // 11. Switch: Show Registered Mobile Number
                LabeledSwitchRow(
                  label: StringFile.showRegisteredNumber,
                  value: draft.showRegisteredNumber,
                  onChanged: (val) => cubit.toggleShowRegisteredNumber(val),
                ),
                Gap(14.s),

                // 12. Alternate phone field
                CustomTextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(AppConstants.phoneLength),
                  ],
                  prefix: const CountryCodePrefix(),
                  hintText: 'Enter alternate phone (optional)',
                  onChanged: (val) => cubit.updateAlternatePhone(val),
                ),
                Gap(14.s),

                // 13. WhatsApp Connect Radio
                Text(
                  StringFile.connectWhatsAppQuestion,
                  style: GoogleFonts.poppins(
                    fontSize: 12.s,
                    fontWeight: FontWeight.w500,
                    color: ColorResources.black,
                  ),
                ),
                Gap(8.s),
                LabeledRadioGroup<bool>(
                  items: const [true, false],
                  labelBuilder: (val) => val ? StringFile.yes : StringFile.no,
                  selectedItem: draft.connectUsingWhatsApp,
                  onChanged: (val) => cubit.updateConnectWhatsApp(val),
                ),
                Gap(14.s),

                // 14. Contact details of interested people Radio
                Text(
                  StringFile.getContactDetailsQuestion,
                  style: GoogleFonts.poppins(
                    fontSize: 12.s,
                    fontWeight: FontWeight.w500,
                    color: ColorResources.black,
                  ),
                ),
                Gap(8.s),
                LabeledRadioGroup<bool>(
                  items: const [true, false],
                  labelBuilder: (val) => val ? StringFile.yes : StringFile.no,
                  selectedItem: draft.getInterestedContactDetails,
                  onChanged: (val) => cubit.updateGetInterestedContactDetails(val),
                ),
                Gap(14.s),

                // 15. Images Section
                Row(
                  children: [
                    SizedBox(
                      height: 40.s,
                      child: ElevatedButton.icon(
                        onPressed: () => _pickImages(cubit),
                        icon: Icon(Icons.image_outlined, size: 18.s),
                        label: Text(
                          StringFile.addImage,
                          style: GoogleFonts.poppins(
                            fontSize: 12.s,
                            fontWeight: FontWeight.w500,
                            color: ColorResources.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorResources.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.s),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                    Gap(8.s),
                    Text(
                      StringFile.optional,
                      style: GoogleFonts.poppins(
                        fontSize: 10.s,
                        fontWeight: FontWeight.w400,
                        color: ColorResources.grey,
                      ),
                    ),
                  ],
                ),
                if (draft.images.isNotEmpty) ...[
                  Gap(12.s),
                  SizedBox(
                    height: 80.s,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: draft.images.length,
                      separatorBuilder: (_, __) => Gap(8.s),
                      itemBuilder: (context, i) {
                        return ImageThumbnailWithRemove(
                          imagePath: draft.images[i],
                          onRemove: () => cubit.removeImage(i),
                        );
                      },
                    ),
                  ),
                ],
                Gap(14.s),

                // 16. Duration section:
                if (config.isDurationExtension) ...[
                  // Edit & Modify modes: "Run Ad for 4 Days" + Dropdown "Additional Day"
                  Text.rich(
                    TextSpan(
                      text: 'Run Ad for ',
                      style: GoogleFonts.poppins(
                        fontSize: 13.s,
                        fontWeight: FontWeight.w400,
                        color: ColorResources.black,
                      ),
                      children: [
                        TextSpan(
                          text: '${draft.currentDays} Days',
                          style: GoogleFonts.poppins(
                            fontSize: 13.s,
                            fontWeight: FontWeight.w700,
                            color: ColorResources.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(8.s),
                  CustomDropdownField<int>(
                    hintText: StringFile.additionalDay,
                    value: draft.additionalDays == 0 ? null : draft.additionalDays,
                    items: _additionalDaysOptions
                        .map((d) => DropdownMenuItem(
                              value: d,
                              child: Text(d == 0 ? '0 Days (No extension)' : '$d Additional Days'),
                            ))
                        .toList(),
                    onChanged: (d) {
                      if (d != null) cubit.updateAdditionalDays(d);
                    },
                  ),
                ] else ...[
                  // Create mode: "Run Ad for (Days)"
                  CustomDropdownField<int>(
                    hintText: StringFile.runAdForDays,
                    value: draft.runDays,
                    items: _daysOptions
                        .map((d) => DropdownMenuItem(value: d, child: Text('$d Days')))
                        .toList(),
                    onChanged: (d) {
                      if (d != null) cubit.updateRunDays(d);
                    },
                  ),
                ],
                Gap(14.s),

                // 17. Checkbox: Agree Terms
                GestureDetector(
                  onTap: () => cubit.toggleAgreeTerms(!draft.agreeTerms),
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    children: [
                      Checkbox(
                        value: draft.agreeTerms,
                        onChanged: (val) => cubit.toggleAgreeTerms(val ?? false),
                        activeColor: ColorResources.primary,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),
                      Gap(4.s),
                      Expanded(
                        child: Text(
                          StringFile.agreeTerms,
                          style: GoogleFonts.poppins(
                            fontSize: 11.s,
                            fontWeight: FontWeight.w400,
                            color: ColorResources.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(14.s),

                // 18. Info line: Pay only ₹50 per day
                const InfoNote(text: StringFile.payPerDayInfo),
                Gap(20.s),

                // 19. Bottom row: Cancel + Action button
                Row(
                  children: [
                    Expanded(
                      child: OutlinedAppButton(
                        label: StringFile.cancel,
                        onPressed: () => AppRoute.pop(),
                      ),
                    ),
                    Gap(16.s),
                    Expanded(
                      child: PrimaryButton(
                        isLoading: _isSubmitting,
                        label: config.buttonLabel(draft),
                        onPressed: () =>
                            _handlePrimaryButton(context, cubit, draft, config),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
