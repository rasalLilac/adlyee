import 'package:flutter/material.dart';
import 'package:solofy_vendor_app/application/core/route/app_route.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/diamentions.dart';
import 'package:solofy_vendor_app/application/core/theme/scale.dart';
import 'package:solofy_vendor_app/application/core/theme/text_styles.dart';
import 'package:solofy_vendor_app/application/core/utils/string_file.dart';
import 'package:solofy_vendor_app/presentation/ads/post_ad/post_ad_screen.dart';
import 'package:solofy_vendor_app/presentation/home/home_screen.dart';
import 'package:solofy_vendor_app/presentation/main/main_shell.dart';
import 'package:solofy_vendor_app/presentation/widgets/outlined_app_button.dart';
import 'package:solofy_vendor_app/presentation/widgets/pattern_background.dart';

class AdPostSuccessScreen extends StatelessWidget {
  const AdPostSuccessScreen({super.key, this.adRef = '0123456789'});

  final String adRef;

  static const routeName = 'ad-post-success';

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: PatternBackground(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.s, vertical: 24.s),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    const Spacer(),

                    // Large outlined clock icon
                    const Icon(
                      Icons.access_time_outlined,
                      size: 88,
                      color: ColorResources.white,
                    ),
                    gap24,

                    // Ad Ref
                    RichText(
                      text: TextSpan(
                        text: StringFile.adRefPrefix,
                        style: baseTextStyle.s14.w400.copyWith(
                          color: ColorResources.white.withValues(alpha: 0.9),
                        ),
                        children: [
                          TextSpan(
                            text: adRef,
                            style: baseTextStyle.s14.w700.copyWith(
                              color: ColorResources.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    gap12,

                    // Ad Submitted Successfully!
                    Text(
                      StringFile.adSubmittedSuccessfully,
                      textAlign: TextAlign.center,
                      style: baseTextStyle.s20.w700.copyWith(
                        color: ColorResources.white,
                      ),
                    ),
                    gap16,

                    // Review message
                    Text(
                      StringFile.successReviewMsg,
                      textAlign: TextAlign.center,
                      style: baseTextStyle.s13.w400.copyWith(
                        color: ColorResources.white.withValues(alpha: 0.9),
                        height: 1.45,
                      ),
                    ),
                    gap8,

                    // Status update message with clickable "submission history" link
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'Please check ',
                        style: baseTextStyle.s13.w400.copyWith(
                          color: ColorResources.white.withValues(alpha: 0.8),
                          height: 1.45,
                        ),
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.baseline,
                            baseline: TextBaseline.alphabetic,
                            child: GestureDetector(
                              onTap: () {
                                AppRoute.pushNamedAndRemoveUntil(
                                  MainShell.routeName,
                                  arguments: {'tab': 2},
                                  predicate: (_) => false,
                                );
                              },
                              child: Text(
                                'submission history',
                                style: baseTextStyle.s13.w600.copyWith(
                                  color: ColorResources.white,
                                  decoration: TextDecoration.underline,
                                  decorationColor: ColorResources.white,
                                  height: 1.45,
                                ),
                              ),
                            ),
                          ),
                          TextSpan(
                            text: ' to get updates about the status of your Ad.',
                            style: baseTextStyle.s13.w400.copyWith(
                              color: ColorResources.white.withValues(alpha: 0.8),
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // Buttons
                    // 1. Back to Home (transparent with white border & text)
                    OutlinedAppButton(
                      label: StringFile.backToHome,
                      borderColor: ColorResources.white,
                      textColor: ColorResources.white,
                      backgroundColor: Colors.transparent,
                      onPressed: () {
                        AppRoute.pushNamedAndRemoveUntil(
                          MainShell.routeName,
                          arguments: {'tab': 0},
                          predicate: (_) => false,
                        );
                      },
                    ),
                    gap12,

                    // 2. Post Another (white filled with blue text)
                    OutlinedAppButton(
                      label: StringFile.postAnother,
                      borderColor: ColorResources.white,
                      textColor: ColorResources.primary,
                      backgroundColor: ColorResources.white,
                      onPressed: () {
                        AppRoute.pushNamedAndRemoveUntil(
                          PostAdScreen.routeName,
                          predicate: (route) =>
                              route.settings.name == MainShell.routeName ||
                              route.settings.name == HomeScreen.routeName,
                        );
                      },
                    ),
                    gap8,
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

