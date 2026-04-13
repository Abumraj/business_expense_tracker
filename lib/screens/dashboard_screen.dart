import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../app/app_router.dart';
import '../app/app_theme.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../widgets/dashboard_budget_row.dart';
import '../widgets/expense_dashboard_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _selectedMonth = 'April';
  String _selectedYear = '2025';

  static const _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static const _years = ['2023', '2024', '2025', '2026'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Dashboard', style: AppTextStyles.h1),
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
              ),
            ),

            // Coming soon message
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 60.h),
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
                        'Dashboard features are under development',
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

            // Month dropdown
            // SliverToBoxAdapter(
            //   child: Padding(
            //     padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
            //     child: Align(
            //       alignment: Alignment.centerLeft,
            //       child: _PillDropdown(
            //         value: _selectedMonth,
            //         items: _months,
            //         onChanged: (v) => setState(() => _selectedMonth = v),
            //       ),
            //     ),
            //   ),
            // ),

            // // Row 1 stat cards
            // SliverToBoxAdapter(
            //   child: SizedBox(
            //     height: 80.h,
            //     child: ListView(
            //       scrollDirection: Axis.horizontal,
            //       padding: EdgeInsets.symmetric(horizontal: 16.w),
            //       children: [
            //         ExpenseDashboardCard.info(
            //           title: 'Total Customers',
            //           amount: '1,500',
            //           icon: SvgPicture.asset(
            //             'assets/images/profile-2user.svg',
            //             width: 22.w,
            //             height: 22.w,
            //             colorFilter: const ColorFilter.mode(
            //               AppColors.primary,
            //               BlendMode.srcIn,
            //             ),
            //           ),
            //           borderColor: AppColors.cardOrangeBorder,
            //         ),
            //         SizedBox(width: 12.w),
            //         ExpenseDashboardCard.info(
            //           title: 'Total Income',
            //           amount: '₦10,000,0',
            //           icon: SvgPicture.asset(
            //             'assets/images/money-tick.svg',
            //             width: 22.w,
            //             height: 22.w,
            //             colorFilter: const ColorFilter.mode(
            //               AppColors.iconTeal,
            //               BlendMode.srcIn,
            //             ),
            //           ),
            //           borderColor: AppColors.cardOrangeBorder,
            //         ),
            //         SizedBox(width: 12.w),
            //         ExpenseDashboardCard.info(
            //           title: 'Total Expense',
            //           amount: '₦5,000,00',
            //           icon: SvgPicture.asset(
            //             'assets/images/wallet.svg',
            //             width: 22.w,
            //             height: 22.w,
            //             colorFilter: const ColorFilter.mode(
            //               AppColors.iconRose,
            //               BlendMode.srcIn,
            //             ),
            //           ),
            //           borderColor: AppColors.cardOrangeBorder,
            //         ),
            //         SizedBox(width: 12.w),
            //         ExpenseDashboardCard.info(
            //           title: 'PNL',
            //           amount: '₦5,000,00',
            //           icon: SvgPicture.asset(
            //             'assets/images/wallet.svg',
            //             width: 22.w,
            //             height: 22.w,
            //             colorFilter: ColorFilter.mode(
            //               AppColors.textPrimary,
            //               BlendMode.srcIn,
            //             ),
            //           ),
            //           borderColor: AppColors.cardOrangeBorder,
            //         ),
            //         SizedBox(width: 16.w),
            //       ],
            //     ),
            //   ),
            // ),

            // SliverToBoxAdapter(child: SizedBox(height: 12.h)),

            // // Row 2 highlight cards
            // SliverToBoxAdapter(
            //   child: SizedBox(
            //     height: 100.h,
            //     child: ListView(
            //       scrollDirection: Axis.horizontal,
            //       padding: EdgeInsets.symmetric(horizontal: 16.w),
            //       children: [
            //         ExpenseDashboardCard.highlighted(
            //           title: 'Predicted Budget',
            //           amount: '₦5,100,00',
            //           percentChange: '51.6%',
            //           isUp: true,
            //           backgroundColor: AppColors.cardLavenderBg,
            //           onTap: () => context.push(AppRoutes.predictedBudget),
            //         ),
            //         SizedBox(width: 12.w),
            //         ExpenseDashboardCard.highlighted(
            //           title: 'Income Forecast',
            //           amount: '₦11,100,0',
            //           percentChange: '51.6%',
            //           isUp: false,
            //           backgroundColor: AppColors.cardTealBg,
            //         ),
            //         SizedBox(width: 12.w),
            //         ExpenseDashboardCard.alert(
            //           title: 'Fraud Alert',
            //           value: '5',
            //           linkText: 'Click to see all anomalies',
            //           onTap: () => context.push(AppRoutes.fraudAlert),
            //         ),
            //         SizedBox(width: 16.w),
            //       ],
            //     ),
            //   ),
            // ),

            // SliverToBoxAdapter(child: SizedBox(height: 32.h)),

            // // Financial metrics header
            // SliverToBoxAdapter(
            //   child: Padding(
            //     padding: EdgeInsets.symmetric(horizontal: 16.w),
            //     child: FadeInUp(
            //       duration: const Duration(milliseconds: 200),
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Text(
            //             'Financial metrics',
            //             style: AppTextStyles.sectionTitle,
            //           ),
            //           _PillDropdown(
            //             value: _selectedYear,
            //             items: _years,
            //             onChanged: (v) => setState(() => _selectedYear = v),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),

            // // Chart legend
            // SliverToBoxAdapter(
            //   child: Padding(
            //     padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         _LegendDot(color: AppColors.iconRose, label: 'Expense'),
            //         SizedBox(width: 16.w),
            //         _LegendDot(color: AppColors.successGreen, label: 'Income'),
            //         SizedBox(width: 16.w),
            //         _LegendDot(color: AppColors.cardOrangeBorder, label: 'PNL'),
            //       ],
            //     ),
            //   ),
            // ),

            // // Chart placeholder
            // SliverToBoxAdapter(
            //   child: Padding(
            //     padding: EdgeInsets.symmetric(horizontal: 16.w),
            //     child: FadeInUp(
            //       duration: const Duration(milliseconds: 250),
            //       child: Container(
            //         height: 200.h,
            //         decoration: BoxDecoration(
            //           color: const Color(0xFFFAFAFC),
            //           borderRadius: AppRadii.r12,
            //           border: Border.all(color: AppColors.border),
            //         ),
            //         alignment: Alignment.center,
            //         child: Text(
            //           'Financial Chart\n(Integrate fl_chart)',
            //           textAlign: TextAlign.center,
            //           style: AppTextStyles.body,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),

            // SliverToBoxAdapter(child: SizedBox(height: 32.h)),

            // // Predicted Budget table
            // SliverToBoxAdapter(
            //   child: Padding(
            //     padding: EdgeInsets.symmetric(horizontal: 16.w),
            //     child: FadeInUp(
            //       duration: const Duration(milliseconds: 200),
            //       child: Text(
            //         'Predicted Budget',
            //         style: AppTextStyles.sectionTitle,
            //       ),
            //     ),
            //   ),
            // ),
            // SliverToBoxAdapter(child: SizedBox(height: 12.h)),
            // SliverToBoxAdapter(
            //   child: Padding(
            //     padding: EdgeInsets.symmetric(horizontal: 16.w),
            //     child: FadeInUp(
            //       duration: const Duration(milliseconds: 200),
            //       delay: const Duration(milliseconds: 40),
            //       child: const DashboardBudgetRow(
            //         month: 'January',
            //         income: '₦420,000',
            //         pnl: '₦280,000',
            //         expense: '₦160,000',
            //       ),
            //     ),
            //   ),
            // ),

            // SliverToBoxAdapter(child: SizedBox(height: 24.h)),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 1:
              context.go(AppRoutes.expenseList);
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

class _PillDropdown extends StatelessWidget {
  const _PillDropdown({
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
            child: Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18.w,
              color: AppColors.textSecondary,
            ),
          ),
          style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          items:
              items
                  .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                  .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 4.w),
        Text(
          label,
          style: AppTextStyles.badgeText.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
