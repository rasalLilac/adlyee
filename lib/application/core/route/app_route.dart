import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solofy_vendor_app/application/bloc/notifications_cubit/notifications_cubit.dart';
import 'package:solofy_vendor_app/application/core/app_details.dart';
import 'package:solofy_vendor_app/application/core/utils/logger.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/ad_detail.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/ad_draft.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/ad_mock.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/submission.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/submission_mock_data.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/submission_status.dart';
import 'package:solofy_vendor_app/domain/bloc/notifications/models/app_notification.dart';
import 'package:solofy_vendor_app/presentation/activity/activity_screen.dart';
import 'package:solofy_vendor_app/presentation/ads/ad_detail/ad_detail_screen.dart';
import 'package:solofy_vendor_app/presentation/ads/edit_ad/edit_ad_screen.dart';
import 'package:solofy_vendor_app/presentation/ads/interested_contacts/interested_contacts_screen.dart';
import 'package:solofy_vendor_app/presentation/ads/modify_ad/modify_ad_screen.dart';
import 'package:solofy_vendor_app/presentation/ads/my_ad_detail/my_ad_detail_screen.dart';
import 'package:solofy_vendor_app/presentation/ads/post_ad/ad_post_success_screen.dart';
import 'package:solofy_vendor_app/presentation/ads/post_ad/ad_preview_screen.dart';
import 'package:solofy_vendor_app/presentation/ads/post_ad/post_ad_screen.dart';
import 'package:solofy_vendor_app/presentation/ads/report_ad/report_ad_screen.dart';
import 'package:solofy_vendor_app/presentation/contact_us/contact_us_screen.dart';
import 'package:solofy_vendor_app/presentation/home/home_screen.dart';
import 'package:solofy_vendor_app/presentation/main/main_shell.dart';
import 'package:solofy_vendor_app/presentation/notifications/notification_detail_screen.dart';
import 'package:solofy_vendor_app/presentation/notifications/notification_screen.dart';
import 'package:solofy_vendor_app/presentation/profile/edit_profile_screen.dart';
import 'package:solofy_vendor_app/presentation/splash/auth/mobile_login_screen.dart';
import 'package:solofy_vendor_app/presentation/splash/auth/otp_verification_screen.dart';
import 'package:solofy_vendor_app/presentation/splash/auth/user_details_screen.dart';
import 'package:solofy_vendor_app/presentation/splash/splash_screen.dart';

class AppRoute {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    Logger.logWarning(
      'Route Name: ${settings.name},  Arguments: ${settings.arguments}, ArgumentType: ${settings.arguments.runtimeType}',
    );
    final arguments = settings.arguments is Map<String, dynamic>
        ? settings.arguments as Map<String, dynamic>
        : null;

