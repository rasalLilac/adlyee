import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:solofy_vendor_app/application/bloc/notifications_cubit/notifications_cubit.dart';
import 'package:solofy_vendor_app/application/bloc/notifications_cubit/notifications_state.dart';
import 'package:solofy_vendor_app/application/core/theme/scale.dart';
import 'package:solofy_vendor_app/application/core/utils/string_file.dart';
import 'package:solofy_vendor_app/domain/bloc/notifications/models/app_notification.dart';
import 'package:solofy_vendor_app/presentation/notifications/widgets/notification_card.dart';
import 'package:solofy_vendor_app/presentation/widgets/app_header_bar.dart';
import 'package:solofy_vendor_app/presentation/widgets/app_page_scaffold.dart';

class NotificationDetailScreen extends StatefulWidget {
  const NotificationDetailScreen({
    super.key,
    required this.notification,
  });

  static const routeName = 'notification-detail';

  final AppNotification notification;

  @override
  State<NotificationDetailScreen> createState() =>
      _NotificationDetailScreenState();
}

class _NotificationDetailScreenState extends State<NotificationDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context
            .read<NotificationsCubit>()
            .markRead(widget.notification.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        final currentNotification = state.notifications.firstWhere(
          (n) => n.id == widget.notification.id,
          orElse: () => widget.notification,
        );

        return AppPageScaffold(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AppHeaderBar(title: StringFile.notification),
              Gap(20.s),
              NotificationCard(
                notification: currentNotification,
                expanded: true,
              ),
            ],
          ),
        );
      },
    );
  }
}

