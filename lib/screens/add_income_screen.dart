import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../app/app_theme.dart';
import '../features/income/add_income_controller.dart';
import '../utils/toast_helper.dart';
import '../widgets/app_button.dart';
import '../widgets/app_date_field.dart';
import '../widgets/app_dropdown_field.dart';
import '../widgets/app_text_area.dart';
import '../widgets/app_text_field.dart';
import '../widgets/invoice_items_section.dart';

class AddIncomeScreen extends ConsumerStatefulWidget {
  const AddIncomeScreen({super.key, this.isEdit = false, this.income});

  final bool isEdit;
  final Map<String, dynamic>? income;

  @override
  ConsumerState<AddIncomeScreen> createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends ConsumerState<AddIncomeScreen> {
  late final TextEditingController _invoiceNumberController;
  late final TextEditingController _notesController;
  late final TextEditingController _bankNameController;
  late final TextEditingController _accountNumberController;
  late final TextEditingController _accountNameController;
  late final TextEditingController _taxController;
  late final TextEditingController _discountController;
  late final TextEditingController _shippingFeeController;

  @override
  void initState() {
    super.initState();

    // Select appropriate provider based on edit mode
    final provider =
        widget.isEdit && widget.income != null
            ? editIncomeControllerProvider(widget.income!['id'])
            : addIncomeControllerProvider;

    final s = ref.read(provider);
    _invoiceNumberController = TextEditingController(text: s.invoiceNumber);
    _notesController = TextEditingController(text: s.notes);
    _bankNameController = TextEditingController(text: s.bankName);
    _accountNumberController = TextEditingController(text: s.accountNumber);
    _accountNameController = TextEditingController(text: s.accountName);
    _taxController = TextEditingController(text: s.tax);
    _discountController = TextEditingController(text: s.discount);
    _shippingFeeController = TextEditingController(text: s.shippingFee);

    final ctrl = ref.read(provider.notifier);
    _invoiceNumberController.addListener(
      () => ctrl.setInvoiceNumber(_invoiceNumberController.text),
    );
    _notesController.addListener(() => ctrl.setNotes(_notesController.text));
    _bankNameController.addListener(
      () => ctrl.setBankName(_bankNameController.text),
    );
    _accountNumberController.addListener(
      () => ctrl.setAccountNumber(_accountNumberController.text),
    );
    _accountNameController.addListener(
      () => ctrl.setAccountName(_accountNameController.text),
    );
    _taxController.addListener(() => ctrl.setTax(_taxController.text));
    _discountController.addListener(
      () => ctrl.setDiscount(_discountController.text),
    );
    _shippingFeeController.addListener(
      () => ctrl.setShippingFee(_shippingFeeController.text),
    );

    // Load customers
    ctrl.loadCustomers();

    // Populate fields with existing data if in edit mode
    if (widget.isEdit && widget.income != null) {
      _populateEditFields();
    }
  }

  void _populateEditFields() {
    if (widget.income == null) return;

    final income = widget.income!;
    final ctrl = ref.read(
      widget.isEdit
          ? editIncomeControllerProvider(income['id']).notifier
          : addIncomeControllerProvider.notifier,
    );

    // Set basic fields
    _invoiceNumberController.text = income['invoiceNumber'] ?? '';
    _notesController.text = income['notes'] ?? '';
    _bankNameController.text = income['bankName'] ?? '';
    _accountNumberController.text = income['accountNumber'] ?? '';
    _accountNameController.text = income['accountName'] ?? '';
    _taxController.text = income['taxRate']?.toString() ?? '0';
    _discountController.text = income['discount']?.toString() ?? '0';
    _shippingFeeController.text = income['shippingFee']?.toString() ?? '0';

    // Set dates
    if (income['invoiceDate'] != null) {
      final invoiceDate = DateTime.tryParse(income['invoiceDate']);
      if (invoiceDate != null) ctrl.setInvoiceDate(invoiceDate);
    }
    if (income['dueDate'] != null) {
      final dueDate = DateTime.tryParse(income['dueDate']);
      if (dueDate != null) ctrl.setDueDate(dueDate);
    }

    // Set customer
    final customerId = income['customerId']?.toString();
    if (customerId != null) {
      String? name;
      final customerObj = income['customer'];
      if (customerObj is Map) {
        name =
            '${customerObj['firstName'] ?? ''} ${customerObj['lastName'] ?? ''}'
                .trim();
      }

      ctrl.setCustomer(
        customerId,
        customerName: name != null && name.isNotEmpty ? name : null,
      );
    }

    // Set items if they exist
    if (income['items'] is List) {
      final items =
          (income['items'] as List).map((item) {
            return InvoiceItem(
              description: item['description'] ?? '',
              quantity: item['quantity'] ?? 0,
              unitPrice: (item['unitPrice'] as num?)?.toDouble() ?? 0.0,
              amount: (item['amount'] as num?)?.toDouble() ?? 0.0,
            );
          }).toList();

      // Clear existing items and add new ones
      for (final item in items) {
        ctrl.addItem(item);
      }
    }
  }

  @override
  void dispose() {
    _invoiceNumberController.dispose();
    _notesController.dispose();
    _bankNameController.dispose();
    _accountNumberController.dispose();
    _accountNameController.dispose();
    _taxController.dispose();
    _discountController.dispose();
    _shippingFeeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Select appropriate provider based on edit mode
    final provider =
        widget.isEdit && widget.income != null
            ? editIncomeControllerProvider(widget.income!['id'])
            : addIncomeControllerProvider;

    final state = ref.watch(provider);
    final ctrl = ref.read(provider.notifier);
    final currencyFormat = NumberFormat('#,##0', 'en_US');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEdit ? 'Edit Income' : 'Add Income',
          style: AppTextStyles.appBarTitle,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FadeInUp(
                      duration: const Duration(milliseconds: 200),
                      child: AppTextField(
                        label: 'Invoice number',
                        controller: _invoiceNumberController,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    FadeInUp(
                      duration: const Duration(milliseconds: 200),
                      delay: const Duration(milliseconds: 40),
                      child: AppDateField(
                        label: 'Invoice date',
                        value: state.invoiceDate,
                        onChanged: ctrl.setInvoiceDate,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    FadeInUp(
                      duration: const Duration(milliseconds: 200),
                      delay: const Duration(milliseconds: 80),
                      child: AppDropdownField<String>(
                        label: 'Select customer',
                        value: state.customerName,
                        items:
                            state.customers
                                .map((customer) => customer.name)
                                .toList(),
                        onChanged: (customerName) {
                          // Find the customer by name and set their ID and name
                          Customer? selectedCustomer;
                          for (final c in state.customers) {
                            if (c.name == customerName) {
                              selectedCustomer = c;
                              break;
                            }
                          }
                          if (selectedCustomer != null) {
                            ctrl.setCustomer(
                              selectedCustomer.id,
                              customerName: selectedCustomer.name,
                            );
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 16.h),
                    FadeInUp(
                      duration: const Duration(milliseconds: 200),
                      delay: const Duration(milliseconds: 120),
                      child: AppDateField(
                        label: 'Due date',
                        value: state.dueDate,
                        onChanged: ctrl.setDueDate,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    FadeInUp(
                      duration: const Duration(milliseconds: 200),
                      delay: const Duration(milliseconds: 140),
                      child: InvoiceItemsSection(
                        items: state.items,
                        totalAmount: state.totalAmount,
                        currencyFormat: currencyFormat,
                        onAddItem: () => _showAddItemSheet(),
                        onEditItem:
                            (index, item) => _showAddItemSheet(
                              existingIndex: index,
                              existing: item,
                            ),
                        onDeleteItem: (index) => ctrl.removeItem(index),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    FadeInUp(
                      duration: const Duration(milliseconds: 200),
                      delay: const Duration(milliseconds: 160),
                      child: AppTextArea(
                        label: 'Notes / payment terms',
                        controller: _notesController,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    FadeInUp(
                      duration: const Duration(milliseconds: 200),
                      delay: const Duration(milliseconds: 200),
                      child: AppTextField(
                        label: 'Bank Name',
                        controller: _bankNameController,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    FadeInUp(
                      duration: const Duration(milliseconds: 200),
                      delay: const Duration(milliseconds: 210),
                      child: AppTextField(
                        label: 'Account Number',
                        controller: _accountNumberController,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    FadeInUp(
                      duration: const Duration(milliseconds: 200),
                      delay: const Duration(milliseconds: 220),
                      child: AppTextField(
                        label: 'Account Name',
                        controller: _accountNameController,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    _buildSubtotalSection(state, currencyFormat),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
              child: AppButton(
                label: 'Add Income',
                enabled: state.canSubmit,
                isLoading: state.status == AddIncomeStatus.loading,
                onPressed: _handleSubmit,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubtotalSection(AddIncomeState state, NumberFormat fmt) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Subtotal', style: AppTextStyles.sectionTitle),
        SizedBox(height: 16.h),
        AppTextField(
          label: 'Tax',
          controller: _taxController,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,

          suffix: Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Text('%', style: AppTextStyles.label),
          ),
        ),
        SizedBox(height: 12.h),
        AppTextField(
          label: 'Discount',
          controller: _discountController,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          suffix: Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Text('₦', style: AppTextStyles.label),
          ),
        ),
        SizedBox(height: 12.h),
        AppTextField(
          label: 'Shipping fee',
          controller: _shippingFeeController,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          suffix: Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Text('₦', style: AppTextStyles.label),
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total', style: AppTextStyles.h1.copyWith(fontSize: 18.sp)),
            Text(
              '₦${fmt.format(state.total)}',
              style: AppTextStyles.h1.copyWith(fontSize: 18.sp),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _showAddItemSheet({
    int? existingIndex,
    InvoiceItem? existing,
  }) async {
    final descCtrl = TextEditingController(text: existing?.description ?? '');
    final priceCtrl = TextEditingController(
      text: existing != null ? existing.unitPrice.toStringAsFixed(0) : '',
    );
    final qtyCtrl = TextEditingController(
      text: existing != null ? existing.quantity.toString() : '',
    );
    final amountCtrl = TextEditingController(
      text: existing != null ? existing.amount.toStringAsFixed(0) : '',
    );

    double parseDouble(String v) => double.tryParse(v.trim()) ?? 0;
    int parseInt(String v) => int.tryParse(v.trim()) ?? 0;

    void recalcAmount() {
      final price = parseDouble(priceCtrl.text);
      final qty = parseInt(qtyCtrl.text);
      final amt = price * qty;
      final nextText = amt == 0 ? '0' : amt.toStringAsFixed(0);
      if (amountCtrl.text != nextText) {
        amountCtrl.text = nextText;
      }
    }

    recalcAmount();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            16.w,
            16.h,
            16.w,
            MediaQuery.of(ctx).viewInsets.bottom + 16.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Add Item', style: AppTextStyles.sectionTitle),
                  GestureDetector(
                    onTap: () => Navigator.pop(ctx),
                    child: Container(
                      width: 28.w,
                      height: 28.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Icon(Icons.close, size: 16.w),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              AppTextField(
                label: 'Item description',
                controller: descCtrl,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: 12.h),
              AppTextField(
                label: 'Unit price',
                controller: priceCtrl,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onChanged: (_) => recalcAmount(),
              ),
              SizedBox(height: 12.h),
              AppTextField(
                label: 'Quantity',
                controller: qtyCtrl,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onChanged: (_) => recalcAmount(),
              ),
              SizedBox(height: 12.h),
              AppTextField(
                label: 'Amount',
                controller: amountCtrl,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                readOnly: true,
              ),
              SizedBox(height: 20.h),
              AppButton(
                label: existingIndex != null ? 'Update item' : 'Add item',
                onPressed: () {
                  final desc = descCtrl.text.trim();
                  final price = parseDouble(priceCtrl.text);
                  final qty = parseInt(qtyCtrl.text);
                  final amt = price * qty;

                  if (desc.isEmpty || qty <= 0) return;

                  final item = InvoiceItem(
                    description: desc,
                    quantity: qty,
                    unitPrice: price,
                    amount: amt,
                  );

                  final provider =
                      widget.isEdit && widget.income != null
                          ? editIncomeControllerProvider(widget.income!['id'])
                          : addIncomeControllerProvider;
                  final ctrl = ref.read(provider.notifier);
                  if (existingIndex != null) {
                    ctrl.updateItem(existingIndex, item);
                  } else {
                    ctrl.addItem(item);
                  }
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        );
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      descCtrl.dispose();
      priceCtrl.dispose();
      qtyCtrl.dispose();
      amountCtrl.dispose();
    });
  }

  Future<void> _handleSubmit() async {
    final provider =
        widget.isEdit && widget.income != null
            ? editIncomeControllerProvider(widget.income!['id'])
            : addIncomeControllerProvider;
    final ctrl = ref.read(provider.notifier);
    final ok = await ctrl.submit();
    if (!mounted || !ok) return;
    AppToast.success(
      widget.isEdit
          ? 'Income updated successfully'
          : 'Invoice added successfully',
    );
    context.pop(true);
  }
}
