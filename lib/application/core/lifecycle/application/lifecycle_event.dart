import 'package:equatable/equatable.dart';

abstract class LifecycleEvent extends Equatable {
  const LifecycleEvent();
  @override
  List<Object?> get props => [];
}

/// Fetch remote app configuration and check if update is required.
class LifecycleCheckEvent extends LifecycleEvent {
  const LifecycleCheckEvent({required this.currentVersion});

  final String currentVersion;

  @override
  List<Object?> get props => [currentVersion];
}
