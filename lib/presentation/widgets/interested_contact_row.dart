import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/scale.dart';
import 'package:solofy_vendor_app/application/core/utils/alert_dialog.dart';
import 'package:solofy_vendor_app/application/core/utils/app_assets.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/interested_user.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/owner_mark.dart';
import 'package:url_launcher/url_launcher.dart';

class InterestedContactRow extends StatelessWidget {
  const InterestedContactRow({
    super.key,
    required this.user,
    this.onMarkChanged,
  });

  final InterestedUser user;
  final ValueChanged<OwnerMark?>? onMarkChanged;

  static const double cardRadius = 10.0;
  static const double paddingAll = 8.0;
  static const double avatarSize = 32.0;
  static const double actionButtonSize = 28.0;

  Future<void> _openWhatsApp() async {
    final cleanPhone = user.phone.replaceAll(RegExp(r'[^0-9]'), '');
    final uri = Uri.parse('https://wa.me/$cleanPhone');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        CustomAlertDialog.showCustomDialog(
          title: 'WhatsApp',
          subtitle: 'Cannot open WhatsApp for ${user.phone}',
        );
      }
    } catch (_) {
      CustomAlertDialog.showCustomDialog(
        title: 'WhatsApp',
        subtitle: 'Cannot open WhatsApp for ${user.phone}',
      );
    }
  }

  Future<void> _makeCall() async {
    final cleanPhone = user.phone.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri.parse('tel:$cleanPhone');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        CustomAlertDialog.showCustomDialog(
          title: 'Call',
          subtitle: 'Cannot place call to ${user.phone}',
        );
      }
    } catch (_) {
      CustomAlertDialog.showCustomDialog(
        title: 'Call',
        subtitle: 'Cannot place call to ${user.phone}',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(paddingAll.s),
      decoration: BoxDecoration(
        color: ColorResources.white,
        borderRadius: BorderRadius.circular(cardRadius.s),
        border: Border.all(
          color: ColorResources.borderColor,
          width: 1.s,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0A000000),
            blurRadius: 4.s,
            offset: Offset(0, 2.s),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Avatar with Feedback Dot at top-left
          SizedBox(
            width: avatarSize.s,
            height: avatarSize.s,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ClipOval(
                  child: Image.network(
                    user.avatarUrl,
                    width: avatarSize.s,
                    height: avatarSize.s,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: avatarSize.s,
                      height: avatarSize.s,
                      color: ColorResources.lightBlue,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.person,
                        size: 18.s,
                        color: ColorResources.primary,
                      ),
                    ),
                  ),
                ),
                if (user.mark != null)
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: 8.s,
                      height: 8.s,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: user.mark!.color,
                        border: Border.all(
                          color: ColorResources.white,
                          width: 1.5.s,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(width: 8.s),

          // 2. Name & Phone (Poppins 11-12 w500, single line ellipsis)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  user.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 12.s,
                    fontWeight: FontWeight.w500,
                    color: ColorResources.textColor,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 2.s),
                Text(
                  user.phone,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 11.s,
                    fontWeight: FontWeight.w500,
                    color: ColorResources.textColor,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.s),

          // 3. Action Buttons: WhatsApp, Call, More (3-dot popup)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (user.onWhatsApp) ...[
                GestureDetector(
                  onTap: _openWhatsApp,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: actionButtonSize.s,
                    height: actionButtonSize.s,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorResources.whatsappGreen,
                    ),
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      AppAssets.whatsappSvg,
                      width: 16.s,
                      height: 16.s,
                      colorFilter: const ColorFilter.mode(
                        ColorResources.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ],
              if (user.onWhatsApp && user.canCall) SizedBox(width: 8.s),
              if (user.canCall) ...[
                GestureDetector(
                  onTap: _makeCall,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: actionButtonSize.s,
                    height: actionButtonSize.s,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorResources.primary,
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.phone_rounded,
                      size: 15.s,
                      color: ColorResources.white,
                    ),
                  ),
                ),
              ],
              SizedBox(width: 4.s),
              Theme(
                data: Theme.of(context).copyWith(
                  popupMenuTheme: PopupMenuThemeData(
                    color: ColorResources.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.s),
                    ),
                    elevation: 6,
                  ),
                ),
                child: PopupMenuButton<OwnerMark>(
                  tooltip: 'More',
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.more_vert,
                    size: 20.s,
                    color: ColorResources.grey,
                  ),
                  onSelected: (selectedMark) {
                    final newMark = user.mark == selectedMark ? null : selectedMark;
                    onMarkChanged?.call(newMark);
                  },
                  itemBuilder: (ctx) => [
                    PopupMenuItem<OwnerMark>(
                      value: OwnerMark.definitelySuitable,
                      height: 32.s,
                      child: Text(
                        OwnerMark.definitelySuitable.label,
                        style: GoogleFonts.poppins(
                          fontSize: 12.s,
                          fontWeight: FontWeight.w500,
                          color: OwnerMark.definitelySuitable.color,
                        ),
                      ),
                    ),
                    PopupMenuItem<OwnerMark>(
                      value: OwnerMark.tentativelySuitable,
                      height: 32.s,
                      child: Text(
                        OwnerMark.tentativelySuitable.label,
                        style: GoogleFonts.poppins(
                          fontSize: 12.s,
                          fontWeight: FontWeight.w500,
                          color: OwnerMark.tentativelySuitable.color,
                        ),
                      ),
                    ),
                    PopupMenuItem<OwnerMark>(
                      value: OwnerMark.notSuitable,
                      height: 32.s,
                      child: Text(
                        OwnerMark.notSuitable.label,
                        style: GoogleFonts.poppins(
                          fontSize: 12.s,
                          fontWeight: FontWeight.w500,
                          color: OwnerMark.notSuitable.color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

