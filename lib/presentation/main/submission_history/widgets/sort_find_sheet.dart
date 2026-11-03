import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/scale.dart';
import 'package:solofy_vendor_app/application/core/utils/app_assets.dart';
import 'package:solofy_vendor_app/application/core/utils/string_file.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/submission_status.dart';
import 'package:solofy_vendor_app/presentation/widgets/custom_dropdown_field.dart';
import 'package:solofy_vendor_app/presentation/widgets/outlined_app_button.dart';
import 'package:solofy_vendor_app/presentation/widgets/primary_button.dart';

class SortFindResult {
  const SortFindResult({
    this.date,
    this.status,
  });

  final DateTime? date;
  final SubmissionStatus? status;
}

class SortFindSheet extends StatefulWidget {
  const SortFindSheet({
    super.key,
    this.initialDate,
    this.initialStatus,
  });

  final DateTime? initialDate;
  final SubmissionStatus? initialStatus;

  static const double sheetRadius = 16.0;
  static const double marginH = 16.0;
  static const double marginB = 16.0;
  static const double paddingAll = 16.0;
  static const double fieldHeight = 44.0;
  static const double fieldRadius = 10.0;
  static const double closeButtonSize = 20.0;

  static Future<SortFindResult?> show(
    BuildContext context, {
    DateTime? initialDate,
    SubmissionStatus? initialStatus,
  }) {
    return showModalBottomSheet<SortFindResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (_) => SortFindSheet(
        initialDate: initialDate,
        initialStatus: initialStatus,
      ),
    );
  }

  @override
  State<SortFindSheet> createState() => _SortFindSheetState();
}

class _SortFindSheetState extends State<SortFindSheet> {
  DateTime? _selectedDate;
  SubmissionStatus? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _selectedStatus = widget.initialStatus;
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

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        SortFindSheet.marginH.s,
        0,
        SortFindSheet.marginH.s,
        SortFindSheet.marginB.s + bottomInset,
      ),
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: ColorResources.white,
            borderRadius: BorderRadius.circular(SortFindSheet.sheetRadius.s),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 16.s,
                offset: Offset(0, 6.s),
              ),
            ],
          ),
          padding: EdgeInsets.all(SortFindSheet.paddingAll.s),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row: "Sort & Find Fast" left, blue circle 'x' close button right
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    StringFile.sortAndFindFast,
                    style: GoogleFonts.poppins(
                      fontSize: 13.s,
                      fontWeight: FontWeight.w600,
                      color: ColorResources.textColor,
                      height: 1.2,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: SortFindSheet.closeButtonSize.s,
                      height: SortFindSheet.closeButtonSize.s,
                      decoration: const BoxDecoration(
                        color: ColorResources.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.close,
                          size: 12.s,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.s),

              // Field 1: Read-only Date Picker Field
              GestureDetector(
                onTap: _pickDate,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  height: SortFindSheet.fieldHeight.s,
                  decoration: BoxDecoration(
                    color: ColorResources.textFieldColor,
                    borderRadius: BorderRadius.circular(SortFindSheet.fieldRadius.s),
                    border: Border.all(
                      color: ColorResources.textFieldBorderColor,
                      width: 1.s,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 14.s),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        AppAssets.calendarSvg,
                        width: 16.s,
                        height: 16.s,
                        colorFilter: const ColorFilter.mode(
                          ColorResources.grey,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: 10.s),
                      Expanded(
                        child: Text(
                          _selectedDate != null
                              ? DateFormat('dd MMM yyyy').format(_selectedDate!)
                              : StringFile.selectDate,
                          style: GoogleFonts.poppins(
                            fontSize: 13.s,
                            fontWeight: FontWeight.w400,
                            color: _selectedDate != null
                                ? ColorResources.textColor
                                : ColorResources.grey,
                            height: 1.2,
                          ),
                        ),
                      ),
                      if (_selectedDate != null)
                        GestureDetector(
                          onTap: () => setState(() => _selectedDate = null),
                          behavior: HitTestBehavior.opaque,
                          child: Icon(
                            Icons.close_rounded,
                            size: 16.s,
                            color: ColorResources.grey,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12.s),

              // Field 2: Status Dropdown Field
              CustomDropdownField<SubmissionStatus?>(
                hintText: StringFile.selectStatus,
                value: _selectedStatus,
                items: [
                  const DropdownMenuItem<SubmissionStatus?>(
                    value: null,
                    child: Text('All'),
                  ),
                  ...SubmissionStatus.values.map(
                    (s) => DropdownMenuItem<SubmissionStatus?>(
                      value: s,
                      child: Text(s.label),
                    ),
                  ),
                ],
                onChanged: (val) {
                  setState(() => _selectedStatus = val);
                },
              ),
              SizedBox(height: 20.s),

              // Buttons row: Equal width Cancel + Apply
              Row(
                children: [
                  Expanded(
                    child: OutlinedAppButton(
                      label: 'Cancel',
                      height: 44.s,
                      borderColor: ColorResources.primary,
                      textColor: ColorResources.primary,
                      backgroundColor: ColorResources.white,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  SizedBox(width: 12.s),
                  Expanded(
                    child: SizedBox(
                      height: 44.s,
                      child: PrimaryButton(
                        label: 'Apply',
                        onPressed: () {
                          Navigator.pop(
                            context,
                            SortFindResult(
                              date: _selectedDate,
                              status: _selectedStatus,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
