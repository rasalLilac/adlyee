import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solofy_vendor_app/application/bloc/activity_cubit/activity_cubit.dart';
import 'package:solofy_vendor_app/application/bloc/main_shell_cubit/main_shell_cubit.dart';
import 'package:solofy_vendor_app/application/bloc/submission_history_cubit/submission_history_cubit.dart';
import 'package:solofy_vendor_app/application/core/app_details.dart';
import 'package:solofy_vendor_app/application/core/theme/theme/theme_cubit.dart';
import 'package:solofy_vendor_app/presentation/main/main_shell.dart';

void main() {
  testWidgets('MainShell smoke test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1.0;
    AppDetails.screenSize = const Size(393, 852);

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ThemeCubit()),
          BlocProvider(create: (_) => MainShellCubit()),
          BlocProvider(create: (_) => ActivityCubit()),
          BlocProvider(create: (_) => SubmissionHistoryCubit()),
        ],
        child: const MaterialApp(
          home: MainShell(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(MainShell), findsOneWidget);
  });
}
