import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app/app_theme.dart';
import 'status_badge.dart';

class FraudAlertCard extends StatelessWidget {
  const FraudAlertCard._({super.key, required List<_FraudRow> rows, this.onTap})
    : _rows = rows;

  final List<_FraudRow> _rows;
  final VoidCallback? onTap;

  factory FraudAlertCard.expense({
    Key? key,
    required String flagType,
    required String category,
    required String unitAmount,
    required int quantity,
    required String paymentMethod,
    required String totalCost,
    VoidCallback? onTap,
  }) => FraudAlertCard._(
    key: key,
    onTap: onTap,
    rows: [
      _FraudRow(
        leftLabel: '🚩 Flag Type',
        leftValue: flagType,
        rightLabel: 'Category',
        rightValue: category,
      ),
      _FraudRow(
        leftLabel: 'Unit Amount',
        leftValue: unitAmount,
        rightLabel: 'Quantity',
        rightValue: quantity.toString(),
      ),
      _FraudRow(
        leftLabel: 'Payment Method',
        leftValue: paymentMethod,
        rightLabel: 'Total Cost',
        rightValue: totalCost,
      ),
    ],
  );

  factory FraudAlertCard.income({
    Key? key,
    required String flagType,
    required String client,
    required String paymentMethod,
    required int quantity,
    required String status,
    required String amount,
    VoidCallback? onTap,
  }) => FraudAlertCard._(
    key: key,
    onTap: onTap,
    rows: [
      _FraudRow(
        leftLabel: '🚩 Flag Type',
        leftValue: flagType,
        rightLabel: 'Client',
        rightValue: client,
      ),
      _FraudRow(
        leftLabel: 'Payment Method',
        leftValue: paymentMethod,
        rightLabel: 'Quantity',
        rightValue: quantity.toString(),
      ),
      _FraudRow(
        leftLabel: 'Status',
        leftValue: status,
        rightLabel: 'Amount',
        rightValue: amount,
        leftIsStatus: true,
      ),
    ],
  );

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
            for (int i = 0; i < _rows.length; i++) ...[
              if (i > 0) SizedBox(height: 12.h),
              _buildRow(_rows[i]),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRow(_FraudRow row) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(row.leftLabel, style: AppTextStyles.detailLabel),
              SizedBox(height: 4.h),
              row.leftIsStatus
                  ? StatusBadge(status: row.leftValue)
                  : Text(row.leftValue, style: AppTextStyles.detailValue),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(row.rightLabel, style: AppTextStyles.detailLabel),
              SizedBox(height: 4.h),
              Text(
                row.rightValue,
                style: AppTextStyles.detailValue.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FraudRow {
  const _FraudRow({
    required this.leftLabel,
    required this.leftValue,
    required this.rightLabel,
    required this.rightValue,
    this.leftIsStatus = false,
  });

  final String leftLabel;
  final String leftValue;
  final String rightLabel;
  final String rightValue;
  final bool leftIsStatus;
}
