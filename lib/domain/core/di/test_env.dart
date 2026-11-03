

import 'package:solofy_vendor_app/application/core/utils/logger.dart';
import 'package:solofy_vendor_app/domain/core/di/env.dart';

/// A class representing the staging environment configuration.
///
/// The [TestEnv] class extends [Env] and provides specific configuration for the staging environment.
/// It initializes with a domain URL for staging and logs that the application has started in staging mode.
class TestEnv extends Env {
  /// Creates an instance of [TestEnv] with the specified [env].
  ///
  /// Parameters:
  /// - [env]: The name of the environment.
  TestEnv(String env)
      : super(domainUrl: 'https://test.bingo.lilacinfotech.com', env: env) {
    Logger.logInfo('App Started In Staging Mode');
  }

  @override
  String toString() {
    return 'Staging';
  }
}
