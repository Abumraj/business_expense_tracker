import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../app/app_router.dart';
import '../app/app_theme.dart';
import '../models/income_model.dart';
import '../models/income_summary_model.dart';
import '../services/service_providers.dart';
import '../utils/error_handler.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../widgets/app_search_field.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/expense_dashboard_card.dart';
import '../widgets/income_list_card.dart';

class IncomeListScreen extends ConsumerStatefulWidget {
  const IncomeListScreen({super.key});

  @override
  ConsumerState<IncomeListScreen> createState() => _IncomeListScreenState();
}

class _IncomeListScreenState extends ConsumerState<IncomeListScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  String _search = '';
  String _selectedFilter = 'All';
  List<Income> _incomes = [];
  bool _isLoading = true;
  String? _error;
  IncomeSummary? _summary;

  static const _filters = ['All', 'Paid', 'Pending'];

  String _formatCurrency(double amount) {
    return '₦${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }

  @override
  void initState() {
    super.initState();
    _loadIncomes();
  }

  Future<void> _loadSummary() async {
    try {
      final summary = await ErrorHandler.withAuthHandling(
        ref,
        context,
        () async {
          final result = await ref.read(incomeApiProvider).getSummary();
          return result;
        },
      );
      setState(() {
        _summary = summary;
      });
    } catch (e) {
      // Error handling is done by ErrorHandler
    }
  }

  Future<void> _loadIncomes() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final status =
          _selectedFilter == 'All' ? null : _selectedFilter.toUpperCase();
      final response = await ErrorHandler.withAuthHandling(
        ref,
        context,
        () async {
          final result = await ref
              .read(incomeApiProvider)
              .getIncomes(status: status, search: _search, skip: 0, take: 20);
          return result;
        },
      );
      _incomes = response.data;
      // Also load summary data
      _loadSummary();
    } catch (e) {
      _error = e.toString();
    }
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _refreshData() async {
    await Future.wait([_loadIncomes(), _loadSummary()]);
  }

  void _onSearchChanged(String v) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      setState(() {
        _search = v;
      });
      _loadIncomes();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshData,
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
                                Text('Income', style: AppTextStyles.h1),
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
                            FadeInUp(
                              duration: const Duration(milliseconds: 200),
                              child: AppSearchField(
                                controller: _searchController,
                                onChanged: _onSearchChanged,
                              ),
                            ),
                            SizedBox(height: 16.h),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 80.h,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          children: [
                            ExpenseDashboardCard.action(
                              title: 'Add income',
                              icon: SvgPicture.asset(
                                'assets/images/additem.svg',
                                width: 28.w,
                                height: 28.w,
                                colorFilter: const ColorFilter.mode(
                                  AppColors.primary,
                                  BlendMode.srcIn,
                                ),
                              ),
                              onTap: () async {
                                final result = await context.push(
                                  AppRoutes.addIncome,
                                );
                                if (result == true && mounted) {
                                  _refreshData();
                                }
                              },
                            ),
                            SizedBox(width: 12.w),
                            ExpenseDashboardCard.info(
                              title: 'Total income',
                              amount:
                                  _summary != null
                                      ? _formatCurrency(_summary!.totalIncome)
                                      : 'Loading...',
                            ),
                            SizedBox(width: 12.w),
                            ExpenseDashboardCard.info(
                              title: 'Pending income',
                              amount:
                                  _summary != null
                                      ? _formatCurrency(_summary!.pendingIncome)
                                      : 'Loading...',
                            ),
                            SizedBox(width: 12.w),
                            ExpenseDashboardCard.info(
                              title: 'Monthly income',
                              amount:
                                  _summary != null
                                      ? _formatCurrency(_summary!.monthlyIncome)
                                      : 'Loading...',
                              borderColor: AppColors.cardOrangeBorder,
                            ),
                            SizedBox(width: 16.w),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: IntrinsicWidth(
                            child: _FilterDropdown(
                              value: _selectedFilter,
                              items: _filters,
                              onChanged: (v) {
                                setState(() => _selectedFilter = v);
                                _loadIncomes();
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (_isLoading)
                      const SliverFillRemaining(
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (_error != null)
                      SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(_error!, style: AppTextStyles.body),
                              SizedBox(height: 8.h),
                              TextButton(
                                onPressed: _loadIncomes,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      )
                    else if (_incomes.isEmpty)
                      SliverFillRemaining(
                        child: EmptyStateWidget(
                          title: 'No income records',
                          subtitle:
                              'Start by adding your first income record to track your earnings',
                          iconPath: 'assets/images/money-tick.svg',
                          action: ElevatedButton(
                            onPressed: () async {
                              final result = await context.push(
                                AppRoutes.addIncome,
                              );
                              if (result == true && mounted) {
                                _refreshData();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: 24.w,
                                vertical: 12.h,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            child: Text('Add Income'),
                          ),
                        ),
                      )
                    else
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        sliver: SliverList.separated(
                          itemCount: _incomes.length,
                          separatorBuilder: (_, __) => SizedBox(height: 12.h),
                          itemBuilder: (context, index) {
                            final inc = _incomes[index];
                            return FadeInUp(
                              duration: const Duration(milliseconds: 200),
                              delay: Duration(milliseconds: 40 * index),
                              child: IncomeListCard(
                                createdOn: inc.formattedInvoiceDate,
                                customer: inc.customerName,
                                paymentMethod: inc.bankName,
                                quantity: inc.totalQuantity,
                                status: inc.displayStatus,
                                amount: inc.formattedAmount,
                                onTap:
                                    () => context.push(
                                      AppRoutes.editIncome,
                                      extra: inc.toJson(),
                                    ),
                              ),
                            );
                          },
                        ),
                      ),
                    SliverToBoxAdapter(child: SizedBox(height: 16.h)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go(AppRoutes.dashboard);
              break;
            case 1:
              context.go(AppRoutes.expenseList);
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

class _FilterDropdown extends StatelessWidget {
  const _FilterDropdown({
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
      width: 120.w,
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
                  .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                  .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}
