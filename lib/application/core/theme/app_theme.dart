import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/text_styles.dart';
import 'package:solofy_vendor_app/application/core/utils/enums.dart';

class AppTheme {
  static ThemeData getTheme(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.dark:
        return _darkTheme;
      case AppThemeMode.light:
        return _lightTheme;
    }
  }

  static ThemeData get _lightTheme {
    final lightColorScheme = ColorScheme.fromSeed(
      seedColor: ColorResources.primary,
    ).copyWith(
      primary: ColorResources.primary,
      surface: ColorResources.white,
      surfaceTint: Colors.transparent,
      surfaceContainerHighest: ColorResources.white,
      surfaceContainer: ColorResources.white,
      surfaceContainerHigh: ColorResources.white,
      surfaceContainerLow: ColorResources.white,
      surfaceContainerLowest: ColorResources.white,
      secondaryContainer: ColorResources.lightBlue,
      onSecondaryContainer: ColorResources.textColor,
      outline: ColorResources.borderColor,
      outlineVariant: ColorResources.borderColor,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: lightColorScheme,
      scaffoldBackgroundColor: ColorResources.white,
      canvasColor: ColorResources.white,
      splashColor: ColorResources.primary.withValues(alpha: 0.08),
      highlightColor: ColorResources.primary.withValues(alpha: 0.06),
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        bodyMedium: baseTextStyle,
        headlineSmall: baseHeadingStyle,
      ),
      primaryTextTheme: GoogleFonts.poppinsTextTheme(),
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: ColorResources.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: ColorResources.borderColor, width: 1),
        ),
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.08),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        menuStyle: MenuStyle(
          backgroundColor: const WidgetStatePropertyAll(ColorResources.white),
          surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: ColorResources.borderColor, width: 1),
            ),
          ),
          elevation: const WidgetStatePropertyAll(2),
          shadowColor:
              WidgetStatePropertyAll(Colors.black.withValues(alpha: 0.08)),
        ),
      ),
      menuTheme: MenuThemeData(
        style: MenuStyle(
          backgroundColor: const WidgetStatePropertyAll(ColorResources.white),
          surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: ColorResources.borderColor, width: 1),
            ),
          ),
          elevation: const WidgetStatePropertyAll(2),
          shadowColor:
              WidgetStatePropertyAll(Colors.black.withValues(alpha: 0.08)),
        ),
      ),
      menuButtonTheme: MenuButtonThemeData(
        style: ButtonStyle(
          backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
          foregroundColor: const WidgetStatePropertyAll(ColorResources.textColor),
          overlayColor: WidgetStatePropertyAll(
            ColorResources.primary.withValues(alpha: 0.08),
          ),
        ),
      ),
      menuBarTheme: const MenuBarThemeData(
        style: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(ColorResources.white),
          surfaceTintColor: WidgetStatePropertyAll(Colors.transparent),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: ColorResources.white,
        surfaceTintColor: Colors.transparent,
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: ColorResources.white,
        surfaceTintColor: Colors.transparent,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return ColorResources.primary;
          }
          return Colors.transparent;
        }),
        checkColor: const WidgetStatePropertyAll(ColorResources.white),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return ColorResources.primary;
          }
          return ColorResources.grey;
        }),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return ColorResources.primary;
          }
          return ColorResources.white;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return ColorResources.primary.withValues(alpha: 0.4);
          }
          return ColorResources.borderColor;
        }),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: ColorResources.white,
        surfaceTintColor: Colors.transparent,
        headerBackgroundColor: ColorResources.primary,
        headerForegroundColor: ColorResources.white,
        todayBorder: const BorderSide(color: ColorResources.primary),
        dayForegroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return ColorResources.white;
          }
          return ColorResources.textColor;
        }),
        dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return ColorResources.primary;
          }
          return Colors.transparent;
        }),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: ColorResources.primary,
        selectionColor: ColorResources.primary.withValues(alpha: 0.3),
        selectionHandleColor: ColorResources.primary,
      ),
    );
  }
  static ThemeData get _darkTheme => ThemeData(
        scaffoldBackgroundColor: const Color(0xFF191B20),
        textTheme: GoogleFonts.poppinsTextTheme().copyWith(
          bodyMedium: baseTextStyle,
          headlineSmall: baseHeadingStyle,
        ),
        primaryTextTheme: GoogleFonts.poppinsTextTheme(),
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
        ),
      );

  // static PinTheme get defaultPinTheme => PinTheme(
  //       // width: 70,
  //       // height: 70,
  //       margin: const EdgeInsets.all(1),
  //       textStyle: const TextStyle(
  //         fontSize: 20,
  //         color: ColorResources.textColor,
  //
  //         fontWeight: FontWeight.w600,
  //       ),
  //       decoration: BoxDecoration(
  //         color: ColorResources.secondary,
  //         border: Border.all(
  //           color: ColorResources.secondary,
  //         ),
  //         borderRadius: BorderRadius.circular(16),

  //       ),
  //     );

  // static PinTheme get focusedPinTheme => defaultPinTheme.copyDecorationWith(
  //       border: Border.all(color: ColorResources.secondary),
  //       borderRadius: BorderRadius.circular(16),
  //     );

  // static PinTheme get submittedPinTheme => defaultPinTheme.copyWith(
  //       decoration: defaultPinTheme.decoration?.copyWith(
  //         color: ColorResources.secondary,
  //       ),
  //     );
}
