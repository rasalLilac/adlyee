import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/diamentions.dart';
import 'package:solofy_vendor_app/application/core/theme/text_styles.dart';
import 'package:solofy_vendor_app/application/core/utils/string_file.dart';
import 'package:solofy_vendor_app/presentation/home/models/ad_item.dart';
import 'package:solofy_vendor_app/presentation/widgets/custom_text_field.dart';

/// Modal bottom sheet for "Sort & Find Fast" filter (Image 4).
class FilterModal extends StatefulWidget {
  const FilterModal({
    super.key,
    required this.initialFilter,
    required this.onApply,
  });

  final AdFilter initialFilter;
  final ValueChanged<AdFilter> onApply;

  static Future<void> show({
    required BuildContext context,
    required AdFilter initialFilter,
    required ValueChanged<AdFilter> onApply,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => FilterModal(
        initialFilter: initialFilter,
        onApply: onApply,
      ),
    );
  }

  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  late double _distance;
  DateTime? _selectedDate;
  late final TextEditingController _pincodeController;

  @override
  void initState() {
    super.initState();
    _distance = widget.initialFilter.maxDistanceKm;
    _selectedDate = widget.initialFilter.selectedDate;
    _pincodeController = TextEditingController(text: widget.initialFilter.pincode);
  }

  @override
  void dispose() {
    _pincodeController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: ColorResources.primary,
              onPrimary: Colors.white,
              onSurface: ColorResources.textColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _onApply() {
    final updated = widget.initialFilter.copyWith(
      maxDistanceKm: _distance,
      selectedDate: _selectedDate,
      clearDate: _selectedDate == null,
      pincode: _pincodeController.text.trim(),
    );
    widget.onApply(updated);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + bottomInset),
      decoration: const BoxDecoration(
        color: ColorResources.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: "Sort & Find Fast" + Close Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                StringFile.sortAndFindFast,
                style: baseTextStyle.s16.w600.black,
              ),
              InkWell(
                onTap: () => Navigator.of(context).pop(),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: ColorResources.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          gap20,

          // Distance Slider with value pill thumb
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 3.5,
              activeTrackColor: ColorResources.primary,
              inactiveTrackColor: ColorResources.borderColor,
              thumbShape: _DistanceThumbShape(value: _distance.toInt()),
              overlayColor: ColorResources.primary.withValues(alpha: 0.1),
              trackShape: const _TrackWithEndDotsShape(),
            ),
            child: Slider(
              value: _distance,
              min: 5,
              max: 100,
              divisions: 95,
              onChanged: (val) => setState(() => _distance = val),
            ),
          ),
          gap16,

          // Date Picker Field
          GestureDetector(
            onTap: _pickDate,
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: ColorResources.textFieldColor,
                borderRadius: BorderRadius.circular(fieldRadius),
                border: Border.all(color: ColorResources.textFieldBorderColor),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_month_outlined,
                    size: 20,
                    color: ColorResources.grey,
                  ),
                  gap12,
                  Expanded(
                    child: Text(
                      _selectedDate != null
                          ? DateFormat('dd MMM yyyy').format(_selectedDate!)
                          : StringFile.selectDate,
                      style: _selectedDate != null
                          ? baseTextStyle.s12.w500.black
                          : baseTextStyle.s12.w400.slateGray,
                    ),
                  ),
                  if (_selectedDate != null)
                    GestureDetector(
                      onTap: () => setState(() => _selectedDate = null),
                      child: const Icon(
                        Icons.cancel,
                        size: 16,
                        color: ColorResources.grey,
                      ),
                    ),
                ],
              ),
            ),
          ),
          gap16,

          // Pincode Input Field
          CustomTextField(
            controller: _pincodeController,
            hintText: StringFile.pincode,
            keyboardType: TextInputType.number,
            maxLength: 6,
          ),
          gap20,

          // Buttons: Cancel & Apply
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 46,
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: ColorResources.primary.withValues(alpha: 0.4),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(fieldRadius),
                      ),
                    ),
                    child: Text(
                      StringFile.cancel,
                      style: baseTextStyle.s14.w500.copyWith(
                        color: ColorResources.primary,
                      ),
                    ),
                  ),
                ),
              ),
              gap16,
              Expanded(
                child: SizedBox(
                  height: 46,
                  child: ElevatedButton(
                    onPressed: _onApply,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorResources.primary,
                      elevation: 2,
                      shadowColor: ColorResources.primaryShadow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(fieldRadius),
                      ),
                    ),
                    child: Text(
                      StringFile.apply,
                      style: baseTextStyle.s14.w500.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Custom Slider Thumb displaying the distance badge, e.g. "50 Km".
class _DistanceThumbShape extends SliderComponentShape {
  const _DistanceThumbShape({required this.value});

  final int value;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(54, 24);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;
    const width = 52.0;
    const height = 22.0;
    final rect = Rect.fromCenter(center: center, width: width, height: height);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(11));

    // Shadow
    canvas.drawRRect(
      rrect.shift(const Offset(0, 2)),
      Paint()
        ..color = ColorResources.primaryShadow.withValues(alpha: 0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );

    // Pill body
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = ColorResources.primary
        ..style = PaintingStyle.fill,
    );

    // Pill text "$value Km"
    final tp = TextPainter(
      text: TextSpan(
        text: '${this.value} Km',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    tp.paint(
      canvas,
      Offset(
        center.dx - (tp.width / 2),
        center.dy - (tp.height / 2),
      ),
    );
  }
}

/// Track shape with small dots at the start and end of the slider track.
class _TrackWithEndDotsShape extends RoundedRectSliderTrackShape {
  const _TrackWithEndDotsShape();

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 0,
  }) {
    super.paint(
      context,
      offset,
      parentBox: parentBox,
      sliderTheme: sliderTheme,
      enableAnimation: enableAnimation,
      textDirection: textDirection,
      thumbCenter: thumbCenter,
      secondaryOffset: secondaryOffset,
      isDiscrete: isDiscrete,
      isEnabled: isEnabled,
      additionalActiveTrackHeight: additionalActiveTrackHeight,
    );

    final trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final dotPaintActive = Paint()
      ..color = ColorResources.primary
      ..style = PaintingStyle.fill;
    final dotPaintInactive = Paint()
      ..color = ColorResources.primary
      ..style = PaintingStyle.fill;

    // Draw start dot and end dot
    context.canvas.drawCircle(
      Offset(trackRect.left, trackRect.center.dy),
      3.5,
      dotPaintActive,
    );
    context.canvas.drawCircle(
      Offset(trackRect.right, trackRect.center.dy),
      3.5,
      dotPaintInactive,
    );
  }
}
