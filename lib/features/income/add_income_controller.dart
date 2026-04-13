import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/api_client.dart';
import '../../services/service_providers.dart';

class Customer {
  const Customer({required this.id, required this.name});

  final String id;
  final String name;

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id']?.toString() ?? '',
      name: '${json['firstName'] ?? ''} ${json['lastName'] ?? ''}'.trim(),
    );
  }
}

class InvoiceItem {
  const InvoiceItem({
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.amount,
  });

  final String description;
  final int quantity;
  final double unitPrice;
  final double amount;

  InvoiceItem copyWith({
    String? description,
    int? quantity,
    double? unitPrice,
    double? amount,
  }) => InvoiceItem(
    description: description ?? this.description,
    quantity: quantity ?? this.quantity,
    unitPrice: unitPrice ?? this.unitPrice,
    amount: amount ?? this.amount,
  );
}

enum AddIncomeStatus { idle, loading, success, error }

class AddIncomeState {
  const AddIncomeState({
    this.invoiceNumber = '#001',
    this.invoiceDate,
    this.customer,
    this.customerName,
    this.dueDate,
    this.items = const [],
    this.notes = '',
    this.bankName = '',
    this.accountNumber = '',
    this.accountName = '',
    this.tax = '',
    this.discount = '',
    this.shippingFee = '',
    this.customers = const [],
    this.incomeId,
    this.status = AddIncomeStatus.idle,
    this.errorMessage,
  });

  final String invoiceNumber;
  final DateTime? invoiceDate;
  final String? customer;
  final String? customerName;
  final DateTime? dueDate;
  final List<InvoiceItem> items;
  final String notes;
  final String bankName;
  final String accountNumber;
  final String accountName;
  final String tax;
  final String discount;
  final String shippingFee;
  final List<Customer> customers;
  final String? incomeId;
  final AddIncomeStatus status;
  final String? errorMessage;

  double get totalAmount => items.fold(0.0, (sum, item) => sum + item.amount);

  double get subtotal => totalAmount;

  double get taxAmount {
    final rate = double.tryParse(tax) ?? 0;
    return subtotal * rate / 100;
  }

  double get discountAmount => double.tryParse(discount) ?? 0;

  double get shippingFeeAmount => double.tryParse(shippingFee) ?? 0;

  double get total => subtotal + taxAmount - discountAmount + shippingFeeAmount;

  bool get canSubmit =>
      invoiceNumber.isNotEmpty &&
      invoiceDate != null &&
      customer != null &&
      dueDate != null &&
      items.isNotEmpty &&
      status != AddIncomeStatus.loading;

  AddIncomeState copyWith({
    String? invoiceNumber,
    DateTime? invoiceDate,
    String? customer,
    String? customerName,
    DateTime? dueDate,
    List<InvoiceItem>? items,
    String? notes,
    String? bankName,
    String? accountNumber,
    String? accountName,
    String? tax,
    String? discount,
    String? shippingFee,
    List<Customer>? customers,
    String? incomeId,
    AddIncomeStatus? status,
    String? errorMessage,
  }) => AddIncomeState(
    invoiceNumber: invoiceNumber ?? this.invoiceNumber,
    invoiceDate: invoiceDate ?? this.invoiceDate,
    customer: customer ?? this.customer,
    customerName: customerName ?? this.customerName,
    dueDate: dueDate ?? this.dueDate,
    items: items ?? this.items,
    notes: notes ?? this.notes,
    bankName: bankName ?? this.bankName,
    accountNumber: accountNumber ?? this.accountNumber,
    accountName: accountName ?? this.accountName,
    tax: tax ?? this.tax,
    discount: discount ?? this.discount,
    shippingFee: shippingFee ?? this.shippingFee,
    customers: customers ?? this.customers,
    incomeId: incomeId ?? this.incomeId,
    status: status ?? this.status,
    errorMessage: errorMessage,
  );
}

class AddIncomeController extends StateNotifier<AddIncomeState> {
  AddIncomeController(this._ref, {String? incomeId})
    : super(AddIncomeState(invoiceDate: DateTime.now(), incomeId: incomeId));

  final Ref _ref;

  void setInvoiceNumber(String v) {
    try {
      state = state.copyWith(invoiceNumber: v);
    } catch (_) {
      // Controller disposed, ignore
    }
  }

  void setInvoiceDate(DateTime v) {
    try {
      state = state.copyWith(invoiceDate: v);
    } catch (_) {
      // Controller disposed, ignore
    }
  }

  void setCustomer(String? customerId, {String? customerName}) {
    try {
      state = state.copyWith(customer: customerId, customerName: customerName);
    } catch (_) {
      // Controller disposed, ignore
    }
  }

  Future<void> loadCustomers() async {
    try {
      final api = _ref.read(customerApiProvider);
      final response = await api.getCustomers();
      final list = response['data'];
      if (list is List) {
        final customers =
            list
                .cast<Map<String, dynamic>>()
                .map((json) => Customer.fromJson(json))
                .where((customer) => customer.id.isNotEmpty)
                .toList();
        state = state.copyWith(customers: customers);
      }
    } catch (_) {
      // Controller disposed, ignore
    }
  }

