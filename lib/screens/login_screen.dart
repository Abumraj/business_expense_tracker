import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../app/app_router.dart';
import '../app/app_theme.dart';
import '../features/auth/login_controller.dart';
import '../services/auth_api.dart';
import '../services/service_providers.dart';
import '../utils/toast_helper.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';
import '../widgets/social_sign_in_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(loginControllerProvider);
    _emailController = TextEditingController(text: state.email);
    _passwordController = TextEditingController(text: state.password);

    _emailController.addListener(() {
      ref
          .read(loginControllerProvider.notifier)
          .setEmail(_emailController.text);
    });
    _passwordController.addListener(() {
      ref
          .read(loginControllerProvider.notifier)
          .setPassword(_passwordController.text);
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginControllerProvider);
    final controller = ref.read(loginControllerProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 375),
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 24.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 56.h),
                      Center(
                        child: Container(
                          width: 48.w,
                          height: 48.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24.r),
                            border: Border.all(
                              color: AppColors.primary,
                              width: 16.w,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      FadeInUp(
                        duration: const Duration(milliseconds: 250),
                        child: Text(
                          'Log in to your account',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.h1,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      FadeInUp(
                        duration: const Duration(milliseconds: 250),
                        delay: const Duration(milliseconds: 40),
                        child: Text(
                          'Manage your financial operations and improve\n'
                          'financial performance by tracking your income,\n'
                          'expenses, sales inventory, and Staff.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.body,
                        ),
                      ),
                      SizedBox(height: 32.h),
                      FadeInUp(
                        duration: const Duration(milliseconds: 250),
                        delay: const Duration(milliseconds: 80),
                        child: SocialSignInButton(
                          label: 'Continue with Google',
                          leading: Center(
                            child: Text(
                              'G',
                              style: AppTextStyles.input.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          onPressed: () {
                            AppToast.success('Google login coming soon');
                          },
                        ),
                      ),
                      SizedBox(height: 32.h),
                      FadeInUp(
                        duration: const Duration(milliseconds: 250),
                        delay: const Duration(milliseconds: 120),
                        child: Text(
                          'Or, sign in with your email',
                          textAlign: TextAlign.left,
                          style: AppTextStyles.sectionTitle,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      FadeInUp(
                        duration: const Duration(milliseconds: 250),
                        delay: const Duration(milliseconds: 140),
                        child: AppTextField(
                          label: 'Email address',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      FadeInUp(
                        duration: const Duration(milliseconds: 250),
                        delay: const Duration(milliseconds: 160),
                        child: AppTextField(
                          label: 'Password',
                          controller: _passwordController,
                          obscureText: state.obscurePassword,
                          textInputAction: TextInputAction.done,
                          suffix: IconButton(
                            onPressed: controller.toggleObscurePassword,
                            icon: Icon(
                              state.obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: const Color(0xFF1B1E21),
                            ),
                          ),
                          onSubmitted: (_) async {
                            final result = await controller.submit();
                            if (!context.mounted || result == null) return;
                            _handleLoginResult(result);
                          },
                        ),
                      ),
                      SizedBox(height: 16.h),
                      FadeInUp(
                        duration: const Duration(milliseconds: 250),
                        delay: const Duration(milliseconds: 180),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: controller.toggleRememberMe,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 22.w,
                                    height: 22.w,
                                    child: Checkbox(
                                      value: state.rememberMe,
                                      onChanged:
                                          (_) => controller.toggleRememberMe(),
                                      activeColor: const Color(0xFF22C55E),
                                      checkColor: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Text(
                                    'Remember for 30 days',
                                    style: AppTextStyles.helper,
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () => context.go(AppRoutes.resetPassword),
                              child: Text(
                                'Forgot password',
                                style: AppTextStyles.link,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.h),
                      FadeInUp(
                        duration: const Duration(milliseconds: 250),
                        delay: const Duration(milliseconds: 200),
                        child: AppButton(
                          label: 'Login',
                          enabled: state.canSubmit,
                          isLoading: state.status == LoginStatus.loading,
                          onPressed: () async {
                            final result = await controller.submit();
                            if (!context.mounted || result == null) return;
                            _handleLoginResult(result);
                          },
                        ),
                      ),
                      SizedBox(height: 32.h),
                      FadeInUp(
                        duration: const Duration(milliseconds: 250),
                        delay: const Duration(milliseconds: 220),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don’t have an account?",
                              style: AppTextStyles.body,
                            ),
                            SizedBox(width: 6.w),
                            GestureDetector(
                              onTap: () => context.go(AppRoutes.createAccount),
                              child: Text(
                                'Create account',
                                style: AppTextStyles.link,
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
          },
        ),
      ),
    );
  }

  Future<void> _handleLoginResult(LoginResult result) async {
    if (!result.success) {
      // Show error toast for login failure
      AppToast.error(result.error ?? 'Login failed');
      return;
    }

    if (result.isVerified) {
      AppToast.success('Login successful');
      context.go(AppRoutes.dashboard);
    } else {
      // Request OTP for unverified user, then navigate to verification
      try {
        await ref.read(authApiProvider).requestOtp(email: result.email);
      } catch (_) {
        // OTP request failed – still navigate so user can resend from verification screen
      }
      if (!mounted) return;
      context.go(
        Uri(
          path: AppRoutes.verify,
          queryParameters: {'email': result.email, 'flow': 'verify'},
        ).toString(),
      );
    }
  }
}
