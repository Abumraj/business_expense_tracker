import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../app/app_router.dart';
import '../app/app_theme.dart';
import '../features/auth/create_account_controller.dart';
import '../utils/toast_helper.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';
import '../widgets/social_sign_in_button.dart';

class CreateAccountScreen extends ConsumerStatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  ConsumerState<CreateAccountScreen> createState() =>
      _CreateAccountScreenState();
}

class _CreateAccountScreenState extends ConsumerState<CreateAccountScreen> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _businessNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneNumberController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(createAccountControllerProvider);
    _firstNameController = TextEditingController(text: state.firstName);
    _lastNameController = TextEditingController(text: state.lastName);
    _businessNameController = TextEditingController(text: state.businessName);
    _emailController = TextEditingController(text: state.email);
    _phoneNumberController = TextEditingController(text: state.phoneNumber);
    _passwordController = TextEditingController(text: state.password);

    _firstNameController.addListener(() {
      ref
          .read(createAccountControllerProvider.notifier)
          .setFirstName(_firstNameController.text);
    });
    _lastNameController.addListener(() {
      ref
          .read(createAccountControllerProvider.notifier)
          .setLastName(_lastNameController.text);
    });
    _businessNameController.addListener(() {
      ref
          .read(createAccountControllerProvider.notifier)
          .setBusinessName(_businessNameController.text);
    });
    _emailController.addListener(() {
      ref
          .read(createAccountControllerProvider.notifier)
          .setEmail(_emailController.text);
    });
    _phoneNumberController.addListener(() {
      ref
          .read(createAccountControllerProvider.notifier)
          .setPhoneNumber(_phoneNumberController.text);
    });
    _passwordController.addListener(() {
      ref
          .read(createAccountControllerProvider.notifier)
          .setPassword(_passwordController.text);
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _businessNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createAccountControllerProvider);
    final controller = ref.read(createAccountControllerProvider.notifier);

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
                      SizedBox(height: 32.h),
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
                          'Create account',
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
                          onPressed: () {},
                        ),
                      ),
                      SizedBox(height: 32.h),
                      FadeInUp(
                        duration: const Duration(milliseconds: 250),
                        delay: const Duration(milliseconds: 120),
                        child: Text(
                          'Or, sign up with your email',
                          textAlign: TextAlign.left,
                          style: AppTextStyles.sectionTitle,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      FadeInUp(
                        duration: const Duration(milliseconds: 250),
                        delay: const Duration(milliseconds: 140),
                        child: AppTextField(
                          label: 'First name',
                          controller: _firstNameController,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      FadeInUp(
                        duration: const Duration(milliseconds: 250),
                        delay: const Duration(milliseconds: 160),
                        child: AppTextField(
                          label: 'Last name',
                          controller: _lastNameController,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      FadeInUp(
                        duration: const Duration(milliseconds: 250),
                        delay: const Duration(milliseconds: 160),
                        child: AppTextField(
                          label: 'Business name',
                          controller: _businessNameController,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      FadeInUp(
                        duration: const Duration(milliseconds: 250),
                        delay: const Duration(milliseconds: 180),
                        child: AppTextField(
                          label: 'Email address',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      FadeInUp(
                        duration: const Duration(milliseconds: 250),
                        delay: const Duration(milliseconds: 200),
                        child: AppTextField(
                          label: 'Phone Number',
                          controller: _phoneNumberController,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      FadeInUp(
                        duration: const Duration(milliseconds: 250),
                        delay: const Duration(milliseconds: 220),
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
                          onSubmitted: (_) => _handleSubmit(),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      FadeInUp(
                        duration: const Duration(milliseconds: 250),
                        delay: const Duration(milliseconds: 240),
                        child: AppButton(
                          label: 'Create Account',
                          enabled: state.canSubmit,
                          isLoading:
                              state.status == CreateAccountStatus.loading,
                          onPressed: () {
                            _handleSubmit();
                          },
                        ),
                      ),
                      SizedBox(height: 24.h),
                      FadeInUp(
                        duration: const Duration(milliseconds: 250),
                        delay: const Duration(milliseconds: 260),
                        child: Text(
                          'By creating, you confirm to have read the company\n'
                          'privacy policy and agree to the terms of service',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.body,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      FadeInUp(
                        duration: const Duration(milliseconds: 250),
                        delay: const Duration(milliseconds: 280),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'I have an account?',
                              style: AppTextStyles.body,
                            ),
                            SizedBox(width: 6.w),
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

  Future<void> _handleSubmit() async {
    final controller = ref.read(createAccountControllerProvider.notifier);
    final state = ref.read(createAccountControllerProvider);
    final ok = await controller.submit();
    if (!mounted || !ok) return;
    AppToast.success('Account created successfully');
    context.go(
      '${AppRoutes.verify}?email=${Uri.encodeComponent(state.email)}&flow=signup',
    );
  }
}
