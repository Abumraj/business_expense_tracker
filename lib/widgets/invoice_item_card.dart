import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app/app_theme.dart';

class InvoiceItemCard extends StatelessWidget {
  const InvoiceItemCard({
    super.key,
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.amount,
    this.onEdit,
    this.onDelete,
    this.showActions = true,
  });

  final String description;
  final int quantity;
  final String unitPrice;
  final String amount;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showActions;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadii.r8,
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: showActions ? 2.h : 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _LabelValue(
                        label: 'Description',
                        value: description,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    _LabelValue(label: 'Quantity', value: quantity.toString()),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Expanded(
                      child: _LabelValue(label: 'Unit Price', value: unitPrice),
                    ),
                    SizedBox(width: 16.w),
                    _LabelValue(label: 'Amount', value: amount),
                  ],
                ),
              ],
            ),
          ),
          if (showActions)
            Positioned(
              top: 0,
              right: 0,
              child: Row(
                children: [
                  _ActionCircle(
                    icon: Icons.edit,
                    color: AppColors.primary,
                    onTap: onEdit,
                  ),
                  SizedBox(width: 6.w),
                  _ActionCircle(
                    icon: Icons.close,
                    color: AppColors.dangerRedBg,
                    iconColor: AppColors.dangerRed,
                    onTap: onDelete,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _LabelValue extends StatelessWidget {
  const _LabelValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.detailLabel),
        SizedBox(height: 2.h),
        Text(value, style: AppTextStyles.detailValue.copyWith(fontSize: 14.sp)),
      ],
    );
  }
}

class _ActionCircle extends StatelessWidget {
  const _ActionCircle({
    required this.icon,
    required this.color,
    this.iconColor = Colors.white,
    this.onTap,
  });

  final IconData icon;
  final Color color;
  final Color iconColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 22.w,
        height: 22.w,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Icon(icon, size: 13.w, color: iconColor),
      ),
    );
  }
}
