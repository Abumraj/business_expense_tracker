import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../app/app_theme.dart';
import '../features/income/add_income_controller.dart';
import 'invoice_item_card.dart';

class InvoiceItemsSection extends StatelessWidget {
  const InvoiceItemsSection({
    super.key,
    required this.items,
    required this.totalAmount,
    required this.currencyFormat,
    this.onAddItem,
    this.onEditItem,
    this.onDeleteItem,
    this.showActions = true,
    this.backgroundColor,
  });

  final List<InvoiceItem> items;
  final double totalAmount;
  final NumberFormat currencyFormat;

  final VoidCallback? onAddItem;
  final void Function(int index, InvoiceItem item)? onEditItem;
  final void Function(int index)? onDeleteItem;

  final bool showActions;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color(0xFFF3F4F6),
        borderRadius: AppRadii.r12,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;

            return Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: InvoiceItemCard(
                description: item.description,
                quantity: item.quantity,
                unitPrice: '\u20A6${currencyFormat.format(item.unitPrice)}',
                amount: '\u20A6${currencyFormat.format(item.amount)}',
                showActions: showActions,
                onEdit:
                    showActions && onEditItem != null
                        ? () => onEditItem!(index, item)
                        : null,
                onDelete:
                    showActions && onDeleteItem != null
                        ? () => onDeleteItem!(index)
                        : null,
              ),
            );
          }),
          SizedBox(height: 8.h),
          if (showActions) ...[
            GestureDetector(
              onTap: onAddItem,
              child: Column(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: const BoxDecoration(
                      color: AppColors.addItemPink,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.add, color: Colors.white, size: 22.w),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'Add item',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Amount:', style: AppTextStyles.body),
              Text(
                '\u20A6${currencyFormat.format(totalAmount)}',
                style: AppTextStyles.detailValue.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
