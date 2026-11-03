import 'package:flutter/material.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/diamentions.dart';
import 'package:solofy_vendor_app/application/core/theme/text_styles.dart';
import 'package:solofy_vendor_app/application/core/utils/string_file.dart';
import 'package:solofy_vendor_app/presentation/widgets/custom_material_button.dart';

class RemoveAdDialog extends StatelessWidget {
  const RemoveAdDialog({
    super.key,
    required this.onConfirm,
  });

  final VoidCallback onConfirm;

  static Future<void> show(BuildContext context, {required VoidCallback onConfirm}) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (_) => RemoveAdDialog(onConfirm: onConfirm),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 380),
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        decoration: BoxDecoration(
          color: ColorResources.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              StringFile.removeAd,
              textAlign: TextAlign.center,
              style: baseTextStyle.s16.w700.black,
            ),
            gap8,
            Text(
              StringFile.areYouSureToRemoveThisFromHere,
              textAlign: TextAlign.center,
              style: baseTextStyle.s12.w400.grey,
            ),
            gap24,
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: ColorResources.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: ColorResources.red,
                        width: 1.2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CustomMaterialButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Center(
                          child: Text(
                            StringFile.cancel,
                            style: baseTextStyle.s14.w500.red,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                gap12,
                Expanded(
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: ColorResources.red,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: ColorResources.red.withValues(alpha: 0.35),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CustomMaterialButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          onConfirm();
                        },
                        child: Center(
                          child: Text(
                            StringFile.remove,
                            style: baseTextStyle.s14.w500.white,
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
