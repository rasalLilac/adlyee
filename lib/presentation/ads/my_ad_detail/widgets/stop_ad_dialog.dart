import 'package:flutter/material.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/scale.dart';
import 'package:solofy_vendor_app/application/core/theme/text_styles.dart';
import 'package:solofy_vendor_app/application/core/utils/string_file.dart';
import 'package:solofy_vendor_app/presentation/widgets/custom_material_button.dart';

class StopAdDialog extends StatelessWidget {
  const StopAdDialog({
    super.key,
    required this.onConfirm,
  });

  final VoidCallback onConfirm;

  static const double sheetRadius = 22.0;
  static const double buttonHeight = 44.0;
  static const double buttonRadius = 10.0;
  static const double paddingH = 20.0;
  static const double paddingTop = 24.0;
  static const double paddingBottom = 32.0;

  static Future<void> show(BuildContext context, {required VoidCallback onConfirm}) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (_) => StopAdDialog(onConfirm: onConfirm),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorResources.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(sheetRadius.s)),
      ),
      padding: EdgeInsets.fromLTRB(paddingH.s, paddingTop.s, paddingH.s, paddingBottom.s),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              StringFile.stopAd,
              textAlign: TextAlign.center,
              style: baseTextStyle.s16.w700.black.h12,
            ),
            SizedBox(height: 8.s),
            Text(
              StringFile.areYouSureToStopAd,
              textAlign: TextAlign.center,
              style: baseTextStyle.s12.w400.grey.h12,
            ),
            SizedBox(height: 24.s),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: buttonHeight.s,
                    decoration: BoxDecoration(
                      color: ColorResources.white,
                      borderRadius: BorderRadius.circular(buttonRadius.s),
                      border: Border.all(
                        color: ColorResources.primary,
                        width: 1.2.s,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(buttonRadius.s),
                      child: CustomMaterialButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Center(
                          child: Text(
                            StringFile.cancel,
                            style: baseTextStyle.s14.w500.copyWith(color: ColorResources.primary).h12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 14.s),
                Expanded(
                  child: Container(
                    height: buttonHeight.s,
                    decoration: BoxDecoration(
                      color: ColorResources.red,
                      borderRadius: BorderRadius.circular(buttonRadius.s),
                      boxShadow: [
                        BoxShadow(
                          color: ColorResources.red.withValues(alpha: 0.35),
                          blurRadius: 8.s,
                          offset: Offset(0, 3.s),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(buttonRadius.s),
                      child: CustomMaterialButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          onConfirm();
                        },
                        child: Center(
                          child: Text(
                            StringFile.stopThisAd,
                            style: baseTextStyle.s14.w600.white.h12,
                          ),
                        ),
                      ),
                    ),
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

