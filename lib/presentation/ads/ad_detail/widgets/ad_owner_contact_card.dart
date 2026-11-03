import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/diamentions.dart';
import 'package:solofy_vendor_app/application/core/theme/scale.dart';
import 'package:solofy_vendor_app/application/core/theme/text_styles.dart';
import 'package:solofy_vendor_app/application/core/utils/alert_dialog.dart';
import 'package:solofy_vendor_app/application/core/utils/app_assets.dart';
import 'package:solofy_vendor_app/application/core/utils/string_file.dart';
import 'package:url_launcher/url_launcher.dart';

class AdOwnerContactCard extends StatelessWidget {
  const AdOwnerContactCard({
    super.key,
    required this.posterName,
    required this.posterPhone,
    required this.posterOnWhatsApp,
    required this.posterAvatarUrl,
  });

  final String posterName;
  final String posterPhone;
  final bool posterOnWhatsApp;
  final String posterAvatarUrl;

  static const double actionButtonSize = 28.0;

  Future<void> _openWhatsApp() async {
    final cleanPhone = posterPhone.replaceAll(RegExp(r'[^0-9]'), '');
    final uri = Uri.parse('https://wa.me/$cleanPhone');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        CustomAlertDialog.showCustomDialog(
          title: 'WhatsApp',
          subtitle: 'Cannot open WhatsApp for $posterPhone',
        );
      }
    } catch (_) {
      CustomAlertDialog.showCustomDialog(
        title: 'WhatsApp',
        subtitle: 'Cannot open WhatsApp for $posterPhone',
      );
    }
  }

  Future<void> _makeCall() async {
    final cleanPhone = posterPhone.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri.parse('tel:$cleanPhone');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        CustomAlertDialog.showCustomDialog(
          title: 'Call',
          subtitle: 'Cannot initiate call to $posterPhone',
        );
      }
    } catch (_) {
      CustomAlertDialog.showCustomDialog(
        title: 'Call',
        subtitle: 'Cannot initiate call to $posterPhone',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          StringFile.contactAdOwner,
          style: baseTextStyle.s12.w600.black,
        ),
        gap8,

        // Available on WhatsApp? Yes / No (Read-only)
        Row(
          children: [
            Text(
              StringFile.availableOnWhatsApp,
              style: baseTextStyle.s11.w400.black,
            ),
            const Spacer(),
            _ReadonlyRadio(
              label: StringFile.yes,
              isSelected: posterOnWhatsApp,
            ),
            gap12,
            _ReadonlyRadio(
              label: StringFile.no,
              isSelected: !posterOnWhatsApp,
            ),
          ],
        ),
        gap10,

        // Owner Card
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: ColorResources.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: ColorResources.borderColor),
            boxShadow: [
              BoxShadow(
                color: ColorResources.primaryShadow.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 18,
                backgroundColor: ColorResources.lightBlue,
                backgroundImage: posterAvatarUrl.isNotEmpty
                    ? NetworkImage(posterAvatarUrl)
                    : null,
                child: posterAvatarUrl.isEmpty
                    ? const Icon(Icons.person, color: ColorResources.primary, size: 20)
                    : null,
              ),
              gap12,

              // Name & Phone
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      posterName,
                      style: baseTextStyle.s11.w700.black,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      posterPhone,
                      style: baseTextStyle.s10.w500.copyWith(
                        color: ColorResources.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              gap8,

              // WhatsApp button
              if (posterOnWhatsApp) ...[
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
                gap8,
              ],

              // Phone call button
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
          ),
        ),
      ],
    );
  }
}

class _ReadonlyRadio extends StatelessWidget {
  const _ReadonlyRadio({
    required this.label,
    required this.isSelected,
  });

  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 15,
          height: 15,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? ColorResources.primary : ColorResources.grey,
              width: 1.5,
            ),
          ),
          child: isSelected
              ? Center(
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: ColorResources.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                )
              : null,
        ),
        gap6,
        Text(
          label,
          style: baseTextStyle.s10.w400.black,
        ),
      ],
    );
  }
}

