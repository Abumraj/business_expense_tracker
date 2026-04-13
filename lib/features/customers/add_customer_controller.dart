import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/api_client.dart';
import '../../services/service_providers.dart';

enum AddCustomerStatus { idle, loading, success, error }

class AddCustomerState {
  const AddCustomerState({
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.phone = '',
    this.city,
    this.country,
    this.status = AddCustomerStatus.idle,
    this.errorMessage,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String? city;
  final String? country;
  final AddCustomerStatus status;
  final String? errorMessage;

  bool get canSubmit =>
      firstName.trim().isNotEmpty &&
      lastName.trim().isNotEmpty &&
      email.trim().isNotEmpty &&
      phone.trim().isNotEmpty &&
      city != null &&
      country != null &&
      status != AddCustomerStatus.loading;

  AddCustomerState copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? city,
    String? country,
    AddCustomerStatus? status,
    String? errorMessage,
  }) => AddCustomerState(
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    email: email ?? this.email,
    phone: phone ?? this.phone,
    city: city ?? this.city,
    country: country ?? this.country,
    status: status ?? this.status,
    errorMessage: errorMessage,
  );
}

class AddCustomerController extends StateNotifier<AddCustomerState> {
  AddCustomerController(this._ref, {AddCustomerState? initial, this.customerId})
    : super(initial ?? const AddCustomerState());

  final Ref _ref;
  final String? customerId;

  void setFirstName(String v) {
    try {
      state = state.copyWith(firstName: v);
    } catch (_) {
      // Controller disposed, ignore
    }
  }

  void setLastName(String v) {
    try {
      state = state.copyWith(lastName: v);
    } catch (_) {
      // Controller disposed, ignore
    }
  }

  void setEmail(String v) {
    try {
      state = state.copyWith(email: v);
    } catch (_) {
      // Controller disposed, ignore
    }
  }

  void setPhone(String v) {
    try {
      state = state.copyWith(phone: v);
    } catch (_) {
      // Controller disposed, ignore
    }
  }

  void setCity(String? v) {
    try {
      state = state.copyWith(city: v);
    } catch (_) {
      // Controller disposed, ignore
    }
  }

  void setCountry(String? v) {
    try {
      state = state.copyWith(country: v);
    } catch (_) {
      // Controller disposed, ignore
    }
  }

  Future<bool> submit() async {
    if (!state.canSubmit) return false;
    try {
      state = state.copyWith(status: AddCustomerStatus.loading);
    } catch (_) {
      // Controller disposed, ignore
      return false;
    }
    try {
      final api = _ref.read(customerApiProvider);
      if (customerId != null) {
        await api.updateCustomer(
          id: customerId!,
          firstName: state.firstName.trim(),
          lastName: state.lastName.trim(),
          email: state.email.trim(),
          phoneNumber: state.phone.trim(),
          city: state.city!,
          country: state.country!,
        );
      } else {
        await api.createCustomer(
          firstName: state.firstName.trim(),
          lastName: state.lastName.trim(),
          email: state.email.trim(),
          phoneNumber: state.phone.trim(),
          city: state.city!,
          country: state.country!,
        );
      }
      try {
        state = state.copyWith(status: AddCustomerStatus.success);
      } catch (_) {
        // Controller disposed, ignore
      }
      return true;
    } on ApiException catch (e) {
      try {
        state = state.copyWith(
          status: AddCustomerStatus.error,
          errorMessage: e.message,
        );
      } catch (_) {
        // Controller disposed, ignore
      }
      return false;
    } catch (e) {
      try {
        state = state.copyWith(
          status: AddCustomerStatus.error,
          errorMessage: e.toString(),
        );
      } catch (_) {
        // Controller disposed, ignore
      }
      return false;
    }
  }

  void reset() {
    try {
      state = const AddCustomerState();
    } catch (_) {
      // Controller disposed, ignore
    }
  }
}

final addCustomerControllerProvider =
    StateNotifierProvider.autoDispose<AddCustomerController, AddCustomerState>(
      (ref) => AddCustomerController(ref),
    );

final editCustomerControllerProvider = StateNotifierProvider.autoDispose.family<
  AddCustomerController,
  AddCustomerState,
  ({AddCustomerState state, String id})
>(
  (ref, args) =>
      AddCustomerController(ref, initial: args.state, customerId: args.id),
);