  void setDueDate(DateTime v) {
    try {
      state = state.copyWith(dueDate: v);
    } catch (_) {
      // Controller disposed, ignore
    }
  }

  void setNotes(String v) {
    try {
      state = state.copyWith(notes: v);
    } catch (_) {
      // Controller disposed, ignore
    }
  }

  void setBankName(String v) {
    try {
      state = state.copyWith(bankName: v);
    } catch (_) {
      // Controller disposed, ignore
    }
  }

  void setAccountNumber(String v) {
    try {
      state = state.copyWith(accountNumber: v);
    } catch (_) {
      // Controller disposed, ignore
    }
  }

  void setAccountName(String v) {
    try {
      state = state.copyWith(accountName: v);
    } catch (_) {
      // Controller disposed, ignore
    }
  }

  void setTax(String v) {
    try {
      state = state.copyWith(tax: v);
    } catch (_) {
      // Controller disposed, ignore
    }
  }

  void setDiscount(String v) {
    try {
      state = state.copyWith(discount: v);
    } catch (_) {
      // Controller disposed, ignore
    }
  }

  void setShippingFee(String v) {
    try {
      state = state.copyWith(shippingFee: v);
    } catch (_) {
      // Controller disposed, ignore
    }
  }

  void addItem(InvoiceItem item) {
    try {
      state = state.copyWith(items: [...state.items, item]);
    } catch (_) {
      // Controller disposed, ignore
    }
  }

  void removeItem(int index) {
    try {
      final updated = List<InvoiceItem>.from(state.items)..removeAt(index);
      state = state.copyWith(items: updated);
    } catch (_) {
      // Controller disposed, ignore
    }
  }

  void updateItem(int index, InvoiceItem item) {
    try {
      final updated = List<InvoiceItem>.from(state.items);
      updated[index] = item;
      state = state.copyWith(items: updated);
    } catch (_) {
      // Controller disposed, ignore
    }
  }

  Future<bool> submit() async {
    if (!state.canSubmit) return false;
    try {
      state = state.copyWith(status: AddIncomeStatus.loading);
    } catch (_) {
      // Controller disposed, ignore
      return false;
    }
    try {
      // Format dates as YYYY-MM-DD for API
      final invoiceDateStr =
          '${state.invoiceDate!.year.toString().padLeft(4, '0')}-${state.invoiceDate!.month.toString().padLeft(2, '0')}-${state.invoiceDate!.day.toString().padLeft(2, '0')}';
      final dueDateStr =
          '${state.dueDate!.year.toString().padLeft(4, '0')}-${state.dueDate!.month.toString().padLeft(2, '0')}-${state.dueDate!.day.toString().padLeft(2, '0')}';

      final api = _ref.read(incomeApiProvider);

      if (state.incomeId != null) {
        // Update existing income
        await api.updateIncome(
          state.incomeId!,
          invoiceDate: invoiceDateStr,
          dueDate: dueDateStr,
          customerId: state.customer!,
          items:
              state.items
                  .map(
                    (i) => {
                      'description': i.description,
                      'quantity': i.quantity,
                      'unitPrice': i.unitPrice,
                    },
                  )
                  .toList(),
          taxRate: double.tryParse(state.tax) ?? 0,
          discount: double.tryParse(state.discount) ?? 0,
          shippingFee: double.tryParse(state.shippingFee) ?? 0,
          notes: state.notes,
          bankName: state.bankName,
          accountNumber: state.accountNumber,
          accountName: state.accountName,
        );
      } else {
        // Create new income
        await api.createIncome(
          invoiceDate: invoiceDateStr,
          dueDate: dueDateStr,
          customerId: state.customer!,
          items:
              state.items
                  .map(
                    (i) => {
                      'description': i.description,
                      'quantity': i.quantity,
                      'unitPrice': i.unitPrice,
                    },
                  )
                  .toList(),
          taxRate: double.tryParse(state.tax) ?? 0,
          discount: double.tryParse(state.discount) ?? 0,
          shippingFee: double.tryParse(state.shippingFee) ?? 0,
          notes: state.notes,
          bankName: state.bankName,
          accountNumber: state.accountNumber,
          accountName: state.accountName,
        );
      }
      try {
        state = state.copyWith(status: AddIncomeStatus.success);
      } catch (_) {
        // Controller disposed, ignore
      }
      return true;
    } on ApiException catch (e) {
      print(e);
      try {
        state = state.copyWith(
          status: AddIncomeStatus.error,
          errorMessage: e.message,
        );
      } catch (_) {
        // Controller disposed, ignore
      }
      return false;
    } catch (e) {
      try {
        state = state.copyWith(
          status: AddIncomeStatus.error,
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
      state = AddIncomeState(invoiceDate: DateTime.now());
    } catch (_) {
      // Controller disposed, ignore
    }
  }
}

final addIncomeControllerProvider =
    StateNotifierProvider.autoDispose<AddIncomeController, AddIncomeState>(
      (ref) => AddIncomeController(ref),
    );

final editIncomeControllerProvider = StateNotifierProvider.autoDispose
    .family<AddIncomeController, AddIncomeState, String>(
      (ref, incomeId) => AddIncomeController(ref, incomeId: incomeId),
    );
