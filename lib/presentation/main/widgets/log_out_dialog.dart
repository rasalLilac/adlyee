import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solofy_vendor_app/application/core/route/app_route.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/scale.dart';
import 'package:solofy_vendor_app/application/core/utils/string_file.dart';
import 'package:solofy_vendor_app/presentation/splash/auth/mobile_login_screen.dart';
import 'package:solofy_vendor_app/presentation/widgets/custom_material_button.dart';

class LogOutDialog extends StatelessWidget {
  const LogOutDialog({super.key});

  static const double sheetRadius = 22.0;
  static const double buttonHeight = 44.0;
  static const double buttonRadius = 10.0;
  static const double paddingH = 20.0;
  static const double paddingTop = 24.0;
  static const double paddingBottom = 32.0;

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (_) => const LogOutDialog(),
    );
  }

  void _onConfirm(BuildContext context) {
    Navigator.of(context).pop();
    // TODO(auth): Clear token & user from AppDetails.tokenKey / userKey via local-db service
    AppRoute.pushNamedAndRemoveUntil(
      MobileLoginScreen.routeName,
      predicate: (_) => false,
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
              StringFile.logOut,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 16.s,
                fontWeight: FontWeight.w700,
                color: ColorResources.black,
                height: 1.2,
              ),
            ),
            Gap(8.s),
            Text(
              StringFile.areYouSureToLogOut,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 12.s,
                fontWeight: FontWeight.w400,
                color: ColorResources.grey,
                height: 1.2,
              ),
            ),
            Gap(24.s),
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
                            style: GoogleFonts.poppins(
                              fontSize: 14.s,
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
                Gap(12.s),
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
                        onPressed: () => _onConfirm(context),
                        child: Center(
                          child: Text(
                            StringFile.logOut,
                            style: GoogleFonts.poppins(
                              fontSize: 14.s,
                              fontWeight: FontWeight.w600,
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

