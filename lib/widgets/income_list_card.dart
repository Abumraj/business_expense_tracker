import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app/app_theme.dart';
import 'status_badge.dart';

class IncomeListCard extends StatelessWidget {
  const IncomeListCard({
    super.key,
    required this.createdOn,
    required this.customer,
    required this.paymentMethod,
    required this.quantity,
    required this.status,
    required this.amount,
    this.onTap,
    this.onEdit,
  });

  final String createdOn;
  final String customer;
  final String paymentMethod;
  final int quantity;
  final String status;
  final String amount;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                  child: _GridRow(
                    leftLabel: 'Created On',
                    leftValue: createdOn,
                    rightLabel: 'Customer',
                    rightValue: customer,
                  ),
                ),
                if (onEdit != null) ...[
                  SizedBox(width: 8.w),
                  GestureDetector(
                    onTap: onEdit,
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: AppColors.iconRose.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        Icons.edit,
                        size: 16.w,
                        color: AppColors.iconRose,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            SizedBox(height: 12.h),
            _GridRow(
              leftLabel: 'Payment Method',
              leftValue: paymentMethod,
              rightLabel: 'Quantity',
              rightValue: quantity.toString(),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Status', style: AppTextStyles.detailLabel),
                      SizedBox(height: 4.h),
                      StatusBadge(status: status),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Amount', style: AppTextStyles.detailLabel),
                      SizedBox(height: 4.h),
                      Text(
                        amount,
                        style: AppTextStyles.detailValue.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GridRow extends StatelessWidget {
  const _GridRow({
    required this.leftLabel,
    required this.leftValue,
    required this.rightLabel,
    required this.rightValue,
  });

  final String leftLabel;
  final String leftValue;
  final String rightLabel;
  final String rightValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(leftLabel, style: AppTextStyles.detailLabel),
              SizedBox(height: 4.h),
              Text(leftValue, style: AppTextStyles.detailValue),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(rightLabel, style: AppTextStyles.detailLabel),
              SizedBox(height: 4.h),
              Text(rightValue, style: AppTextStyles.detailValue),
            ],
          ),
        ),
      ],
    );
  }
}
