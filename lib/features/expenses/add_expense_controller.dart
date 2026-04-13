import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AddExpenseStatus { idle, loading, success, error }

class AddExpenseState {
  const AddExpenseState({
    this.amount = '',
    this.quantity = 0,
    this.category,
    this.paymentMethod,
    this.unitAmount = '',
    this.totalCost = '',
    this.description = '',
    this.status = AddExpenseStatus.idle,
    this.errorMessage,
  });

  final String amount;
  final int quantity;
  final String? category;
  final String? paymentMethod;
  final String unitAmount;
  final String totalCost;
  final String description;
  final AddExpenseStatus status;
  final String? errorMessage;

  bool get canSubmit =>
      amount.isNotEmpty &&
      quantity > 0 &&
      category != null &&
      paymentMethod != null &&
      unitAmount.isNotEmpty &&
      totalCost.isNotEmpty &&
      status != AddExpenseStatus.loading;

  AddExpenseState copyWith({
    String? amount,
    int? quantity,
    String? category,
    String? paymentMethod,
    String? unitAmount,
    String? totalCost,
    String? description,
    AddExpenseStatus? status,
    String? errorMessage,
  }) =>
      AddExpenseState(
        amount: amount ?? this.amount,
        quantity: quantity ?? this.quantity,
        category: category ?? this.category,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        unitAmount: unitAmount ?? this.unitAmount,
        totalCost: totalCost ?? this.totalCost,
        description: description ?? this.description,
        status: status ?? this.status,
        errorMessage: errorMessage,
      );
}

class AddExpenseController extends StateNotifier<AddExpenseState> {
  AddExpenseController() : super(const AddExpenseState());

  void setAmount(String v) => state = state.copyWith(amount: v);
  void setQuantity(int v) => state = state.copyWith(quantity: v < 0 ? 0 : v);
  void incrementQuantity() => state = state.copyWith(quantity: state.quantity + 1);
  void decrementQuantity() {
    if (state.quantity > 0) {
      state = state.copyWith(quantity: state.quantity - 1);
    }
  }

  void setCategory(String? v) => state = state.copyWith(category: v);
  void setPaymentMethod(String? v) => state = state.copyWith(paymentMethod: v);
  void setUnitAmount(String v) => state = state.copyWith(unitAmount: v);
  void setTotalCost(String v) => state = state.copyWith(totalCost: v);
  void setDescription(String v) => state = state.copyWith(description: v);

  Future<bool> submit() async {
    if (!state.canSubmit) return false;
    state = state.copyWith(status: AddExpenseStatus.loading);
    try {
      // TODO: replace with real API call
      await Future.delayed(const Duration(seconds: 1));
      state = state.copyWith(status: AddExpenseStatus.success);
      return true;
    } catch (e) {
      state = state.copyWith(
        status: AddExpenseStatus.error,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  void reset() => state = const AddExpenseState();
}

final addExpenseControllerProvider =
    StateNotifierProvider.autoDispose<AddExpenseController, AddExpenseState>(
  (ref) => AddExpenseController(),
);
