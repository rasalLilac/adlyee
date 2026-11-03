import 'package:flutter/material.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/diamentions.dart';
import 'package:solofy_vendor_app/application/core/theme/text_styles.dart';
import 'package:solofy_vendor_app/application/core/utils/extentions.dart';
import 'package:solofy_vendor_app/application/core/utils/string_file.dart';
import 'package:solofy_vendor_app/presentation/widgets/app_logo.dart';
import 'package:solofy_vendor_app/presentation/widgets/pattern_background.dart';

/// Shared layout of Login / OTP / Details screens:
/// blue pattern background, logo badge + "Welcome To Adlyee" on top,
/// and the screen-specific [card] pinned to the bottom (moves above the keyboard).
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({super.key, required this.card});

  /// Usually an `AuthCard`.
  final Widget card;

  @override
  Widget build(BuildContext context) {
    final size = context.getSize;
    return Scaffold(
      backgroundColor: ColorResources.primary,
      body: PatternBackground(
        child: SafeArea(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => FocusScope.of(context).unfocus(),
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            SizedBox(height: size.height * 0.08),
                            _LogoBadge(size: size.width * 0.28),
                            gap24,
                            const _WelcomeTitle(),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          authCardMargin,
                          paddingLarge,
                          authCardMargin,
                          authCardMargin,
                        ),
                        child: card,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoBadge extends StatelessWidget {
  const _LogoBadge({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: ColorResources.white,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: AppLogo(size: size * 0.5, color: ColorResources.primary),
      ),
    );
  }
}

class _WelcomeTitle extends StatelessWidget {
  const _WelcomeTitle();

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: StringFile.welcomeTo,
        style: baseTextStyle.s20.w400.white,
        children: [
          TextSpan(
            text: StringFile.appName,
            style: baseTextStyle.s20.w700.white,
          ),
        ],
      ),
    );
  }
}
