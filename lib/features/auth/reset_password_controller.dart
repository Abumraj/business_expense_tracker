import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/api_client.dart';
import '../../services/service_providers.dart';

enum ResetPasswordStatus { idle, loading, error }

class ResetPasswordState {
  const ResetPasswordState({
    this.email = '',
    this.status = ResetPasswordStatus.idle,
    this.errorMessage,
  });

  final String email;
  final ResetPasswordStatus status;
  final String? errorMessage;

  bool get canSubmit => email.trim().isNotEmpty;

  ResetPasswordState copyWith({
    String? email,
    ResetPasswordStatus? status,
    String? errorMessage,
  }) {
    return ResetPasswordState(
      email: email ?? this.email,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}

class ResetPasswordController extends StateNotifier<ResetPasswordState> {
  ResetPasswordController(this._ref) : super(const ResetPasswordState());

  final Ref _ref;

  void setEmail(String value) {
    state = state.copyWith(
      email: value,
      errorMessage: null,
      status: ResetPasswordStatus.idle,
    );
  }

  Future<bool> submit() async {
    if (!state.canSubmit) {
      state = state.copyWith(
        status: ResetPasswordStatus.error,
        errorMessage: 'Please enter your email address.',
      );
      return false;
    }

    state = state.copyWith(
      status: ResetPasswordStatus.loading,
      errorMessage: null,
    );

    try {
      await _ref
          .read(authApiProvider)
          .forgotPassword(email: state.email.trim());
      await _ref.read(authApiProvider).requestOtp(email: state.email.trim());
      state = state.copyWith(status: ResetPasswordStatus.idle);
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(
        status: ResetPasswordStatus.error,
        errorMessage: e.message,
      );
      return false;
    } catch (_) {
      state = state.copyWith(
        status: ResetPasswordStatus.error,
        errorMessage: 'Failed to send instructions. Please try again.',
      );
      return false;
    }
  }
}

final resetPasswordControllerProvider = StateNotifierProvider.autoDispose<
  ResetPasswordController,
  ResetPasswordState
>((ref) => ResetPasswordController(ref));
