import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/scale.dart';
import 'package:solofy_vendor_app/application/core/theme/text_styles.dart';

/// Rounded, light-filled text field used on every form.
/// Wraps [TextFormField] so it works with `Form` + validators.
class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.maxLength,
    this.prefix,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.textCapitalization = TextCapitalization.none,
    this.maxLines = 1,
    this.minLines = 1,
    this.counterText,
    this.isRequiredStar = false,
    this.innerCounterText,
    this.readOnly = false,
    this.focusNode,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;

  /// Optional widget shown before the text (e.g. the "+91 |" country code).
  final Widget? prefix;
  final Widget? suffixIcon;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final TextCapitalization textCapitalization;
  final int? maxLines;
  final int? minLines;
  final String? counterText;
  final bool isRequiredStar;
  final String? innerCounterText;
  final bool readOnly;
  final FocusNode? focusNode;

  static OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.s),
        borderSide: BorderSide(color: color, width: 1.s),
      );

  @override
  Widget build(BuildContext context) {
    final isMulti = (maxLines ?? 1) > 1;

    final field = TextFormField(
      controller: controller,
      readOnly: readOnly,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      maxLines: maxLines,
      minLines: minLines,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      textCapitalization: textCapitalization,
      cursorColor: ColorResources.primary,
      style: GoogleFonts.poppins(
        fontSize: 13.s,
        fontWeight: FontWeight.w400,
        color: ColorResources.black,
        height: 1.2,
      ),
      decoration: InputDecoration(
        isDense: true,
        counterText: counterText ?? '',
        counterStyle: baseTextStyle.s10.w400.slateGray,
        filled: true,
        fillColor: ColorResources.textFieldColor,
        hintText: isRequiredStar ? null : hintText,
        hintStyle: GoogleFonts.poppins(
          fontSize: 12.s,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF9E9E9E),
          height: 1.2,
        ),
        errorStyle: GoogleFonts.poppins(
          fontSize: 10.s,
          fontWeight: FontWeight.w400,
          color: ColorResources.red,
          height: 1.2,
        ),
        contentPadding: EdgeInsets.fromLTRB(
          14.s,
          11.s,
          14.s,
          isMulti
              ? (innerCounterText != null ? 24.s : 11.s)
              : 11.s,
        ),
        prefixIcon: prefix == null
            ? null
            : Padding(
                padding: EdgeInsets.only(left: 14.s, right: 8.s),
                child: prefix,
              ),
        prefixIconConstraints: const BoxConstraints(),
        suffixIcon: suffixIcon,
        border: _border(ColorResources.textFieldBorderColor),
        enabledBorder: _border(ColorResources.textFieldBorderColor),
        focusedBorder: _border(ColorResources.primary),
        errorBorder: _border(ColorResources.red),
        focusedErrorBorder: _border(ColorResources.red),
      ),
    );

    if (isRequiredStar || innerCounterText != null) {
      return Stack(
        children: [
          field,
          if (isRequiredStar)
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (context, val, _) {
                if (val.text.isNotEmpty) {
                  return const SizedBox.shrink();
                }
                return Positioned(
                  left: prefix == null ? 14.s : 56.s,
                  top: 11.s,
                  child: IgnorePointer(
                    child: Text.rich(
                      TextSpan(
                        text: hintText,
                        style: GoogleFonts.poppins(
                          fontSize: 12.s,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF9E9E9E),
                          height: 1.2,
                        ),
                        children: const [
                          TextSpan(
                            text: '*',
                            style: TextStyle(
                              color: ColorResources.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          if (innerCounterText != null)
            Positioned(
              right: 12.s,
              bottom: 8.s,
              child: Text(
                innerCounterText!,
                style: baseTextStyle.s09.w400.slateGray,
              ),
            ),
        ],
      );
    }

    return field;
  }
}
