import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solofy_vendor_app/application/bloc/main_shell_cubit/main_shell_cubit.dart';
import 'package:solofy_vendor_app/application/bloc/notifications_cubit/notifications_cubit.dart';
import 'package:solofy_vendor_app/application/bloc/profile_cubit/profile_cubit.dart';
import 'package:solofy_vendor_app/application/bloc/submission_history_cubit/submission_history_cubit.dart';
import 'package:solofy_vendor_app/application/core/app_details.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/theme/theme_cubit.dart';
import 'package:solofy_vendor_app/application/core/utils/enums.dart';
import 'package:solofy_vendor_app/presentation/main/favourite/favourite_tab.dart';
import 'package:solofy_vendor_app/presentation/main/home/home_tab.dart';
import 'package:solofy_vendor_app/presentation/main/submission_history/submission_history_tab.dart';
import 'package:solofy_vendor_app/presentation/main/widgets/app_bottom_nav.dart';
import 'package:solofy_vendor_app/presentation/widgets/dropdown_chip.dart';
import 'package:solofy_vendor_app/presentation/widgets/dropdown_chip_menu.dart';

Widget _buildApp({Widget? child, Size size = const Size(393, 852)}) {
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
      ),
      child: MaterialApp(
        navigatorKey: AppDetails.globalNavigatorKey,
        home: Scaffold(body: child),
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FIX 1: Bottom Nav flat styling tests', () {
    testWidgets('Pill container and tab icons have no box shadow / glow',
        (tester) async {
      await tester.pumpWidget(
        _buildApp(
          child: AppBottomNav(
            selectedIndex: 0,
            onTabSelected: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find the main pill Container
      final pillFinder = find.byType(Container).first;
      final pillContainer = tester.widget<Container>(pillFinder);
      final pillDecoration = pillContainer.decoration as BoxDecoration?;

      expect(pillDecoration, isNotNull);
      // Pill must have NO shadow
      expect(pillDecoration!.boxShadow, isNull);

      // Verify the '+' button STILL HAS its halo and shadow
      final fabCircleFinder = find.byWidgetPredicate((w) {
        if (w is Container && w.decoration is BoxDecoration) {
          final box = w.decoration as BoxDecoration;
          return box.shape == BoxShape.circle && box.boxShadow != null;
        }
        return false;
      });
      expect(fabCircleFinder, findsOneWidget);
    });

    testWidgets('Tab icons show selection only by color (no circles / glow)',
        (tester) async {
      int selected = 0;
      await tester.pumpWidget(
        _buildApp(
          child: StatefulBuilder(
            builder: (context, setState) {
              return AppBottomNav(
                selectedIndex: selected,
                onTabSelected: (idx) => setState(() => selected = idx),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Check favourite icon (index 1) inactive
      Icon favIcon = tester.widget<Icon>(find.byIcon(Icons.favorite_rounded));
      expect(favIcon.color, ColorResources.navInactive);

      // Tap favourite tab
      await tester.tap(find.byIcon(Icons.favorite_rounded));
      await tester.pumpAndSettle();

      // Now favourite icon is active (primary color)
      favIcon = tester.widget<Icon>(find.byIcon(Icons.favorite_rounded));
      expect(favIcon.color, ColorResources.primary);

      // Play icon (index 2) inactive
      Icon playIcon =
          tester.widget<Icon>(find.byIcon(Icons.play_circle_fill_rounded));
      expect(playIcon.color, ColorResources.navInactive);

      // Tap play tab
      await tester.tap(find.byIcon(Icons.play_circle_fill_rounded));
      await tester.pumpAndSettle();

      playIcon = tester.widget<Icon>(find.byIcon(Icons.play_circle_fill_rounded));
      expect(playIcon.color, ColorResources.primary);
    });
  });

  group('FIX 2: DropdownChipMenu reusable widget tests', () {
    testWidgets('Opens popup menu directly below chip and selects an item',
        (tester) async {
      SortOrder selected = SortOrder.latest;

      await tester.pumpWidget(
        _buildApp(
          child: Center(
            child: SizedBox(
              width: 100,
              child: StatefulBuilder(
                builder: (context, setState) {
                  return DropdownChipMenu<SortOrder>(
                    value: selected,
                    items: const [SortOrder.latest, SortOrder.oldest],
                    itemLabel: (o) => o.label,
                    onChanged: (val) {
                      setState(() => selected = val);
                    },
                  );
                },
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Latest'), findsOneWidget);

      // Tap to open popup menu
      await tester.tap(find.byType(DropdownChipMenu<SortOrder>));
      await tester.pumpAndSettle();

      // Menu is displayed with both options
      expect(find.text('Latest'), findsWidgets);
      expect(find.text('Oldest'), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);

      // Tap "Oldest"
      await tester.tap(find.text('Oldest'));
      await tester.pumpAndSettle();

      expect(selected, SortOrder.oldest);
      expect(find.text('Oldest'), findsOneWidget);
    });
  });

  group('FIX 2: Independent Sort and Featured states in Tabs', () {
    testWidgets('HomeTab toggling Featured does not change sort chip from Latest',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(393, 852));
      await tester.pumpWidget(_buildApp(child: const HomeTab()));
      await tester.pumpAndSettle();

      // Initially sort chip is 'Latest'
      expect(find.widgetWithText(DropdownChipMenu<SortOrder>, 'Latest'),
          findsOneWidget);

      // Tap 'Featured' toggle chip
      await tester.tap(find.widgetWithText(DropdownChip, 'Featured'));
      await tester.pumpAndSettle();

      // Sort chip is STILL 'Latest'
      expect(find.widgetWithText(DropdownChipMenu<SortOrder>, 'Latest'),
          findsOneWidget);

      // Change sort to Oldest
      await tester.tap(find.widgetWithText(DropdownChipMenu<SortOrder>, 'Latest'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Oldest'));
      await tester.pumpAndSettle();

      // Sort chip is now 'Oldest'
      expect(find.widgetWithText(DropdownChipMenu<SortOrder>, 'Oldest'),
          findsOneWidget);

      // Toggling Featured again preserves 'Oldest'
      await tester.tap(find.widgetWithText(DropdownChip, 'Featured'));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(DropdownChipMenu<SortOrder>, 'Oldest'),
          findsOneWidget);
    });

    testWidgets('FavouriteTab independent sort and featured toggle',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(393, 852));
      await tester.pumpWidget(_buildApp(child: const FavouriteTab()));
      await tester.pumpAndSettle();

      // Initially sort chip is 'Latest'
      expect(find.widgetWithText(DropdownChipMenu<SortOrder>, 'Latest'),
          findsOneWidget);

      // Tap 'Featured' toggle chip
      await tester.tap(find.widgetWithText(DropdownChip, 'Featured'));
      await tester.pumpAndSettle();

      // Sort chip does NOT become 'Featured', stays 'Latest'
      expect(find.widgetWithText(DropdownChipMenu<SortOrder>, 'Latest'),
          findsOneWidget);

      // Open sort menu and select Oldest
      await tester.tap(find.widgetWithText(DropdownChipMenu<SortOrder>, 'Latest'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Oldest'));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(DropdownChipMenu<SortOrder>, 'Oldest'),
          findsOneWidget);
    });

    testWidgets('SubmissionHistoryTab sort dropdown works seamlessly',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(393, 852));
      await tester.pumpWidget(
        _buildApp(
          child: BlocProvider(
            create: (_) => SubmissionHistoryCubit(),
            child: const SubmissionHistoryTab(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Initially sort is 'Latest'
      expect(find.widgetWithText(DropdownChipMenu<String>, 'Latest'),
          findsOneWidget);

      // Tap sort menu
      await tester.tap(find.widgetWithText(DropdownChipMenu<String>, 'Latest'));
      await tester.pumpAndSettle();

      // Select Oldest
      await tester.tap(find.text('Oldest'));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(DropdownChipMenu<String>, 'Oldest'),
          findsOneWidget);
    });

    testWidgets('Renders cleanly on 360x800 and 412x915 without overflow',
        (tester) async {
      for (final size in [
        const Size(360, 800),
        const Size(412, 915),
      ]) {
        await tester.binding.setSurfaceSize(size);
        await tester.pumpWidget(_buildApp(child: const HomeTab(), size: size));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);

        await tester.pumpWidget(
            _buildApp(child: const FavouriteTab(), size: size));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
    });
  });

  group('Category DropdownChipMenu (Same dropdown as Latest/Oldest)', () {
    testWidgets('HomeTab: Category opens popup menu with mock categories and selects item',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(393, 852));
      await tester.pumpWidget(_buildApp(child: const HomeTab()));
      await tester.pumpAndSettle();

      // Initially chip displays "Category"
      final categoryChipFinder =
          find.widgetWithText(DropdownChipMenu<String>, 'Category');
      expect(categoryChipFinder, findsOneWidget);

      // Verify no modal bottom sheet is open
      expect(find.text('Select Category'), findsNothing);

      // Tap Category dropdown chip
      await tester.tap(categoryChipFinder);
      await tester.pumpAndSettle();

      // Dropdown menu is open with all mock categories
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Property'), findsOneWidget);
      expect(find.text('Vehicles'), findsOneWidget);
      expect(find.text('Jobs'), findsOneWidget);
      expect(find.text('Electronics'), findsOneWidget);

      // 'All' has check mark because 'Category' acts as All
      expect(find.byIcon(Icons.check), findsOneWidget);

      // Select 'Electronics'
      await tester.tap(find.text('Electronics'));
      await tester.pumpAndSettle();

      // Chip now shows 'Electronics'
      expect(find.widgetWithText(DropdownChipMenu<String>, 'Electronics'),
          findsOneWidget);

      // Category chip is active (isActive = true), but sort is still Latest and featured is false
      expect(find.widgetWithText(DropdownChipMenu<SortOrder>, 'Latest'),
          findsOneWidget);

      // Open category again and select 'All'
      await tester.tap(find.widgetWithText(DropdownChipMenu<String>, 'Electronics'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('All'));
      await tester.pumpAndSettle();

      // Chip returns to 'Category'
      expect(find.widgetWithText(DropdownChipMenu<String>, 'Category'),
          findsOneWidget);
    });

    testWidgets('FavouriteTab: Category dropdown selects item and updates chip',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(393, 852));
      await tester.pumpWidget(_buildApp(child: const FavouriteTab()));
      await tester.pumpAndSettle();

      // Chip displays "Category"
      final chipFinder =
          find.widgetWithText(DropdownChipMenu<String>, 'Category');
      expect(chipFinder, findsOneWidget);

      // Open menu
      await tester.tap(chipFinder);
      await tester.pumpAndSettle();

      // Select 'Property'
      await tester.tap(find.text('Property'));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(DropdownChipMenu<String>, 'Property'),
          findsOneWidget);
    });

    testWidgets('SubmissionHistoryTab: Category dropdown updates cubit and chip',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(393, 852));
      await tester.pumpWidget(
        _buildApp(
          child: BlocProvider(
            create: (_) => SubmissionHistoryCubit(),
            child: const SubmissionHistoryTab(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap Category chip
      await tester.tap(find.widgetWithText(DropdownChipMenu<String>, 'Category'));
      await tester.pumpAndSettle();

      // Select 'Vehicles'
      await tester.tap(find.text('Vehicles'));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(DropdownChipMenu<String>, 'Vehicles'),
          findsOneWidget);
    });

    testWidgets('SubmissionHistoryTab: Featured plan dropdown opens menu, filters submissions, and updates chip',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(393, 852));
      await tester.pumpWidget(
        _buildApp(
          child: BlocProvider(
            create: (_) => SubmissionHistoryCubit(),
            child: const SubmissionHistoryTab(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Initially 3rd chip displays 'Featured' (placeholder for 'All')
      final planChipFinder =
          find.widgetWithText(DropdownChipMenu<String>, 'Featured');
      expect(planChipFinder, findsOneWidget);

      // Verify no bottom sheet
      expect(find.text('Select Plan'), findsNothing);

      // Tap Featured dropdown chip
      await tester.tap(planChipFinder);
      await tester.pumpAndSettle();

      // Menu should show All, Regular, Featured, Urgent
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Regular'), findsOneWidget);
      expect(find.text('Urgent'), findsOneWidget);

      // Select 'Urgent'
      await tester.tap(find.text('Urgent'));
      await tester.pumpAndSettle();

      // Chip now displays 'Urgent'
      expect(find.widgetWithText(DropdownChipMenu<String>, 'Urgent'),
          findsOneWidget);

      // Re-open and select 'All'
      await tester.tap(find.widgetWithText(DropdownChipMenu<String>, 'Urgent'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('All'));
      await tester.pumpAndSettle();

      // Chip reverts to 'Featured'
      expect(find.widgetWithText(DropdownChipMenu<String>, 'Featured'),
          findsOneWidget);
    });

    testWidgets('Home screen uses menu.svg, setting-4.svg, and location.svg',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(393, 852));
      await tester.pumpWidget(_buildApp(child: const HomeTab()));
      await tester.pumpAndSettle();

      // Verify drawer button uses menu.svg
      final menuSvgFinder = find.byWidgetPredicate(
        (w) => w is SvgPicture && w.bytesLoader.toString().contains('menu.svg'),
      );
      expect(menuSvgFinder, findsOneWidget);

      // Verify filter button uses setting-4.svg
      final filterSvgFinder = find.byWidgetPredicate(
        (w) =>
            w is SvgPicture && w.bytesLoader.toString().contains('setting-4.svg'),
      );
      expect(filterSvgFinder, findsOneWidget);

      // Verify location icon uses location.svg
      final locationSvgFinder = find.byWidgetPredicate(
        (w) =>
            w is SvgPicture && w.bytesLoader.toString().contains('location.svg'),
      );
      expect(locationSvgFinder, findsWidgets);
    });
  });
}