    switch (settings.name) {
      // ---- Auth ----
      case MobileLoginScreen.routeName:
        return pushRoute(settings, const MobileLoginScreen());
      case OtpVerificationScreen.routeName:
        return pushRoute(
          settings,
          OtpVerificationScreen(phone: arguments?['phone'] as String? ?? ''),
        );
      case UserDetailsScreen.routeName:
        return pushRoute(
          settings,
          UserDetailsScreen(phone: arguments?['phone'] as String? ?? ''),
        );

      // ---- Home & Ad Details ----
      case MainShell.routeName:
        final initialTab = arguments?['tab'] as int? ?? 0;
        return pushRoute(settings, MainShell(initialTab: initialTab));
      case HomeScreen.routeName:
        return pushRoute(settings, const MainShell(initialTab: 0));
      case ActivityScreen.routeName:
        return pushRoute(settings, const MainShell(initialTab: 1));
      case 'submission-history':
        return pushRoute(settings, const MainShell(initialTab: 2));
      case AdDetailScreen.routeName:
        AdDetail? ad;
        bool isInterested = false;
        if (settings.arguments is AdDetail) {
          ad = settings.arguments as AdDetail;
        } else if (arguments?['ad'] is AdDetail) {
          ad = arguments!['ad'] as AdDetail;
          isInterested = arguments['isInterested'] as bool? ?? false;
        }
        return pushRoute(
          settings,
          AdDetailScreen(
            ad: ad ?? AdMock.propertyActive,
            initialInterested: isInterested,
          ),
        );
      case MyAdDetailScreen.routeName:
        Submission? myAd;
        if (settings.arguments is Submission) {
          myAd = settings.arguments as Submission;
        } else if (arguments?['ad'] is Submission) {
          myAd = arguments!['ad'] as Submission;
        }
        return pushRoute(
          settings,
          MyAdDetailScreen(ad: myAd ?? mockSubmissions.first),
        );
      case EditAdScreen.routeName:
        Submission? editAd;
        if (settings.arguments is Submission) {
          editAd = settings.arguments as Submission;
        } else if (arguments?['ad'] is Submission) {
          editAd = arguments!['ad'] as Submission;
        }
        return pushRoute(
          settings,
          EditAdScreen(ad: editAd ?? mockSubmissions.first),
        );
      case ModifyAdScreen.routeName:
        Submission? modifyAd;
        if (settings.arguments is Submission) {
          modifyAd = settings.arguments as Submission;
        } else if (arguments?['ad'] is Submission) {
          modifyAd = arguments!['ad'] as Submission;
        }
        return pushRoute(
          settings,
          ModifyAdScreen(ad: modifyAd ?? mockSubmissions.firstWhere((s) => s.status == SubmissionStatus.expired)),
        );
      case InterestedContactsScreen.routeName:
      case 'interested-users':
        Submission? contactAd;
        int? roundNum;
        if (settings.arguments is Submission) {
          contactAd = settings.arguments as Submission;
        } else if (arguments != null) {
          contactAd = arguments['ad'] as Submission?;
          roundNum = arguments['roundNumber'] as int?;
        }
        return pushRoute(
          settings,
          InterestedContactsScreen(
            ad: contactAd ?? mockSubmissions.first,
            roundNumber: roundNum,
          ),
        );
      case ReportAdScreen.routeName:
        String adRef = '0123456789';
        if (settings.arguments is String) {
          adRef = settings.arguments as String;
        } else if (arguments?['adRef'] is String) {
          adRef = arguments!['adRef'] as String;
        }
        return pushRoute(settings, ReportAdScreen(adRef: adRef));
      case PostAdScreen.routeName:
        AdDraft? draft;
        if (settings.arguments is AdDraft) {
          draft = settings.arguments as AdDraft;
        } else if (arguments?['draft'] is AdDraft) {
          draft = arguments!['draft'] as AdDraft;
        }
        return pushRoute(settings, PostAdScreen(initialDraft: draft));
      case AdPreviewScreen.routeName:
        AdDraft draft;
        if (settings.arguments is AdDraft) {
          draft = settings.arguments as AdDraft;
        } else if (arguments?['draft'] is AdDraft) {
          draft = arguments!['draft'] as AdDraft;
        } else {
          draft = const AdDraft();
        }
        return pushRoute(settings, AdPreviewScreen(draft: draft));
      case AdPostSuccessScreen.routeName:
        String adRef = '0123456789';
        if (settings.arguments is String) {
          adRef = settings.arguments as String;
        } else if (arguments?['adRef'] is String) {
          adRef = arguments!['adRef'] as String;
        }
        return pushRoute(settings, AdPostSuccessScreen(adRef: adRef));
      case EditProfileScreen.routeName:
        return pushRoute(settings, const EditProfileScreen());
      case ContactUsScreen.routeName:
        return pushRoute(settings, const ContactUsScreen());
      case NotificationScreen.routeName:
        return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (_) => BlocProvider.value(
            value: NotificationsCubit.instance,
            child: const NotificationScreen(),
          ),
        );
      case NotificationDetailScreen.routeName:
        AppNotification? notif;
        if (settings.arguments is AppNotification) {
          notif = settings.arguments as AppNotification;
        } else if (arguments?['notification'] is AppNotification) {
          notif = arguments!['notification'] as AppNotification;
        }
        return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (_) => BlocProvider.value(
            value: NotificationsCubit.instance,
            child: NotificationDetailScreen(
              notification:
                  notif ?? NotificationsCubit.defaultNotifications.first,
            ),
          ),
        );

      // ---- Splash (also the fallback route) ----
      case SplashScreen.routeName:
      default:
        return pushRoute(settings, const SplashScreen());
    }
  }

  static Route<dynamic> pushRoute(RouteSettings settings, Widget screen) {
    // Right-to-left slide. Built with Flutter's own PageRouteBuilder because
    // page_transition 2.2.1 does not compile on the newest Flutter versions.
    return PageRouteBuilder<dynamic>(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) => screen,
      transitionsBuilder: (_, animation, __, child) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeIn);
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        );
      },
    );
  }

  static Future<T?> pushNamed<T>(String routeName, {Object? arguments}) {
    return AppDetails.globalNavigatorKey.currentState!.pushNamed<T>(
      routeName,
      arguments: arguments,
    );
  }

  /// Generic pushReplacementNamed method
  static Future<T?> pushReplacementNamed<T, TO>(
    String routeName, {
    Object? arguments,
  }) {
    return AppDetails.globalNavigatorKey.currentState!
        .pushReplacementNamed<T, TO>(routeName, arguments: arguments);
  }

  /// Generic pushNamedAndRemoveUntil method
  static Future<T?> pushNamedAndRemoveUntil<T>(
    String routeName, {
    Object? arguments,
    bool Function(Route<dynamic>)? predicate,
  }) {
    return AppDetails.globalNavigatorKey.currentState!
        .pushNamedAndRemoveUntil<T>(
          routeName,
          predicate ?? (_) => false, // Default removes all previous routes
          arguments: arguments,
        );
  }

  /// Generic pop method
  static void pop<T>([T? result]) {
    AppDetails.globalNavigatorKey.currentState!.pop<T>(result);
  }

  /// Generic popUntil method
  static void popUntil(bool Function(Route<dynamic>) predicate) {
    AppDetails.globalNavigatorKey.currentState!.popUntil(predicate);
  }

  /// Pop Until + Refresh Route With Arguments
  static void popUntilAndReplaceWithArgs(
    bool Function(Route<dynamic>) predicate,
    Object? arguments,
  ) {
    final navigator = AppDetails.globalNavigatorKey.currentState!;

    navigator.popUntil(predicate);

    // Now replace the top-most route with arguments
    navigator.pushReplacementNamed(
      SplashScreen.routeName,
      arguments: arguments,
      
    );
  }
}