import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solofy_vendor_app/application/bloc/main_shell_cubit/main_shell_cubit.dart';
import 'package:solofy_vendor_app/application/bloc/notifications_cubit/notifications_cubit.dart';
import 'package:solofy_vendor_app/application/bloc/profile_cubit/profile_cubit.dart';
import 'package:solofy_vendor_app/application/core/app_details.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/theme/theme_cubit.dart';
import 'package:solofy_vendor_app/presentation/main/home/home_tab.dart';
import 'package:solofy_vendor_app/presentation/main/main_shell.dart';
import 'package:solofy_vendor_app/presentation/main/widgets/gradient_header_background.dart';
import 'package:solofy_vendor_app/presentation/main/widgets/home_app_bar.dart';
import 'package:solofy_vendor_app/presentation/widgets/admin_banner_carousel.dart';
import 'package:solofy_vendor_app/presentation/widgets/dots_indicator.dart';

Widget _buildHomeApp({Size size = const Size(393, 852), double textScale = 1.0}) {
  return MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => ThemeCubit()),
      BlocProvider(create: (_) => MainShellCubit()),
      BlocProvider.value(value: ProfileCubit.instance),
      BlocProvider.value(value: NotificationsCubit.instance),
    ],
    child: MediaQuery(
      data: MediaQueryData(
        size: size,
        padding: const EdgeInsets.only(top: 44, bottom: 34),
        textScaler: TextScaler.linear(textScale),
      ),
      child: MaterialApp(
        navigatorKey: AppDetails.globalNavigatorKey,
        home: const Scaffold(body: HomeTab()),
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Home Tab Scrolling Gradient & Header Tests', () {
    testWidgets('Header block uses GradientHeaderBackground inside SliverToBoxAdapter',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(393, 852));
      await tester.pumpWidget(_buildHomeApp());
      await tester.pumpAndSettle();

      // Verify GradientHeaderBackground is present and wraps HomeAppBar
      final gradientFinder = find.byType(GradientHeaderBackground);
      expect(gradientFinder, findsOneWidget);

      final gradientWidget = tester.widget<GradientHeaderBackground>(gradientFinder);
      expect(gradientWidget.fadeStart, 83.0);
      expect(gradientWidget.fadeEnd, 163.0);

      // HomeAppBar is child of GradientHeaderBackground
      expect(
        find.descendant(of: gradientFinder, matching: find.byType(HomeAppBar)),
        findsOneWidget,
      );

      // Search bar is child of GradientHeaderBackground
      expect(
        find.descendant(of: gradientFinder, matching: find.byType(TextField)),
        findsOneWidget,
      );
    });

    testWidgets('Search bar has white fill, 1px borderColor, and soft shadow',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(393, 852));
      await tester.pumpWidget(_buildHomeApp());
      await tester.pumpAndSettle();

      // Find the search bar container
      final textFieldFinder = find.byType(TextField);
      expect(textFieldFinder, findsOneWidget);

      final searchContainerFinder = find.ancestor(
        of: textFieldFinder,
        matching: find.byType(Container),
      ).first;

      final container = tester.widget<Container>(searchContainerFinder);
      final decoration = container.decoration as BoxDecoration?;
      expect(decoration, isNotNull);
      expect(decoration!.color, ColorResources.white);
      expect(decoration.borderRadius, BorderRadius.circular(10.0));

      // 1 px light border
      expect(decoration.border, isNotNull);
      expect(decoration.border!.top.color, ColorResources.borderColor);
      expect(decoration.border!.top.width, 1.0);

      // Soft shadow
      expect(decoration.boxShadow, isNotNull);
      expect(decoration.boxShadow!.first.color, Colors.black.withValues(alpha: 0.06));
      expect(decoration.boxShadow!.first.blurRadius, 8.0);
    });

    testWidgets('Fixed layer behind scroll view exists with solid primary blue',
        (tester) async {
      const size = Size(393, 852);
      await tester.binding.setSurfaceSize(size);
      await tester.pumpWidget(_buildHomeApp(size: size));
      await tester.pumpAndSettle();

      // ColoredBox with primary color is rendered behind scroll view
      final blueBoxes = find.byWidgetPredicate(
        (w) => w is ColoredBox && w.color == ColorResources.primary,
      );
      expect(blueBoxes, findsWidgets);

      // RefreshIndicator has white background and primary blue spinner
      final refreshFinder = find.byType(RefreshIndicator);
      expect(refreshFinder, findsOneWidget);
      final refresh = tester.widget<RefreshIndicator>(refreshFinder);
      expect(refresh.color, ColorResources.primary);
      expect(refresh.backgroundColor, ColorResources.white);
    });

    testWidgets('Scrolling list moves header block upwards and recedes blue background',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(393, 852));
      await tester.pumpWidget(_buildHomeApp());
      await tester.pumpAndSettle();

      final initialHeaderTop = tester.getTopLeft(find.byType(HomeAppBar)).dy;

      // Drag scroll view upwards by 200 px
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -200));
      await tester.pumpAndSettle();

      final scrolledHeaderTop = tester.getTopLeft(find.byType(HomeAppBar)).dy;
      // Header has scrolled upwards
      expect(scrolledHeaderTop, lessThan(initialHeaderTop));
      expect(tester.takeException(), isNull);
    });

    testWidgets('Renders cleanly on 360x800, 393x852, 412x915 and Large Font',
        (tester) async {
      for (final size in [
        const Size(360, 800),
        const Size(393, 852),
        const Size(412, 915),
      ]) {
        await tester.binding.setSurfaceSize(size);
        AppDetails.screenSize = size;

        // Normal text scale
        await tester.pumpWidget(_buildHomeApp(size: size));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);

        // Large font scale (1.3x)
        await tester.pumpWidget(_buildHomeApp(size: size, textScale: 1.3));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
    });

    testWidgets('Side menu opens and closes seamlessly with HomeTab',
        (tester) async {
      const size = Size(393, 852);
      await tester.binding.setSurfaceSize(size);
      AppDetails.screenSize = size;

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => ThemeCubit()),
            BlocProvider(create: (_) => MainShellCubit()),
            BlocProvider.value(value: ProfileCubit.instance),
            BlocProvider.value(value: NotificationsCubit.instance),
          ],
          child: const MaterialApp(
            home: MainShell(initialTab: 0),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find hamburger menu icon in HomeAppBar
      final menuFinder = find.byType(IconButton).first;
      expect(menuFinder, findsOneWidget);

      // Tap hamburger
      await tester.tap(menuFinder);
      await tester.pumpAndSettle();

      // Drawer is open, tap to close
      await tester.tapAt(const Offset(350, 400));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('Top banner carousel has fixed height 98, radius 16, and 4 dots outside',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(393, 852));
      await tester.pumpWidget(_buildHomeApp());
      await tester.pumpAndSettle();

      // Verify AdminBannerCarousel is present
      final carouselFinder = find.byType(AdminBannerCarousel);
      expect(carouselFinder, findsOneWidget);

      final carousel = tester.widget<AdminBannerCarousel>(carouselFinder);
      expect(carousel.boxHeight, AdminBannerCarousel.bannerHeight);
      expect(AdminBannerCarousel.bannerHeight, 98.0);
      expect(AdminBannerCarousel.bannerRadius, 16.0);

      // Verify ClipRRect with radius 16 wraps the PageView
      final clipFinder = find.descendant(
        of: carouselFinder,
        matching: find.byType(ClipRRect),
      );
      expect(clipFinder, findsOneWidget);
      final clip = tester.widget<ClipRRect>(clipFinder);
      expect(clip.borderRadius, BorderRadius.circular(16.0));

      // Verify PageView uses HomeBannerSlide
      final slideFinder = find.descendant(
        of: carouselFinder,
        matching: find.byType(HomeBannerSlide),
      );
      expect(slideFinder, findsWidgets);

      final slide = tester.widget<HomeBannerSlide>(slideFinder.first);
      expect(slide.showDotsInside, isFalse);

      // Verify ONE dots indicator exists outside the banner box with 4 dots
      final dotsFinder = find.descendant(
        of: carouselFinder,
        matching: find.byType(DotsIndicator),
      );
      expect(dotsFinder, findsOneWidget);
      final dots = tester.widget<DotsIndicator>(dotsFinder);
      expect(dots.itemCount, 4);
      expect(dots.activeColor, ColorResources.primary);
      expect(dots.inactiveColor, const Color(0xFFC2D6E7));

      // Swipe PageView to next slide
      await tester.drag(find.byType(PageView).first, const Offset(-250, 0));
      await tester.pumpAndSettle();

      final updatedDots = tester.widget<DotsIndicator>(dotsFinder);
      expect(updatedDots.currentIndex, 1);
    });
  });
}

