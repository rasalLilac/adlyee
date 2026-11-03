import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/scale.dart';

class ThirdTab extends StatelessWidget {
  const ThirdTab({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Container(
        color: ColorResources.white,
        width: double.infinity,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.play_circle_fill_rounded,
                size: 56.s,
                color: ColorResources.navInactive,
              ),
              SizedBox(height: 12.s),
              Text(
                'Coming soon',
                style: GoogleFonts.poppins(
                  fontSize: 16.s,
                  fontWeight: FontWeight.w500,
                  color: ColorResources.grey,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
