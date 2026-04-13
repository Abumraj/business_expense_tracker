import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../app/app_router.dart';
import '../app/app_theme.dart';
import '../features/auth/new_password_controller.dart';
import '../utils/toast_helper.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';

class NewPasswordScreen extends ConsumerStatefulWidget {
  const NewPasswordScreen({super.key, required this.email, this.otp});

  final String email;
  final String? otp;

  @override
  ConsumerState<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends ConsumerState<NewPasswordScreen> {
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(newPasswordControllerProvider);
    _passwordController = TextEditingController(text: state.password);
    _confirmPasswordController = TextEditingController(
      text: state.confirmPassword,
    );

    _passwordController.addListener(() {
      ref
          .read(newPasswordControllerProvider.notifier)
          .setPassword(_passwordController.text);
    });
    _confirmPasswordController.addListener(() {
      ref
          .read(newPasswordControllerProvider.notifier)
          .setConfirmPassword(_confirmPasswordController.text);
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(newPasswordControllerProvider);
    final controller = ref.read(newPasswordControllerProvider.notifier);

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
                      SizedBox(height: 40.h),
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
                          'New Password',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.h1,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      FadeInUp(
                        duration: const Duration(milliseconds: 250),
                        delay: const Duration(milliseconds: 40),
                        child: Text(
                          'The password should have a mininum of 8\n'
                          'characters, and you can reuse your old password\n'
                          'once you change it.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.body,
                        ),
                      ),
                      SizedBox(height: 32.h),
                      FadeInUp(
                        duration: const Duration(milliseconds: 250),
                        delay: const Duration(milliseconds: 80),
                        child: AppTextField(
                          label: 'Enter new password',
                          controller: _passwordController,
                          obscureText: state.obscurePassword,
                          textInputAction: TextInputAction.next,
                          suffix: IconButton(
                            onPressed: controller.toggleObscurePassword,
                            icon: Icon(
                              state.obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: const Color(0xFF1B1E21),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      FadeInUp(
                        duration: const Duration(milliseconds: 250),
                        delay: const Duration(milliseconds: 120),
                        child: _buildValidationChecklist(state.validation),
                      ),
                      SizedBox(height: 24.h),
                      FadeInUp(
                        duration: const Duration(milliseconds: 250),
                        delay: const Duration(milliseconds: 160),
                        child: AppTextField(
                          label: 'Confirm new password',
                          controller: _confirmPasswordController,
                          obscureText: state.obscureConfirmPassword,
                          textInputAction: TextInputAction.done,
                          suffix: IconButton(
                            onPressed: controller.toggleObscureConfirmPassword,
                            icon: Icon(
                              state.obscureConfirmPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: const Color(0xFF1B1E21),
                            ),
                          ),
                          onSubmitted: (_) => _handleSubmit(),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      FadeInUp(
                        duration: const Duration(milliseconds: 250),
                        delay: const Duration(milliseconds: 200),
                        child: AppButton(
                          label: 'Reset Password',
                          enabled: state.canSubmit,
                          isLoading: state.status == NewPasswordStatus.loading,
                          onPressed: _handleSubmit,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      FadeInUp(
                        duration: const Duration(milliseconds: 250),
                        delay: const Duration(milliseconds: 220),
                        child: Text(
                          "To make sure your accout is secure, you'll be\n"
                          'logged out from other device once you set the new\n'
                          'password.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.body,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      FadeInUp(
                        duration: const Duration(milliseconds: 250),
                        delay: const Duration(milliseconds: 240),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Or ', style: AppTextStyles.body),
                            GestureDetector(
                              onTap: () => context.go(AppRoutes.login),
                              child: Text('Login', style: AppTextStyles.link),
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

  Widget _buildValidationChecklist(PasswordValidation validation) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _validationRow('One lowercase character', validation.hasLowercase),
        SizedBox(height: 8.h),
        _validationRow('One uppercase character', validation.hasUppercase),
        SizedBox(height: 8.h),
        _validationRow('One number', validation.hasNumber),
        SizedBox(height: 8.h),
        _validationRow('One special character', validation.hasSpecialChar),
        SizedBox(height: 8.h),
        _validationRow('8 characters mininum', validation.hasMinLength),
      ],
    );
  }

  Widget _validationRow(String label, bool isValid) {
    return Row(
      children: [
        Icon(
          Icons.check,
          size: 18.w,
          color: isValid ? const Color(0xFF22C55E) : AppColors.textMuted,
        ),
        SizedBox(width: 10.w),
        Text(
          label,
          style: AppTextStyles.body.copyWith(
            color: isValid ? AppColors.textPrimary : AppColors.textMuted,
          ),
        ),
      ],
    );
  }

  Future<void> _handleSubmit() async {
    final controller = ref.read(newPasswordControllerProvider.notifier);
    final ok = await controller.submit(email: widget.email, otp: widget.otp);
    if (!mounted || !ok) return;
    AppToast.success('Password reset successfully');
    context.go(AppRoutes.login);
  }
}
