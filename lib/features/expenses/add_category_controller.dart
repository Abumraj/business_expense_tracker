import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AddCategoryStatus { idle, loading, success, error }

class AddCategoryState {
  const AddCategoryState({
    this.name = '',
    this.status = AddCategoryStatus.idle,
    this.errorMessage,
  });

  final String name;
  final AddCategoryStatus status;
  final String? errorMessage;

  bool get canSubmit =>
      name.trim().isNotEmpty && status != AddCategoryStatus.loading;

  AddCategoryState copyWith({
    String? name,
    AddCategoryStatus? status,
    String? errorMessage,
  }) =>
      AddCategoryState(
        name: name ?? this.name,
        status: status ?? this.status,
        errorMessage: errorMessage,
      );
}

class AddCategoryController extends StateNotifier<AddCategoryState> {
  AddCategoryController() : super(const AddCategoryState());

  void setName(String v) => state = state.copyWith(name: v);

  Future<bool> submit() async {
    if (!state.canSubmit) return false;
    state = state.copyWith(status: AddCategoryStatus.loading);
    try {
      // TODO: replace with real API call
      await Future.delayed(const Duration(milliseconds: 800));
      state = state.copyWith(status: AddCategoryStatus.success);
      return true;
    } catch (e) {
      state = state.copyWith(
        status: AddCategoryStatus.error,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  void reset() => state = const AddCategoryState();
}

final addCategoryControllerProvider =
    StateNotifierProvider.autoDispose<AddCategoryController, AddCategoryState>(
  (ref) => AddCategoryController(),
);
