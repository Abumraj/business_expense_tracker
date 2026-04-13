import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../app/app_theme.dart';
import '../widgets/detail_row.dart';

class ExpenseDetailsScreen extends StatelessWidget {
  const ExpenseDetailsScreen({
    super.key,
    required this.amount,
    required this.quantity,
    required this.category,
    required this.paymentMethod,
    required this.unitAmount,
    required this.totalCost,
    required this.description,
    required this.date,
  });

  final String amount;
  final String quantity;
  final String category;
  final String paymentMethod;
  final String unitAmount;
  final String totalCost;
  final String description;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text('Expense Details', style: AppTextStyles.appBarTitle),
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
                child: Text('Expense Details', style: AppTextStyles.h1),
              ),
              SizedBox(height: 8.h),
              FadeInUp(
                duration: const Duration(milliseconds: 200),
                delay: const Duration(milliseconds: 40),
                child: DetailRow(label: 'Amount', value: amount),
              ),
              FadeInUp(
                duration: const Duration(milliseconds: 200),
                delay: const Duration(milliseconds: 80),
                child: DetailRow(label: 'Quantity', value: quantity),
              ),
              FadeInUp(
                duration: const Duration(milliseconds: 200),
                delay: const Duration(milliseconds: 120),
                child: DetailRow(label: 'Category', value: category),
              ),
              FadeInUp(
                duration: const Duration(milliseconds: 200),
                delay: const Duration(milliseconds: 160),
                child: DetailRow(label: 'Payment method', value: paymentMethod),
              ),
              FadeInUp(
                duration: const Duration(milliseconds: 200),
                delay: const Duration(milliseconds: 200),
                child: DetailRow(label: 'Unit amount', value: unitAmount),
              ),
              FadeInUp(
                duration: const Duration(milliseconds: 200),
                delay: const Duration(milliseconds: 240),
                child: DetailRow(label: 'Total cost', value: totalCost),
              ),
              FadeInUp(
                duration: const Duration(milliseconds: 200),
                delay: const Duration(milliseconds: 280),
                child: DetailRow(label: 'Description', value: description),
              ),
              FadeInUp(
                duration: const Duration(milliseconds: 200),
                delay: const Duration(milliseconds: 320),
                child: DetailRow(
                  label: 'Date',
                  value: date,
                  showDivider: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
