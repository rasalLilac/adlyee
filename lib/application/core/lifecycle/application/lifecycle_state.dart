import 'package:equatable/equatable.dart';
import '../domain/app_config.dart';

sealed class LifecycleState extends Equatable {
  const LifecycleState();
}

final class LifecycleInitial extends LifecycleState {
  const LifecycleInitial();

  @override
  List<Object?> get props => const [];
}

final class LifecycleLoading extends LifecycleState {
  const LifecycleLoading();

  @override
  List<Object?> get props => const [];
}

/// App is allowed to proceed normally.
/// [config] is present when fetch succeeded.
/// [error] is present when the fetch failed but the app proceeds gracefully.
final class LifecycleReady extends LifecycleState {
  const LifecycleReady({this.config, this.error});

  final AppConfig? config;
  final String? error;

  @override
  List<Object?> get props => [config, error];
}

/// App is blocked behind a "force update" screen.
final class LifecycleForceUpdate extends LifecycleState {
  const LifecycleForceUpdate({required this.config});

  final AppConfig config;

  @override
  List<Object?> get props => [config];
}
