import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app/app_theme.dart';

class DashboardBudgetRow extends StatelessWidget {
  const DashboardBudgetRow({
    super.key,
    required this.month,
    required this.income,
    required this.pnl,
    required this.expense,
  });

  final String month;
  final String income;
  final String pnl;
  final String expense;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadii.r12,
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _LabelValue(
                  label: 'Month',
                  value: month,
                ),
              ),
              Expanded(
                child: _LabelValue(
                  label: 'Income ↓',
                  value: income,
                  labelColor: AppColors.dangerRed,
                  crossAxisAlignment: CrossAxisAlignment.end,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _LabelValue(
                  label: 'PNL',
                  value: pnl,
                ),
              ),
              Expanded(
                child: _LabelValue(
                  label: 'Expense ↑',
                  value: expense,
                  labelColor: AppColors.successGreen,
                  crossAxisAlignment: CrossAxisAlignment.end,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LabelValue extends StatelessWidget {
  const _LabelValue({
    required this.label,
    required this.value,
    this.labelColor,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  final String label;
  final String value;
  final Color? labelColor;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(
          label,
          style: AppTextStyles.detailLabel.copyWith(
            color: labelColor ?? AppColors.textMuted,
          ),
        ),
        SizedBox(height: 4.h),
        Text(value, style: AppTextStyles.detailValue),
      ],
    );
  }
}
