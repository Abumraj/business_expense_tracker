import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app/app_theme.dart';

class AppTextArea extends StatelessWidget {
  const AppTextArea({
    super.key,
    required this.label,
    required this.controller,
    this.minLines = 4,
    this.maxLines = 6,
    this.textInputAction,
  });

  final String label;
  final TextEditingController controller;
  final int minLines;
  final int maxLines;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      minLines: minLines,
      maxLines: maxLines,
      textInputAction: textInputAction,
      style: AppTextStyles.input,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.label,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        alignLabelWithHint: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      ),
    );
  }
}
