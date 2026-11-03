import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solofy_vendor_app/application/core/app_details.dart';
import 'package:solofy_vendor_app/application/core/theme/theme/theme_cubit.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/interested_user_mock.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/owner_mark.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/submission_mock_data.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/submission_status.dart';
import 'package:solofy_vendor_app/presentation/ads/edit_ad/edit_ad_screen.dart';
import 'package:solofy_vendor_app/presentation/ads/interested_contacts/interested_contacts_screen.dart';
import 'package:solofy_vendor_app/presentation/ads/modify_ad/modify_ad_screen.dart';
import 'package:solofy_vendor_app/presentation/ads/my_ad_detail/my_ad_detail_screen.dart';
import 'package:solofy_vendor_app/presentation/ads/my_ad_detail/widgets/delete_ad_dialog.dart';
import 'package:solofy_vendor_app/presentation/ads/my_ad_detail/widgets/re_post_ad_dialog.dart';
import 'package:solofy_vendor_app/presentation/ads/my_ad_detail/widgets/stop_ad_dialog.dart';
import 'package:solofy_vendor_app/presentation/ads/post_ad/post_ad_screen.dart';
import 'package:solofy_vendor_app/presentation/widgets/interested_contact_row.dart';

Widget _buildTestApp(Widget child) {
  return BlocProvider(
    create: (_) => ThemeCubit(),
    child: MaterialApp(
      home: child,
    ),
  );
}

