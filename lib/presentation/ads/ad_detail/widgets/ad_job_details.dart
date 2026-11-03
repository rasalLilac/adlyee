import 'package:flutter/material.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/diamentions.dart';
import 'package:solofy_vendor_app/application/core/theme/text_styles.dart';
import 'package:solofy_vendor_app/application/core/utils/string_file.dart';

class AdJobDetails extends StatelessWidget {
  const AdJobDetails({
    super.key,
    required this.skills,
    required this.otherInfo,
  });

  final List<String> skills;
  final String otherInfo;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (skills.isNotEmpty) ...[
          Text(StringFile.skillsLabel, style: baseTextStyle.s12.w600.black),
          gap6,
          ...skills.map(
            (skill) => Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Text(
                skill,
                style: baseTextStyle.s11.w400.copyWith(
                  color: ColorResources.textSecondary,
                ),
              ),
            ),
          ),
          gap12,
        ],
        if (otherInfo.isNotEmpty) ...[
          Text(StringFile.otherInfoLabel, style: baseTextStyle.s12.w600.black),
          gap6,
          Text(
            otherInfo,
            style: baseTextStyle.s11.w400.copyWith(
              color: ColorResources.textSecondary,
              height: 1.45,
            ),
          ),
          gap12,
        ],
      ],
    );
  }
}

