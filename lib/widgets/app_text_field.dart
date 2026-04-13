import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app/app_theme.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.readOnly = false,
    this.suffix,
    this.textInputAction,
    this.onSubmitted,
    this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool readOnly;
  final Widget? suffix;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64.h,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        readOnly: readOnly,
        textInputAction: textInputAction,
        onSubmitted: onSubmitted,
        onChanged: onChanged,
        style: AppTextStyles.input,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppTextStyles.label,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          suffixIcon:
              suffix == null
                  ? null
                  : Padding(
                    padding: EdgeInsets.only(top: 15.h, right: 8.w),
                    child: suffix,
                  ),
          suffixIconConstraints: BoxConstraints(
            minWidth: 48.w,
            minHeight: 48.h,
          ),
        ),
      ),
    );
  }
}
