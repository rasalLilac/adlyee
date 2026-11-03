import 'package:solofy_vendor_app/application/core/utils/extentions.dart';
import 'package:solofy_vendor_app/application/core/utils/logger.dart';
import 'package:solofy_vendor_app/domain/core/di/env.dart';

/// A class representing the development environment configuration.
///
/// The [DevelopmentEnv] class extends [Env] and provides specific configuration for the development environment.
/// It initializes with a domain URL for development and logs that the application has started in development mode.
class DevelopmentEnv extends Env {
  /// Creates an instance of [DevelopmentEnv] with the specified [env].
  ///
  /// Parameters:
  /// - [env]: The name of the environment.
  DevelopmentEnv(String env)
      : super(
          domainUrl: 'http://192.168.29.8:8080',
          env: env,
        ) {
    Logger.logInfo('App Started In Development Mode');
  }

  @override
  String toString() {
    return env.capitalize;
  }
}
