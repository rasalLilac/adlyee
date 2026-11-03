// import 'package:upgrader/upgrader.dart';
// import 'app_config.dart';
// import '../application/lifecycle_bloc.dart';

// /// A repository that automatically checks the Apple App Store or Google Play Store
// /// for the latest version and forces an update if a newer version is published.
// class StoreLifecycleRepository implements ILifecycleRepository {
//   @override
//   Future<AppConfig> fetchAppConfig() async {
//     try {
//       final upgrader = Upgrader();
//       await upgrader.initialize();

//       final storeVersion = upgrader.currentAppStoreVersion;
//       final storeUrl = upgrader.currentAppStoreListingURL;

//       return AppConfig(
//         minimumVersion:
//             storeVersion, // Force update to whatever is in the store
//         latestVersion: storeVersion,
//         storeUrl: storeUrl,
//         featureFlags: const {},
//       );
//     } catch (e) {
//       // If store check fails (e.g., no internet, or app not published yet),
//       // allow app to continue gracefully.
//       return const AppConfig();
//     }
//   }
// }
