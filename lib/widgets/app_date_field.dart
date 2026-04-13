import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../app/app_theme.dart';

class AppDateField extends StatelessWidget {
  const AppDateField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.firstDate,
    this.lastDate,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime> onChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null;
    final displayText =
        hasValue ? DateFormat('MMMM dd, yyyy').format(value!) : '';

    return GestureDetector(
      onTap: () => _pickDate(context),
      child: SizedBox(
        height: 64.h,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: hasValue ? label : null,
            hintText: hasValue ? null : label,
            labelStyle: AppTextStyles.label,
            hintStyle: AppTextStyles.label,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            suffixIcon: Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: Icon(
                Icons.calendar_today_outlined,
                color: AppColors.textSecondary,
                size: 20.w,
              ),
            ),
            suffixIconConstraints: BoxConstraints(
              minWidth: 48.w,
              minHeight: 48.h,
            ),
          ),
          child: hasValue
              ? Text(displayText, style: AppTextStyles.input)
              : const SizedBox.shrink(),
        ),
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: value ?? now,
      firstDate: firstDate ?? DateTime(2020),
      lastDate: lastDate ?? DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.primary,
                ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) onChanged(picked);
  }
}
