import 'package:equatable/equatable.dart';

/// Configuration for lifecycle management.
class AppConfig extends Equatable {
  const AppConfig({
    this.minimumVersion,
    this.latestVersion,
    this.storeUrl,
    this.featureFlags = const {},
  });

  /// Minimum app version required — below this triggers force update.
  final String? minimumVersion;

  /// Latest available version in the store.
  final String? latestVersion;

  /// Store URL for force update redirect.
  final String? storeUrl;

  /// Runtime feature flags.
  final Map<String, bool> featureFlags;

  @override
  List<Object?> get props => [
    minimumVersion,
    latestVersion,
    storeUrl,
    featureFlags,
  ];
}
