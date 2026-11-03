import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solofy_vendor_app/application/bloc/main_shell_cubit/main_shell_cubit.dart';
import 'package:solofy_vendor_app/application/bloc/main_shell_cubit/main_shell_state.dart';
import 'package:solofy_vendor_app/application/bloc/notifications_cubit/notifications_cubit.dart';
import 'package:solofy_vendor_app/application/bloc/profile_cubit/profile_cubit.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/presentation/main/favourite/favourite_tab.dart';
import 'package:solofy_vendor_app/presentation/main/home/home_tab.dart';
import 'package:solofy_vendor_app/presentation/main/submission_history/submission_history_tab.dart';
import 'package:solofy_vendor_app/presentation/main/widgets/app_bottom_nav.dart';
import 'package:solofy_vendor_app/presentation/main/widgets/side_menu_host.dart';

/// Configuration entry per tab allowing tabs to declare their status bar & app bar preferences (Fix A).
class TabConfig {
  const TabConfig({
    this.showHomeAppBar = false,
    this.statusBar = const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  });

  final bool showHomeAppBar;
  final SystemUiOverlayStyle statusBar;
}

class MainShell extends StatelessWidget {
  const MainShell({super.key, this.initialTab = 0});

  final int initialTab;
  static const routeName = 'main';

  // Tab configurations: Home opts into HomeAppBar + light icons; Favourite & Third are plain white with dark icons.
  static const List<TabConfig> tabConfigs = [
    TabConfig(
      showHomeAppBar: true,
      statusBar: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    ),
    TabConfig(
      showHomeAppBar: false,
      statusBar: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    ),
    TabConfig(
      showHomeAppBar: false,
      statusBar: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => MainShellCubit()..selectTab(initialTab)),
        BlocProvider.value(value: ProfileCubit.instance),
        BlocProvider.value(value: NotificationsCubit.instance),
      ],
      child: const _MainShellView(),
    );
  }
}

class _MainShellView extends StatelessWidget {
  const _MainShellView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainShellCubit, MainShellState>(
      builder: (context, state) {
        final cubit = context.read<MainShellCubit>();
        final currentConfig = MainShell.tabConfigs[state.selectedTabIndex.clamp(
          0,
          MainShell.tabConfigs.length - 1,
        )];

        final mainBody = PopScope(
          canPop: state.selectedTabIndex == 0,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop && state.selectedTabIndex != 0) {
              cubit.selectTab(0);
            }
          },
          child: Scaffold(
            backgroundColor: ColorResources.white,
            body: Stack(
              children: [
                // 1. Tab switching IndexedStack (owns scrollable body per tab)
                IndexedStack(
                  index: state.selectedTabIndex,
                  children: const [
                    HomeTab(),
                    FavouriteTab(),
                    SubmissionHistoryTab(),
                  ],
                ),

                // 2. Floating Bottom Navigation Bar fixed at the bottom
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: AppBottomNav(
                    selectedIndex: state.selectedTabIndex,
                    onTabSelected: (index) => cubit.selectTab(index),
                  ),
                ),
              ],
            ),
          ),
        );

        return SideMenuHost(
          currentStatusBar: currentConfig.statusBar,
          child: mainBody,
        );
      },
    );
  }
}
