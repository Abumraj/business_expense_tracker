import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../app/app_router.dart';
import '../app/app_theme.dart';
import '../widgets/app_bottom_nav_bar.dart';

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Expenses', style: AppTextStyles.h1),
                              CircleAvatar(
                                radius: 20.r,
                                backgroundColor: AppColors.border,
                                child: Icon(
                                  Icons.person,
                                  size: 22.w,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          // FadeInUp(
                          //   duration: const Duration(milliseconds: 200),
                          //   child: AppSearchField(
                          //     controller: _searchController,
                          //   ),
                          // ),
                          // SizedBox(height: 16.h),
                        ],
                      ),
                    ),
                  ),

                  // Coming soon message
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 60.h,
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.construction,
                              size: 64.w,
                              color: AppColors.textMuted,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'Coming Soon',
                              style: AppTextStyles.h1.copyWith(
                                color: AppColors.textMuted,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Expense tracking features are under development',
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.textMuted,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // // Horizontal stat cards
                  // SliverToBoxAdapter(
                  //   child: SizedBox(
                  //     height: 80.h,
                  //     child: ListView(
                  //       scrollDirection: Axis.horizontal,
                  //       padding: EdgeInsets.symmetric(horizontal: 16.w),
                  //       children: [
                  //         ExpenseDashboardCard.action(
                  //           title: 'Add expense',
                  //           icon: Icon(
                  //             Icons.add_circle_outline,
                  //             color: AppColors.primary,
                  //             size: 28.w,
                  //           ),
                  //           onTap: () => context.push(AppRoutes.addExpense),
                  //         ),
                  //         SizedBox(width: 12.w),
                  //         ExpenseDashboardCard.info(
                  //           title: 'Total expenses',
                  //           amount: '₦5,000,000',
                  //         ),
                  //         SizedBox(width: 12.w),
                  //         ExpenseDashboardCard.info(
                  //           title: 'Weekly expenses',
                  //           amount: '₦395,000',
                  //         ),
                  //         SizedBox(width: 12.w),
                  //         ExpenseDashboardCard.info(
                  //           title: 'Monthly expenses',
                  //           amount: '₦1,200,000',
                  //           borderColor: AppColors.cardOrangeBorder,
                  //         ),
                  //         SizedBox(width: 16.w),
                  //       ],
                  //     ),
                  //   ),
                  // ),

                  // // Filter
                  // SliverToBoxAdapter(
                  //   child: Padding(
                  //     padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
                  //     child: _FilterDropdown(
                  //       value: _selectedFilter,
                  //       items: _filters,
                  //       onChanged: (v) => setState(() => _selectedFilter = v),
                  //     ),
                  //   ),
                  // ),

                  // // Expense list
                  // SliverPadding(
                  //   padding: EdgeInsets.symmetric(horizontal: 16.w),
                  //   sliver: SliverList.separated(
                  //     itemCount: _sampleExpenses.length,
                  //     separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  //     itemBuilder: (context, index) {
                  //       final exp = _sampleExpenses[index];
                  //       return FadeInUp(
                  //         duration: const Duration(milliseconds: 200),
                  //         delay: Duration(milliseconds: 40 * index),
                  //         child: _ExpenseCard(
                  //           category: exp['category'] as String,
                  //           amount: exp['amount'] as String,
                  //           quantity: exp['quantity'] as int,
                  //           paymentMethod: exp['paymentMethod'] as String,
                  //           date: exp['date'] as String,
                  //           onTap:
                  //               () => context.push(
                  //                 AppRoutes.expenseDetails,
                  //                 extra: exp.map(
                  //                   (k, v) => MapEntry(k, v.toString()),
                  //                 ),
                  //               ),
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),
                  // SliverToBoxAdapter(child: SizedBox(height: 16.h)),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go(AppRoutes.dashboard);
              break;
            case 2:
              context.go(AppRoutes.incomeList);
              break;
            case 3:
              context.go(AppRoutes.customerList);
              break;
          }
        },
      ),
    );
  }
}