void main() {
  const size360 = Size(360, 800);
  const size393 = Size(393, 852);
  const size412 = Size(412, 915);

  setUp(() {
    InterestedContactsStore.instance.reset();
    SubmissionStore.instance.reset();
  });

  group('MyAdDetailScreen Tests - All Statuses', () {
    testWidgets('Renders Pending Approval state at 360, 393, 412',
        (WidgetTester tester) async {
      final pendingAd = mockSubmissions.firstWhere(
        (s) => s.status == SubmissionStatus.pendingApproval,
      );

      for (final size in [size360, size393, size412]) {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        AppDetails.screenSize = size;

        await tester.pumpWidget(_buildTestApp(MyAdDetailScreen(ad: pendingAd)));
        await tester.pumpAndSettle();

        expect(find.text('View Details'), findsOneWidget);
        expect(find.text('Pending Approval'), findsOneWidget);
        expect(find.textContaining('Contact Number : '), findsOneWidget);
        expect(find.text('Stop This Ad'), findsOneWidget);
        expect(find.text('Edit Or Update'), findsNothing);
        expect(tester.takeException(), isNull);
      }
    });

    testWidgets('Renders Active with 0 Interested state at 360, 393, 412',
        (WidgetTester tester) async {
      final active0Ad = mockSubmissions.firstWhere(
        (s) => s.status == SubmissionStatus.active && s.interestedCount == 0 && s.rePostedAt == null,
      );

      for (final size in [size360, size393, size412]) {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        AppDetails.screenSize = size;

        await tester.pumpWidget(_buildTestApp(MyAdDetailScreen(ad: active0Ad)));
        await tester.pumpAndSettle();

        expect(find.text('View Details'), findsOneWidget);
        expect(find.text('Active'), findsOneWidget);
        expect(find.textContaining('Reg Phone : '), findsOneWidget);
        expect(find.text('Interested : 0'), findsOneWidget);
        expect(find.text('View All'), findsNothing);
        expect(find.byType(InterestedContactRow), findsNothing);
        expect(find.text('Edit Or Update'), findsOneWidget);
        expect(find.text('Stop This Ad'), findsOneWidget);
        expect(tester.takeException(), isNull);
      }
    });

    testWidgets('Renders Expired ad state with Modify and Re-Post buttons (Figma 2)',
        (WidgetTester tester) async {
      final expiredAd = mockSubmissions.firstWhere(
        (s) => s.status == SubmissionStatus.expired,
      );

      tester.view.physicalSize = size393;
      tester.view.devicePixelRatio = 1.0;
      AppDetails.screenSize = size393;

      await tester.pumpWidget(_buildTestApp(MyAdDetailScreen(ad: expiredAd)));
      await tester.pumpAndSettle();

      expect(find.text('View Details'), findsOneWidget);
      expect(find.text('Expired'), findsOneWidget);
      expect(find.textContaining('Contact Number : '), findsOneWidget);
      expect(find.text('Interested : 20'), findsOneWidget);
      expect(find.text('View All'), findsOneWidget);
      expect(find.text('Modify'), findsOneWidget);
      expect(find.text('Re-Post'), findsOneWidget);

      // Re-Post dialog opens
      await tester.tap(find.text('Re-Post'));
      await tester.pumpAndSettle();

      expect(find.byType(RePostAdDialog), findsOneWidget);
      expect(find.text('Re-Post Ad'), findsOneWidget);
      expect(find.textContaining('Run this ad again for 4 days?'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Pay ₹200'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.byType(RePostAdDialog), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Renders Stopped Ad Details (Figma Screenshot 3) with Re-run button',
        (WidgetTester tester) async {
      final stoppedAd = mockSubmissions.firstWhere(
        (s) => s.status == SubmissionStatus.stopped,
      );

      for (final size in [size360, size393, size412]) {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        AppDetails.screenSize = size;

        await tester.pumpWidget(_buildTestApp(MyAdDetailScreen(ad: stoppedAd)));
        await tester.pumpAndSettle();

        expect(find.text('Stopped Ad Details'), findsOneWidget);
        expect(find.text('Stopped'), findsOneWidget);
        expect(find.textContaining('Reg Phone : '), findsOneWidget);
        expect(find.textContaining('Stopped At : '), findsOneWidget);
        expect(find.textContaining('26 Jul 2025 | 04:00 PM'), findsOneWidget);
        expect(find.text('Re-run this Ad'), findsOneWidget);
        expect(find.text('Interested : 20'), findsNothing);
        expect(find.byType(InterestedContactRow), findsNothing);
        expect(tester.takeException(), isNull);
      }

      // Re-run this Ad opens confirmation dialog
      await tester.tap(find.text('Re-run this Ad'));
      await tester.pumpAndSettle();

      expect(find.byType(RePostAdDialog), findsOneWidget);
      expect(find.text('Pay ₹200'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
    });

    testWidgets('Stop This Ad updates screen immediately to Stopped state',
        (WidgetTester tester) async {
      final activeAd = mockSubmissions.firstWhere(
        (s) => s.status == SubmissionStatus.active && s.interestedCount == 20 && s.rePostedAt == null,
      );

      tester.view.physicalSize = size393;
      tester.view.devicePixelRatio = 1.0;
      AppDetails.screenSize = size393;

      await tester.pumpWidget(_buildTestApp(MyAdDetailScreen(ad: activeAd)));
      await tester.pumpAndSettle();

      expect(find.text('View Details'), findsOneWidget);
      expect(find.text('Active'), findsOneWidget);

      await tester.tap(find.text('Stop This Ad'));
      await tester.pumpAndSettle();

      expect(find.byType(StopAdDialog), findsOneWidget);
      await tester.tap(find.descendant(of: find.byType(StopAdDialog), matching: find.text('Stop This Ad')));
      await tester.pumpAndSettle();

      // Screen updates immediately to Stopped Ad Details
      expect(find.text('Stopped Ad Details'), findsOneWidget);
      expect(find.text('Stopped'), findsOneWidget);
      expect(find.text('Re-run this Ad'), findsOneWidget);
    });

    testWidgets('Renders Rejected Ad Details (Figma Screenshot 4) with Delete and Modify',
        (WidgetTester tester) async {
      final rejectedAd = mockSubmissions.firstWhere(
        (s) => s.status == SubmissionStatus.rejected,
      );

      for (final size in [size360, size393, size412]) {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        AppDetails.screenSize = size;

        await tester.pumpWidget(_buildTestApp(MyAdDetailScreen(ad: rejectedAd)));
        await tester.pumpAndSettle();

        expect(find.text('Rejected Ad Details'), findsOneWidget);
        expect(find.text('Rejected'), findsOneWidget);
        expect(find.text('0'), findsOneWidget); // Views 0
        expect(find.text('Reason For Rejection :'), findsOneWidget);
        expect(find.text('Delete'), findsOneWidget);
        expect(find.text('Modify'), findsOneWidget);
        expect(find.text('Interested : 20'), findsNothing);
        expect(find.byType(InterestedContactRow), findsNothing);
        expect(tester.takeException(), isNull);
      }

      // Tapping Delete opens DeleteAdDialog
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      expect(find.byType(DeleteAdDialog), findsOneWidget);
      expect(find.text('Delete Ad'), findsOneWidget);
      expect(find.text('Are You Sure You Want To Delete This Ad?'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.byType(DeleteAdDialog), findsNothing);
    });

    testWidgets('Renders Re-posted Active ad (Figma Screenshots 1 + 2) with posting rounds',
        (WidgetTester tester) async {
      final repostedAd = mockSubmissions.firstWhere(
        (s) => s.rePostedAt != null,
      );

      tester.view.physicalSize = size393;
      tester.view.devicePixelRatio = 1.0;
      AppDetails.screenSize = size393;

      await tester.pumpWidget(_buildTestApp(MyAdDetailScreen(ad: repostedAd)));
      await tester.pumpAndSettle();

      expect(find.text('Re-post the Ad'), findsOneWidget);
      expect(find.text('Active'), findsOneWidget);
      expect(find.textContaining('Re-Posted : 30 Jul 2025 | 04:00 PM'), findsOneWidget);
      expect(find.text('Interested : 20'), findsOneWidget);
      expect(find.text('Run Ad For (Days)'), findsOneWidget);

      // Section per posting round
      expect(find.textContaining('Interested From First Post : '), findsOneWidget);
      expect(find.textContaining('Interested From Second Post : '), findsOneWidget);

      // Contact rows rendered
      expect(find.byType(InterestedContactRow), findsWidgets);
      expect(find.text('Edit Or Update'), findsOneWidget);
      expect(find.text('Stop This Ad'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('InterestedContactsScreen Tests (Screenshots 1 & 3)', () {
    testWidgets('Renders header, search bar, and contact rows for active and expired ads',
        (WidgetTester tester) async {
      final expiredAd = mockSubmissions.firstWhere(
        (s) => s.status == SubmissionStatus.expired,
      );

      await tester.pumpWidget(
        _buildTestApp(InterestedContactsScreen(ad: expiredAd)),
      );
      await tester.pumpAndSettle();

      expect(find.text('Interested Contacts'), findsOneWidget);
      expect(find.text('Expired'), findsOneWidget);
      expect(find.text('Interested : 20'), findsOneWidget);
      expect(find.byType(InterestedContactRow), findsWidgets);
      expect(find.text('Wade Warren'), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Search filters contact list by name or phone',
        (WidgetTester tester) async {
      final ad = mockSubmissions.first;
      await tester.pumpWidget(_buildTestApp(InterestedContactsScreen(ad: ad)));
      await tester.pumpAndSettle();

      // Enter search query
      await tester.enterText(find.byType(TextField).first, 'Jenny');
      await tester.pumpAndSettle();

      expect(find.text('Jenny Wilson'), findsWidgets);
      expect(find.text('Guy Hawkins'), findsNothing);

      // Clear search query
      await tester.enterText(find.byType(TextField).first, '');
      await tester.pumpAndSettle();

      expect(find.text('Guy Hawkins'), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Three-dot menu toggles owner mark (Definitely/Tentatively/Not Suitable)',
        (WidgetTester tester) async {
      final ad = mockSubmissions.first;
      await tester.pumpWidget(_buildTestApp(InterestedContactsScreen(ad: ad)));
      await tester.pumpAndSettle();

      // Tap 3-dot menu on first contact (Wade Warren, initially definitelySuitable)
      final moreButtons = find.byIcon(Icons.more_vert);
      expect(moreButtons, findsWidgets);
      await tester.tap(moreButtons.first);
      await tester.pumpAndSettle();

      expect(find.text('Definitely Suitable'), findsOneWidget);
      expect(find.text('Tentatively Suitable'), findsOneWidget);
      expect(find.text('Not Suitable'), findsOneWidget);

      // Select Not Suitable
      await tester.tap(find.text('Not Suitable'));
      await tester.pumpAndSettle();

      final firstUser = InterestedContactsStore.instance.contacts.first;
      expect(firstUser.mark, OwnerMark.notSuitable);

      // Open menu again and tap Not Suitable again to toggle off
      await tester.tap(find.byIcon(Icons.more_vert).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Not Suitable'));
      await tester.pumpAndSettle();

      expect(InterestedContactsStore.instance.contacts.first.mark, isNull);
    });

    testWidgets('Accepts roundNumber and renders only that round',
        (WidgetTester tester) async {
      final repostedAd = mockSubmissions.firstWhere(
        (s) => s.rePostedAt != null,
      );

      await tester.pumpWidget(
        _buildTestApp(InterestedContactsScreen(ad: repostedAd, roundNumber: 1)),
      );
      await tester.pumpAndSettle();

      expect(find.text('Interested Contacts'), findsOneWidget);
      expect(find.text('Active'), findsOneWidget);
      expect(find.text('Interested : 10'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('ModifyAdScreen Tests (Screenshots 4 & 5)', () {
    testWidgets('Renders ModifyAdScreen with editable categories, ad title, and Pay ₹200 button',
        (WidgetTester tester) async {
      final expiredAd = mockSubmissions.firstWhere(
        (s) => s.status == SubmissionStatus.expired,
      );

      for (final size in [size360, size393, size412]) {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        AppDetails.screenSize = size;

        await tester.pumpWidget(_buildTestApp(ModifyAdScreen(ad: expiredAd)));
        await tester.pumpAndSettle();

        expect(find.text('Modify Your Ad'), findsOneWidget);
        expect(find.text('Property'), findsWidgets);
        expect(find.text('Rent'), findsWidgets);
        // Auto-built ad title
        expect(find.text('Property For Rent'), findsWidgets);
        // No black "Use Current Location" button in modify mode
        expect(find.text('Use Current Location'), findsNothing);
        // Run Ad for 4 Days duration block
        expect(find.textContaining('Run Ad for '), findsOneWidget);
        // Pay ₹200 button (no word "Only")
        expect(find.text('Pay ₹200'), findsOneWidget);
        expect(tester.takeException(), isNull);
      }
    });
  });

  group('EditAdScreen & PostAdScreen Tests', () {
    testWidgets('Renders EditAdScreen with read-only categories and update button',
        (WidgetTester tester) async {
      final ad = mockSubmissions.first;

      await tester.pumpWidget(_buildTestApp(EditAdScreen(ad: ad)));
      await tester.pumpAndSettle();

      expect(find.text('Edit Your Ad'), findsOneWidget);
      expect(find.text('Property'), findsOneWidget);
      expect(find.text('Rent'), findsOneWidget);
      expect(find.text('Use Current Location'), findsOneWidget);
      expect(find.textContaining('Run Ad for '), findsOneWidget);
      expect(find.text('Update'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('PostAdScreen continues working in create mode', (WidgetTester tester) async {
      await tester.pumpWidget(_buildTestApp(const PostAdScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Post Your Ad'), findsOneWidget);
      expect(find.text('Use Current Location'), findsOneWidget);
      expect(find.text('Preview'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
