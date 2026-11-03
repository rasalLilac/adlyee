import 'package:flutter/material.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/scale.dart';
import 'package:solofy_vendor_app/application/core/theme/text_styles.dart';
import 'package:solofy_vendor_app/application/core/utils/constants.dart';
import 'package:solofy_vendor_app/application/core/utils/string_file.dart';
import 'package:solofy_vendor_app/presentation/widgets/outlined_app_button.dart';
import 'package:solofy_vendor_app/presentation/widgets/primary_button.dart';

// TODO(design): Finalize re-post confirmation sheet visuals if design changes
// TODO(payment): Replace simulated payment with real payment gateway integration
class RePostAdDialog extends StatefulWidget {
  const RePostAdDialog({
    super.key,
    this.days = 4,
    required this.onConfirm,
  });

  final int days;
  final VoidCallback onConfirm;

  static const double sheetRadius = 22.0;
  static const double paddingH = 20.0;
  static const double paddingTop = 24.0;
  static const double paddingBottom = 28.0;

  static Future<void> show(
    BuildContext context, {
    int days = 4,
    required VoidCallback onConfirm,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (_) => RePostAdDialog(
        days: days,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  State<RePostAdDialog> createState() => _RePostAdDialogState();
}

class _RePostAdDialogState extends State<RePostAdDialog> {
  bool _isLoading = false;

  int get _amount => widget.days * AppConstants.pricePerDay;

  Future<void> _handleConfirm() async {
    setState(() => _isLoading = true);
    // Simulate 1s payment/loading
    await Future<void>.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    Navigator.of(context).pop();
    widget.onConfirm();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorResources.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(RePostAdDialog.sheetRadius.s)),
      ),
      padding: EdgeInsets.fromLTRB(
        RePostAdDialog.paddingH.s,
        RePostAdDialog.paddingTop.s,
        RePostAdDialog.paddingH.s,
        RePostAdDialog.paddingBottom.s,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              StringFile.rePostAd,
              textAlign: TextAlign.center,
              style: baseTextStyle.s16.w700.black.h12,
            ),
            SizedBox(height: 10.s),
            Text(
              StringFile.rePostConfirmMsg(widget.days, _amount),
              textAlign: TextAlign.center,
              style: baseTextStyle.s12.w400.grey.h12,
            ),
            SizedBox(height: 24.s),
            Row(
              children: [
                Expanded(
                  child: OutlinedAppButton(
                    label: StringFile.cancel,
                    textColor: ColorResources.textColor,
                    borderColor: ColorResources.borderColor,
                    backgroundColor: ColorResources.white,
                    onPressed: _isLoading ? () {} : () => Navigator.of(context).pop(),
                  ),
                ),
                SizedBox(width: 14.s),
                Expanded(
                  child: PrimaryButton(
                    label: _isLoading ? 'Processing...' : 'Pay ₹$_amount',
                    onPressed: _isLoading ? () {} : _handleConfirm,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

