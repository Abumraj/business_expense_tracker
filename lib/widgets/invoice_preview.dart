import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../app/app_theme.dart';

/// Data class for a single line item in the invoice preview table.
class InvoiceLineItem {
  const InvoiceLineItem({
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.amount,
  });

  final String description;
  final int quantity;
  final double unitPrice;
  final double amount;
}

/// Full invoice preview widget matching the clean invoice layout.
/// Suitable for use as a full-screen preview or inside a modal.
class InvoicePreview extends StatelessWidget {
  const InvoicePreview({
    super.key,
    required this.businessName,
    this.businessLogoUrl,
    this.businessLogoWidget,
    required this.invoiceNumber,
    required this.dateOfIssue,
    required this.dueDate,
    required this.fromName,
    required this.fromEmail,
    required this.fromPhone,
    required this.toName,
    required this.toEmail,
    required this.toPhone,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.shippingFee,
    required this.totalAmount,
    this.notes,
    this.bankName,
    this.accountNumber,
    this.accountName,
    this.onClose,
  });

  final String businessName;
  final String? businessLogoUrl;
  final Widget? businessLogoWidget;

  final String invoiceNumber;
  final String dateOfIssue;
  final String dueDate;

  final String fromName;
  final String fromEmail;
  final String fromPhone;

  final String toName;
  final String toEmail;
  final String toPhone;

  final List<InvoiceLineItem> items;
  final double subtotal;
  final double tax;
  final double shippingFee;
  final double totalAmount;

