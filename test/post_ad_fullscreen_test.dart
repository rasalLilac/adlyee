import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solofy_vendor_app/application/core/route/app_route.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/theme/theme_cubit.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/ad_draft.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/submission_mock_data.dart';
import 'package:solofy_vendor_app/presentation/ads/post_ad/post_ad_screen.dart';
import 'package:solofy_vendor_app/presentation/widgets/app_page_scaffold.dart';
import 'package:solofy_vendor_app/presentation/widgets/custom_dropdown_field.dart';

void main() {
  Widget buildApp(Size size) {
    return BlocProvider(
      create: (_) => ThemeCubit(),
      child: MediaQuery(
        data: MediaQueryData(
          size: size,
          padding: const EdgeInsets.only(top: 44, bottom: 34),
        ),
        child: const MaterialApp(
          home: PostAdScreen(),
        ),
      ),
    );
  }

  group('Post Your Ad Full Screen Page Tests', () {
    testWidgets('Renders PostAdScreen full-screen with AppPageScaffold (no grey frame)', (tester) async {
      await tester.binding.setSurfaceSize(const Size(393, 852));
      await tester.pumpWidget(buildApp(const Size(393, 852)));
      await tester.pumpAndSettle();

      // Check AppPageScaffold is present
      expect(find.byType(AppPageScaffold), findsOneWidget);

      // Check Scaffold background is white, NOT appBackgroundGrey
      final scaffold = tester.widget<Scaffold>(find.descendant(
        of: find.byType(AppPageScaffold),
        matching: find.byType(Scaffold),
      ));
      expect(scaffold.backgroundColor, ColorResources.white);

      // Verify "Post Your Ad" title is rendered
      expect(find.text('Post Your Ad'), findsOneWidget);

      // Verify Location header selector is present
      expect(find.text('Palazhi , Calicut'), findsOneWidget);

      // Verify Categories start empty in Create mode
      final dropdowns = tester.widgetList<CustomDropdownField<String>>(
        find.byType(CustomDropdownField<String>),
      );
      expect(dropdowns.length, 2);
      expect(dropdowns.first.value, isNull);
      expect(dropdowns.last.value, isNull);

      // Verify "Use Current Location" button is rendered
      expect(find.text('Use Current Location'), findsOneWidget);
    });

    testWidgets('Renders at multiple screen sizes without overflow', (tester) async {
      for (final size in [
        const Size(360, 800),
        const Size(393, 852),
        const Size(412, 915),
      ]) {
        await tester.binding.setSurfaceSize(size);
        await tester.pumpWidget(buildApp(size));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull, reason: 'No exception at size $size');
      }
    });

    testWidgets('AppRoute.onGenerateRoute handles direct Object arguments without throwing cast exceptions', (tester) async {
      // 1. Passing Submission directly (e.g. from SubmissionHistoryTab)
      final subRoute = AppRoute.onGenerateRoute(
        RouteSettings(
          name: 'my-ad-detail',
          arguments: mockSubmissions.first,
        ),
      );
      expect(subRoute, isNotNull);

      // 2. Passing AdDraft directly (e.g. from PostAdScreen to AdPreviewScreen)
      final previewRoute = AppRoute.onGenerateRoute(
        const RouteSettings(
          name: 'ad-preview',
          arguments: AdDraft(),
        ),
      );
      expect(previewRoute, isNotNull);

      // 3. Passing String directly (e.g. adRef)
      final successRoute = AppRoute.onGenerateRoute(
        const RouteSettings(
          name: 'ad-post-success',
          arguments: '0123456789',
        ),
      );
      expect(successRoute, isNotNull);
    });
  });
}
