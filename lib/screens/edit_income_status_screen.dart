import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

import '../app/app_theme.dart';
import '../features/income/add_income_controller.dart';
import '../services/service_providers.dart';
import '../utils/error_handler.dart';
import '../utils/income_pdf_generator.dart';
import '../utils/toast_helper.dart';
import '../widgets/invoice_items_section.dart';

class EditIncomeStatusScreen extends ConsumerStatefulWidget {
  const EditIncomeStatusScreen({super.key, required this.income});

  final Map<String, dynamic> income;

  @override
  ConsumerState<EditIncomeStatusScreen> createState() =>
      _EditIncomeStatusScreenState();
}

class _EditIncomeStatusScreenState
    extends ConsumerState<EditIncomeStatusScreen> {
  static const _statusItems = ['Pending', 'Paid'];

  late String _selectedStatus;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final raw = widget.income['status']?.toString() ?? 'PENDING';
    _selectedStatus = raw.toLowerCase() == 'paid' ? 'Paid' : 'Pending';
  }

  String _formatDate(dynamic iso) {
    final s = iso?.toString();
    if (s == null || s.isEmpty) return '';
    final dt = DateTime.tryParse(s);
    if (dt == null) return '';
    return DateFormat('MMM dd, yyyy').format(dt);
  }

  String _formatNaira(num? v) {
    final fmt = NumberFormat('#,##0', 'en_US');
    final n = (v ?? 0).toDouble();
    return '₦${fmt.format(n)}';
  }

  double _parseDouble(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0;
  }

  String _toApiDate(dynamic iso) {
    final s = iso?.toString();
    if (s == null || s.isEmpty) return '';
    final dt = DateTime.tryParse(s);
    if (dt == null) return '';
    return '${dt.year.toString().padLeft(4, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }

  Future<void> _saveStatus(String newStatus) async {
    final id = widget.income['id']?.toString();
    if (id == null || id.isEmpty) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final invoiceDate = _toApiDate(widget.income['invoiceDate']);
      final dueDate = _toApiDate(widget.income['dueDate']);
      final customerId = widget.income['customerId']?.toString() ?? '';
      final rawItems = (widget.income['items'] as List?) ?? const [];
      final items = <Map<String, dynamic>>[];
      for (final raw in rawItems) {
        if (raw is! Map) continue;
        final desc = raw['description']?.toString() ?? '';
        final qty = int.tryParse(raw['quantity']?.toString() ?? '') ?? 0;
        final unitPrice = _parseDouble(raw['unitPrice']);
        if (desc.isEmpty || qty <= 0) continue;
        items.add({
          'description': desc,
          'quantity': qty,
          'unitPrice': unitPrice,
        });
      }

      if (invoiceDate.isEmpty ||
          dueDate.isEmpty ||
          customerId.isEmpty ||
          items.isEmpty) {
        AppToast.error('Missing required income data');
        return;
      }

      await ErrorHandler.withAuthHandling(ref, context, () async {
        await ref
            .read(incomeApiProvider)
            .updateIncome(
              id,
              invoiceDate: invoiceDate,
              dueDate: dueDate,
              customerId: customerId,
              items: items,
              taxRate: _parseDouble(widget.income['taxRate']),
              discount: _parseDouble(widget.income['discount']),
              shippingFee: _parseDouble(widget.income['shippingFee']),
              notes: widget.income['notes']?.toString() ?? '',
              bankName: widget.income['bankName']?.toString() ?? '',
              accountNumber: widget.income['accountNumber']?.toString() ?? '',
              accountName: widget.income['accountName']?.toString() ?? '',
              status: newStatus.toUpperCase(),
            );
        return null;
      }, successMessage: 'Status updated');

      if (!mounted) return;
      setState(() {
        _selectedStatus = newStatus;
      });
    } catch (e) {
      // handled by ErrorHandler
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _downloadPdf() async {
    try {
      final bytes = await IncomePdfGenerator.generate(income: widget.income);
      final invoiceNumber =
          widget.income['invoiceNumber']?.toString().trim().isNotEmpty == true
              ? widget.income['invoiceNumber']!.toString().trim()
              : 'invoice';
      await Printing.sharePdf(bytes: bytes, filename: '$invoiceNumber.pdf');
    } catch (e) {
      AppToast.error('Failed to generate PDF');
    }
  }

  @override
  Widget build(BuildContext context) {
    final income = widget.income;
    final invoiceNumber = income['invoiceNumber']?.toString() ?? '#001';
    final fromValue =
        (income['from']?.toString().trim().isNotEmpty == true)
            ? income['from']!.toString().trim()
            : (income['businessName']?.toString().trim().isNotEmpty == true)
            ? income['businessName']!.toString().trim()
            : (income['companyName']?.toString().trim().isNotEmpty == true)
            ? income['companyName']!.toString().trim()
            : 'T&G Parties';
    final customerName =
        (income['customer'] is Map)
            ? '${(income['customer'] as Map)['firstName'] ?? ''} ${(income['customer'] as Map)['lastName'] ?? ''}'
                .trim()
            : (income['customerName']?.toString() ??
                income['customerId']?.toString() ??
                '');

    final fmt = NumberFormat('#,##0', 'en_US');

    final itemsRaw = (income['items'] as List?) ?? const [];
    final List<InvoiceItem> items =
        itemsRaw.whereType<Map>().map((e) {
          final qty = int.tryParse(e['quantity']?.toString() ?? '') ?? 0;
          final unitPrice = _parseDouble(e['unitPrice']);
          final amount =
              e['amount'] != null
                  ? _parseDouble(e['amount'])
                  : (unitPrice * qty);
          return InvoiceItem(
            description: e['description']?.toString() ?? '',
            quantity: qty,
            unitPrice: unitPrice,
            amount: amount,
          );
        }).toList();

    final subtotal = _parseDouble(income['subtotal']);
    final taxRate = _parseDouble(income['taxRate']);
    final taxAmount = _parseDouble(income['taxAmount']);
    final shippingFee = _parseDouble(income['shippingFee']);
    final total = _parseDouble(income['total']);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
        title: Text('Income Details', style: AppTextStyles.appBarTitle),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 44.h,
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(10.r),
                        color: Colors.white,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedStatus,
                          isExpanded: true,
                          icon: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 22.w,
                            color: AppColors.textSecondary,
                          ),
                          style: AppTextStyles.input,
                          items:
                              _statusItems
                                  .map(
                                    (s) => DropdownMenuItem<String>(
                                      value: s,
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 6.w,
                                            height: 6.w,
                                            decoration: BoxDecoration(
                                              color:
                                                  s == 'Paid'
                                                      ? AppColors.successGreen
                                                      : AppColors.statusPending,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          SizedBox(width: 8.w),
                                          Text(
                                            s,
                                            style: AppTextStyles.body.copyWith(
                                              color: AppColors.textSecondary,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                          onChanged:
                              _isSaving
                                  ? null
                                  : (v) {
                                    if (v == null) return;
                                    _saveStatus(v);
                                  },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  SizedBox(
                    height: 44.h,
                    child: OutlinedButton(
                      onPressed: _downloadPdf,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                      ),
                      child: Text(
                        'Download PDF',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 64.w,
                    height: 64.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14.r),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4B5563), Color(0xFF111827)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.local_fire_department_rounded,
                        size: 30.w,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: Text(
                        'Invoice $invoiceNumber',
                        style: AppTextStyles.h1.copyWith(fontSize: 18.sp),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18.h),
              _InfoGrid(
                leftLabel: 'Invoice Number',
                leftValue: invoiceNumber,
                rightLabel: 'Date of Issue',
                rightValue: _formatDate(income['invoiceDate']),
              ),
              SizedBox(height: 14.h),
              _InfoGrid(
                leftLabel: 'Due Date',
                leftValue: _formatDate(income['dueDate']),
                rightLabel: 'Customer',
                rightValue: customerName,
              ),
              SizedBox(height: 14.h),
              _InfoSingle(label: 'From', value: fromValue),
              SizedBox(height: 18.h),
              Container(
                color: AppColors.backgroundColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InvoiceItemsSection(
                      items: items,
                      totalAmount: items.fold(0.0, (s, i) => s + i.amount),
                      currencyFormat: fmt,
                      showActions: false,
                      backgroundColor: AppColors.backgroundColor,
                    ),
                    SizedBox(height: 16.h),
                    Text('Notes', style: AppTextStyles.label),
                    SizedBox(height: 6.h),
                    Text(
                      income['notes']?.toString().isNotEmpty == true
                          ? income['notes']?.toString() ?? ''
                          : 'Payment Should be made on time',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Divider(color: AppColors.borderStrong),
                    SizedBox(height: 10.h),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: _SummaryRow(
                        label: 'Subtotal',
                        value: '${_formatNaira(subtotal)} NGN',
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: _SummaryRow(
                        label: '(Tax Rate)',
                        value: '${taxRate.toStringAsFixed(0)}%',
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: _SummaryRow(
                        label: 'Vat',
                        value: '${_formatNaira(taxAmount)} NGN',
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: _SummaryRow(
                        label: 'Shipping Fee',
                        value: '${_formatNaira(shippingFee)} NGN',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 14.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Income Total',
                    style: AppTextStyles.sectionTitle.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                    ),
                  ),
                  Text(
                    _formatNaira(total),
                    style: AppTextStyles.sectionTitle.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 18.h),
              Text('Bank Account Details', style: AppTextStyles.label),
              SizedBox(height: 10.h),
              Text(
                income['bankName']?.toString().isNotEmpty == true
                    ? income['bankName']?.toString() ?? ''
                    : 'Palmpay',
                style: AppTextStyles.detailValue.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                income['accountNumber']?.toString().isNotEmpty == true
                    ? income['accountNumber']?.toString() ?? ''
                    : '9122112260',
                style: AppTextStyles.detailValue,
              ),
              SizedBox(height: 8.h),
              Text(
                income['accountName']?.toString().isNotEmpty == true
                    ? income['accountName']?.toString() ?? ''
                    : 'Temilade Adekeye',
                style: AppTextStyles.detailValue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoGrid extends StatelessWidget {
  const _InfoGrid({
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
        Expanded(child: _InfoSingle(label: leftLabel, value: leftValue)),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: _InfoSingle(label: rightLabel, value: rightValue),
          ),
        ),
      ],
    );
  }
}

class _InfoSingle extends StatelessWidget {
  const _InfoSingle({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label),
        SizedBox(height: 4.h),
        Text(
          value,
          style: AppTextStyles.detailValue.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
        ),
        Text(
          value,
          style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
        ),
      ],
    );
  }
}
