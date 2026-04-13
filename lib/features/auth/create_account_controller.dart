import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/api_client.dart';
import '../../services/service_providers.dart';

enum CreateAccountStatus { idle, loading, error }

class CreateAccountState {
  const CreateAccountState({
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.phoneNumber = '',
    this.password = '',
    this.businessName = '',
    this.obscurePassword = true,
    this.status = CreateAccountStatus.idle,
    this.errorMessage,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String password;
  final String businessName;
  final bool obscurePassword;
  final CreateAccountStatus status;
  final String? errorMessage;

  bool get canSubmit =>
      firstName.trim().isNotEmpty &&
      lastName.trim().isNotEmpty &&
      email.trim().isNotEmpty &&
      phoneNumber.trim().isNotEmpty &&
      businessName.trim().isNotEmpty &&
      password.isNotEmpty;

  CreateAccountState copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? businessName,
    String? password,
    bool? obscurePassword,
    CreateAccountStatus? status,
    String? errorMessage,
  }) {
    return CreateAccountState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      businessName: businessName ?? this.businessName,
      password: password ?? this.password,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}

class CreateAccountController extends StateNotifier<CreateAccountState> {
  CreateAccountController(this._ref) : super(const CreateAccountState());

  final Ref _ref;

  void setFirstName(String value) {
    state = state.copyWith(
      firstName: value,
      errorMessage: null,
      status: CreateAccountStatus.idle,
    );
  }

  void setLastName(String value) {
    state = state.copyWith(
      lastName: value,
      errorMessage: null,
      status: CreateAccountStatus.idle,
    );
  }

  void setBusinessName(String value) {
    state = state.copyWith(
      businessName: value,
      errorMessage: null,
      status: CreateAccountStatus.idle,
    );
  }

  void setEmail(String value) {
    state = state.copyWith(
      email: value,
      errorMessage: null,
      status: CreateAccountStatus.idle,
    );
  }

  void setPhoneNumber(String value) {
    state = state.copyWith(
      phoneNumber: value,
      errorMessage: null,
      status: CreateAccountStatus.idle,
    );
  }

  void setPassword(String value) {
    state = state.copyWith(
      password: value,
      errorMessage: null,
      status: CreateAccountStatus.idle,
    );
  }

  void toggleObscurePassword() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  Future<bool> submit() async {
    if (!state.canSubmit) {
      state = state.copyWith(
        status: CreateAccountStatus.error,
        errorMessage: 'Please fill in all fields.',
      );
      return false;
    }

    state = state.copyWith(
      status: CreateAccountStatus.loading,
      errorMessage: null,
    );

    try {
      await _ref
          .read(authApiProvider)
          .register(
            firstName: state.firstName.trim(),
            lastName: state.lastName.trim(),
            email: state.email.trim(),
            businessName: state.businessName.trim(),
            phoneNumber: state.phoneNumber.trim(),
            password: state.password,
          );
      await _ref.read(authApiProvider).requestOtp(email: state.email.trim());
      state = state.copyWith(status: CreateAccountStatus.idle);
      return true;
    } on ApiException catch (e) {
      print(e);
      state = state.copyWith(
        status: CreateAccountStatus.error,
        errorMessage: e.message,
      );
      return false;
    } catch (_) {
      state = state.copyWith(
        status: CreateAccountStatus.error,
        errorMessage: 'Account creation failed. Please try again.',
      );
      return false;
    }
  }
}

final createAccountControllerProvider = StateNotifierProvider.autoDispose<
  CreateAccountController,
  CreateAccountState
>((ref) => CreateAccountController(ref));
