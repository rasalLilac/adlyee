import 'package:flutter/material.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/text_styles.dart';
import 'package:solofy_vendor_app/application/core/utils/extentions.dart';
import 'package:solofy_vendor_app/presentation/widgets/custom_material_button.dart';

/// Small underlined text action ("Continue As Guest", "Resend").
/// Pass [color] to tint it, [enabled] = false to grey it out.
class TextLinkButton extends StatelessWidget {
  const TextLinkButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color,
    this.enabled = true,
  });

  final String label;
  final VoidCallback onPressed;
  final Color? color;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return CustomMaterialButton(
      onPressed: enabled ? onPressed : () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(
          label,
          style: context.textStyle1.s12.w500.underline.copyWith(
            color: enabled ? color : ColorResources.grey,
          ),
        ),
      ),
    );
  }
}
