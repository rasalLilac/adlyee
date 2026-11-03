import 'package:flutter/material.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/diamentions.dart';
import 'package:solofy_vendor_app/application/core/theme/text_styles.dart';
import 'package:solofy_vendor_app/presentation/widgets/custom_material_button.dart';

/// Full-width blue button with soft shadow ("Send OTP", "Confirm", ...).
/// Built on top of [CustomMaterialButton]; shows a spinner while [isLoading].
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(fieldRadius);
    final isClickable = isEnabled && !isLoading;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isEnabled
            ? ColorResources.primary
            : ColorResources.primary.withValues(alpha: 0.45),
        borderRadius: radius,
        boxShadow: isEnabled
            ? [
                BoxShadow(
                  color: ColorResources.primaryShadow.withValues(alpha: 0.6),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: CustomMaterialButton(
          width: double.infinity,
          onPressed: isClickable ? onPressed : () {},
          child: SizedBox(
            height: 48,
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: ColorResources.white,
                      ),
                    )
                  : Text(
                      label,
                      style: baseTextStyle.s14.w500.copyWith(
                        color: isEnabled
                            ? ColorResources.white
                            : ColorResources.white.withValues(alpha: 0.85),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
