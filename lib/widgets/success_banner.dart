import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app/app_theme.dart';

class SuccessBanner extends StatelessWidget {
  const SuccessBanner({
    super.key,
    required this.message,
    required this.onClose,
  });

  final String message;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.successBackground,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.input.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.successText,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          InkWell(
            onTap: onClose,
            child: Icon(Icons.close, size: 20.w, color: AppColors.successText),
          ),
        ],
      ),
    );
  }
}
