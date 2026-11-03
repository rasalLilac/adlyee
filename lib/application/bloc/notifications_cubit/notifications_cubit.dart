import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solofy_vendor_app/application/bloc/notifications_cubit/notifications_state.dart';
import 'package:solofy_vendor_app/domain/bloc/notifications/models/app_notification.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit({List<AppNotification>? initial})
      : super(NotificationsState(notifications: initial ?? defaultNotifications));

  static final NotificationsCubit instance = NotificationsCubit();

  static List<AppNotification> get defaultNotifications {
    final now = DateTime.now();
    final todayMorning = DateTime(now.year, now.month, now.day, 9, 0);
    final todayEarlier = DateTime(now.year, now.month, now.day, 8, 30);
    final todayRead = DateTime(now.year, now.month, now.day, 7, 15);
    final yesterday1 = now.subtract(const Duration(days: 1));
    final yesterdayMorning =
        DateTime(yesterday1.year, yesterday1.month, yesterday1.day, 9, 0);
    final yesterdayAfternoon =
        DateTime(yesterday1.year, yesterday1.month, yesterday1.day, 14, 0);

    const fullText =
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.";

    return [
      AppNotification(
        id: 'notif_1',
        message: fullText,
        receivedAt: todayMorning,
        isRead: false,
      ),
      AppNotification(
        id: 'notif_2',
        message: fullText,
        receivedAt: todayEarlier,
        isRead: false,
      ),
      AppNotification(
        id: 'notif_3',
        message: fullText,
        receivedAt: todayRead,
        isRead: true,
      ),
      AppNotification(
        id: 'notif_4',
        message: fullText,
        receivedAt: yesterdayMorning,
        isRead: true,
      ),
      AppNotification(
        id: 'notif_5',
        message: fullText,
        receivedAt: yesterdayAfternoon,
        isRead: true,
      ),
    ];
  }

  void markRead(String id) {
    emit(state.copyWith(
      notifications: state.notifications.map((n) {
        if (n.id == id) {
          return n.copyWith(isRead: true);
        }
        return n;
      }).toList(),
    ));
  }

  void markAllRead() {
    emit(state.copyWith(
      notifications: state.notifications
          .map((n) => n.copyWith(isRead: true))
          .toList(),
    ));
  }

  void reset() {
    emit(NotificationsState(notifications: defaultNotifications));
  }
}
