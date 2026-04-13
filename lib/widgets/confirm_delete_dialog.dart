import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app/app_theme.dart';

class ConfirmDeleteDialog extends StatelessWidget {
  const ConfirmDeleteDialog({
    super.key,
    this.title = 'Are you sure you want to delete this customer record?',
    this.subtitle = "You can't undo this action.",
    this.deleteLabel = 'Delete',
    this.cancelLabel = 'Cancel',
  });

  final String title;
  final String subtitle;
  final String deleteLabel;
  final String cancelLabel;

  static Future<bool?> show(
    BuildContext context, {
    String? title,
    String? subtitle,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (_) => ConfirmDeleteDialog(
        title: title ?? 'Are you sure you want to delete this customer record?',
        subtitle: subtitle ?? "You can't undo this action.",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadii.r16),
      insetPadding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () => Navigator.pop(context, false),
                child: Container(
                  width: 28.w,
                  height: 28.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Icon(Icons.close, size: 16.w),
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.h1.copyWith(fontSize: 20.sp),
            ),
            SizedBox(height: 8.h),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.body,
            ),
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: AppRadii.r8),
                  elevation: 0,
                ),
                onPressed: () => Navigator.pop(context, true),
                child: Text(deleteLabel, style: AppTextStyles.button),
              ),
            ),
            SizedBox(height: 12.h),
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.dangerRed,
                  side: const BorderSide(color: AppColors.dangerRed),
                  shape: RoundedRectangleBorder(borderRadius: AppRadii.r8),
                ),
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  cancelLabel,
                  style: AppTextStyles.button.copyWith(
                    color: AppColors.dangerRed,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
