
import 'package:solofy_vendor_app/application/core/utils/logger.dart';

/// An abstract class representing the environment configuration for the application.
///
/// The [Env] class defines the basic structure for environment configurations. It provides
/// a way to initialize and configure different environments (e.g., Staging, Production, Development).
///
/// Subclasses of [Env] should specify the environment's domain URL and handle any specific
/// configuration or initialization needed for that environment.
///
/// Example usage:
/// ```dart
/// void main() {
///   Env env = StagingEnv('staging');
///   print(env); // Outputs: Staging
/// }
/// ```
abstract class Env {
  /// The base URL for the domain in this environment.
  final String domainUrl;

  /// The name of the environment (e.g., 'staging', 'production').
  final String env;

  /// A static instance of the [Env] class that represents the current environment.
  static late Env instance;

  /// Creates an instance of [Env] with the specified [env] and [domainUrl].
  ///
  /// Initializes the environment and logs the domain URL.
  ///
  /// Parameters:
  /// - [env]: The name of the environment.
  /// - [domainUrl]: The base URL for the domain in this environment.
  Env({
    required this.env,
    required this.domainUrl,
  }) {
    boot();
  }

  /// Initializes the environment.
  ///
  /// This method sets up the environment by initializing time zones and logging the domain URL.
  /// It also assigns the current instance to the static [instance] variable.
  void boot() async {
    // await dotenv.load(fileName: '.env');

    instance = this;

    Logger.logInfo('Domain Url: $domainUrl');
  }
}
