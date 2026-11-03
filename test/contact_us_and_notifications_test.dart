import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solofy_vendor_app/application/bloc/notifications_cubit/notifications_cubit.dart';
import 'package:solofy_vendor_app/application/bloc/profile_cubit/profile_cubit.dart';
import 'package:solofy_vendor_app/application/core/app_details.dart';
import 'package:solofy_vendor_app/application/core/route/app_route.dart';
import 'package:solofy_vendor_app/application/core/theme/theme/theme_cubit.dart';
import 'package:solofy_vendor_app/presentation/contact_us/contact_us_screen.dart';
import 'package:solofy_vendor_app/presentation/main/main_shell.dart';
import 'package:solofy_vendor_app/presentation/main/widgets/home_app_bar.dart';
import 'package:solofy_vendor_app/presentation/notifications/notification_detail_screen.dart';
import 'package:solofy_vendor_app/presentation/notifications/notification_screen.dart';
import 'package:solofy_vendor_app/presentation/notifications/widgets/notification_card.dart';
import 'package:solofy_vendor_app/presentation/widgets/app_confirm_dialog.dart';
import 'package:solofy_vendor_app/presentation/widgets/app_header_bar.dart';
import 'package:solofy_vendor_app/presentation/widgets/app_page_scaffold.dart';
import 'package:solofy_vendor_app/presentation/widgets/custom_dropdown_field.dart';
import 'package:solofy_vendor_app/presentation/widgets/custom_text_field.dart';
import 'package:solofy_vendor_app/presentation/widgets/primary_button.dart';

