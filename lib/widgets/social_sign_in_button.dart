import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app/app_theme.dart';

class SocialSignInButton extends StatelessWidget {
  const SocialSignInButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.leading,
  });

  final String label;
  final VoidCallback onPressed;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: InkWell(
        borderRadius: AppRadii.r8,
        onTap: onPressed,
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppRadii.r8,
            border: Border.all(color: AppColors.borderStrong, width: 1),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D0A0C12),
                offset: Offset(0, 1),
                blurRadius: 2,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 20.w,
                height: 20.w,
                child: leading ?? const SizedBox.shrink(),
              ),
              SizedBox(width: 12.w),
              Text(
                label,
                style: AppTextStyles.input.copyWith(
                  color: const Color(0xFF414651),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
