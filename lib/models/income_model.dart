import 'package:intl/intl.dart';

class IncomeListResponse {
  const IncomeListResponse({
    required this.data,
    required this.total,
    required this.totalAmount,
  });

  factory IncomeListResponse.fromJson(Map<String, dynamic> json) {
    final data = <Income>[];
    if (json['data'] is List) {
      data.addAll(
        (json['data'] as List).map(
          (e) => Income.fromJson(e as Map<String, dynamic>),
        ),
      );
    }
    return IncomeListResponse(
      data: data,
      total: json['total'] as int? ?? 0,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
    );
  }

  final List<Income> data;
  final int total;
  final double totalAmount;
}

class Income {
  const Income({
    required this.id,
    required this.invoiceNumber,
    required this.invoiceDate,
    required this.dueDate,
    required this.status,
    required this.subtotal,
    required this.taxRate,
    required this.taxAmount,
    required this.discount,
    required this.shippingFee,
    required this.total,
    required this.bankName,
    required this.accountNumber,
    required this.accountName,
    required this.notes,
    required this.userId,
    required this.customerId,
    this.customer,
    required this.items,
  });

  factory Income.fromJson(Map<String, dynamic> json) {
    // Helper function to parse both string and numeric values to double
    double parseDynamic(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return Income(
      id: json['id'] as String,
      invoiceNumber: json['invoiceNumber'] as String? ?? '',
      invoiceDate: DateTime.parse(json['invoiceDate'] as String),
      dueDate: DateTime.parse(json['dueDate'] as String),
      status: json['status'] as String? ?? 'PENDING',
      subtotal: parseDynamic(json['subtotal']),
      taxRate: parseDynamic(json['taxRate']),
      taxAmount: parseDynamic(json['taxAmount']),
      discount: parseDynamic(json['discount']),
      shippingFee: parseDynamic(json['shippingFee']),
      total: parseDynamic(json['total']),
      bankName: json['bankName'] as String? ?? '',
      accountNumber: json['accountNumber'] as String? ?? '',
      accountName: json['accountName'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      userId: json['userId'] as String,
      customerId: json['customerId'] as String,
      customer:
          json['customer'] != null
              ? Customer.fromJson(json['customer'] as Map<String, dynamic>)
              : null,
      items:
          (json['items'] as List?)
              ?.map((e) => IncomeItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  final String id;
  final String invoiceNumber;
  final DateTime invoiceDate;
  final DateTime dueDate;
  final String status;
  final double subtotal;
  final double taxRate;
  final double taxAmount;
  final double discount;
  final double shippingFee;
  final double total;
  final String bankName;
  final String accountNumber;
  final String accountName;
  final String notes;
  final String userId;
  final String customerId;
  final Customer? customer;
  final List<IncomeItem> items;

  // Computed properties for UI
  String get formattedInvoiceDate => _dateFmt.format(invoiceDate);
  String get formattedDueDate => _dateFmt.format(dueDate);
  String get formattedAmount => '₦${_numFmt.format(total)}';
  String get displayStatus => status[0] + status.substring(1).toLowerCase();
  String get customerName => customer?.fullName ?? customerId;
  int get totalQuantity => items.fold(0, (sum, item) => sum + item.quantity);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoiceNumber': invoiceNumber,
      'invoiceDate': invoiceDate.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'status': status,
      'subtotal': subtotal,
      'taxRate': taxRate,
      'taxAmount': taxAmount,
      'discount': discount,
      'shippingFee': shippingFee,
      'total': total,
      'bankName': bankName,
      'accountNumber': accountNumber,
      'accountName': accountName,
      'notes': notes,
      'userId': userId,
      'customerId': customerId,
      'customer': customer?.toJson(),
      'items': items.map((e) => e.toJson()).toList(),
    };
  }

  static final _dateFmt = DateFormat('MMM dd, yyyy');
  static final _numFmt = NumberFormat('#,##0');
}

class Customer {
  const Customer({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.city,
    required this.country,
    required this.dateAdded,
    required this.lastInteraction,
    required this.userId,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] as String,
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      city: json['city'] as String? ?? '',
      country: json['country'] as String? ?? '',
      dateAdded: DateTime.parse(json['dateAdded'] as String),
      lastInteraction: DateTime.parse(json['lastInteraction'] as String),
      userId: json['userId'] as String,
    );
  }

  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String city;
  final String country;
  final DateTime dateAdded;
  final DateTime lastInteraction;
  final String userId;

  String get fullName => '$firstName $lastName'.trim();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'city': city,
      'country': country,
      'dateAdded': dateAdded.toIso8601String(),
      'lastInteraction': lastInteraction.toIso8601String(),
      'userId': userId,
    };
  }
}

class IncomeItem {
  const IncomeItem({
    required this.id,
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.amount,
    required this.incomeId,
  });

  factory IncomeItem.fromJson(Map<String, dynamic> json) {
    // Helper function to parse both string and numeric values to double
    double parseDynamic(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    // Helper function to parse both string and numeric values to int
    int parseIntDynamic(dynamic value) {
      if (value == null) return 0;
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    return IncomeItem(
      id: json['id'] as String,
      description: json['description'] as String? ?? '',
      quantity: parseIntDynamic(json['quantity']),
      unitPrice: parseDynamic(json['unitPrice']),
      amount: parseDynamic(json['amount']),
      incomeId: json['incomeId'] as String,
    );
  }

  final String id;
  final String description;
  final int quantity;
  final double unitPrice;
  final double amount;
  final String incomeId;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'amount': amount,
      'incomeId': incomeId,
    };
  }
}
