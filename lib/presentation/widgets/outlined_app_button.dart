import 'package:flutter/material.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/diamentions.dart';
import 'package:solofy_vendor_app/application/core/theme/text_styles.dart';
import 'package:solofy_vendor_app/presentation/widgets/custom_material_button.dart';

class OutlinedAppButton extends StatelessWidget {
  const OutlinedAppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.borderColor = ColorResources.primary,
    this.textColor = ColorResources.primary,
    this.backgroundColor = Colors.transparent,
    this.height = 48,
    this.width,
  });

  final String label;
  final VoidCallback onPressed;
  final Color borderColor;
  final Color textColor;
  final Color backgroundColor;
  final double height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(fieldRadius);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: radius,
        border: Border.all(color: borderColor, width: 1.2),
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: CustomMaterialButton(
          onPressed: onPressed,
          width: width,
          child: Center(
            child: Text(
              label,
              style: baseTextStyle.s14.w500.copyWith(color: textColor),
            ),
          ),
        ),
      ),
    );
  }
}

