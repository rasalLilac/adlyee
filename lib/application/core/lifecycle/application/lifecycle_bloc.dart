import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/semver.dart';
import '../domain/app_config.dart';
import '../domain/feature_flag_service.dart';
import 'lifecycle_event.dart';
import 'lifecycle_state.dart';

/// Define an interface for providing the AppConfig
abstract class ILifecycleRepository {
  Future<AppConfig> fetchAppConfig();
}

class LifecycleBloc extends Bloc<LifecycleEvent, LifecycleState> {
  LifecycleBloc({required this.repository}) : super(const LifecycleInitial()) {
    on<LifecycleCheckEvent>(_onCheck);
  }

  final ILifecycleRepository repository;

  FutureOr<void> _onCheck(
    LifecycleCheckEvent event,
    Emitter<LifecycleState> emit,
  ) async {
    emit(const LifecycleLoading());

    try {
      final config = await repository.fetchAppConfig();

      // Update feature flags
      if (config.featureFlags.isNotEmpty) {
        FeatureFlagService.instance.updateFlags(config.featureFlags);
      }

      // Check force update
      if (config.minimumVersion != null &&
          Semver.isBelow(event.currentVersion, config.minimumVersion!)) {
        emit(LifecycleForceUpdate(config: config));
        return;
      }

      // All clear
      emit(LifecycleReady(config: config));
    } catch (e) {
      // On failure, allow the app to proceed (graceful degradation)
      emit(LifecycleReady(error: e.toString()));
    }
  }
}
