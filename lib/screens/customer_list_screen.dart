import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../app/app_router.dart';
import '../app/app_theme.dart';
import '../services/service_providers.dart';
import '../utils/error_handler.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../widgets/app_search_field.dart';
import '../widgets/confirm_delete_dialog.dart';
import '../widgets/customer_list_tile.dart';
import '../widgets/empty_state_widget.dart';

class CustomerListScreen extends ConsumerStatefulWidget {
  const CustomerListScreen({super.key});

  @override
  ConsumerState<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends ConsumerState<CustomerListScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  String _search = '';
  String _selectedCity = 'All';
  List<Map<String, dynamic>> _customers = [];
  bool _isLoading = true;
  String? _error;

  static const _cities = [
    'All',
    'Port Harcourt',
    'Lagos',
    'Abuja',
    'Ibadan',
    'Kano',
  ];

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  Future<void> _loadCustomers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final city = _selectedCity == 'All' ? null : _selectedCity;
      final response = await ErrorHandler.withAuthHandling(
        ref,
        context,
        () async {
          final result = await ref
              .read(customerApiProvider)
              .getCustomers(search: _search, city: city, skip: 0, take: 20);
          return result;
        },
      );
      final list = response['data'];
      if (list is List) {
        _customers = list.cast<Map<String, dynamic>>();
      } else {
        _customers = [];
      }
    } catch (e) {
      _error = e.toString();
    }
    if (mounted) setState(() => _isLoading = false);
  }

  void _onSearchChanged(String v) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      setState(() {
        _search = v;
      });
      _loadCustomers();
    });
  }

  Future<void> _deleteCustomer(int index) async {
    final c = _customers[index];
    final id = c['id']?.toString() ?? c['_id']?.toString();
    if (id == null) return;

    try {
      await ErrorHandler.withAuthHandling(ref, context, () async {
        await ref.read(customerApiProvider).deleteCustomer(id);
        return null;
      }, successMessage: 'Customer deleted');
      setState(() => _customers.removeAt(index));
    } catch (e) {
      // Error handling is done by ErrorHandler
    }
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
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Customers', style: AppTextStyles.h1),
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
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: FadeInUp(
                duration: const Duration(milliseconds: 200),
                child: AppSearchField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _OutlinedActionButton(
                    icon: Icons.add,
                    label: 'Add Customer',
                    onTap: () async {
                      final result = await context.push(AppRoutes.addCustomer);
                      // If result is true, refresh the customer list
                      if (result == true) {
                        _loadCustomers();
                      }
                    },
                  ),
                  SizedBox(width: 12.w),
                  _FilledActionButton(
                    leading: SvgPicture.asset(
                      'assets/images/profile-2user.svg',
                      width: 18.w,
                      height: 18.w,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    label: 'Import Record',
                    onTap: () {
                      // TODO: import record
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _FilterPill(
                    value: _selectedCity,
                    items: _cities,
                    onChanged: (v) {
                      setState(() {
                        _selectedCity = v;
                      });
                      _loadCustomers();
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child:
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _error != null
                      ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(_error!, style: AppTextStyles.body),
                            SizedBox(height: 8.h),
                            TextButton(
                              onPressed: _loadCustomers,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                      : _customers.isEmpty
                      ? RefreshIndicator(
                        onRefresh: _loadCustomers,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height - 200.h,
                            child: EmptyStateWidget(
                              title: 'No customers yet',
                              subtitle:
                                  'Add your first customer to start managing your client relationships',
                              iconPath: 'assets/images/profile-2user.svg',
                              action: ElevatedButton(
                                onPressed: () async {
                                  final result = await context.push(
                                    AppRoutes.addCustomer,
                                  );
                                  if (result == true) {
                                    _loadCustomers();
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
                                child: Text('Add Customer'),
                              ),
                            ),
                          ),
                        ),
                      )
                      : RefreshIndicator(
                        onRefresh: _loadCustomers,
                        child: ListView.separated(
                          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
                          itemCount: _customers.length,
                          separatorBuilder:
                              (_, __) =>
                                  Divider(height: 1, color: AppColors.divider),
                          itemBuilder: (context, index) {
                            final c = _customers[index];
                            final name =
                                '${c['firstName'] ?? ''} ${c['lastName'] ?? ''}'
                                    .trim();
                            final email = c['email']?.toString() ?? '';
                            final phone = c['phoneNumber']?.toString() ?? '';
                            final location =
                                '${c['city'] ?? ''}, ${c['country'] ?? ''}'
                                    .trim();
                            final id =
                                c['id']?.toString() ??
                                c['_id']?.toString() ??
                                '$index';
                            return FadeInUp(
                              duration: const Duration(milliseconds: 200),
                              delay: Duration(milliseconds: 30 * index),
                              child: Dismissible(
                                key: Key('customer_$id'),
                                direction: DismissDirection.endToStart,
                                confirmDismiss:
                                    (_) => ConfirmDeleteDialog.show(context),
                                onDismissed: (_) => _deleteCustomer(index),
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.only(right: 20.w),
                                  color: Colors.white,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 40.w,
                                        height: 40.w,
                                        decoration: BoxDecoration(
                                          color: AppColors.dangerRedBg,
                                          borderRadius: AppRadii.r8,
                                        ),
                                        child: Center(
                                          child: SvgPicture.asset(
                                            'assets/images/trash.svg',
                                            width: 20.w,
                                            height: 20.w,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        'Delete',
                                        style: AppTextStyles.body.copyWith(
                                          color: AppColors.dangerRed,
                                          fontSize: 11.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                child: CustomerListTile(
                                  name: name,
                                  email: email,
                                  phone: phone,
                                  location: location,
                                  onTap: () async {
                                    final result = await context.push(
                                      AppRoutes.customerDetail,
                                      extra: c,
                                    );
                                    if (result == true && mounted) {
                                      _loadCustomers();
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 3,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go(AppRoutes.dashboard);
              break;
            case 1:
              context.go(AppRoutes.expenseList);
              break;
            case 2:
              context.go(AppRoutes.incomeList);
              break;
          }
        },
      ),
    );
  }
}

class _OutlinedActionButton extends StatelessWidget {
  const _OutlinedActionButton({
    required this.icon,
    required this.label,
    this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: AppRadii.r8,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18.w, color: AppColors.primary),
            SizedBox(width: 6.w),
            Text(
              label,
              style: AppTextStyles.body.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilledActionButton extends StatelessWidget {
  const _FilledActionButton({
    required this.leading,
    required this.label,
    this.onTap,
  });
  final Widget leading;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: AppRadii.r8,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            leading,
            SizedBox(width: 6.w),
            Text(
              label,
              style: AppTextStyles.body.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
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
