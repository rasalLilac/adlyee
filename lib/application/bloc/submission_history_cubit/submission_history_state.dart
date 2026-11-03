import 'package:equatable/equatable.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/submission.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/submission_status.dart';

class SubmissionHistoryState extends Equatable {
  const SubmissionHistoryState({
    this.allSubmissions = const [],
    this.filteredSubmissions = const [],
    this.searchQuery = '',
    this.selectedCategory = 'Category',
    this.selectedSort = 'Latest',
    this.selectedPlan = 'All',
    this.filterDate,
    this.filterStatus,
    this.isLoading = false,
  });

  final List<Submission> allSubmissions;
  final List<Submission> filteredSubmissions;
  final String searchQuery;
  final String selectedCategory;
  final String selectedSort;
  final String selectedPlan;
  final DateTime? filterDate;
  final SubmissionStatus? filterStatus;
  final bool isLoading;

  bool get hasActivePopupFilter => filterDate != null || filterStatus != null;

  SubmissionHistoryState copyWith({
    List<Submission>? allSubmissions,
    List<Submission>? filteredSubmissions,
    String? searchQuery,
    String? selectedCategory,
    String? selectedSort,
    String? selectedPlan,
    DateTime? Function()? filterDate,
    SubmissionStatus? Function()? filterStatus,
    bool? isLoading,
  }) {
    return SubmissionHistoryState(
      allSubmissions: allSubmissions ?? this.allSubmissions,
      filteredSubmissions: filteredSubmissions ?? this.filteredSubmissions,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedSort: selectedSort ?? this.selectedSort,
      selectedPlan: selectedPlan ?? this.selectedPlan,
      filterDate: filterDate != null ? filterDate() : this.filterDate,
      filterStatus: filterStatus != null ? filterStatus() : this.filterStatus,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
        allSubmissions,
        filteredSubmissions,
        searchQuery,
        selectedCategory,
        selectedSort,
        selectedPlan,
        filterDate,
        filterStatus,
        isLoading,
      ];
}

