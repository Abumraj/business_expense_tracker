import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../app/app_theme.dart';
import '../features/expenses/predicted_budget_controller.dart';
import '../widgets/budget_category_row.dart';

class PredictedBudgetScreen extends ConsumerWidget {
  const PredictedBudgetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(predictedBudgetControllerProvider);
    final ctrl = ref.read(predictedBudgetControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text('Predicted Budget', style: AppTextStyles.appBarTitle),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInUp(
                duration: const Duration(milliseconds: 200),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Predicted Budget',
                      style: AppTextStyles.detailValue.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                      ),
                    ),
                    _MonthDropdown(
                      value: state.selectedMonth,
                      months: ctrl.months,
                      onChanged: ctrl.setMonth,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              ...state.categories.asMap().entries.map(
                (entry) => FadeInUp(
                  duration: const Duration(milliseconds: 200),
                  delay: Duration(milliseconds: 40 * (entry.key + 1)),
                  child: BudgetCategoryRow(
                    category: entry.value.name,
                    amount: entry.value.amount,
                    percentChange: entry.value.percentChange,
                    isUp: entry.value.isUp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MonthDropdown extends StatelessWidget {
  const _MonthDropdown({
    required this.value,
    required this.months,
    required this.onChanged,
  });

  final String value;
  final List<String> months;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: true,
          icon: Padding(
            padding: EdgeInsets.only(left: 4.w),
            child: Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18.w,
              color: AppColors.textSecondary,
            ),
          ),
          style: AppTextStyles.body.copyWith(
            color: AppColors.textSecondary,
          ),
          items: months
              .map(
                (m) => DropdownMenuItem(
                  value: m,
                  child: Text(m),
                ),
              )
              .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}
