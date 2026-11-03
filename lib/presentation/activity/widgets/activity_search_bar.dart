import 'package:flutter/material.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/diamentions.dart';
import 'package:solofy_vendor_app/application/core/theme/text_styles.dart';
import 'package:solofy_vendor_app/application/core/utils/string_file.dart';

class ActivitySearchBar extends StatelessWidget {
  const ActivitySearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onFilterTap,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onFilterTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: ColorResources.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ColorResources.primary,
          width: 1.5,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          const Icon(
            Icons.search,
            color: ColorResources.grey,
            size: 20,
          ),
          gap8,
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: baseTextStyle.s13.w400.black,
              decoration: InputDecoration(
                hintText: StringFile.search,
                hintStyle: baseTextStyle.s13.w400.grey,
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          gap8,
          GestureDetector(
            onTap: onFilterTap,
            behavior: HitTestBehavior.opaque,
            child: const Icon(
              Icons.tune_rounded,
              color: ColorResources.black,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