Widget _buildTestApp({
  Widget? child,
  Size size = const Size(393, 852),
  double textScale = 1.0,
}) {
  return MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => ThemeCubit()),
      BlocProvider.value(value: ProfileCubit.instance),
      BlocProvider.value(value: NotificationsCubit.instance),
    ],
    child: MediaQuery(
      data: MediaQueryData(
        size: size,
        textScaler: TextScaler.linear(textScale),
        padding: const EdgeInsets.only(top: 44, bottom: 34),
      ),
      child: MaterialApp(
        navigatorKey: AppDetails.globalNavigatorKey,
        onGenerateRoute: AppRoute.onGenerateRoute,
        home: child ?? const MainShell(),
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    NotificationsCubit.instance.reset();
  });

  group('Feature 1: AppConfirmDialog & Side Menu Logout Tests (Screenshot 1)', () {
    testWidgets('Renders AppConfirmDialog with title, message, Cancel and Logout buttons',
        (tester) async {
      bool confirmed = false;

      await tester.pumpWidget(
        _buildTestApp(
          child: Builder(
            builder: (context) {
              return Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      AppConfirmDialog.show(
                        context,
                        title: 'Are you logging out?',
                        message: 'Are You Sure Do You Want To Logout The App',
                        cancelLabel: 'Cancel',
                        confirmLabel: 'Logout',
                        isDestructive: true,
                        onConfirm: () {
                          confirmed = true;
                        },
                      );
                    },
                    child: const Text('Show Dialog'),
                  ),
                ),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.byType(AppConfirmDialog), findsOneWidget);
      expect(find.text('Are you logging out?'), findsOneWidget);
      expect(find.text('Are You Sure Do You Want To Logout The App'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Logout'), findsOneWidget);

      await tester.tap(find.text('Logout'));
      await tester.pumpAndSettle();

      expect(confirmed, isTrue);
      expect(find.byType(AppConfirmDialog), findsNothing);
    });
  });

  group('Feature 2: Contact Us Screen Tests (Figma Screenshot 2)', () {
    testWidgets('Opens Contact Us from Side Menu and renders all components',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(393, 852));
      await tester.pumpWidget(_buildTestApp());
      await tester.pumpAndSettle();

      // Open side menu
      await tester.tap(find.descendant(
        of: find.byType(HomeAppBar),
        matching: find.byType(IconButton),
      ));
      await tester.pumpAndSettle();

      // Tap Contact Us
      await tester.tap(find.text('Contact Us'));
      await tester.pumpAndSettle();

      // Verify Contact Us screen
      expect(find.byType(ContactUsScreen), findsOneWidget);
      expect(find.byType(AppPageScaffold), findsOneWidget);
      expect(find.byType(AppHeaderBar), findsOneWidget);
      expect(find.text('Contact Us'), findsWidgets);

      // Verify dropdown and text area
      expect(find.byType(CustomDropdownField<String>), findsOneWidget);
      expect(find.byType(CustomTextField), findsOneWidget);
      expect(find.text('Reason'), findsOneWidget);
      expect(find.text('Enter Your Comments'), findsOneWidget);

      // Verify pinned bottom section
      expect(find.textContaining('Thanks For Using'), findsOneWidget);
      expect(find.textContaining('Hope'), findsOneWidget);
      expect(find.byType(PrimaryButton), findsOneWidget);
      expect(find.text('Submit'), findsOneWidget);
    });

    testWidgets('Submit button is disabled initially and enables when fields are filled',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(393, 852));
      await tester.pumpWidget(_buildTestApp(child: const ContactUsScreen()));
      await tester.pumpAndSettle();

      final submitFinder = find.widgetWithText(PrimaryButton, 'Submit');
      expect(submitFinder, findsOneWidget);

      PrimaryButton btn = tester.widget<PrimaryButton>(submitFinder);
      expect(btn.isEnabled, isFalse);

      // Select reason
      await tester.tap(find.byType(CustomDropdownField<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Feedback').last);
      await tester.pumpAndSettle();

      // Still disabled because comments are empty
      btn = tester.widget<PrimaryButton>(submitFinder);
      expect(btn.isEnabled, isFalse);

      // Enter comments
      await tester.enterText(find.byType(CustomTextField), 'Great app experience!');
      await tester.pumpAndSettle();

      // Now enabled
      btn = tester.widget<PrimaryButton>(submitFinder);
      expect(btn.isEnabled, isTrue);

      // Tap Submit
      await tester.tap(submitFinder);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 700));
      await tester.pumpAndSettle();
    });
  });

  group('Feature 3 & 4: Notifications List & Detail Tests (Screenshots 3 & 4)', () {
    testWidgets('Bell icon in HomeAppBar shows live unread count and opens NotificationScreen',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(393, 852));
      await tester.pumpWidget(_buildTestApp());
      await tester.pumpAndSettle();

      // Unread count badge shows 2 (from mock data: 2 unread today)
      expect(find.text('2'), findsOneWidget);

      // Tap notification bell
      await tester.tap(find.text('2'));
      await tester.pumpAndSettle();

      // Verify NotificationScreen is displayed
      expect(find.byType(NotificationScreen), findsOneWidget);
      expect(find.byType(AppHeaderBar), findsOneWidget);
      expect(find.text('Notification'), findsOneWidget);

      // Groups Today and Yesterday exist
      expect(find.text('Today'), findsOneWidget);
      expect(find.text('Yesterday'), findsOneWidget);

      // Multiple NotificationCards
      expect(find.byType(NotificationCard), findsNWidgets(5));
    });

    testWidgets('Tapping notification card opens detail and marks it as read',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(393, 852));
      await tester.pumpWidget(_buildTestApp(child: const NotificationScreen()));
      await tester.pumpAndSettle();

      // Initial unread count is 2
      expect(NotificationsCubit.instance.state.unreadCount, 2);

      // Tap the first notification card
      await tester.tap(find.byType(NotificationCard).first);
      await tester.pumpAndSettle();

      // Now on NotificationDetailScreen
      expect(find.byType(NotificationDetailScreen), findsOneWidget);
      expect(find.byType(NotificationCard), findsOneWidget);

      final detailCard = tester.widget<NotificationCard>(find.byType(NotificationCard));
      expect(detailCard.expanded, isTrue);

      // Unread count decremented to 1
      expect(NotificationsCubit.instance.state.unreadCount, 1);
    });

    testWidgets('Renders Contact Us and Notifications at 360, 393, 412 and fontScale 1.3 without overflow',
        (tester) async {
      for (final size in [
        const Size(360, 800),
        const Size(393, 852),
        const Size(412, 915),
      ]) {
        await tester.binding.setSurfaceSize(size);

        await tester.pumpWidget(_buildTestApp(
          child: const ContactUsScreen(),
          size: size,
          textScale: 1.3,
        ));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);

        await tester.pumpWidget(_buildTestApp(
          child: const NotificationScreen(),
          size: size,
          textScale: 1.3,
        ));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
    });

    testWidgets('AppRoute.onGenerateRoute returns MaterialPageRoute for notification routes',
        (tester) async {
      final notifRoute = AppRoute.onGenerateRoute(
        const RouteSettings(name: 'notifications'),
      );
      expect(notifRoute, isA<MaterialPageRoute>());
      expect(notifRoute.settings.name, 'notifications');

      final detailRoute = AppRoute.onGenerateRoute(
        RouteSettings(
          name: 'notification-detail',
          arguments: NotificationsCubit.defaultNotifications.first,
        ),
      );
      expect(detailRoute, isA<MaterialPageRoute>());
      expect(detailRoute.settings.name, 'notification-detail');
    });

    testWidgets('Back arrow in NotificationScreen and detail screen pops route normally',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(393, 852));
      await tester.pumpWidget(_buildTestApp());
      await tester.pumpAndSettle();

      // Tap notification bell
      await tester.tap(find.text('2'));
      await tester.pumpAndSettle();

      expect(find.byType(NotificationScreen), findsOneWidget);

      // Tap back button
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Back on Home
      expect(find.byType(NotificationScreen), findsNothing);
      expect(find.text('2'), findsOneWidget);
    });
  });
}
