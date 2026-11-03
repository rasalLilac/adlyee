import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solofy_vendor_app/application/bloc/contact_us_cubit/contact_us_cubit.dart';
import 'package:solofy_vendor_app/application/bloc/contact_us_cubit/contact_us_state.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/scale.dart';
import 'package:solofy_vendor_app/application/core/utils/constants.dart';
import 'package:solofy_vendor_app/application/core/utils/string_file.dart';
import 'package:solofy_vendor_app/presentation/widgets/app_header_bar.dart';
import 'package:solofy_vendor_app/presentation/widgets/app_page_scaffold.dart';
import 'package:solofy_vendor_app/presentation/widgets/custom_dropdown_field.dart';
import 'package:solofy_vendor_app/presentation/widgets/custom_text_field.dart';
import 'package:solofy_vendor_app/presentation/widgets/primary_button.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  static const routeName = 'contact-us';

  static const List<String> reasons = [
    StringFile.reasonFeedback,
    StringFile.reasonReportProblem,
    StringFile.reasonPaymentIssue,
    StringFile.reasonAccountIssue,
    StringFile.reasonOther,
  ];

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  late final TextEditingController _commentsController;

  @override
  void initState() {
    super.initState();
    _commentsController = TextEditingController();
  }

  @override
  void dispose() {
    _commentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ContactUsCubit(),
      child: BlocBuilder<ContactUsCubit, ContactUsState>(
        builder: (context, state) {
          final bottomSafe = MediaQuery.paddingOf(context).bottom;

          return AppPageScaffold(
            bottomBar: Container(
              color: ColorResources.white,
              padding: EdgeInsets.fromLTRB(
                18.s,
                12.s,
                18.s,
                24.s + bottomSafe,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text.rich(
                    TextSpan(
                      style: GoogleFonts.poppins(
                        fontSize: 12.s,
                        fontWeight: FontWeight.w400,
                        color: ColorResources.textColor,
                        height: 1.4,
                      ),
                      children: [
                        const TextSpan(text: StringFile.thanksForUsing),
                        TextSpan(
                          text: StringFile.appName,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            color: ColorResources.textColor,
                          ),
                        ),
                        const TextSpan(text: StringFile.hopeYouAreEnjoyingIt),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Gap(16.s),
                  PrimaryButton(
                    label: StringFile.submit,
                    isLoading: state.isSubmitting,
                    isEnabled: state.isValid,
                    onPressed: () =>
                        context.read<ContactUsCubit>().submit(context),
                  ),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AppHeaderBar(title: StringFile.contactUs),
                Gap(20.s),
                CustomDropdownField<String>(
                  hintText: StringFile.reason,
                  value: state.reason,
                  items: ContactUsScreen.reasons
                      .map(
                        (r) => DropdownMenuItem<String>(
                          value: r,
                          child: Text(
                            r,
                            style: GoogleFonts.poppins(
                              fontSize: 12.s,
                              fontWeight: FontWeight.w400,
                              color: ColorResources.textColor,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (val) =>
                      context.read<ContactUsCubit>().updateReason(val),
                ),
                Gap(16.s),
                CustomTextField(
                  controller: _commentsController,
                  hintText: StringFile.enterYourComments,
                  minLines: 6,
                  maxLines: 8,
                  maxLength: AppConstants.maxComment,
                  onChanged: (val) =>
                      context.read<ContactUsCubit>().updateComments(val),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

