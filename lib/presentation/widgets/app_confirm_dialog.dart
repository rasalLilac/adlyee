import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/scale.dart';
import 'package:solofy_vendor_app/application/core/utils/string_file.dart';
import 'package:solofy_vendor_app/presentation/widgets/custom_material_button.dart';

/// Reusable bottom-aligned confirmation dialog (Figma Logout / Remove / Stop style).
/// Displays a dimmed barrier (black ~0.45), a white card (radius 16, margin 16, padding 16)
/// at the bottom of the screen, with centered title, two-line message, and equal action buttons.
class AppConfirmDialog extends StatelessWidget {
  const AppConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.cancelLabel = StringFile.cancel,
    required this.confirmLabel,
    this.isDestructive = true,
    required this.onConfirm,
  });

  final String title;
  final String message;
  final String cancelLabel;
  final String confirmLabel;
  final bool isDestructive;
  final VoidCallback onConfirm;

  static const double cardRadius = 16.0;
  static const double cardMarginH = 16.0;
  static const double cardMarginBottom = 24.0;
  static const double cardPadding = 16.0;
  static const double buttonHeight = 44.0;
  static const double buttonRadius = 10.0;
  static const double buttonGap = 12.0;

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    String cancelLabel = StringFile.cancel,
    required String confirmLabel,
    bool isDestructive = true,
    required VoidCallback onConfirm,
  }) {
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (dialogContext) => Align(
        alignment: Alignment.bottomCenter,
        child: AppConfirmDialog(
          title: title,
          message: message,
          cancelLabel: cancelLabel,
          confirmLabel: confirmLabel,
          isDestructive: isDestructive,
          onConfirm: onConfirm,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomSafe = MediaQuery.paddingOf(context).bottom;
    final primaryActionColor =
        isDestructive ? ColorResources.red : ColorResources.primary;
    final shadowColor = isDestructive
        ? ColorResources.red.withValues(alpha: 0.35)
        : ColorResources.primaryShadow.withValues(alpha: 0.6);

    return Material(
      color: Colors.transparent,
      child: Container(
        margin: EdgeInsets.fromLTRB(
          cardMarginH.s,
          0,
          cardMarginH.s,
          cardMarginBottom.s + bottomSafe,
        ),
        padding: EdgeInsets.all(cardPadding.s),
        decoration: BoxDecoration(
          color: ColorResources.white,
          borderRadius: BorderRadius.circular(cardRadius.s),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13.s,
                fontWeight: FontWeight.w500,
                color: ColorResources.textColor,
                height: 1.3,
              ),
            ),
            Gap(6.s),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 11.s,
                fontWeight: FontWeight.w400,
                color: ColorResources.grey,
                height: 1.3,
              ),
            ),
            Gap(20.s),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: buttonHeight.s,
                    decoration: BoxDecoration(
                      color: ColorResources.white,
                      borderRadius: BorderRadius.circular(buttonRadius.s),
                      border: Border.all(
                        color: ColorResources.red,
                        width: 1.s,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(buttonRadius.s),
                      child: CustomMaterialButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Center(
                          child: Text(
                            cancelLabel,
                            style: GoogleFonts.poppins(
                              fontSize: 13.s,
                              fontWeight: FontWeight.w500,
                              color: ColorResources.red,
                              height: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Gap(buttonGap.s),
                Expanded(
                  child: Container(
                    height: buttonHeight.s,
                    decoration: BoxDecoration(
                      color: primaryActionColor,
                      borderRadius: BorderRadius.circular(buttonRadius.s),
                      boxShadow: [
                        BoxShadow(
                          color: shadowColor,
                          blurRadius: 10.s,
                          offset: Offset(0, 4.s),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(buttonRadius.s),
                      child: CustomMaterialButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                          onConfirm();
                        },
                        child: Center(
                          child: Text(
                            confirmLabel,
                            style: GoogleFonts.poppins(
                              fontSize: 13.s,
                              fontWeight: FontWeight.w500,
                              color: ColorResources.white,
                              height: 1.2,
                            ),
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

