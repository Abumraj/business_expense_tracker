import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../app/app_theme.dart';
import '../features/expenses/add_expense_controller.dart';
import '../utils/toast_helper.dart';
import '../widgets/app_button.dart';
import '../widgets/app_dropdown_field.dart';
import '../widgets/app_stepper_field.dart';
import '../widgets/app_text_area.dart';
import '../widgets/app_text_field.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  late final TextEditingController _amountController;
  late final TextEditingController _unitAmountController;
  late final TextEditingController _totalCostController;
  late final TextEditingController _descriptionController;

  static const _categories = [
    'Employee service',
    'Rent',
    'Utilities',
    'Travel',
    'Transportation',
    'Salary',
    'Repairs',
  ];

  static const _paymentMethods = [
    'Transfer',
    'Cash',
    'Card',
    'Cheque',
  ];

  @override
  void initState() {
    super.initState();
    final state = ref.read(addExpenseControllerProvider);
    _amountController = TextEditingController(text: state.amount);
    _unitAmountController = TextEditingController(text: state.unitAmount);
    _totalCostController = TextEditingController(text: state.totalCost);
    _descriptionController = TextEditingController(text: state.description);

    _amountController.addListener(() {
      ref.read(addExpenseControllerProvider.notifier).setAmount(_amountController.text);
    });
    _unitAmountController.addListener(() {
      ref.read(addExpenseControllerProvider.notifier).setUnitAmount(_unitAmountController.text);
    });
    _totalCostController.addListener(() {
      ref.read(addExpenseControllerProvider.notifier).setTotalCost(_totalCostController.text);
    });
    _descriptionController.addListener(() {
      ref.read(addExpenseControllerProvider.notifier).setDescription(_descriptionController.text);
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _unitAmountController.dispose();
    _totalCostController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addExpenseControllerProvider);
    final ctrl = ref.read(addExpenseControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text('Add financial expenses', style: AppTextStyles.appBarTitle),
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
                padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 16.h),
                    FadeInUp(
                      duration: const Duration(milliseconds: 200),
                      child: AppTextField(
                        label: 'Enter amount',
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    FadeInUp(
                      duration: const Duration(milliseconds: 200),
                      delay: const Duration(milliseconds: 40),
                      child: AppStepperField(
                        label: 'Quantity',
                        value: state.quantity,
                        onIncrement: ctrl.incrementQuantity,
                        onDecrement: ctrl.decrementQuantity,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    FadeInUp(
                      duration: const Duration(milliseconds: 200),
                      delay: const Duration(milliseconds: 80),
                      child: AppDropdownField<String>(
                        label: 'Select category',
                        value: state.category,
                        items: _categories,
                        onChanged: ctrl.setCategory,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    FadeInUp(
                      duration: const Duration(milliseconds: 200),
                      delay: const Duration(milliseconds: 120),
                      child: AppDropdownField<String>(
                        label: 'Select payment method',
                        value: state.paymentMethod,
                        items: _paymentMethods,
                        onChanged: ctrl.setPaymentMethod,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    FadeInUp(
                      duration: const Duration(milliseconds: 200),
                      delay: const Duration(milliseconds: 160),
                      child: AppTextField(
                        label: 'Enter unit amount',
                        controller: _unitAmountController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    FadeInUp(
                      duration: const Duration(milliseconds: 200),
                      delay: const Duration(milliseconds: 200),
                      child: AppTextField(
                        label: 'Total cost',
                        controller: _totalCostController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    FadeInUp(
                      duration: const Duration(milliseconds: 200),
                      delay: const Duration(milliseconds: 240),
                      child: AppTextArea(
                        label: 'Enter description',
                        controller: _descriptionController,
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
              child: AppButton(
                label: 'Add expense',
                enabled: state.canSubmit,
                isLoading: state.status == AddExpenseStatus.loading,
                onPressed: _handleSubmit,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    final ctrl = ref.read(addExpenseControllerProvider.notifier);
    final ok = await ctrl.submit();
    if (!mounted || !ok) return;
    AppToast.success('Expense added successfully');
    context.pop();
  }
}
