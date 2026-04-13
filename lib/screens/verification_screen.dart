import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../app/app_router.dart';
import '../app/app_theme.dart';
import '../features/auth/verification_controller.dart';
import '../utils/toast_helper.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';
import '../widgets/success_banner.dart';

class VerificationScreen extends ConsumerStatefulWidget {
  const VerificationScreen({super.key, required this.email, this.flow = ''});

  final String email;
  final String flow;

  @override
  ConsumerState<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends ConsumerState<VerificationScreen> {
  late final TextEditingController _codeController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(verificationControllerProvider);
    _codeController = TextEditingController(text: state.code);
    _codeController.addListener(() {
      ref
          .read(verificationControllerProvider.notifier)
          .setCode(_codeController.text);
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(verificationControllerProvider);
    final controller = ref.read(verificationControllerProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 375),
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (state.showSuccessBanner) ...[
                        FadeInDown(
                          duration: const Duration(milliseconds: 250),
                          child: SuccessBanner(
                            message: 'Account verified successfully',
                            onClose: controller.closeBanner,
                          ),
                        ),
                        SizedBox(height: 24.h),
                      ] else
                        SizedBox(height: 24.h),
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
                          'Enter verification code',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.h1,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      FadeInUp(
                        duration: const Duration(milliseconds: 250),
                        delay: const Duration(milliseconds: 40),
                        child: Text(
                          'Please enter the six (6) digit verification code sent\n'
                          'to this email address ${widget.email.isEmpty ? '...' : widget.email}\n'
                          'below to complete your login .',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.body,
                        ),
                      ),
                      SizedBox(height: 32.h),
                      AppTextField(
                        label: 'Enter verification code',
                        controller: _codeController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) async {
                          final ok = await controller.verify(
                            email: widget.email,
                            flow: widget.flow,
                          );
                          if (!context.mounted || !ok) return;
                          if (widget.flow == 'reset') {
                            context.go(
                              '${AppRoutes.newPassword}?email=${Uri.encodeComponent(widget.email)}&otp=${Uri.encodeComponent(state.code)}',
                            );
                          } else if (widget.flow == 'signup') {
                            context.go(AppRoutes.login);
                          } else {
                            context.go(AppRoutes.dashboard);
                          }
                        },
                      ),
                      SizedBox(height: 24.h),
                      AppButton(
                        label: 'Verify Email',
                        isLoading: state.status == VerificationStatus.loading,
                        enabled: state.canVerify,
                        onPressed: () async {
                          final ok = await controller.verify(
                            email: widget.email,
                            flow: widget.flow,
                          );
                          if (!context.mounted || !ok) return;
                          if (widget.flow == 'reset') {
                            AppToast.success('Code verified successfully');
                            context.go(
                              '${AppRoutes.newPassword}?email=${Uri.encodeComponent(widget.email)}&otp=${Uri.encodeComponent(state.code)}',
                            );
                          } else {
                            AppToast.success('Account verified successfully');
                            context.go(AppRoutes.dashboard);
                          }
                        },
                      ),
                      SizedBox(height: 28.h),
                      Center(
                        child: GestureDetector(
                          onTap:
                              state.canResend
                                  ? () {
                                    controller.resendCode(email: widget.email);
                                    AppToast.info(
                                      'New code sent to your email',
                                    );
                                  }
                                  : null,
                          child: Text(
                            state.canResend
                                ? 'Get New Code'
                                : 'Get New Code in ${state.secondsRemaining}s',
                            style: AppTextStyles.link.copyWith(
                              color: AppColors.primary.withOpacity(
                                state.canResend ? 0.45 : 0.35,
                              ),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 44.h),
                      Center(
                        child: Text(
                          "Don’t get an email?  check your spam\nfolder!",
                          textAlign: TextAlign.center,
                          style: AppTextStyles.body,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            context.go(AppRoutes.login);
                          },
                          child: Text(
                            'Change email address and try again',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.link.copyWith(
                              color: AppColors.linkOrange,
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
}
