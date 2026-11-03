import 'package:flutter/material.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/diamentions.dart';
import 'package:solofy_vendor_app/application/core/theme/text_styles.dart';
import 'package:solofy_vendor_app/application/core/utils/string_file.dart';

class ActivityFilterRow extends StatelessWidget {
  const ActivityFilterRow({
    super.key,
    required this.resultCount,
    required this.selectedCategory,
    required this.selectedSort,
    required this.selectedFilter,
    required this.onCategoryTap,
    required this.onSortTap,
    required this.onFilterTap,
  });

  final int resultCount;
  final String? selectedCategory;
  final String? selectedSort;
  final String? selectedFilter;
  final VoidCallback onCategoryTap;
  final VoidCallback onSortTap;
  final VoidCallback onFilterTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            _FilterChip(
              label: selectedCategory ?? StringFile.category,
              isActive: selectedCategory != null,
              onTap: onCategoryTap,
            ),
            gap8,
            _FilterChip(
              label: selectedSort ?? StringFile.latest,
              isActive: selectedSort != null,
              onTap: onSortTap,
            ),
            gap8,
            _FilterChip(
              label: selectedFilter ?? StringFile.featured,
              isActive: selectedFilter != null,
              onTap: onFilterTap,
            ),
          ],
        ),
        gap8,
        Text(
          '$resultCount Results',
          style: baseTextStyle.s10.w400.grey,
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.onTap,
    this.isActive = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ? ColorResources.primary.withValues(alpha: 0.08)
              : ColorResources.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive
                ? ColorResources.primary
                : ColorResources.borderColor,
            width: 1.1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: baseTextStyle.s11.w400.black,
            ),
            gap4,
            const Icon(
              Icons.keyboard_arrow_down,
              size: 14,
              color: ColorResources.grey,
            ),
          ],
        ),
      ),
    );
  }
}
