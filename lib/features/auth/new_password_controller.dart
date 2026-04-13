import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/api_client.dart';
import '../../services/service_providers.dart';

enum NewPasswordStatus { idle, loading, error }

class PasswordValidation {
  const PasswordValidation({
    this.hasLowercase = false,
    this.hasUppercase = false,
    this.hasNumber = false,
    this.hasSpecialChar = false,
    this.hasMinLength = false,
  });

  final bool hasLowercase;
  final bool hasUppercase;
  final bool hasNumber;
  final bool hasSpecialChar;
  final bool hasMinLength;

  bool get allValid =>
      hasLowercase &&
      hasUppercase &&
      hasNumber &&
      hasSpecialChar &&
      hasMinLength;

  static PasswordValidation fromPassword(String password) {
    return PasswordValidation(
      hasLowercase: password.contains(RegExp(r'[a-z]')),
      hasUppercase: password.contains(RegExp(r'[A-Z]')),
      hasNumber: password.contains(RegExp(r'[0-9]')),
      hasSpecialChar: password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]')),
      hasMinLength: password.length >= 8,
    );
  }
}

class NewPasswordState {
  const NewPasswordState({
    this.password = '',
    this.confirmPassword = '',
    this.obscurePassword = true,
    this.obscureConfirmPassword = true,
    this.validation = const PasswordValidation(),
    this.status = NewPasswordStatus.idle,
    this.errorMessage,
  });

  final String password;
  final String confirmPassword;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final PasswordValidation validation;
  final NewPasswordStatus status;
  final String? errorMessage;

  bool get canSubmit =>
      validation.allValid &&
      confirmPassword.isNotEmpty &&
      password == confirmPassword;

  NewPasswordState copyWith({
    String? password,
    String? confirmPassword,
    bool? obscurePassword,
    bool? obscureConfirmPassword,
    PasswordValidation? validation,
    NewPasswordStatus? status,
    String? errorMessage,
  }) {
    return NewPasswordState(
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirmPassword:
          obscureConfirmPassword ?? this.obscureConfirmPassword,
      validation: validation ?? this.validation,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}

class NewPasswordController extends StateNotifier<NewPasswordState> {
  NewPasswordController(this._ref) : super(const NewPasswordState());

  final Ref _ref;

  void setPassword(String value) {
    state = state.copyWith(
      password: value,
      validation: PasswordValidation.fromPassword(value),
      errorMessage: null,
      status: NewPasswordStatus.idle,
    );
  }

  void setConfirmPassword(String value) {
    state = state.copyWith(
      confirmPassword: value,
      errorMessage: null,
      status: NewPasswordStatus.idle,
    );
  }

  void toggleObscurePassword() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  void toggleObscureConfirmPassword() {
    state = state.copyWith(
      obscureConfirmPassword: !state.obscureConfirmPassword,
    );
  }

  Future<bool> submit({required String email, String? otp}) async {
    if (!state.validation.allValid) {
      state = state.copyWith(
        status: NewPasswordStatus.error,
        errorMessage: 'Password does not meet requirements.',
      );
      return false;
    }

    if (state.password != state.confirmPassword) {
      state = state.copyWith(
        status: NewPasswordStatus.error,
        errorMessage: 'Passwords do not match.',
      );
      return false;
    }

    if (otp == null || otp.trim().isEmpty) {
      state = state.copyWith(
        status: NewPasswordStatus.error,
        errorMessage: 'Enter verification code.',
      );
      return false;
    }

    state = state.copyWith(
      status: NewPasswordStatus.loading,
      errorMessage: null,
    );

    try {
      await _ref
          .read(authApiProvider)
          .resetPassword(
            email: email.trim(),
            otp: otp.trim(),
            newPassword: state.password,
          );
      state = state.copyWith(status: NewPasswordStatus.idle);
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(
        status: NewPasswordStatus.error,
        errorMessage: e.message,
      );
      return false;
    } catch (_) {
      state = state.copyWith(
        status: NewPasswordStatus.error,
        errorMessage: 'Password reset failed. Please try again.',
      );
      return false;
    }
  }
}

final newPasswordControllerProvider =
    StateNotifierProvider.autoDispose<NewPasswordController, NewPasswordState>(
      (ref) => NewPasswordController(ref),
    );
