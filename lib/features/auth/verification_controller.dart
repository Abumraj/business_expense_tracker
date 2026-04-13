import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/api_client.dart';
import '../../services/service_providers.dart';

enum VerificationStatus { idle, loading, success, error }

class VerificationState {
  const VerificationState({
    this.code = '',
    this.secondsRemaining = 30,
    this.status = VerificationStatus.idle,
    this.showSuccessBanner = false,
    this.errorMessage,
  });

  final String code;
  final int secondsRemaining;
  final VerificationStatus status;
  final bool showSuccessBanner;
  final String? errorMessage;

  bool get canResend => secondsRemaining <= 0;
  bool get canVerify => code.trim().isNotEmpty;

  VerificationState copyWith({
    String? code,
    int? secondsRemaining,
    VerificationStatus? status,
    bool? showSuccessBanner,
    String? errorMessage,
  }) {
    return VerificationState(
      code: code ?? this.code,
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
      status: status ?? this.status,
      showSuccessBanner: showSuccessBanner ?? this.showSuccessBanner,
      errorMessage: errorMessage,
    );
  }
}

class VerificationController extends StateNotifier<VerificationState> {
  VerificationController(this._ref) : super(const VerificationState()) {
    _startTimer();
  }

  final Ref _ref;

  Timer? _timer;

  void setCode(String value) {
    state = state.copyWith(
      code: value,
      errorMessage: null,
      status: VerificationStatus.idle,
    );
  }

  void _startTimer() {
    _timer?.cancel();
    state = state.copyWith(secondsRemaining: 30);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final next = state.secondsRemaining - 1;
      if (next <= 0) {
        timer.cancel();
        state = state.copyWith(secondsRemaining: 0);
      } else {
        state = state.copyWith(secondsRemaining: next);
      }
    });
  }

  Future<void> resendCode({required String email}) async {
    if (!state.canResend) return;

    state = state.copyWith(
      status: VerificationStatus.loading,
      errorMessage: null,
    );
    try {
      await _ref.read(authApiProvider).requestOtp(email: email.trim());
      _startTimer();
      state = state.copyWith(status: VerificationStatus.idle);
    } on ApiException catch (e) {
      state = state.copyWith(
        status: VerificationStatus.error,
        errorMessage: e.message,
      );
    } catch (_) {
      state = state.copyWith(
        status: VerificationStatus.error,
        errorMessage: 'Failed to resend code. Please try again.',
      );
    }
  }

  Future<bool> verify({required String email, String flow = ''}) async {
    if (!state.canVerify) {
      state = state.copyWith(
        status: VerificationStatus.error,
        errorMessage: 'Enter verification code.',
      );
      return false;
    }

    state = state.copyWith(
      status: VerificationStatus.loading,
      errorMessage: null,
    );

    try {
      await _ref
          .read(authApiProvider)
          .verifyOtp(email: email.trim(), otp: state.code.trim());
      state = state.copyWith(
        status: VerificationStatus.success,
        showSuccessBanner: flow != 'reset',
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(
        status: VerificationStatus.error,
        errorMessage: e.message,
      );
      return false;
    } catch (_) {
      state = state.copyWith(
        status: VerificationStatus.error,
        errorMessage: 'Verification failed. Please try again.',
      );
      return false;
    }
  }

  void closeBanner() {
    state = state.copyWith(showSuccessBanner: false);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final verificationControllerProvider = StateNotifierProvider.autoDispose<
  VerificationController,
  VerificationState
>((ref) => VerificationController(ref));
