import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/scale.dart';
import 'package:solofy_vendor_app/domain/bloc/notifications/models/app_notification.dart';

String formatNotificationTimestamp(DateTime dt) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  final day = dt.day;
  final month = months[dt.month - 1];
  final year = dt.year;
  final hour12 = dt.hour == 0 ? 12 : (dt.hour > 12 ? dt.hour - 12 : dt.hour);
  final minute = dt.minute.toString().padLeft(2, '0');
  final period = dt.hour >= 12 ? 'PM' : 'AM';
  return '$day $month $year | $hour12:$minute $period';
}

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.notification,
    this.expanded = false,
    this.onTap,
  });

  final AppNotification notification;
  final bool expanded;
  final VoidCallback? onTap;

  static const double cardRadius = 12.0;
  static const double unreadDotSize = 8.0;

  @override
  Widget build(BuildContext context) {
    final cardContent = Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorResources.white,
        borderRadius: BorderRadius.circular(cardRadius.s),
        border: Border.all(
          color: ColorResources.textFieldBorderColor,
          width: 1.s,
        ),
      ),
      padding: EdgeInsets.all(14.s),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  notification.message,
                  maxLines: expanded ? null : 2,
                  overflow: expanded ? null : TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 12.s,
                    fontWeight: FontWeight.w400,
                    color: ColorResources.textColor,
                    height: expanded ? 1.45 : 1.35,
                  ),
                ),
                Gap(8.s),
                Text(
                  formatNotificationTimestamp(notification.receivedAt),
                  style: GoogleFonts.poppins(
                    fontSize: 10.s,
                    fontWeight: FontWeight.w400,
                    color: ColorResources.grey,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          if (!notification.isRead) ...[
            Gap(8.s),
            Padding(
              padding: EdgeInsets.only(top: 2.s),
              child: Container(
                width: unreadDotSize.s,
                height: unreadDotSize.s,
                decoration: const BoxDecoration(
                  color: ColorResources.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: cardContent,
      );
    }
    return cardContent;
  }
}

