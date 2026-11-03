// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

class ColorResources {
  static const gradientColor1 = Color(0xFF2E75B5);
  static const gradientColor2 = Color(0xFF7FAAD0);
  static const gradientColor3 = Color(0xFFD2E3F2);
  static const gradientColor4 = Color(0xFFFFFFFF);

  static const primaryGradient = LinearGradient(
    colors: [gradientColor1, gradientColor2, gradientColor3, gradientColor4],
    // begin: Alignment.topLeft,
    // end: Alignment.bottomRight,
  );

  static const primary = Color(0xFF2E75B5);
  static const lightBlue = Color(0xFFE4F2FF);

  static const textColor = Color(0xFF01091B);
  static const white = Color(0xFFFFFFFF);
  static const scaffoldBackground = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
  static const grey = Color(0xFF979797);
  static const borderColor = Color(0xFFE4EBFF);
  static const primaryShadow = Color(0xFF70A2CF);
  static const secondaryShadow = Color(0xFF616161);
  static const dividerColor = Color(0xFFA4B6DD);
  static const textFieldBorderColor = Color(0xFFD8D8D8);
  static const textFieldColor = Color(0xFFFBFBFB);
  static const green = Color(0xFF00B72E);
  static const red = Color(0xFFFF383C);
  static const orange = Color(0xFFFF9800);
  static const purple = Color(0xFFBA38D5);
  static const navInactive = Color(0xFFC2D6E7);
  static const navBorder = Color(0xFFE4EBFF);
  static const lightGray = Color(0xFFD9D9D9);
  static const appBackgroundGrey = Color(0xFFE5E5E5);
  static const transparent = Colors.transparent;

  // ---- Status chip colors ----
  static const statusActive = Color(0xFF00B72E);
  static const statusActiveText = Color(0xFF00B72E);
  static const statusActiveBg = Color(0xFFE8F8EE);
  static const statusExpiring = Color(0xFFFF9800);
  static const statusExpiringText = Color(0xFFFF9800);
  static const statusExpiringBg = Color(0xFFFFF3E0);
  static const statusExpired = Color(0xFFFF383C);
  static const statusExpiredText = Color(0xFFFF383C);
  static const statusExpiredBg = Color(0xFFFFEBEE);
  static const statusPendingApproval = Color(0xFF2E75B5);
  static const statusPendingApprovalText = Color(0xFF2E75B5);
  static const statusPendingApprovalBg = Color(0xFFE4F2FF);
  static const statusRejected = Color(0xFFE53935);
  static const statusRejectedText = Color(0xFFE53935);
  static const statusRejectedBg = Color(0xFFFFEBEE);
  static const statusStopped = Color(0xFFFF383C);
  static const statusStoppedText = Color(0xFFFF383C);
  static const statusStoppedBg = Color(0xFFFFEBEE);

  // ---- Contact & Action colors ----
  static const whatsappGreen = Color(0xFF25D366);
  static const textSecondary = Color(0xFF555555);
  static const textMuted = Color(0xFF757575);
  static const bannerBlue = Color(0xFF266FB1);
  static const darkButton = Color(0xFF0C1322);
}
