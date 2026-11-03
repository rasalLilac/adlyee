import 'package:flutter/material.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/scale.dart';
import 'package:solofy_vendor_app/application/core/theme/text_styles.dart';
import 'package:solofy_vendor_app/application/core/utils/string_file.dart';
import 'package:solofy_vendor_app/presentation/widgets/custom_material_button.dart';
import 'package:solofy_vendor_app/presentation/widgets/outlined_app_button.dart';

class DeleteAdDialog extends StatelessWidget {
  const DeleteAdDialog({
    super.key,
    required this.onConfirm,
  });

  final VoidCallback onConfirm;

  static const double sheetRadius = 22.0;
  static const double paddingH = 20.0;
  static const double paddingTop = 24.0;
  static const double paddingBottom = 28.0;
  static const double buttonHeight = 44.0;
  static const double buttonRadius = 10.0;

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onConfirm,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (_) => DeleteAdDialog(onConfirm: onConfirm),
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
              StringFile.deleteAd,
              textAlign: TextAlign.center,
              style: baseTextStyle.s16.w700.black.h12,
            ),
            SizedBox(height: 10.s),
            Text(
              StringFile.areYouSureToDeleteAd,
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
                    onPressed: () => Navigator.of(context).pop(),
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
                          offset: Offset(0, 4.s),
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
                            StringFile.delete,
                            style: baseTextStyle.s14.w500.white.h12,
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
