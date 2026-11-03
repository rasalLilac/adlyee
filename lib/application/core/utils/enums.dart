enum AppThemeMode {
  light,
  dark,
}

enum ApiStatus { initial, loading, success, error, empty }

enum SortOrder {
  latest('Latest'),
  oldest('Oldest');

  const SortOrder(this.label);
  final String label;
}