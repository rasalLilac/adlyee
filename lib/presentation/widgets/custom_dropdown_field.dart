import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/scale.dart';

class _DropdownItemWrapper<T> {
  const _DropdownItemWrapper(this.value);
  final T? value;
}

/// Reusable clean dropdown field matching the app design system:
/// - White anchored popup directly below the field, same width as the field
/// - Radius 10, 1 px light border, very light shadow
/// - Selected item in primary blue (w500) with checkmark (14) at right
/// - Animated 180° rotating chevron on the field
/// - Height capped at ~6 items with internal scrolling for long lists
/// - Full FormField validator & required * support
class CustomDropdownField<T> extends StatefulWidget {
  const CustomDropdownField({
    super.key,
    required this.hintText,
    required this.items,
    this.onChanged,
    this.value,
    this.validator,
    this.isRequiredStar = false,
    this.enabled = true,
  });

  final String hintText;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final T? value;
  final FormFieldValidator<T>? validator;
  final bool isRequiredStar;
  final bool enabled;

  @override
  State<CustomDropdownField<T>> createState() => _CustomDropdownFieldState<T>();
}

class _CustomDropdownFieldState<T> extends State<CustomDropdownField<T>>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormFieldState<T>> _formFieldKey =
      GlobalKey<FormFieldState<T>>();
  final GlobalKey _boxKey = GlobalKey();

  late final AnimationController _chevronController;
  late final Animation<double> _chevronAnimation;
  bool _isOpen = false;
  bool _syncScheduled = false;

  static const double fieldRadius = 10.0;
  static const double fieldHeight = 44.0;
  static const double menuItemHeight = 40.0;

  @override
  void initState() {
    super.initState();
    _chevronController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _chevronAnimation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: _chevronController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(covariant CustomDropdownField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      final currentFormFieldValue = _formFieldKey.currentState?.value;
      if (currentFormFieldValue != widget.value) {
        _scheduleValueSync();
      }
    }
  }

  void _scheduleValueSync() {
    if (_syncScheduled) return;
    _syncScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncScheduled = false;
      if (!mounted) return;
      final formFieldState = _formFieldKey.currentState;
      if (formFieldState != null && formFieldState.value != widget.value) {
        formFieldState.didChange(widget.value);
      }
    });
  }

  @override
  void dispose() {
    _chevronController.dispose();
    super.dispose();
  }

  String _labelOf(DropdownMenuItem<T> item) {
    final child = item.child;
    if (child is Text) {
      if (child.data != null) return child.data!;
      if (child.textSpan != null) return child.textSpan!.toPlainText();
    }
    return item.value?.toString() ?? '';
  }

  String? _selectedLabel(T? val) {
    if (val == null) return null;
    for (final item in widget.items) {
      if (item.value == val) {
        return _labelOf(item);
      }
    }
    return val.toString();
  }

  Future<void> _openMenu(FormFieldState<T> formState) async {
    if (!widget.enabled || widget.items.isEmpty) return;

    final RenderBox? button =
        _boxKey.currentContext?.findRenderObject() as RenderBox?;
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

    setState(() => _isOpen = true);
    _chevronController.forward();

    final currentValue =
        _syncScheduled ? widget.value : (formState.value ?? widget.value);

    final selected = await showMenu<_DropdownItemWrapper<T>>(
      context: context,
      position: position,
      constraints: BoxConstraints(
        minWidth: size.width,
        maxWidth: size.width,
        maxHeight: (menuItemHeight * 6.5).s,
      ),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      surfaceTintColor: Colors.transparent,
      color: ColorResources.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(fieldRadius.s),
        side: BorderSide(
          color: ColorResources.borderColor,
          width: 1.s,
        ),
      ),
      items: widget.items.map((item) {
        final isSelected = item.value == currentValue;
        return PopupMenuItem<_DropdownItemWrapper<T>>(
          value: _DropdownItemWrapper(item.value),
          height: menuItemHeight.s,
          padding: EdgeInsets.symmetric(horizontal: 14.s),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _labelOf(item),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 12.5.s,
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
      setState(() => _isOpen = false);
      _chevronController.reverse();
    }

    if (selected != null) {
      final pickedVal = selected.value;
      formState.didChange(pickedVal);
      widget.onChanged?.call(pickedVal);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      key: _formFieldKey,
      initialValue: widget.value,
      validator: (val) {
        final effectiveVal = _syncScheduled ? widget.value : val;
        return widget.validator?.call(effectiveVal);
      },
      builder: (FormFieldState<T> state) {
        final currentValue =
            _syncScheduled ? widget.value : (state.value ?? widget.value);
        final selectedText = _selectedLabel(currentValue);
        final hasError = state.hasError;

        Color borderColor;
        if (hasError) {
          borderColor = ColorResources.red;
        } else if (_isOpen) {
          borderColor = ColorResources.primary;
        } else {
          borderColor = ColorResources.textFieldBorderColor;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              key: _boxKey,
              onTap: widget.enabled ? () => _openMenu(state) : null,
              behavior: HitTestBehavior.opaque,
              child: Container(
                height: fieldHeight.s,
                padding: EdgeInsets.symmetric(
                  horizontal: 14.s,
                  vertical: 11.s,
                ),
                decoration: BoxDecoration(
                  color: ColorResources.textFieldColor,
                  borderRadius: BorderRadius.circular(fieldRadius.s),
                  border: Border.all(
                    color: borderColor,
                    width: 1.s,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: selectedText != null
                          ? Text(
                              selectedText,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: 13.s,
                                fontWeight: FontWeight.w400,
                                color: ColorResources.black,
                                height: 1.2,
                              ),
                            )
                          : (widget.isRequiredStar
                              ? Text.rich(
                                  TextSpan(
                                    text: widget.hintText,
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
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                              : Text(
                                  widget.hintText,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12.s,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF9E9E9E),
                                    height: 1.2,
                                  ),
                                )),
                    ),
                    if (widget.enabled) ...[
                      SizedBox(width: 6.s),
                      RotationTransition(
                        turns: _chevronAnimation,
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: ColorResources.grey,
                          size: 20.s,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            if (hasError && state.errorText != null)
              Padding(
                padding: EdgeInsets.only(top: 4.s, left: 2.s),
                child: Text(
                  state.errorText!,
                  style: GoogleFonts.poppins(
                    fontSize: 11.s,
                    fontWeight: FontWeight.w400,
                    color: ColorResources.red,
                    height: 1.2,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
