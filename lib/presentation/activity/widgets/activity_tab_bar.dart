import 'package:flutter/material.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/diamentions.dart';
import 'package:solofy_vendor_app/application/core/theme/text_styles.dart';
import 'package:solofy_vendor_app/domain/bloc/activity/models/activity_ad_item.dart';

class ActivityTabBar extends StatelessWidget {
  const ActivityTabBar({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  final ActivityTab selectedTab;
  final ValueChanged<ActivityTab> onTabSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _TabButton(
            label: ActivityTab.favourites.label,
            isSelected: selectedTab == ActivityTab.favourites,
            onTap: () => onTabSelected(ActivityTab.favourites),
          ),
        ),
        gap10,
        Expanded(
          child: _TabButton(
            label: ActivityTab.interests.label,
            isSelected: selectedTab == ActivityTab.interests,
            onTap: () => onTabSelected(ActivityTab.interests),
          ),
        ),
        gap10,
        Expanded(
          child: _TabButton(
            label: ActivityTab.viewed.label,
            isSelected: selectedTab == ActivityTab.viewed,
            onTap: () => onTabSelected(ActivityTab.viewed),
          ),
        ),
      ],
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 38,
        decoration: BoxDecoration(
          color: isSelected
              ? ColorResources.primary
              : ColorResources.lightBlue,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            label,
            style: isSelected
                ? baseTextStyle.s12.w600.white
                : baseTextStyle.s12.w500.copyWith(
                    color: ColorResources.textColor,
                  ),
          ),
        ),
      ),
    );
  }
}
