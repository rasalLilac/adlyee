import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solofy_vendor_app/application/core/theme/app_theme.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/utils/enums.dart';
import 'package:solofy_vendor_app/presentation/widgets/custom_dropdown_field.dart';

Widget _buildTestApp({required Widget child}) {
  return MaterialApp(
    theme: AppTheme.getTheme(AppThemeMode.light),
    home: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: child,
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FIX A: AppTheme Material 3 neutral & white dropdown tokens', () {
    testWidgets('Light theme colorScheme has no purple/lavender and transparent surfaceTint', (tester) async {
      final theme = AppTheme.getTheme(AppThemeMode.light);
      expect(theme.colorScheme.primary, ColorResources.primary);
      expect(theme.colorScheme.surface, ColorResources.white);
      expect(theme.colorScheme.surfaceTint, Colors.transparent);
      expect(theme.colorScheme.surfaceContainerHighest, ColorResources.white);
      expect(theme.colorScheme.surfaceContainer, ColorResources.white);
      expect(theme.colorScheme.outline, ColorResources.borderColor);
      expect(theme.canvasColor, ColorResources.white);
      expect(theme.popupMenuTheme.color, ColorResources.white);
      expect(theme.popupMenuTheme.surfaceTintColor, Colors.transparent);
      expect(theme.bottomSheetTheme.surfaceTintColor, Colors.transparent);
      expect(theme.dialogTheme.surfaceTintColor, Colors.transparent);
    });
  });

  group('FIX B: CustomDropdownField clean anchored menu tests', () {
    testWidgets('Opens white popup directly below field with checkmark on selected item',
        (tester) async {
      String? selectedValue = 'Option 2';

      await tester.pumpWidget(
        _buildTestApp(
          child: StatefulBuilder(
            builder: (context, setState) {
              return CustomDropdownField<String>(
                hintText: 'Select Option',
                value: selectedValue,
                items: const [
                  DropdownMenuItem(value: 'Option 1', child: Text('Option 1')),
                  DropdownMenuItem(value: 'Option 2', child: Text('Option 2')),
                  DropdownMenuItem(value: 'Option 3', child: Text('Option 3')),
                ],
                onChanged: (val) {
                  setState(() => selectedValue = val);
                },
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Displays selected value
      expect(find.text('Option 2'), findsOneWidget);

      // Tap field to open dropdown menu
      await tester.tap(find.byType(CustomDropdownField<String>));
      await tester.pumpAndSettle();

      // Menu opens showing all options
      expect(find.text('Option 1'), findsOneWidget);
      expect(find.text('Option 2'), findsWidgets); // on field and in menu
      expect(find.text('Option 3'), findsOneWidget);

      // Selected item has a check icon
      expect(find.byIcon(Icons.check), findsOneWidget);

      // Tap Option 3
      await tester.tap(find.text('Option 3'));
      await tester.pumpAndSettle();

      expect(selectedValue, 'Option 3');
      expect(find.text('Option 3'), findsOneWidget);
    });

    testWidgets('FormField validation displays error in red when required',
        (tester) async {
      final formKey = GlobalKey<FormState>();
      String? selected;

      await tester.pumpWidget(
        _buildTestApp(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                CustomDropdownField<String>(
                  hintText: 'Category',
                  isRequiredStar: true,
                  value: selected,
                  items: const [
                    DropdownMenuItem(value: 'Property', child: Text('Property')),
                  ],
                  onChanged: (val) => selected = val,
                  validator: (v) => v == null ? 'Category is required' : null,
                ),
                ElevatedButton(
                  onPressed: () => formKey.currentState!.validate(),
                  child: const Text('Validate'),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Hint with asterisk
      expect(find.textContaining('Category'), findsOneWidget);
      expect(find.text('Category is required'), findsNothing);

      // Trigger validation
      await tester.tap(find.text('Validate'));
      await tester.pumpAndSettle();

      // Error message is displayed in red
      expect(find.text('Category is required'), findsOneWidget);
    });

    testWidgets('Disabled field hides chevron and does not open menu',
        (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          child: const CustomDropdownField<String>(
            hintText: 'Disabled Field',
            enabled: false,
            items: [
              DropdownMenuItem(value: 'Fixed', child: Text('Fixed')),
            ],
            onChanged: null,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // No chevron when disabled
      expect(find.byIcon(Icons.keyboard_arrow_down), findsNothing);

      // Tapping does not open menu
      await tester.tap(find.byType(CustomDropdownField<String>));
      await tester.pumpAndSettle();

      expect(find.text('Fixed'), findsNothing);
    });

    testWidgets('Safely synchronizes updated widget value inside Form without throwing setState during build',
        (tester) async {
      String? selectedValue = 'Option 1';
      late void Function(void Function()) parentSetState;
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        _buildTestApp(
          child: Form(
            key: formKey,
            child: StatefulBuilder(
              builder: (context, setState) {
                parentSetState = setState;
                return Column(
                  children: [
                    CustomDropdownField<String>(
                      hintText: 'Select Option',
                      value: selectedValue,
                      isRequiredStar: true,
                      items: const [
                        DropdownMenuItem(value: 'Option 1', child: Text('Option 1')),
                        DropdownMenuItem(value: 'Option 2', child: Text('Option 2')),
                      ],
                      onChanged: (val) {
                        setState(() => selectedValue = val);
                      },
                      validator: (val) => val == null ? 'Field is required' : null,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Option 1'), findsOneWidget);

      // Programmatically update value from parent while inside Form during build
      parentSetState(() {
        selectedValue = 'Option 2';
      });
      await tester.pumpAndSettle();
      expect(find.text('Option 2'), findsOneWidget);

      // Programmatically reset to null
      parentSetState(() {
        selectedValue = null;
      });
      await tester.pumpAndSettle();
      expect(find.textContaining('Select Option'), findsOneWidget);

      // Validation correctly fails when value was programmatically reset to null
      final isValid = formKey.currentState!.validate();
      await tester.pumpAndSettle();
      expect(isValid, isFalse);
      expect(find.text('Field is required'), findsOneWidget);
    });
  });
}
