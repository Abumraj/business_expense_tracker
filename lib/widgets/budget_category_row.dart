import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app/app_theme.dart';

class BudgetCategoryRow extends StatelessWidget {
  const BudgetCategoryRow({
    super.key,
    required this.category,
    required this.amount,
    required this.percentChange,
    required this.isUp,
  });

  final String category;
  final String amount;
  final String percentChange;
  final bool isUp;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 14.h),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(category, style: AppTextStyles.detailValue),
                    SizedBox(height: 6.h),
                    _PercentBadge(
                      percent: percentChange,
                      isUp: isUp,
                    ),
                  ],
                ),
              ),
              Text(amount, style: AppTextStyles.detailValue.copyWith(
                fontWeight: FontWeight.w600,
              )),
            ],
          ),
        ),
        Divider(height: 1, thickness: 1, color: AppColors.divider),
      ],
    );
  }
}

class _PercentBadge extends StatelessWidget {
  const _PercentBadge({required this.percent, required this.isUp});

  final String percent;
  final bool isUp;

  @override
  Widget build(BuildContext context) {
    final bgColor = isUp ? AppColors.successGreenBg : AppColors.dangerRedBg;
    final fgColor = isUp ? AppColors.successGreen : AppColors.dangerRed;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isUp ? Icons.arrow_upward : Icons.arrow_downward,
            size: 12.w,
            color: fgColor,
          ),
          SizedBox(width: 2.w),
          Text(
            percent,
            style: AppTextStyles.badgeText.copyWith(color: fgColor),
          ),
        ],
      ),
    );
  }
}
