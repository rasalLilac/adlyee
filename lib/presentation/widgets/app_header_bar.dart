import 'package:flutter/material.dart';
import 'package:solofy_vendor_app/application/core/route/app_route.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/text_styles.dart';

class AppHeaderBar extends StatelessWidget {
  const AppHeaderBar({
    super.key,
    this.title,
    this.trailing,
    this.onBack,
    this.iconColor = ColorResources.black,
  });

  final String? title;
  final Widget? trailing;
  final VoidCallback? onBack;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onBack ?? () => AppRoute.pop(),
          icon: Icon(Icons.arrow_back, color: iconColor, size: 24),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        if (title != null) ...[
          Expanded(
            child: Text(
              title!,
              textAlign: TextAlign.center,
              style: baseTextStyle.s15.w700.black,
            ),
          ),
        ] else ...[
          const Spacer(),
        ],
        if (trailing != null)
          trailing!
        else if (title != null)
          const SizedBox(width: 24), // Keep title centered
      ],
    );
  }
}

