import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../app/app_theme.dart';

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textMuted,
      selectedFontSize: 12.sp,
      unselectedFontSize: 12.sp,
      iconSize: 24.w,
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/images/home.svg',
            width: 24.w,
            height: 24.w,
          ),
          activeIcon: SvgPicture.asset(
            'assets/images/home-bold.svg',
            width: 24.w,
            height: 24.w,
          ),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/images/wallet.svg',
            width: 24.w,
            height: 24.w,
          ),
          activeIcon: SvgPicture.asset(
            'assets/images/wallet-bold.svg',
            width: 24.w,
            height: 24.w,
          ),
          label: 'Expenses',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/images/money-tick.svg',
            width: 24.w,
            height: 24.w,
          ),
          activeIcon: SvgPicture.asset(
            'assets/images/money-tick-bold.svg',
            width: 24.w,
            height: 24.w,
          ),
          label: 'Income',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/images/profile-2user.svg',
            width: 24.w,
            height: 24.w,
          ),
          activeIcon: SvgPicture.asset(
            'assets/images/profile-2user-bold.svg',
            width: 24.w,
            height: 24.w,
          ),
          label: 'Customers',
        ),
      ],
    );
  }
}