  final String? notes;
  final String? bankName;
  final String? accountNumber;
  final String? accountName;

  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat('#,##0', 'en_US');

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 32.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),
                  // Business header
                  _BusinessHeader(
                    businessName: businessName,
                    logoWidget: businessLogoWidget,
                  ),
                  SizedBox(height: 24.h),

                  // "Invoice" title
                  Text(
                    'Invoice',
                    style: AppTextStyles.h1.copyWith(fontSize: 22.sp),
                  ),
                  SizedBox(height: 20.h),

                  // Date of Issue / Due Date
                  InvoiceInfoRow(
                    leftLabel: 'Date of Issue',
                    leftValue: dateOfIssue,
                    rightLabel: 'Due Date',
                    rightValue: dueDate,
                  ),
                  SizedBox(height: 20.h),

                  // Invoice Number
                  InvoiceInfoPair(
                    label: 'Invoice Number',
                    value: invoiceNumber,
                  ),
                  SizedBox(height: 20.h),

                  // From / To
                  InvoiceInfoRow(
                    leftLabel: 'From',
                    leftValue: fromName,
                    rightLabel: 'To',
                    rightValue: toName,
                  ),
                  SizedBox(height: 4.h),
                  _ContactRow(left: fromEmail, right: toEmail),
                  SizedBox(height: 2.h),
                  _ContactRow(left: fromPhone, right: toPhone),
                  SizedBox(height: 28.h),

                  // Items table
                  _ItemsTableHeader(),
                  Divider(color: AppColors.border, height: 1),
                  SizedBox(height: 8.h),
                  ...items.map(
                    (item) => _ItemsTableRow(
                      description: item.description,
                      quantity: item.quantity,
                      unitPrice: '\u20A6${fmt.format(item.unitPrice)}',
                      amount: '\u20A6${fmt.format(item.amount)}',
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Divider(color: AppColors.border, height: 1),
                  SizedBox(height: 12.h),

                  // Totals
                  InvoiceSummaryRow(
                    label: 'Subtotal',
                    value: '\u20A6${fmt.format(subtotal)}',
                  ),
                  SizedBox(height: 6.h),
                  InvoiceSummaryRow(
                    label: 'Tax',
                    value: '\u20A6${fmt.format(tax)}',
                  ),
                  SizedBox(height: 6.h),
                  InvoiceSummaryRow(
                    label: 'Shipping Fee',
                    value: '\u20A6${fmt.format(shippingFee)}',
                  ),
                  SizedBox(height: 8.h),
                  Divider(color: AppColors.border, height: 1),
                  SizedBox(height: 8.h),
                  InvoiceSummaryRow(
                    label: 'Total Amount',
                    value: '\u20A6${fmt.format(totalAmount)}',
                    bold: true,
                  ),
                  SizedBox(height: 28.h),

                  // Notes
                  if (notes != null && notes!.isNotEmpty) ...[
                    Text(
                      'Notes',
                      style: AppTextStyles.detailLabel.copyWith(
                        color: AppColors.primary,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(notes!, style: AppTextStyles.detailValue),
                    SizedBox(height: 24.h),
                  ],

                  // Payment Information
                  if (bankName != null && bankName!.isNotEmpty)
                    InvoicePaymentInfoCard(
                      bankName: bankName!,
                      accountNumber: accountNumber ?? '',
                      accountName: accountName ?? '',
                    ),
                ],
              ),
            ),

            // Close button
            if (onClose != null)
              Positioned(
                top: 8.h,
                right: 8.w,
                child: GestureDetector(
                  onTap: onClose,
                  child: Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      size: 18.w,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Reusable sub-widgets (exported so they can be used standalone)
// ---------------------------------------------------------------------------

class _BusinessHeader extends StatelessWidget {
  const _BusinessHeader({required this.businessName, this.logoWidget});

  final String businessName;
  final Widget? logoWidget;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (logoWidget != null) ...[
          SizedBox(width: 48.w, height: 48.w, child: logoWidget),
          SizedBox(width: 12.w),
        ] else ...[
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F0FF),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.storefront_rounded,
              color: AppColors.primary,
              size: 26.w,
            ),
          ),
          SizedBox(width: 12.w),
        ],
        Expanded(
          child: Text(
            businessName,
            style: AppTextStyles.h1.copyWith(fontSize: 20.sp),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

/// A row with two label-value pairs side by side.
class InvoiceInfoRow extends StatelessWidget {
  const InvoiceInfoRow({
    super.key,
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
          child: InvoiceInfoPair(label: leftLabel, value: leftValue),
        ),
        Expanded(
          child: InvoiceInfoPair(label: rightLabel, value: rightValue),
        ),
      ],
    );
  }
}

/// A single label-value pair.
class InvoiceInfoPair extends StatelessWidget {
  const InvoiceInfoPair({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.detailLabel.copyWith(
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 4.h),
        Text(value, style: AppTextStyles.detailValue),
      ],
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({required this.left, required this.right});

  final String left;
  final String right;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            left,
            style: AppTextStyles.body.copyWith(fontSize: 13.sp),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Expanded(
          child: Text(
            right,
            style: AppTextStyles.body.copyWith(fontSize: 13.sp),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _ItemsTableHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final style = AppTextStyles.detailLabel.copyWith(
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
      fontSize: 13.sp,
    );

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text('Item', style: style)),
          Expanded(flex: 2, child: Text('Quantity', style: style)),
          Expanded(flex: 2, child: Text('Unit Price', style: style)),
          Expanded(
            flex: 2,
            child: Text('Amount', style: style, textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }
}

class _ItemsTableRow extends StatelessWidget {
  const _ItemsTableRow({
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.amount,
  });

  final String description;
  final int quantity;
  final String unitPrice;
  final String amount;

  @override
  Widget build(BuildContext context) {
    final style = AppTextStyles.body.copyWith(fontSize: 13.sp);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              description,
              style: style,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(quantity.toString(), style: style, textAlign: TextAlign.center),
          ),
          Expanded(flex: 2, child: Text(unitPrice, style: style)),
          Expanded(
            flex: 2,
            child: Text(amount, style: style, textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }
}

/// A row in the financial summary (Subtotal, Tax, Shipping, Total).
class InvoiceSummaryRow extends StatelessWidget {
  const InvoiceSummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.bold = false,
  });

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: bold
              ? AppTextStyles.detailValue.copyWith(fontWeight: FontWeight.w600)
              : AppTextStyles.body,
        ),
        Text(
          value,
          style: bold
              ? AppTextStyles.detailValue.copyWith(fontWeight: FontWeight.w700)
              : AppTextStyles.body.copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

/// The "Payment Information" card at the bottom of the invoice preview.
class InvoicePaymentInfoCard extends StatelessWidget {
  const InvoicePaymentInfoCard({
    super.key,
    required this.bankName,
    required this.accountNumber,
    required this.accountName,
  });

  final String bankName;
  final String accountNumber;
  final String accountName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: AppRadii.r12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Information',
            style: AppTextStyles.detailLabel.copyWith(
              color: AppColors.textSecondary,
              fontSize: 13.sp,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            bankName,
            style: AppTextStyles.detailValue.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4.h),
          Text(accountNumber, style: AppTextStyles.detailValue),
          SizedBox(height: 4.h),
          Text(
            accountName,
            style: AppTextStyles.body.copyWith(
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
