import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app/app_theme.dart';

class AppSearchField extends StatelessWidget {
  const AppSearchField({
    super.key,
    required this.controller,
    this.hintText = 'Search',
    this.onChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: AppTextStyles.input,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTextStyles.label,
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 16.w, right: 8.w),
            child: Icon(
              Icons.search,
              color: AppColors.textMuted,
              size: 22.w,
            ),
          ),
          prefixIconConstraints: BoxConstraints(
            minWidth: 48.w,
            minHeight: 48.h,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        ),
      ),
    );
  }
}
