import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../app/app_theme.dart';
import '../widgets/app_segmented_tab.dart';
import '../widgets/fraud_alert_card.dart';

class FraudAlertScreen extends StatefulWidget {
  const FraudAlertScreen({super.key});

  @override
  State<FraudAlertScreen> createState() => _FraudAlertScreenState();
}

class _FraudAlertScreenState extends State<FraudAlertScreen> {
  int _tabIndex = 0;
  String _filter = 'All';

  static const _filters = ['All', 'Dirty Read', 'Non-Repeatable Read', 'Phantom Read'];

  static const _expenseItems = [
    {'flagType': 'Dirty Read', 'category': 'Employee service', 'unitAmount': '₦100,000', 'quantity': 1, 'paymentMethod': 'Card', 'totalCost': '₦100,000'},
    {'flagType': 'Non-Repeatable Read', 'category': 'Rent', 'unitAmount': '₦100,000', 'quantity': 2, 'paymentMethod': 'Transfer', 'totalCost': '₦200,000'},
    {'flagType': 'Phantom Read', 'category': 'Utilities', 'unitAmount': '₦100,000', 'quantity': 1, 'paymentMethod': 'Cash', 'totalCost': '₦100,000'},
  ];

  static const _incomeItems = [
    {'flagType': 'Dirty Read', 'client': 'John Cena', 'paymentMethod': 'Card', 'quantity': 1, 'status': 'Paid', 'amount': '₦100,000'},
    {'flagType': 'Non-Repeatable Read', 'client': 'John Cena', 'paymentMethod': 'Transfer', 'quantity': 1, 'status': 'Pending', 'amount': '₦100,000'},
    {'flagType': 'Phantom Read', 'client': 'John Cena', 'paymentMethod': 'Card', 'quantity': 1, 'status': 'Paid', 'amount': '₦100,000'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text('Fraud Alert', style: AppTextStyles.appBarTitle),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
              child: AppSegmentedTab(
                tabs: const ['Expenses', 'Income'],
                selectedIndex: _tabIndex,
                onChanged: (i) => setState(() => _tabIndex = i),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
              child: Align(
                alignment: Alignment.centerRight,
                child: _FilterPill(
                  value: _filter,
                  items: _filters,
                  onChanged: (v) => setState(() => _filter = v),
                ),
              ),
            ),
            Expanded(
              child: _tabIndex == 0 ? _buildExpenseList() : _buildIncomeList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseList() {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
      itemCount: _expenseItems.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final item = _expenseItems[index];
        return FadeInUp(
          duration: const Duration(milliseconds: 200),
          delay: Duration(milliseconds: 40 * index),
          child: FraudAlertCard.expense(
            flagType: item['flagType'] as String,
            category: item['category'] as String,
            unitAmount: item['unitAmount'] as String,
            quantity: item['quantity'] as int,
            paymentMethod: item['paymentMethod'] as String,
            totalCost: item['totalCost'] as String,
          ),
        );
      },
    );
  }

  Widget _buildIncomeList() {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
      itemCount: _incomeItems.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final item = _incomeItems[index];
        return FadeInUp(
          duration: const Duration(milliseconds: 200),
          delay: Duration(milliseconds: 40 * index),
          child: FraudAlertCard.income(
            flagType: item['flagType'] as String,
            client: item['client'] as String,
            paymentMethod: item['paymentMethod'] as String,
            quantity: item['quantity'] as int,
            status: item['status'] as String,
            amount: item['amount'] as String,
          ),
        );
      },
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String value;
  final List<String> items;
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
            child: Icon(Icons.keyboard_arrow_down_rounded, size: 18.w, color: AppColors.textSecondary),
          ),
          style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          items: items.map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}
