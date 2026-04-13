import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app/app_theme.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.status,
  });

  final String status;

  bool get _isPaid => status.toLowerCase() == 'paid';

  @override
  Widget build(BuildContext context) {
    final dotColor = _isPaid ? AppColors.successGreen : AppColors.statusPending;
    final textColor = _isPaid ? AppColors.successGreen : AppColors.statusPending;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(
            color: dotColor,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 6.w),
        Text(
          status,
          style: AppTextStyles.body.copyWith(
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
