import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/scale.dart';

/// Reusable dropdown chip that opens a styled popup menu directly below it.
/// Same visual appearance as [DropdownChip], with an animated rotating chevron
/// and anchored popup menu displaying options.
class DropdownChipMenu<T> extends StatefulWidget {
  const DropdownChipMenu({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.chipLabel,
    this.itemLabel,
    this.isSelected,
    this.isActive = false,
    this.height = 30.0,
    this.fontSize,
    this.menuMaxWidth = 200.0,
    this.menuMaxHeight,
  });

  final T value;
  final List<T> items;
  final ValueChanged<T> onChanged;
  final String? chipLabel;
  final String Function(T item)? itemLabel;
  final bool Function(T item)? isSelected;
  final bool isActive;
  final double height;
  final double? fontSize;
  final double? menuMaxWidth;
  final double? menuMaxHeight;

  static const double chipRadius = 8.0;
  static const double paddingH = 6.0;
  static const double iconSize = 16.0;
  static const double iconGap = 2.0;
  static const double menuItemHeight = 36.0;
  static const double menuRadius = 10.0;

  @override
  State<DropdownChipMenu<T>> createState() => _DropdownChipMenuState<T>();
}

class _DropdownChipMenuState<T> extends State<DropdownChipMenu<T>>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _chevronAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _chevronAnimation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _labelFor(T item) {
    if (widget.itemLabel != null) {
      return widget.itemLabel!(item);
    }
    return item.toString();
  }

  Future<void> _openMenu() async {
    final RenderBox? button = context.findRenderObject() as RenderBox?;
    if (button == null || !button.hasSize) return;

    final overlay =
        Navigator.of(context).overlay?.context.findRenderObject() as RenderBox?;
    if (overlay == null || !overlay.hasSize) return;

    final Offset offset = button.localToGlobal(Offset.zero, ancestor: overlay);
    final Size size = button.size;

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromLTWH(
        offset.dx,
        offset.dy + size.height + 4.s,
        size.width,
        size.height,
      ),
      Offset.zero & overlay.size,
    );

    _controller.forward();

    final maxW = math.max(size.width, (widget.menuMaxWidth ?? 200.0).s);
    final maxH =
        (widget.menuMaxHeight ?? (DropdownChipMenu.menuItemHeight * 6.5)).s;

    final selected = await showMenu<T>(
      context: context,
      position: position,
      constraints: BoxConstraints(
        minWidth: size.width,
        maxWidth: maxW,
        maxHeight: maxH,
      ),
      elevation: 3,
      shadowColor: Colors.black.withValues(alpha: 0.12),
      surfaceTintColor: Colors.transparent,
      color: ColorResources.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DropdownChipMenu.menuRadius.s),
        side: BorderSide(
          color: ColorResources.borderColor,
          width: 1.s,
        ),
      ),
      items: widget.items.map((item) {
        final isSelected = widget.isSelected != null
            ? widget.isSelected!(item)
            : item == widget.value;
        return PopupMenuItem<T>(
          value: item,
          height: DropdownChipMenu.menuItemHeight.s,
          padding: EdgeInsets.symmetric(horizontal: 10.s),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  _labelFor(item),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 12.s,
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                    color: isSelected
                        ? ColorResources.primary
                        : ColorResources.textColor,
                    height: 1.2,
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check,
                  size: 14.s,
                  color: ColorResources.primary,
                ),
            ],
          ),
        );
      }).toList(),
    );

    if (mounted) {
      _controller.reverse();
    }

    if (selected != null) {
      widget.onChanged(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openMenu,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: widget.height.s,
        padding: EdgeInsets.symmetric(horizontal: DropdownChipMenu.paddingH.s),
        decoration: BoxDecoration(
          color: widget.isActive
              ? ColorResources.primary.withValues(alpha: 0.08)
              : ColorResources.white,
          borderRadius:
              BorderRadius.circular(DropdownChipMenu.chipRadius.s),
          border: Border.all(
            color: widget.isActive
                ? ColorResources.primary
                : ColorResources.borderColor,
            width: 1.s,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                widget.chipLabel ?? _labelFor(widget.value),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: (widget.fontSize ?? 11.5).s,
                  fontWeight: FontWeight.w400,
                  color: ColorResources.grey,
                  height: 1.2,
                ),
              ),
            ),
            SizedBox(width: DropdownChipMenu.iconGap.s),
            RotationTransition(
              turns: _chevronAnimation,
              child: Icon(
                Icons.keyboard_arrow_down,
                size: DropdownChipMenu.iconSize.s,
                color: ColorResources.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

