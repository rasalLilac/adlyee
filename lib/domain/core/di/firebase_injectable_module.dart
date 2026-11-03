// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:injectable/injectable.dart';

// @module
// abstract class FirebaseInjectableModule {
//   @preResolve
//   Future<FirebaseServeice> firebaseServeice() => FirebaseServeice.init();

//   @lazySingleton
//   FirebaseMessaging get firebaseMessaging => FirebaseMessaging.instance;

//   // @preResolve
//   // Future<OneSignalServeice> initNotification() => OneSignalServeice.init();

//   // @preResolve
//   // Future<LocalNotification> initLocalNotification() => LocalNotification.init();
// }

// class FirebaseServeice {
//   static Future<FirebaseServeice> init() async {
//     await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform,
//     );
//     return FirebaseServeice();
//   }
// }

// class OneSignalServeice {
//   static Future<OneSignalServeice> init() async {
//     OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
//     OneSignal.initialize('957c20f0-d3ee-41cd-a0d2-b0eadbed815c');
//     OneSignal.Notifications.requestPermission(true);
//     return OneSignalServeice();
//   }
// }

