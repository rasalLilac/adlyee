import 'package:get_it/get_it.dart';

import 'package:injectable/injectable.dart';
import 'package:solofy_vendor_app/domain/core/di/development.dart';
import 'package:solofy_vendor_app/domain/core/di/production.dart';
import 'package:solofy_vendor_app/domain/core/di/test_env.dart';

import 'injection.config.dart';

/// [sl] serveice locater is used for
/// inject the dependency
final GetIt sl = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // default init
  preferRelativeImports: true, // default true
  asExtension: false,
)

/// [configureDependency] setup the dependency
Future<void> configureDependency({required String env}) async {
  switch (env) {
    case Environment.prod:
      ProductionEnv(env);
    case Environment.test:
      TestEnv(env);
    case Environment.dev:
    default:
      DevelopmentEnv(env);
  }
  // [init] generated method
  await init(
    sl,
    environment: Environment.prod,
  );
}

// @InjectableInit(preferRelativeImports: true)
// configureDependency({
//   String? env,
//   EnvironmentFilter? environmentFilter,
// }) async{
//   return getIt.init(
//     environmentFilter: environmentFilter,
//     environment: env,
//   );
// }
