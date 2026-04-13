import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetCategory {
  const BudgetCategory({
    required this.name,
    required this.amount,
    required this.percentChange,
    required this.isUp,
  });

  final String name;
  final String amount;
  final String percentChange;
  final bool isUp;
}

class PredictedBudgetState {
  const PredictedBudgetState({
    this.selectedMonth = 'April',
    this.categories = const [],
    this.isLoading = false,
  });

  final String selectedMonth;
  final List<BudgetCategory> categories;
  final bool isLoading;

  PredictedBudgetState copyWith({
    String? selectedMonth,
    List<BudgetCategory>? categories,
    bool? isLoading,
  }) =>
      PredictedBudgetState(
        selectedMonth: selectedMonth ?? this.selectedMonth,
        categories: categories ?? this.categories,
        isLoading: isLoading ?? this.isLoading,
      );
}

class PredictedBudgetController extends StateNotifier<PredictedBudgetState> {
  PredictedBudgetController() : super(const PredictedBudgetState()) {
    _loadSampleData();
  }

  static const _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  List<String> get months => _months;

  void setMonth(String month) {
    state = state.copyWith(selectedMonth: month);
    _loadSampleData();
  }

  void _loadSampleData() {
    // TODO: replace with real API call
    state = state.copyWith(
      categories: const [
        BudgetCategory(
          name: 'Employee service',
          amount: '₦280,000',
          percentChange: '51.6%',
          isUp: true,
        ),
        BudgetCategory(
          name: 'Rent',
          amount: '₦320,000',
          percentChange: '51.6%',
          isUp: true,
        ),
        BudgetCategory(
          name: 'Utilities',
          amount: '₦50,000',
          percentChange: '51.6%',
          isUp: false,
        ),
        BudgetCategory(
          name: 'Travel',
          amount: '₦50,000',
          percentChange: '51.6%',
          isUp: false,
        ),
        BudgetCategory(
          name: 'Transportation',
          amount: '₦50,000',
          percentChange: '51.6%',
          isUp: false,
        ),
        BudgetCategory(
          name: 'Salary',
          amount: '₦320,000',
          percentChange: '51.6%',
          isUp: true,
        ),
      ],
    );
  }
}

final predictedBudgetControllerProvider = StateNotifierProvider.autoDispose<
    PredictedBudgetController, PredictedBudgetState>(
  (ref) => PredictedBudgetController(),
);
