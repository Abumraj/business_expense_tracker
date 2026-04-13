import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../app/app_router.dart';
import '../app/app_theme.dart';
import '../services/service_providers.dart';
import '../utils/toast_helper.dart';
import '../widgets/confirm_delete_dialog.dart';

class CustomerDetailScreen extends ConsumerWidget {
  const CustomerDetailScreen({super.key, this.customer});

  final Map<String, dynamic>? customer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = customer ?? {};
    final name = '${c['firstName'] ?? ''} ${c['lastName'] ?? ''}'.trim();
    final email = c['email']?.toString() ?? '';
    final phone = c['phoneNumber']?.toString() ?? '';
    final city = c['city']?.toString() ?? '';
    final country = c['country']?.toString() ?? '';
    final dateAdded = c['createdAt']?.toString() ?? '';
    final customerId = c['id']?.toString() ?? c['_id']?.toString();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text('Customer Details', style: AppTextStyles.appBarTitle),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 32.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInUp(
                duration: const Duration(milliseconds: 200),
                child: Text(
                  name.isNotEmpty ? name : 'Customer',
                  style: AppTextStyles.h1,
                ),
              ),
              SizedBox(height: 8.h),
              FadeInUp(
                duration: const Duration(milliseconds: 200),
                delay: const Duration(milliseconds: 40),
                child: _PurpleDetailRow(label: 'Full Name', value: name),
              ),
              FadeInUp(
                duration: const Duration(milliseconds: 200),
                delay: const Duration(milliseconds: 80),
                child: _PurpleDetailRow(label: 'Email Address', value: email),
              ),
              FadeInUp(
                duration: const Duration(milliseconds: 200),
                delay: const Duration(milliseconds: 120),
                child: _PurpleDetailRow(label: 'Phone Number', value: phone),
              ),
              FadeInUp(
                duration: const Duration(milliseconds: 200),
                delay: const Duration(milliseconds: 160),
                child: _PurpleDetailRow(label: 'City', value: city),
              ),
              FadeInUp(
                duration: const Duration(milliseconds: 200),
                delay: const Duration(milliseconds: 200),
                child: _PurpleDetailRow(label: 'Country', value: country),
              ),
              if (dateAdded.isNotEmpty)
                FadeInUp(
                  duration: const Duration(milliseconds: 200),
                  delay: const Duration(milliseconds: 240),
                  child: _PurpleDetailRow(
                    label: 'Date Added',
                    value: dateAdded,
                    showDivider: false,
                  ),
                ),
              SizedBox(height: 32.h),
              FadeInUp(
                duration: const Duration(milliseconds: 200),
                delay: const Duration(milliseconds: 320),
                child: Row(
                  children: [
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.dangerRed,
                        side: const BorderSide(color: AppColors.dangerRed),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadii.r8,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                      ),
                      onPressed: () async {
                        final confirmed = await ConfirmDeleteDialog.show(
                          context,
                        );
                        if (confirmed == true && context.mounted) {
                          if (customerId != null) {
                            try {
                              await ref
                                  .read(customerApiProvider)
                                  .deleteCustomer(customerId);
                              AppToast.success('Customer deleted');
                            } catch (e) {
                              AppToast.error('Delete failed');
                              return;
                            }
                          }
                          if (context.mounted) context.pop();
                        }
                      },
                      icon: SvgPicture.asset(
                        'assets/images/trash.svg',
                        width: 18.w,
                        height: 18.w,
                      ),
                      label: Text(
                        'Delete Customer',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.dangerRed,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadii.r8,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                      ),
                      onPressed: () async {
                        final result = await context.push(
                          AppRoutes.editCustomer,
                          extra: c,
                        );
                        if (result == true && context.mounted) {
                          context.pop(true);
                        }
                      },
                      child: Text(
                        'Edit Customer',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PurpleDetailRow extends StatelessWidget {
  const _PurpleDetailRow({
    required this.label,
    required this.value,
    this.showDivider = true,
  });

  final String label;
  final String value;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.h),
        Text(
          label,
          style: AppTextStyles.detailLabel.copyWith(color: AppColors.primary),
        ),
        SizedBox(height: 6.h),
        Text(value, style: AppTextStyles.detailValue),
        SizedBox(height: 16.h),
        if (showDivider)
          Divider(height: 1, thickness: 1, color: AppColors.divider),
      ],
    );
  }
}
