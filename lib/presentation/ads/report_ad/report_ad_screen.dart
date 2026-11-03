import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solofy_vendor_app/application/bloc/report_ad_cubit/report_ad_cubit.dart';
import 'package:solofy_vendor_app/application/bloc/report_ad_cubit/report_ad_state.dart';
import 'package:solofy_vendor_app/application/core/route/app_route.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/diamentions.dart';
import 'package:solofy_vendor_app/application/core/theme/text_styles.dart';
import 'package:solofy_vendor_app/application/core/utils/alert_dialog.dart';
import 'package:solofy_vendor_app/application/core/utils/string_file.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/ad_draft.dart';
import 'package:solofy_vendor_app/presentation/widgets/app_header_bar.dart';
import 'package:solofy_vendor_app/presentation/widgets/app_page_scaffold.dart';
import 'package:solofy_vendor_app/presentation/widgets/custom_text_field.dart';
import 'package:solofy_vendor_app/presentation/widgets/labeled_radio_group.dart';
import 'package:solofy_vendor_app/presentation/widgets/primary_button.dart';

class ReportAdScreen extends StatelessWidget {
  const ReportAdScreen({super.key, required this.adRef});

  final String adRef;

  static const routeName = 'report-ad';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReportAdCubit(adRef: adRef),
      child: const _ReportAdView(),
    );
  }
}

class _ReportAdView extends StatefulWidget {
  const _ReportAdView();

  @override
  State<_ReportAdView> createState() => _ReportAdViewState();
}

class _ReportAdViewState extends State<_ReportAdView> {
  late final TextEditingController _reasonController;

  @override
  void initState() {
    super.initState();
    _reasonController = TextEditingController();
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _onReport(BuildContext context, ReportAdCubit cubit, ReportAdState state) async {
    if (!state.isValid) {
      CustomAlertDialog.showCustomDialog(
        title: 'Issue Required',
        subtitle: state.selectedReason == null
            ? 'Please select an issue.'
            : 'Please enter a reason for reporting.',
      );
      return;
    }

    await cubit.submitReport();
    CustomAlertDialog.showCustomDialog(
      title: StringFile.reportedSuccess,
      subtitle: StringFile.reportSuccessMsg,
    );
    AppRoute.pop();
  }

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      horizontalPadding: 18,
      child: BlocBuilder<ReportAdCubit, ReportAdState>(
        builder: (context, state) {
          final cubit = context.read<ReportAdCubit>();

          return LayoutBuilder(
            builder: (context, constraints) {
              return ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header: Back + centered title "Report Ad"
                      const AppHeaderBar(title: StringFile.reportAdTitle),
                      gap16,

                      // Ad Ref
                      RichText(
                        text: TextSpan(
                          text: StringFile.adRefPrefix,
                          style: baseTextStyle.s11.w400.slateGray,
                          children: [
                            TextSpan(
                              text: state.adRef,
                              style: baseTextStyle.s11.w700.black,
                            ),
                          ],
                        ),
                      ),
                      gap12,
                      const Divider(color: ColorResources.borderColor, height: 1),
                      gap16,

                      // Select An Issue
                      Text(
                        StringFile.selectAnIssue,
                        style: baseTextStyle.s12.w500.slateGray,
                      ),
                      gap12,

                      // Radio options
                      LabeledRadioGroup<ReportReason>(
                        items: ReportReason.values,
                        labelBuilder: (r) => r.label,
                        selectedItem: state.selectedReason,
                        isVertical: true,
                        itemSpacing: 14,
                        onChanged: (reason) {
                          cubit.selectReason(reason);
                        },
                      ),

                      // Reason input when Other is selected
                      if (state.selectedReason == ReportReason.other) ...[
                        gap12,
                        CustomTextField(
                          controller: _reasonController,
                          hintText: StringFile.enterReason,
                          maxLines: 4,
                          minLines: 4,
                          onChanged: (val) => cubit.updateOtherReason(val),
                        ),
                      ],

                      const Spacer(),
                      gap24,

                      // Report button pinned at bottom
                      PrimaryButton(
                        label: StringFile.report,
                        isLoading: state.isSubmitting,
                        onPressed: () => _onReport(context, cubit, state),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

