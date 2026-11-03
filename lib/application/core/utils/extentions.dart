import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/theme/theme_cubit.dart';
import 'package:solofy_vendor_app/application/core/utils/enums.dart';
import 'package:intl/intl.dart';

extension BuildContextX on BuildContext {
  AppThemeMode get theme => read<ThemeCubit>().state.themeMode;
  AppThemeMode get theme1 => read<ThemeCubit>().state.themeMode;

  TextStyle get body =>
      GoogleFonts.poppins(textStyle: Theme.of(this).textTheme.bodyMedium!);
  Size get getSize => MediaQuery.sizeOf(this);

  TextStyle get textStyle1 {
    switch (theme1) {
      case AppThemeMode.light:
        return GoogleFonts.poppins(
          textStyle: Theme.of(
            this,
          ).textTheme.bodyMedium!.copyWith(color: ColorResources.textColor),
        );
      case AppThemeMode.dark:
        return GoogleFonts.poppins(
          textStyle: Theme.of(
            this,
          ).textTheme.bodyMedium!.copyWith(color: ColorResources.white),
        );
    }
  }

  TextStyle get textStyle2 {
    switch (theme1) {
      case AppThemeMode.light:
        return GoogleFonts.poppins(
          textStyle: Theme.of(
            this,
          ).textTheme.bodySmall!.copyWith(color: ColorResources.primary),
        );
      case AppThemeMode.dark:
        return GoogleFonts.poppins(
          textStyle: Theme.of(
            this,
          ).textTheme.bodySmall!.copyWith(color: ColorResources.primary),
        );
    }
  }

  TextStyle get heading {
    switch (theme) {
      case AppThemeMode.light:
        return GoogleFonts.poppins(
          textStyle: Theme.of(
            this,
          ).textTheme.headlineSmall!.copyWith(color: ColorResources.textColor),
        );
      case AppThemeMode.dark:
        return GoogleFonts.poppins(
          textStyle: Theme.of(
            this,
          ).textTheme.headlineSmall!.copyWith(color: ColorResources.white),
        );
    }
  }

  TextStyle get hintText {
    switch (theme) {
      case AppThemeMode.light:
        return GoogleFonts.poppins(
          textStyle: Theme.of(
            this,
          ).textTheme.bodySmall!.copyWith(color: ColorResources.grey),
        );
      case AppThemeMode.dark:
        return GoogleFonts.poppins(
          textStyle: Theme.of(
            this,
          ).textTheme.bodySmall!.copyWith(color: ColorResources.grey),
        );
    }
  }

  TextStyle get resetText {
    switch (theme) {
      case AppThemeMode.light:
        return GoogleFonts.poppins(
          textStyle: Theme.of(
            this,
          ).textTheme.headlineSmall!.copyWith(color: ColorResources.textColor),
        );
      case AppThemeMode.dark:
        return GoogleFonts.poppins(
          textStyle: Theme.of(
            this,
          ).textTheme.headlineSmall!.copyWith(color: ColorResources.textColor),
        );
    }
  }

  TextStyle get whiteText {
    switch (theme) {
      case AppThemeMode.light:
        return GoogleFonts.poppins(
          textStyle: Theme.of(
            this,
          ).textTheme.headlineSmall!.copyWith(color: ColorResources.white),
        );
      case AppThemeMode.dark:
        return GoogleFonts.poppins(
          textStyle: Theme.of(
            this,
          ).textTheme.headlineSmall!.copyWith(color: ColorResources.white),
        );
    }
  }

  TextStyle get primaryText {
    switch (theme) {
      case AppThemeMode.light:
        return GoogleFonts.poppins(
          textStyle: Theme.of(
            this,
          ).textTheme.headlineSmall!.copyWith(color: ColorResources.textColor),
        );
      case AppThemeMode.dark:
        return GoogleFonts.poppins(
          textStyle: Theme.of(
            this,
          ).textTheme.headlineSmall!.copyWith(color: ColorResources.textColor),
        );
    }
  }

  TextStyle get secondaryText {
    switch (theme) {
      case AppThemeMode.light:
        return GoogleFonts.poppins(
          textStyle: Theme.of(
            this,
          ).textTheme.headlineSmall!.copyWith(color: ColorResources.textColor),
        );
      case AppThemeMode.dark:
        return GoogleFonts.poppins(
          textStyle: Theme.of(
            this,
          ).textTheme.headlineSmall!.copyWith(color: ColorResources.textColor),
        );
    }
  }

  TextStyle get redText {
    switch (theme) {
      case AppThemeMode.light:
        return GoogleFonts.poppins(
          textStyle: Theme.of(
            this,
          ).textTheme.headlineSmall!.copyWith(color: ColorResources.red),
        );
      case AppThemeMode.dark:
        return GoogleFonts.poppins(
          textStyle: Theme.of(
            this,
          ).textTheme.headlineSmall!.copyWith(color: ColorResources.red),
        );
    }
  }

  TextStyle get policyText {
    switch (theme) {
      case AppThemeMode.light:
        return GoogleFonts.poppins(
          textStyle: Theme.of(
            this,
          ).textTheme.headlineSmall!.copyWith(color: ColorResources.textColor),
        );
      case AppThemeMode.dark:
        return GoogleFonts.poppins(
          textStyle: Theme.of(
            this,
          ).textTheme.headlineSmall!.copyWith(color: ColorResources.textColor),
        );
    }
  }

  TextStyle get subTitleText {
    switch (theme) {
      case AppThemeMode.light:
        return GoogleFonts.poppins(
          textStyle: Theme.of(
            this,
          ).textTheme.headlineSmall!.copyWith(color: ColorResources.grey),
        );
      case AppThemeMode.dark:
        return GoogleFonts.poppins(
          textStyle: Theme.of(
            this,
          ).textTheme.headlineSmall!.copyWith(color: ColorResources.grey),
        );
    }
  }
}

extension StringCapitalization on String {
  String get capitalize {
    if (isEmpty) {
      return this;
    }

    List<String> words = split(" ");
    for (int i = 0; i < words.length; i++) {
      if (words[i].isNotEmpty) {
        words[i] = words[i][0].toUpperCase() + words[i].substring(1);
      }
    }
    return words.join(" ");
  }

  String toAppDateFormat() {
    try {
      DateTime dt = DateTime.parse(this).toLocal(); // convert to local time

      return DateFormat("dd MMM yyyy | hh:mm a").format(dt);
    } catch (e) {
      return this; // return original if parsing fails
    }
  }

  String toAppDateFormatShort() {
    try {
      DateTime dt = DateTime.parse(this).toLocal(); // convert to local time

      return DateFormat("dd MMM yyyy").format(dt);
    } catch (e) {
      return this; // return original if parsing fails
    }
  }
}

extension ResponseX on Response {
  bool get isOk => statusCode == 200 || statusCode == 201 || statusCode == 202;
  dynamic get responseData => data['data'];
  String get message => data['message'];
  String get error => data[''];
}

extension FormatDate on DateTime {
  String toYyyyMmDd() {
    final year = this.year.toString();
    final month = this.month.toString().padLeft(2, '0');
    final day = this.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}
