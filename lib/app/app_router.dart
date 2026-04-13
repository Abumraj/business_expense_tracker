import 'package:go_router/go_router.dart';

import '../screens/add_category_screen.dart';
import '../screens/add_customer_screen.dart';
import '../screens/add_expense_screen.dart';
import '../screens/add_income_screen.dart';
import '../screens/create_account_screen.dart';
import '../screens/customer_detail_screen.dart';
import '../screens/customer_list_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/expense_details_screen.dart';
import '../screens/expense_list_screen.dart';
import '../screens/fraud_alert_screen.dart';
import '../screens/income_list_screen.dart';
import '../screens/edit_income_status_screen.dart';
import '../screens/invoice_detail_screen.dart';
import '../screens/login_screen.dart';
import '../screens/login_success_screen.dart';
import '../screens/new_password_screen.dart';
import '../screens/predicted_budget_screen.dart';
import '../screens/reset_password_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/verification_screen.dart';

class AppRoutes {
  static const login = '/login';
  static const createAccount = '/create-account';
  static const verify = '/verify';
  static const resetPassword = '/reset-password';
  static const newPassword = '/new-password';
  static const loginSuccess = '/login-success';

  // Expense flow
  static const expenseList = '/expenses';
  static const addExpense = '/add-expense';
  static const expenseDetails = '/expense-details';
  static const addCategory = '/add-category';
  static const predictedBudget = '/predicted-budget';

  // Income flow
  static const incomeList = '/income';
  static const addIncome = '/add-income';
  static const editIncome = '/edit-income';
  static const invoiceDetail = '/invoice-detail';

  // Dashboard + Fraud
  static const dashboard = '/dashboard';
  static const fraudAlert = '/fraud-alert';

  // Customers
  static const customerList = '/customers';
  static const customerDetail = '/customer-detail';
  static const addCustomer = '/add-customer';
  static const editCustomer = '/edit-customer';
}

GoRouter buildRouter() {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.createAccount,
        builder: (context, state) => const CreateAccountScreen(),
      ),
      GoRoute(
        path: AppRoutes.verify,
        builder: (context, state) {
          final email = state.uri.queryParameters['email'] ?? '';
          final flow = state.uri.queryParameters['flow'] ?? '';
          return VerificationScreen(email: email, flow: flow);
        },
      ),
      GoRoute(
        path: AppRoutes.resetPassword,
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.newPassword,
        builder: (context, state) {
          final email = state.uri.queryParameters['email'] ?? '';
          final otp = state.uri.queryParameters['otp'];
          return NewPasswordScreen(email: email, otp: otp);
        },
      ),
      GoRoute(
        path: AppRoutes.loginSuccess,
        builder: (context, state) => const LoginSuccessScreen(),
      ),

      // ── Expense flow ──
      GoRoute(
        path: AppRoutes.expenseList,
        builder: (context, state) => const ExpenseListScreen(),
      ),
      GoRoute(
        path: AppRoutes.addExpense,
        builder: (context, state) => const AddExpenseScreen(),
      ),
      GoRoute(
        path: AppRoutes.expenseDetails,
        builder: (context, state) {
          final extra = state.extra as Map<String, String>? ?? {};
          return ExpenseDetailsScreen(
            amount: extra['amount'] ?? '',
            quantity: extra['quantity'] ?? '',
            category: extra['category'] ?? '',
            paymentMethod: extra['paymentMethod'] ?? '',
            unitAmount: extra['unitAmount'] ?? '',
            totalCost: extra['totalCost'] ?? '',
            description: extra['description'] ?? '',
            date: extra['date'] ?? '',
          );
        },
      ),
      GoRoute(
        path: AppRoutes.addCategory,
        builder: (context, state) => const AddCategoryScreen(),
      ),
      GoRoute(
        path: AppRoutes.predictedBudget,
        builder: (context, state) => const PredictedBudgetScreen(),
      ),

      // ── Income flow ──
      GoRoute(
        path: AppRoutes.incomeList,
        builder: (context, state) => const IncomeListScreen(),
      ),
      GoRoute(
        path: AppRoutes.addIncome,
        builder: (context, state) => const AddIncomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.editIncome,
        builder: (context, state) {
          final income = state.extra as Map<String, dynamic>?;
          return EditIncomeStatusScreen(income: income ?? {});
        },
      ),
      GoRoute(
        path: AppRoutes.invoiceDetail,
        builder: (context, state) => const InvoiceDetailScreen(),
      ),

      // ── Dashboard + Fraud ──
      GoRoute(
        path: AppRoutes.dashboard,
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.fraudAlert,
        builder: (context, state) => const FraudAlertScreen(),
      ),

      // ── Customers ──
      GoRoute(
        path: AppRoutes.customerList,
        builder: (context, state) => const CustomerListScreen(),
      ),
      GoRoute(
        path: AppRoutes.customerDetail,
        builder: (context, state) {
          final customer = state.extra as Map<String, dynamic>?;
          return CustomerDetailScreen(customer: customer);
        },
      ),
      GoRoute(
        path: AppRoutes.addCustomer,
        builder: (context, state) => const AddCustomerScreen(),
      ),
      GoRoute(
        path: AppRoutes.editCustomer,
        builder: (context, state) {
          final customer = state.extra as Map<String, dynamic>?;
          return AddCustomerScreen(isEdit: true, customer: customer);
        },
      ),
    ],
  );
}
