import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app/app_theme.dart';

class AppStepperField extends StatelessWidget {
  const AppStepperField({
    super.key,
    required this.label,
    required this.value,
    required this.onIncrement,
    required this.onDecrement,
  });

  final String label;
  final int value;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    final hasValue = value > 0;

    return SizedBox(
      height: 64.h,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: hasValue ? label : null,
          hintText: hasValue ? null : label,
          labelStyle: AppTextStyles.label,
          hintStyle: AppTextStyles.label,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          suffixIcon: Padding(
            padding: EdgeInsets.only(right: 4.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                _StepperArrow(
                  icon: Icons.keyboard_arrow_up_rounded,
                  onTap: onIncrement,
                ),
                _StepperArrow(
                  icon: Icons.keyboard_arrow_down_rounded,
                  onTap: onDecrement,
                ),
              ],
            ),
          ),
          suffixIconConstraints: BoxConstraints(
            minWidth: 40.w,
            minHeight: 48.h,
          ),
        ),
        child: hasValue
            ? Text(value.toString(), style: AppTextStyles.input)
            : const SizedBox.shrink(),
      ),
    );
  }
}

class _StepperArrow extends StatelessWidget {
  const _StepperArrow({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4.r),
      child: Icon(icon, size: 22.w, color: AppColors.textSecondary),
    );
  }
}
