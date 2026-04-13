import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app/app_theme.dart';

class AppDropdownField<T> extends StatelessWidget {
  const AppDropdownField({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
    this.value,
    this.itemLabelBuilder,
  });

  final String label;
  final T? value;
  final List<T> items;
  final ValueChanged<T?> onChanged;
  final String Function(T)? itemLabelBuilder;

  String _labelFor(T item) =>
      itemLabelBuilder != null ? itemLabelBuilder!(item) : item.toString();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64.h,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: value != null ? label : null,
          hintText: value == null ? label : null,
          labelStyle: AppTextStyles.label,
          hintStyle: AppTextStyles.label,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          suffixIcon: Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.textSecondary,
              size: 24.w,
            ),
          ),
          suffixIconConstraints: BoxConstraints(
            minWidth: 48.w,
            minHeight: 48.h,
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            value: value,
            isDense: true,
            isExpanded: true,
            icon: const SizedBox.shrink(),
            style: AppTextStyles.input,
            items: items
                .map(
                  (item) => DropdownMenuItem<T>(
                    value: item,
                    child: Text(_labelFor(item), style: AppTextStyles.input),
                  ),
                )
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
