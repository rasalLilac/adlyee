import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:solofy_vendor_app/application/core/utils/logger.dart';

class LocalNotification {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static bool isFlutterLocalNotificationsInitialized = false;
  static int _notificationId = 0;

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.high,
  );

  // Private constructor for singleton pattern
  LocalNotification._();

  // Singleton instance
  static final LocalNotification _instance = LocalNotification._();

  factory LocalNotification() {
    return _instance;
  }

  static Future<LocalNotification> init() async {
    if (isFlutterLocalNotificationsInitialized) {
      return LocalNotification();
    }

    try {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(_channel);

      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        // onDidReceiveLocalNotification: onDidReceiveLocalNotification,
      );

      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      await flutterLocalNotificationsPlugin.initialize(initializationSettings);
      isFlutterLocalNotificationsInitialized = true;
    } catch (e) {
      // Handle initialization error
      Logger.logError('Error initializing notifications: $e');
    }

    return LocalNotification();
  }

  static void onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) {
    // Handle received notification
  }

  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'simple-notification',
      'Simple Notification',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    try {
      await flutterLocalNotificationsPlugin.show(
        _notificationId++,
        title,
        body,
        notificationDetails,
      );
    } catch (e) {
      // Handle notification display error
      Logger.logError('Error showing notification: $e');
    }
  }

  // Method to show progress notification
  static Future<void> showProgressNotification({
    required String title,
    required String body,
    required int progress,
    required int total,
  }) async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'download_progress_channel', // Channel ID
            'Download Progress Notifications',
            importance: Importance.max,
            priority: Priority.high,
            showProgress: true,
            maxProgress: total,
            channelDescription: 'Notifications for download progress',
            progress: progress);

    final NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    try {
      await flutterLocalNotificationsPlugin.show(
        _notificationId,
        title,
        body,
        notificationDetails,
        payload: 'progress_payload',
      );

      // Update the notification with progress
      await flutterLocalNotificationsPlugin.show(
        _notificationId,
        title,
        body,
        notificationDetails,
      );
    } catch (e) {
      // Handle notification display error
      Logger.logError('Error showing progress notification: $e');
    }
  }
}
