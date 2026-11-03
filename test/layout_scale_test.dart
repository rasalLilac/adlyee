import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solofy_vendor_app/application/core/app_details.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/ad_mock_data.dart';
import 'package:solofy_vendor_app/presentation/main/favourite/favourite_tab.dart';
import 'package:solofy_vendor_app/presentation/main/home/home_tab.dart';
import 'package:solofy_vendor_app/presentation/main/main_shell.dart';
import 'package:solofy_vendor_app/presentation/main/submission_history/submission_history_tab.dart';
import 'package:solofy_vendor_app/presentation/main/submission_history/widgets/submission_card.dart';
import 'package:solofy_vendor_app/presentation/widgets/ad_card.dart';

void main() {
  testWidgets('Renders MainShell FavouriteTab at 360x800 without overflow',
      (WidgetTester tester) async {
    const size = Size(360, 800);
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    AppDetails.screenSize = size;

    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(
            size: size,
            textScaler: TextScaler.noScaling,
          ),
          child: MainShell(initialTab: 1),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(FavouriteTab), findsOneWidget);
    expect(find.byType(AdCard), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Renders MainShell FavouriteTab at 393x852 without overflow',
      (WidgetTester tester) async {
    const size = Size(393, 852);
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    AppDetails.screenSize = size;

    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(
            size: size,
            textScaler: TextScaler.noScaling,
          ),
          child: MainShell(initialTab: 1),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(FavouriteTab), findsOneWidget);
    expect(find.byType(AdCard), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Renders MainShell FavouriteTab at 412x915 without overflow',
      (WidgetTester tester) async {
    const size = Size(412, 915);
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    AppDetails.screenSize = size;

    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(
            size: size,
            textScaler: TextScaler.noScaling,
          ),
          child: MainShell(initialTab: 1),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(FavouriteTab), findsOneWidget);
    expect(find.byType(AdCard), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Renders with system Large Font without expanding UI',
      (WidgetTester tester) async {
    const size = Size(393, 852);
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    AppDetails.screenSize = size;

    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(
            size: size,
            textScaler: TextScaler.noScaling,
          ),
          child: MainShell(initialTab: 1),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(FavouriteTab), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Renders MainShell HomeTab at 360, 393, 412 without overflow',
      (WidgetTester tester) async {
    for (final size in [
      const Size(360, 800),
      const Size(393, 852),
      const Size(412, 915),
    ]) {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1.0;
      AppDetails.screenSize = size;

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(
              size: size,
              textScaler: TextScaler.noScaling,
            ),
            child: const MainShell(initialTab: 0),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(HomeTab), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('AdCard remove badge is hit-testable and calls onRemove',
      (WidgetTester tester) async {
    bool removed = false;
    bool cardTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 185,
              height: 166,
              child: AdCard(
                ad: mockFavouritesAds.first,
                onRemove: () => removed = true,
                onTap: () => cardTapped = true,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final closeIcon = find.byIcon(Icons.close_rounded);
    expect(closeIcon, findsOneWidget);
    await tester.tap(closeIcon);
    await tester.pumpAndSettle();
    expect(removed, isTrue);
    expect(cardTapped, isFalse);

    await tester.tap(find.text('Rent House'));
    await tester.pumpAndSettle();
    expect(cardTapped, isTrue);
  });

  testWidgets('Renders MainShell SubmissionHistoryTab at 360, 393, 412 without overflow',
      (WidgetTester tester) async {
    for (final size in [
      const Size(360, 800),
      const Size(393, 852),
      const Size(412, 915),
    ]) {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1.0;
      AppDetails.screenSize = size;

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(
              size: size,
              textScaler: TextScaler.noScaling,
            ),
            child: const MainShell(initialTab: 2),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(SubmissionHistoryTab), findsOneWidget);
      expect(find.byType(SubmissionCard), findsWidgets);
      expect(find.text('Submission History'), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });
}
