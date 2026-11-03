import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dropdown_alert/dropdown_alert.dart';
import 'package:injectable/injectable.dart';
import 'package:solofy_vendor_app/application/core/app_details.dart';
import 'package:solofy_vendor_app/application/core/route/app_route.dart';
import 'package:solofy_vendor_app/application/core/theme/app_theme.dart';
import 'package:solofy_vendor_app/application/core/theme/theme/theme_cubit.dart';
import 'package:solofy_vendor_app/application/core/utils/enums.dart';
import 'package:solofy_vendor_app/domain/core/di/injection.dart';
import 'package:solofy_vendor_app/presentation/splash/splash_screen.dart';

// NOTE: the template's version-check / connectivity wrappers were removed from
// this file because their sources (LifecycleGate, StoreLifecycleRepository,
// NetworkConnectivityWrapper) and the packages they need (package_info_plus,
// flutter_screenutil) are not in the project yet. Add them back when those are enabled.

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependency(env: Environment.dev);
  runApp(const SafeArea(bottom: true, top: false, child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppDetails.screenSize = MediaQuery.sizeOf(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeCubit()), // Theme
        // BlocProvider(create: (context) => sl<AuthBloc>()), // enable with the auth bloc
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            navigatorKey: AppDetails.globalNavigatorKey,
            debugShowCheckedModeBanner: false,
            title: AppDetails.appName,
            onGenerateRoute: AppRoute.onGenerateRoute,
            initialRoute: SplashScreen.routeName,
            theme: AppTheme.getTheme(AppThemeMode.light),
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.noScaling,
                ),
                child: Stack(
                  children: [
                    child ?? const SizedBox.shrink(),
                    const DropdownAlert(),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
