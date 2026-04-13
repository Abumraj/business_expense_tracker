import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/api_client.dart';
import '../../services/auth_api.dart';
import '../../services/service_providers.dart';

enum LoginStatus { idle, loading, error }

class LoginState {
  const LoginState({
    this.email = '',
    this.password = '',
    this.rememberMe = false,
    this.obscurePassword = true,
    this.status = LoginStatus.idle,
    this.errorMessage,
  });

  final String email;
  final String password;
  final bool rememberMe;
  final bool obscurePassword;
  final LoginStatus status;
  final String? errorMessage;

  bool get canSubmit => email.trim().isNotEmpty && password.isNotEmpty;

  LoginState copyWith({
    String? email,
    String? password,
    bool? rememberMe,
    bool? obscurePassword,
    LoginStatus? status,
    String? errorMessage,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      rememberMe: rememberMe ?? this.rememberMe,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}

class LoginController extends StateNotifier<LoginState> {
  LoginController(this._ref) : super(const LoginState());

  final Ref _ref;

  void setEmail(String value) {
    state = state.copyWith(
      email: value,
      errorMessage: null,
      status: LoginStatus.idle,
    );
  }

  void setPassword(String value) {
    state = state.copyWith(
      password: value,
      errorMessage: null,
      status: LoginStatus.idle,
    );
  }

  void toggleRememberMe() {
    state = state.copyWith(rememberMe: !state.rememberMe);
  }

  void toggleObscurePassword() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  Future<LoginResult?> submit() async {
    if (!state.canSubmit) {
      state = state.copyWith(
        status: LoginStatus.error,
        errorMessage: 'Please enter email and password.',
      );
      return null;
    }

    state = state.copyWith(status: LoginStatus.loading, errorMessage: null);

    try {
      final result = await _ref
          .read(authApiProvider)
          .login(email: state.email.trim(), password: state.password);
      state = state.copyWith(status: LoginStatus.idle);
      return result;
    } on ApiException catch (e) {
      state = state.copyWith(
        status: LoginStatus.error,
        errorMessage: e.message,
      );
      return null;
    } catch (_) {
      state = state.copyWith(
        status: LoginStatus.error,
        errorMessage: 'Login failed. Please try again.',
      );
      return null;
    }
  }
}

final loginControllerProvider =
    StateNotifierProvider<LoginController, LoginState>(
      (ref) => LoginController(ref),
    );
