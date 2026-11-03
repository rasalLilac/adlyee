import 'package:flutter/material.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/diamentions.dart';
import 'package:solofy_vendor_app/application/core/theme/text_styles.dart';

class LabeledRadioGroup<T> extends StatelessWidget {
  const LabeledRadioGroup({
    super.key,
    required this.items,
    required this.labelBuilder,
    required this.selectedItem,
    required this.onChanged,
    this.isVertical = false,
    this.spacing = 16,
    this.itemSpacing = 8,
  });

  final List<T> items;
  final String Function(T) labelBuilder;
  final T? selectedItem;
  final ValueChanged<T> onChanged;
  final bool isVertical;
  final double spacing;
  final double itemSpacing;

  Widget _buildRadioItem(T item) {
    final isSelected = item == selectedItem;
    return GestureDetector(
      onTap: () => onChanged(item),
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? ColorResources.primary
                    : const Color(0xFFC7D3E3),
                width: 1.5,
              ),
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      width: 9,
                      height: 9,
                      decoration: const BoxDecoration(
                        color: ColorResources.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                : null,
          ),
          gap8,
          Text(
            labelBuilder(item),
            style: baseTextStyle.s12.w400.copyWith(
              color: isSelected ? ColorResources.black : ColorResources.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isVertical) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items
            .map(
              (item) => Padding(
                padding: EdgeInsets.only(bottom: itemSpacing),
                child: _buildRadioItem(item),
              ),
            )
            .toList(),
      );
    }

    return Wrap(
      spacing: spacing,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: items.map(_buildRadioItem).toList(),
    );
  }
}

