import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app/app_theme.dart';

class DetailRow extends StatelessWidget {
  const DetailRow({
    super.key,
    required this.label,
    required this.value,
    this.showDivider = true,
  });

  final String label;
  final String value;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.h),
        Text(label, style: AppTextStyles.detailLabel),
        SizedBox(height: 6.h),
        Text(value, style: AppTextStyles.detailValue),
        SizedBox(height: 16.h),
        if (showDivider)
          Divider(height: 1, thickness: 1, color: AppColors.divider),
      ],
    );
  }
}
