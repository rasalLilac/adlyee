import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:solofy_vendor_app/application/bloc/submission_history_cubit/submission_history_state.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/submission.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/submission_mock_data.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/submission_status.dart';

class SubmissionHistoryCubit extends Cubit<SubmissionHistoryState> {
  SubmissionHistoryCubit()
      : super(
          SubmissionHistoryState(
            allSubmissions: List<Submission>.of(mockSubmissions),
            filteredSubmissions: List<Submission>.of(mockSubmissions),
          ),
        );

  Future<void> loadSubmissions() async {
    emit(state.copyWith(isLoading: true));
    // TODO(api): Fetch submissions from backend
    final initialList = List<Submission>.of(mockSubmissions);
    final filtered = _filter(
      list: initialList,
      query: state.searchQuery,
      category: state.selectedCategory,
      sort: state.selectedSort,
      plan: state.selectedPlan,
      date: state.filterDate,
      status: state.filterStatus,
    );
    emit(state.copyWith(
      allSubmissions: initialList,
      filteredSubmissions: filtered,
      isLoading: false,
    ));
  }

  void onSearchChanged(String query) {
    final filtered = _filter(
      list: state.allSubmissions,
      query: query,
      category: state.selectedCategory,
      sort: state.selectedSort,
      plan: state.selectedPlan,
      date: state.filterDate,
      status: state.filterStatus,
    );
    emit(state.copyWith(
      searchQuery: query,
      filteredSubmissions: filtered,
    ));
  }

  void selectCategory(String category) {
    final filtered = _filter(
      list: state.allSubmissions,
      query: state.searchQuery,
      category: category,
      sort: state.selectedSort,
      plan: state.selectedPlan,
      date: state.filterDate,
      status: state.filterStatus,
    );
    emit(state.copyWith(
      selectedCategory: category,
      filteredSubmissions: filtered,
    ));
  }

  void selectSort(String sort) {
    final filtered = _filter(
      list: state.allSubmissions,
      query: state.searchQuery,
      category: state.selectedCategory,
      sort: sort,
      plan: state.selectedPlan,
      date: state.filterDate,
      status: state.filterStatus,
    );
    emit(state.copyWith(
      selectedSort: sort,
      filteredSubmissions: filtered,
    ));
  }

  void selectPlan(String plan) {
    final filtered = _filter(
      list: state.allSubmissions,
      query: state.searchQuery,
      category: state.selectedCategory,
      sort: state.selectedSort,
      plan: plan,
      date: state.filterDate,
      status: state.filterStatus,
    );
    emit(state.copyWith(
      selectedPlan: plan,
      filteredSubmissions: filtered,
    ));
  }

  void applyPopupFilter({DateTime? date, SubmissionStatus? status}) {
    final filtered = _filter(
      list: state.allSubmissions,
      query: state.searchQuery,
      category: state.selectedCategory,
      sort: state.selectedSort,
      plan: state.selectedPlan,
      date: date,
      status: status,
    );
    emit(state.copyWith(
      filterDate: () => date,
      filterStatus: () => status,
      filteredSubmissions: filtered,
    ));
  }

  void clearPopupFilter() {
    final filtered = _filter(
      list: state.allSubmissions,
      query: state.searchQuery,
      category: state.selectedCategory,
      sort: state.selectedSort,
      plan: state.selectedPlan,
      date: null,
      status: null,
    );
    emit(state.copyWith(
      filterDate: () => null,
      filterStatus: () => null,
      filteredSubmissions: filtered,
    ));
  }

  List<Submission> _filter({
    required List<Submission> list,
    required String query,
    required String category,
    required String sort,
    required String plan,
    required DateTime? date,
    required SubmissionStatus? status,
  }) {
    var result = List<Submission>.of(list);

    // 1. Text search
    if (query.trim().isNotEmpty) {
      final q = query.trim().toLowerCase();
      result = result.where((sub) {
        return sub.title.toLowerCase().contains(q) ||
            sub.adRef.toLowerCase().contains(q) ||
            sub.description.toLowerCase().contains(q) ||
            sub.locationLabel.toLowerCase().contains(q);
      }).toList();
    }

    // 2. Category
    if (category != 'Category' && category != 'All') {
      result = result
          .where((sub) => sub.category.toLowerCase() == category.toLowerCase())
          .toList();
    }

    // 3. Plan / Featured chip
    if (plan != 'All') {
      result = result
          .where((sub) => sub.plan.toLowerCase() == plan.toLowerCase())
          .toList();
    }

    // 4. Date filter from pop-up
    if (date != null) {
      final dateStr = DateFormat('dd MMM yyyy').format(date);
      result = result.where((sub) => sub.postedAt.trim() == dateStr).toList();
    }

    // 5. Status filter from pop-up
    if (status != null) {
      result = result.where((sub) => sub.status == status).toList();
    }

    // 6. Sort
    if (sort == 'Oldest') {
      result = result.reversed.toList();
    }

    return result;
  }
}
