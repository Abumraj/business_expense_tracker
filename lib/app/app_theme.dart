import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const background = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF181D27);
  static const textSecondary = Color(0xFF535862);
  static const textMuted = Color(0xFF6D7786);

  static const border = Color(0xFFCFD5DC);
  static const borderStrong = Color(0xFFD5D6DA);

  static const primary = Color(0xFF6A42C2);

  static const successBackground = Color(0xFFDDF6E9);
  static const successText = Color(0xFF1B5E3A);

  static const linkOrange = Color(0xFFFF6A00);

  static const successGreen = Color(0xFF16A34A);
  static const successGreenBg = Color(0xFFDCFCE7);
  static const dangerRed = Color(0xFFDC2626);
  static const dangerRedBg = Color(0xFFFEE2E2);
  static const cardPinkBg = Color(0xFFFFF1F3);
  static const divider = Color(0xFFE5E7EB);

  static const cardOrangeBorder = Color(0xFFF97316);
  static const addItemPink = Color(0xFFEC4899);
  static const statusPending = Color(0xFF374151);

  static const cardLavenderBg = Color(0xFFF3F0FF);
  static const cardTealBg = Color(0xFFECFDF5);
  static const fraudAlertBg = Color(0xFFFEF2F2);
  static const iconTeal = Color(0xFF14B8A6);
  static const iconRose = Color(0xFFF43F5E);
  // Background color
  static const backgroundColor = Color(0xFFF0F2F5);
}

class AppRadii {
  static BorderRadius get r8 => BorderRadius.all(Radius.circular(8.r));
  static BorderRadius get r12 => BorderRadius.all(Radius.circular(12.r));
  static BorderRadius get r16 => BorderRadius.all(Radius.circular(16.r));
}

class AppTextStyles {
  static TextStyle get h1 => GoogleFonts.inter(
    fontSize: 24.sp,
    height: 32 / 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle get body => GoogleFonts.inter(
    fontSize: 14.sp,
    height: 1.25,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static TextStyle get sectionTitle => GoogleFonts.inter(
    fontSize: 18.sp,
    height: 24 / 18,
    fontWeight: FontWeight.w400,
    color: const Color(0xFF363C43),
  );

  static TextStyle get label => GoogleFonts.inter(
    fontSize: 14.sp,
    height: 1,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
  );

  static TextStyle get input => GoogleFonts.inter(
    fontSize: 16.sp,
    height: 24 / 16,
    fontWeight: FontWeight.w400,
    color: const Color(0xFF1B1E21),
  );

  static TextStyle get button => GoogleFonts.inter(
    fontSize: 16.sp,
    height: 24 / 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle get link => GoogleFonts.inter(
    fontSize: 14.sp,
    height: 20 / 14,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );

  static TextStyle get helper => GoogleFonts.inter(
    fontSize: 14.sp,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
    color: const Color(0xFF414651),
  );

  static TextStyle get appBarTitle => GoogleFonts.inter(
    fontSize: 18.sp,
    height: 24 / 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle get detailLabel => GoogleFonts.inter(
    fontSize: 13.sp,
    height: 1.2,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
  );

  static TextStyle get detailValue => GoogleFonts.inter(
    fontSize: 16.sp,
    height: 24 / 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static TextStyle get cardTitle => GoogleFonts.inter(
    fontSize: 13.sp,
    height: 1.2,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static TextStyle get cardAmount => GoogleFonts.inter(
    fontSize: 22.sp,
    height: 28 / 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle get badgeText => GoogleFonts.inter(
    fontSize: 12.sp,
    height: 1.2,
    fontWeight: FontWeight.w500,
  );
}

ThemeData buildAppTheme() {
  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
  );

  return base.copyWith(
    textTheme: GoogleFonts.interTextTheme(base.textTheme),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
      side: const BorderSide(color: AppColors.borderStrong),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: AppRadii.r8,
        borderSide: const BorderSide(color: AppColors.border, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadii.r8,
        borderSide: const BorderSide(color: AppColors.border, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadii.r8,
        borderSide: const BorderSide(color: AppColors.primary, width: 1.2),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
      hintStyle: AppTextStyles.label,
    ),
  );
}
