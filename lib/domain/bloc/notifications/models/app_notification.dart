import 'package:equatable/equatable.dart';

class AppNotification extends Equatable {
  const AppNotification({
    required this.id,
    required this.message,
    required this.receivedAt,
    this.isRead = false,
  });

  final String id;
  final String message;
  final DateTime receivedAt;
  final bool isRead;

  AppNotification copyWith({
    String? id,
    String? message,
    DateTime? receivedAt,
    bool? isRead,
  }) {
    return AppNotification(
      id: id ?? this.id,
      message: message ?? this.message,
      receivedAt: receivedAt ?? this.receivedAt,
      isRead: isRead ?? this.isRead,
    );
  }

  @override
  List<Object?> get props => [id, message, receivedAt, isRead];
}

