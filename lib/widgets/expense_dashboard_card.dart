import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app/app_theme.dart';

enum DashboardCardVariant { action, info, highlighted, alert }

class ExpenseDashboardCard extends StatelessWidget {
  const ExpenseDashboardCard({
    super.key,
    required this.variant,
    this.title,
    this.amount,
    this.subtitle,
    this.icon,
    this.onTap,
    this.percentChange,
    this.isUp = true,
    this.customBorderColor,
    this.customBgColor,
  });

  final DashboardCardVariant variant;
  final String? title;
  final String? amount;
  final String? subtitle;
  final Widget? icon;
  final VoidCallback? onTap;
  final String? percentChange;
  final bool isUp;
  final Color? customBorderColor;
  final Color? customBgColor;

  factory ExpenseDashboardCard.action({
    Key? key,
    required String title,
    required Widget icon,
    VoidCallback? onTap,
  }) => ExpenseDashboardCard(
    key: key,
    variant: DashboardCardVariant.action,
    title: title,
    icon: icon,
    onTap: onTap,
  );

  factory ExpenseDashboardCard.info({
    Key? key,
    required String title,
    required String amount,
    Color? borderColor,
    Widget? icon,
    VoidCallback? onTap,
  }) => ExpenseDashboardCard(
    key: key,
    variant: DashboardCardVariant.info,
    title: title,
    amount: amount,
    icon: icon,
    customBorderColor: borderColor,
    onTap: onTap,
  );

  factory ExpenseDashboardCard.highlighted({
    Key? key,
    required String title,
    required String amount,
    String? percentChange,
    bool isUp = true,
    Color? backgroundColor,
    VoidCallback? onTap,
  }) => ExpenseDashboardCard(
    key: key,
    variant: DashboardCardVariant.highlighted,
    title: title,
    amount: amount,
    percentChange: percentChange,
    isUp: isUp,
    customBgColor: backgroundColor,
    onTap: onTap,
  );

  factory ExpenseDashboardCard.alert({
    Key? key,
    required String title,
    required String value,
    String? linkText,
    Color? backgroundColor,
    VoidCallback? onTap,
  }) => ExpenseDashboardCard(
    key: key,
    variant: DashboardCardVariant.alert,
    title: title,
    amount: value,
    subtitle: linkText,
    customBgColor: backgroundColor,
    onTap: onTap,
  );

  @override
  Widget build(BuildContext context) {
    switch (variant) {
      case DashboardCardVariant.action:
        return _buildActionCard();
      case DashboardCardVariant.info:
        return _buildInfoCard();
      case DashboardCardVariant.highlighted:
        return _buildHighlightedCard();
      case DashboardCardVariant.alert:
        return _buildAlertCard();
    }
  }

  Widget _buildActionCard() {
    return _CardShell(
      onTap: onTap,
      borderColor: AppColors.primary,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[icon!, SizedBox(width: 10.w)],
          Text(
            title ?? '',
            style: AppTextStyles.detailValue.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return _CardShell(
      onTap: onTap,
      borderColor: customBorderColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title ?? '', style: AppTextStyles.cardTitle),
          SizedBox(height: 6.h),
          icon != null
              ? Row(
                children: [
                  icon!,
                  SizedBox(width: 6.w),
                  Flexible(
                    child: Text(amount ?? '', style: AppTextStyles.cardAmount),
                  ),
                ],
              )
              : Text(amount ?? '', style: AppTextStyles.cardAmount),
        ],
      ),
    );
  }

  Widget _buildHighlightedCard() {
    return _CardShell(
      onTap: onTap,
      backgroundColor: customBgColor ?? AppColors.cardPinkBg,
      borderColor: customBgColor ?? AppColors.cardPinkBg,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title ?? '', style: AppTextStyles.cardTitle),
                SizedBox(height: 4.h),
                Text(amount ?? '', style: AppTextStyles.cardAmount),
                if (percentChange != null) ...[
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Text(
                        'Last month vs ',
                        style: AppTextStyles.badgeText.copyWith(
                          color: AppColors.textMuted,
                          fontSize: 8.sp,
                        ),
                      ),
                      Icon(
                        isUp ? Icons.arrow_upward : Icons.arrow_downward,
                        size: 12.w,
                        color:
                            isUp ? AppColors.successGreen : AppColors.dangerRed,
                      ),
                      Text(
                        ' $percentChange',
                        style: AppTextStyles.badgeText.copyWith(
                          color:
                              isUp
                                  ? AppColors.successGreen
                                  : AppColors.dangerRed,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20.w),
        ],
      ),
    );
  }

  Widget _buildAlertCard() {
    return _CardShell(
      onTap: onTap,
      backgroundColor: customBgColor ?? AppColors.fraudAlertBg,
      borderColor: customBgColor ?? AppColors.fraudAlertBg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title ?? '', style: AppTextStyles.cardTitle),
          SizedBox(height: 4.h),
          Text(amount ?? '', style: AppTextStyles.cardAmount),
          if (subtitle != null) ...[
            SizedBox(height: 4.h),
            Row(
              children: [
                Flexible(
                  child: Text(
                    subtitle!,
                    style: AppTextStyles.link.copyWith(fontSize: 9.sp),
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(Icons.chevron_right, size: 14.w, color: AppColors.primary),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _CardShell extends StatelessWidget {
  const _CardShell({
    required this.child,
    this.onTap,
    this.backgroundColor,
    this.borderColor,
  });

  final Widget child;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180.w,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          borderRadius: AppRadii.r12,
          border: Border.all(color: borderColor ?? AppColors.border, width: 1),
        ),
        child: child,
      ),
    );
  }
}
