import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../app/app_theme.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.enabled = true,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool enabled;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final canPress = enabled && !isLoading;

    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              canPress
                  ? AppColors.primary
                  : AppColors.primary.withOpacity(0.45),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: AppRadii.r8),
          elevation: 0,
        ),
        onPressed: canPress ? onPressed : null,
        child:
            isLoading
                ? SpinKitThreeBounce(color: Colors.white, size: 20.w)
                : Text(label, style: AppTextStyles.button),
      ),
    );
  }
}
