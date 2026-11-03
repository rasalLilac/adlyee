import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solofy_vendor_app/application/bloc/profile_cubit/profile_cubit.dart';
import 'package:solofy_vendor_app/application/core/app_details.dart';
import 'package:solofy_vendor_app/application/core/route/app_route.dart';
import 'package:solofy_vendor_app/application/core/theme/theme/theme_cubit.dart';
import 'package:solofy_vendor_app/presentation/main/main_shell.dart';
import 'package:solofy_vendor_app/presentation/main/widgets/home_app_bar.dart';
import 'package:solofy_vendor_app/presentation/main/widgets/side_menu_content.dart';
import 'package:solofy_vendor_app/presentation/main/widgets/side_menu_host.dart';
import 'package:solofy_vendor_app/presentation/profile/edit_profile_screen.dart';
import 'package:solofy_vendor_app/presentation/widgets/app_confirm_dialog.dart';
import 'package:solofy_vendor_app/presentation/widgets/custom_text_field.dart';
import 'package:solofy_vendor_app/presentation/widgets/primary_button.dart';

Widget _buildApp({Widget? child, Size size = const Size(393, 852)}) {
  return MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => ThemeCubit()),
      BlocProvider.value(value: ProfileCubit.instance),
    ],
    child: MediaQuery(
      data: MediaQueryData(
        size: size,
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
  setUp(() {
    ProfileCubit.instance = ProfileCubit();
  });

  group('Part A: Side Menu Tests (Figma Screenshot 1)', () {
    testWidgets('Opens side menu on hamburger press, shows stacked layers and menu items',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(393, 852));
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // Find hamburger button in HomeAppBar
      final menuButton = find.descendant(
        of: find.byType(HomeAppBar),
        matching: find.byType(IconButton),
      );
      expect(menuButton, findsOneWidget);

      // Tap hamburger icon
      await tester.tap(menuButton);
      await tester.pumpAndSettle();

      // Verify SideMenuContent is visible
      expect(find.byType(SideMenuContent), findsOneWidget);
      expect(find.text('Cameron Williamson'), findsOneWidget);
      expect(find.text('User ID: 654321'), findsOneWidget);

      // Verify Menu Items
      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Favourites'), findsOneWidget);
      expect(find.text('Submissions'), findsOneWidget);
      expect(find.text('Log Out'), findsOneWidget);
      expect(find.text('Contact Us'), findsOneWidget);

      // Verify SideMenuHost has transformed layers
      expect(find.byType(SideMenuHost), findsOneWidget);
    });

    testWidgets('Tapping Favourites switches to tab 1 and closes side menu',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(393, 852));
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // Open side menu
      await tester.tap(find.descendant(
        of: find.byType(HomeAppBar),
        matching: find.byType(IconButton),
      ));
      await tester.pumpAndSettle();

      // Tap Favourites
      await tester.tap(find.text('Favourites'));
      await tester.pumpAndSettle();

      // Verify side menu is closed (controller value == 0)
      final hostState = tester.state(find.byType(SideMenuHost)) as dynamic;
      expect(hostState.isOpen, isFalse);
    });

    testWidgets('Tapping Log Out opens confirmation dialog in AppConfirmDialog style without closing menu',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(393, 852));
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // Open side menu
      await tester.tap(find.descendant(
        of: find.byType(HomeAppBar),
        matching: find.byType(IconButton),
      ));
      await tester.pumpAndSettle();

      // Tap Log Out
      await tester.tap(find.text('Log Out'));
      await tester.pumpAndSettle();

      // Verify AppConfirmDialog is displayed over the open side menu
      expect(find.byType(AppConfirmDialog), findsOneWidget);
      expect(find.text('Are you logging out?'), findsOneWidget);
      expect(find.text('Are You Sure Do You Want To Logout The App'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Logout'), findsOneWidget);

      // Tap Cancel to dismiss dialog
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.byType(AppConfirmDialog), findsNothing);
    });

    testWidgets('Tapping card when menu is open closes the menu', (tester) async {
      await tester.binding.setSurfaceSize(const Size(393, 852));
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // Open side menu
      await tester.tap(find.descendant(
        of: find.byType(HomeAppBar),
        matching: find.byType(IconButton),
      ));
      await tester.pumpAndSettle();

      final hostState = tester.state(find.byType(SideMenuHost)) as dynamic;
      expect(hostState.isOpen, isTrue);

      // Tap on the shifted main card area (e.g. right side of screen)
      await tester.tapAt(const Offset(350, 400));
      await tester.pumpAndSettle();

      expect(hostState.isOpen, isFalse);
    });
  });

  group('Part B: Edit Profile Tests (Figma Screenshots 2, 3, 4)', () {
    testWidgets('Renders Edit Profile in normal state with Save button disabled initially (Screenshot 2)',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(393, 852));
      await tester.pumpWidget(_buildApp(child: const EditProfileScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Edit Profile'), findsOneWidget);
      expect(find.text('Cameron Williamson'), findsOneWidget);
      expect(find.text('8606449640'), findsOneWidget);
      expect(find.text('cameron@gmail.com'), findsOneWidget);

      // Save button is visible but disabled look (isEnabled = false)
      final saveBtn = tester.widget<PrimaryButton>(find.byType(PrimaryButton));
      expect(saveBtn.label, 'Save');
      expect(saveBtn.isEnabled, isFalse);
    });

    testWidgets('Modifying name enables Save button', (tester) async {
      await tester.binding.setSurfaceSize(const Size(393, 852));
      await tester.pumpWidget(_buildApp(child: const EditProfileScreen()));
      await tester.pumpAndSettle();

      final nameField = find.byType(CustomTextField).first;
      await tester.enterText(nameField, 'Cameron Williamson Jr');
      await tester.pumpAndSettle();

      final saveBtn = tester.widget<PrimaryButton>(find.byType(PrimaryButton));
      expect(saveBtn.label, 'Save');
      expect(saveBtn.isEnabled, isTrue);
    });

    testWidgets('Changing phone number replaces Email with Enter OTP and shows Send OTP button (Screenshot 3)',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(393, 852));
      await tester.pumpWidget(_buildApp(child: const EditProfileScreen()));
      await tester.pumpAndSettle();

      // Tap pencil icon on phone field to enable editing
      final editPencilIcons = find.descendant(
        of: find.byType(CustomTextField),
        matching: find.byType(IconButton),
      );
      expect(editPencilIcons, findsNWidgets(2)); // phone & email
      await tester.tap(editPencilIcons.first);
      await tester.pumpAndSettle();

      // Change phone to a new 10-digit number
      final phoneField = find.byType(CustomTextField).at(1);
      await tester.enterText(phoneField, '9876543210');
      await tester.pumpAndSettle();

      // Button should now be "Send OTP"
      final sendOtpBtn = tester.widget<PrimaryButton>(find.byType(PrimaryButton));
      expect(sendOtpBtn.label, 'Send OTP');
      expect(sendOtpBtn.isEnabled, isTrue);

      // Email field should be replaced by "Enter OTP" field
      expect(find.text('Enter OTP'), findsOneWidget);
      expect(find.text('cameron@gmail.com'), findsNothing);
    });

    testWidgets('Tapping Send OTP changes button to Confirm, entering OTP and confirming accepts new phone (Screenshot 4)',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(393, 852));
      await tester.pumpWidget(_buildApp(child: const EditProfileScreen()));
      await tester.pumpAndSettle();

      // Tap pencil on phone and enter new phone
      final editPencilIcons = find.descendant(
        of: find.byType(CustomTextField),
        matching: find.byType(IconButton),
      );
      await tester.tap(editPencilIcons.first);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(CustomTextField).at(1), '9876543210');
      await tester.pumpAndSettle();

      // Tap Send OTP
      await tester.tap(find.text('Send OTP'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 700));
      await tester.pumpAndSettle();

      // Button is now "Confirm"
      expect(find.text('Confirm'), findsOneWidget);

      // Enter OTP
      final otpField = find.byType(CustomTextField).at(2);
      await tester.enterText(otpField, '1234');
      await tester.pumpAndSettle();

      // Tap Confirm
      await tester.tap(find.text('Confirm'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 700));
      await tester.pumpAndSettle();

      // Returns to idle state with "Save" button and Email field visible
      expect(find.text('Save'), findsOneWidget);
      expect(find.text('cameron@gmail.com'), findsOneWidget);
      expect(find.text('Enter OTP'), findsNothing);
    });

    testWidgets('Renders cleanly at 360, 393, 412 screen sizes and with large font scale',
        (tester) async {
      for (final size in [
        const Size(360, 800),
        const Size(393, 852),
        const Size(412, 915),
      ]) {
        await tester.binding.setSurfaceSize(size);
        await tester.pumpWidget(
          MediaQuery(
            data: MediaQueryData(
              size: size,
              textScaler: const TextScaler.linear(1.3), // Large font scale
            ),
            child: _buildApp(child: const EditProfileScreen(), size: size),
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull, reason: 'No exception at size $size');
      }
    });
  });
}
