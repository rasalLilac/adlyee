import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solofy_vendor_app/application/bloc/submission_history_cubit/submission_history_cubit.dart';
import 'package:solofy_vendor_app/application/core/app_details.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/submission_mock_data.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/submission_status.dart';
import 'package:solofy_vendor_app/presentation/main/submission_history/submission_history_tab.dart';
import 'package:solofy_vendor_app/presentation/main/submission_history/widgets/sort_find_sheet.dart';
import 'package:solofy_vendor_app/presentation/main/submission_history/widgets/submission_card.dart';
import 'package:solofy_vendor_app/presentation/widgets/ad_status_chip.dart';

void main() {
  test('SubmissionStatus covers all 5 states with correct labels', () {
    expect(SubmissionStatus.pendingApproval.label, 'Pending Approval');
    expect(SubmissionStatus.active.label, 'Active');
    expect(SubmissionStatus.expiringSoon.label, 'Expiring Soon');
    expect(SubmissionStatus.expired.label, 'Expired');
    expect(SubmissionStatus.rejected.label, 'Rejected');
  });

  test('SubmissionHistoryCubit filters by category, status, and query', () {
    final cubit = SubmissionHistoryCubit();
    expect(cubit.state.allSubmissions.length, mockSubmissions.length);
    expect(cubit.state.filteredSubmissions.length, mockSubmissions.length);

    // Filter by category
    cubit.selectCategory('Vehicles');
    expect(cubit.state.filteredSubmissions.every((s) => s.category == 'Vehicles'), isTrue);

    // Reset category
    cubit.selectCategory('All');
    expect(cubit.state.filteredSubmissions.length, mockSubmissions.length);

    // Filter by status via popup
    cubit.applyPopupFilter(status: SubmissionStatus.pendingApproval);
    expect(cubit.state.hasActivePopupFilter, isTrue);
    expect(cubit.state.filteredSubmissions.every((s) => s.status == SubmissionStatus.pendingApproval), isTrue);

    // Search query
    cubit.onSearchChanged('Rent House');
    expect(cubit.state.filteredSubmissions.every((s) => s.title == 'Rent House'), isTrue);

    // Clear popup filter & search query
    cubit.clearPopupFilter();
    cubit.onSearchChanged('');
    expect(cubit.state.filteredSubmissions.length, mockSubmissions.length);

    // Filter by plan
    expect(cubit.state.selectedPlan, 'All');
    cubit.selectPlan('Urgent');
    expect(cubit.state.filteredSubmissions.length, 1);
    expect(cubit.state.filteredSubmissions.first.plan, 'Urgent');

    cubit.selectPlan('Regular');
    expect(cubit.state.filteredSubmissions.length, 6);
    expect(cubit.state.filteredSubmissions.every((s) => s.plan == 'Regular'), isTrue);

    cubit.selectPlan('Featured');
    expect(cubit.state.filteredSubmissions.length, 1);
    expect(cubit.state.filteredSubmissions.first.plan, 'Featured');

    cubit.selectPlan('All');
    expect(cubit.state.filteredSubmissions.length, mockSubmissions.length);
  });

  testWidgets('Renders SubmissionHistoryTab and opens SortFindSheet',
      (WidgetTester tester) async {
    const size = Size(393, 852);
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    AppDetails.screenSize = size;

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SubmissionHistoryTab(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Submission History'), findsOneWidget);
    expect(find.byType(SubmissionCard), findsWidgets);
    expect(find.byType(StatusChip), findsWidgets);

    // Open filter sheet
    final tuneIcon = find.byIcon(Icons.tune_rounded);
    expect(tuneIcon, findsOneWidget);
    await tester.tap(tuneIcon);
    await tester.pumpAndSettle();

    expect(find.byType(SortFindSheet), findsOneWidget);
    expect(find.text('Sort & Find Fast'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Apply'), findsOneWidget);

    // Tap Cancel
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.byType(SortFindSheet), findsNothing);
  });
}

