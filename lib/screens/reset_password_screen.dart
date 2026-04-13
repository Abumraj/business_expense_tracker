import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../app/app_router.dart';
import '../app/app_theme.dart';
import '../features/auth/reset_password_controller.dart';
import '../utils/toast_helper.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(resetPasswordControllerProvider);
    _emailController = TextEditingController(text: state.email);

    _emailController.addListener(() {
      ref
          .read(resetPasswordControllerProvider.notifier)
          .setEmail(_emailController.text);
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(resetPasswordControllerProvider);

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
                          'Reset Password',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.h1,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      FadeInUp(
                        duration: const Duration(milliseconds: 250),
                        delay: const Duration(milliseconds: 40),
                        child: Text(
                          'Enter your email address used in loggin in on the\n'
                          'FinTrack. We\'ll send you an email with a link in order\n'
                          'to let you choose a new password.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.body,
                        ),
                      ),
                      SizedBox(height: 48.h),
                      FadeInUp(
                        duration: const Duration(milliseconds: 250),
                        delay: const Duration(milliseconds: 80),
                        child: AppTextField(
                          label: 'Email address',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => _handleSubmit(),
                        ),
                      ),
                      SizedBox(height: 32.h),
                      FadeInUp(
                        duration: const Duration(milliseconds: 250),
                        delay: const Duration(milliseconds: 120),
                        child: AppButton(
                          label: 'Send Instructions',
                          enabled: state.canSubmit,
                          isLoading:
                              state.status == ResetPasswordStatus.loading,
                          onPressed: _handleSubmit,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      FadeInUp(
                        duration: const Duration(milliseconds: 250),
                        delay: const Duration(milliseconds: 160),
                        child: Center(
                          child: GestureDetector(
                            onTap: () => context.go(AppRoutes.login),
                            child: Text(
                              'Return to Login',
                              style: AppTextStyles.link,
                            ),
                          ),
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

  Future<void> _handleSubmit() async {
    final controller = ref.read(resetPasswordControllerProvider.notifier);
    final state = ref.read(resetPasswordControllerProvider);
    final ok = await controller.submit();
    if (!mounted || !ok) return;
    AppToast.success('Instructions sent to your email');
    context.go(
      '${AppRoutes.verify}?email=${Uri.encodeComponent(state.email)}&flow=reset',
    );
  }
}
