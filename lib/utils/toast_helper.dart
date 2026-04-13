import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../app/app_theme.dart';

class AppToast {
  static void success(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      backgroundColor: AppColors.successBackground,
      textColor: AppColors.successText,
      fontSize: 14.sp,
    );
  }

  static void error(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      backgroundColor: const Color(0xFFFEE2E2),
      textColor: const Color(0xFFB91C1C),
      fontSize: 14.sp,
    );
  }

  static void info(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      backgroundColor: const Color(0xFFE0E7FF),
      textColor: AppColors.primary,
      fontSize: 14.sp,
    );
  }
}
