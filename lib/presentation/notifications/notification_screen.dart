import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solofy_vendor_app/application/bloc/notifications_cubit/notifications_cubit.dart';
import 'package:solofy_vendor_app/application/bloc/notifications_cubit/notifications_state.dart';
import 'package:solofy_vendor_app/application/core/route/app_route.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/scale.dart';
import 'package:solofy_vendor_app/application/core/utils/string_file.dart';
import 'package:solofy_vendor_app/domain/bloc/notifications/models/app_notification.dart';
import 'package:solofy_vendor_app/presentation/notifications/notification_detail_screen.dart';
import 'package:solofy_vendor_app/presentation/notifications/widgets/notification_card.dart';
import 'package:solofy_vendor_app/presentation/widgets/app_header_bar.dart';
import 'package:solofy_vendor_app/presentation/widgets/app_page_scaffold.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  static const routeName = 'notifications';

  String _groupKeyFor(DateTime dt, DateTime now) {
    final dateOnly = DateTime(dt.year, dt.month, dt.day);
    final todayDate = DateTime(now.year, now.month, now.day);
    final yesterdayDate = todayDate.subtract(const Duration(days: 1));

    if (dateOnly == todayDate) {
      return StringFile.today;
    } else if (dateOnly == yesterdayDate) {
      return StringFile.yesterday;
    } else {
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ];
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
    }
  }

  Map<String, List<AppNotification>> _groupNotifications(
    List<AppNotification> notifications,
  ) {
    final now = DateTime.now();
    final grouped = <String, List<AppNotification>>{};

    for (final notif in notifications) {
      final key = _groupKeyFor(notif.receivedAt, now);
      grouped.putIfAbsent(key, () => []).add(notif);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        final grouped = _groupNotifications(state.notifications);

        return AppPageScaffold(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AppHeaderBar(title: StringFile.notification),
              Gap(16.s),
              if (state.notifications.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.s),
                  child: Center(
                    child: Text(
                      StringFile.noNotificationsYet,
                      style: GoogleFonts.poppins(
                        fontSize: 14.s,
                        fontWeight: FontWeight.w400,
                        color: ColorResources.grey,
                      ),
                    ),
                  ),
                )
              else
                ...grouped.entries.map((entry) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 12.s, top: 8.s),
                        child: Text(
                          entry.key,
                          style: GoogleFonts.poppins(
                            fontSize: 14.s,
                            fontWeight: FontWeight.w500,
                            color: ColorResources.textColor,
                            height: 1.2,
                          ),
                        ),
                      ),
                      ...entry.value.map((notif) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 12.s),
                          child: NotificationCard(
                            notification: notif,
                            expanded: false,
                            onTap: () {
                              context
                                  .read<NotificationsCubit>()
                                  .markRead(notif.id);
                              AppRoute.pushNamed(
                                NotificationDetailScreen.routeName,
                                arguments: notif,
                              );
                            },
                          ),
                        );
                      }),
                      Gap(8.s),
                    ],
                  );
                }),
            ],
          ),
        );
      },
    );
  }
}

