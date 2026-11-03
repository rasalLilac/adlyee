import 'dart:async';

import 'package:flutter/material.dart';
import 'package:solofy_vendor_app/application/core/route/app_route.dart';
import 'package:solofy_vendor_app/application/core/theme/diamentions.dart';
import 'package:solofy_vendor_app/application/core/theme/text_styles.dart';
import 'package:solofy_vendor_app/application/core/utils/constants.dart';
import 'package:solofy_vendor_app/application/core/utils/string_file.dart';
import 'package:solofy_vendor_app/presentation/splash/auth/mobile_login_screen.dart';
import 'package:solofy_vendor_app/presentation/widgets/app_logo.dart';
import 'package:solofy_vendor_app/presentation/widgets/pattern_background.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const routeName = 'splash';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(AppConstants.splashDuration, _next);
  }

  void _next() {
    if (!mounted) return;
    // TODO(auth): if a saved token exists, go to Home instead of Login.
    AppRoute.pushReplacementNamed(MobileLoginScreen.routeName);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PatternBackground(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AppLogo(size: 72),
              gap12,
              Text(StringFile.appName, style: baseTextStyle.s16.w500.white),
            ],
          ),
        ),
      ),
    );
  }
}
