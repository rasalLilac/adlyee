import 'package:flutter/material.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/diamentions.dart';
import 'package:solofy_vendor_app/application/core/theme/text_styles.dart';
import 'package:solofy_vendor_app/application/core/utils/constants.dart';
import 'package:solofy_vendor_app/application/core/utils/extentions.dart';

/// "+91 |" shown inside the mobile number field.
class CountryCodePrefix extends StatelessWidget {
  const CountryCodePrefix({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(AppConstants.countryCode, style: context.textStyle1.s12.w500),
        gap8,
        Container(width: 1, height: 16, color: ColorResources.textFieldBorderColor),
      ],
    );
  }
}
