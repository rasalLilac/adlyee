import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/scale.dart';
import 'package:solofy_vendor_app/application/core/theme/theme/theme_cubit.dart';
import 'package:solofy_vendor_app/application/core/utils/enums.dart';

final baseTextStyle = GoogleFonts.poppins();
final baseHeadingStyle = GoogleFonts.poppins();

extension TextStyleX on TextStyle {
  TextStyle get w200 => copyWith(fontWeight: FontWeight.w200);
  TextStyle get w300 => copyWith(fontWeight: FontWeight.w300);
  TextStyle get w400 => copyWith(fontWeight: FontWeight.w400);
  TextStyle get w500 => copyWith(fontWeight: FontWeight.w500);
  TextStyle get w600 => copyWith(fontWeight: FontWeight.w600);
  TextStyle get w700 => copyWith(fontWeight: FontWeight.w700);
  TextStyle get w800 => copyWith(fontWeight: FontWeight.w800);
  TextStyle get w900 => copyWith(fontWeight: FontWeight.w900);
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);

  TextStyle get s08 => copyWith(fontSize: 8.s);
  TextStyle get s09 => copyWith(fontSize: 9.s);
  TextStyle get s10 => copyWith(fontSize: 10.s);
  TextStyle get s11 => copyWith(fontSize: 11.s);
  TextStyle get s12 => copyWith(fontSize: 12.s);
  TextStyle get s13 => copyWith(fontSize: 13.s);
  TextStyle get s14 => copyWith(fontSize: 14.s);
  TextStyle get s15 => copyWith(fontSize: 15.s);
  TextStyle get s16 => copyWith(fontSize: 16.s);
  TextStyle get s18 => copyWith(fontSize: 18.s);
  TextStyle get s20 => copyWith(fontSize: 20.s);
  TextStyle get s22 => copyWith(fontSize: 22.s);
  TextStyle get s24 => copyWith(fontSize: 24.s);
  TextStyle get s26 => copyWith(fontSize: 26.s);
  TextStyle get s28 => copyWith(fontSize: 28.s);
  TextStyle get s31 => copyWith(fontSize: 31.s);
  TextStyle get s32 => copyWith(fontSize: 32.s);

  TextStyle get h12 => copyWith(height: 1.2);
  TextStyle get tight => copyWith(height: 1.15);
  TextStyle get h13 => copyWith(height: 1.3);

  TextStyle get underline => copyWith(decoration: TextDecoration.underline);

  TextStyle get poppins => GoogleFonts.poppins(textStyle: this);

  TextStyle get white => copyWith(color: ColorResources.white);
  TextStyle get primary => copyWith(color: ColorResources.primary);
  TextStyle get red => copyWith(color: ColorResources.red);
  TextStyle get lightGray => copyWith(color: ColorResources.lightGray);
  TextStyle get slateGray => copyWith(color: ColorResources.grey);
  TextStyle get silverGray => copyWith(color: ColorResources.grey);
  TextStyle get grey => copyWith(color: ColorResources.grey);
  TextStyle get black => copyWith(color: ColorResources.black);
}

class ThemeTextStyles {
  static TextStyle getPrimaryTextStyle(BuildContext context) {
    final themeMode = context.watch<ThemeCubit>().state.themeMode;
    final baseStyle = GoogleFonts.poppins(
      textStyle: Theme.of(context).textTheme.titleSmall,
    );

    switch (themeMode) {
      case AppThemeMode.light:
        return baseStyle.black;
      case AppThemeMode.dark:
        return baseStyle.white;
    }
  }

  static TextStyle getSecondaryTextStyle(BuildContext context) {
    final themeMode = context.watch<ThemeCubit>().state.themeMode;
    final baseStyle = GoogleFonts.poppins(
      textStyle: Theme.of(context).textTheme.titleSmall,
    );

    switch (themeMode) {
      case AppThemeMode.light:
        return baseStyle.black;
      case AppThemeMode.dark:
        return baseStyle.white;
    }
  }
}
