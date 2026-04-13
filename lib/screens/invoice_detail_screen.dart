import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/invoice_preview.dart';

class InvoiceDetailScreen extends StatelessWidget {
  const InvoiceDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data — will be replaced with real data during API integration
    final sampleItems = [
      const InvoiceLineItem(
        description: 'Don Julio',
        quantity: 1,
        unitPrice: 350000,
        amount: 350000,
      ),
      const InvoiceLineItem(
        description: 'Azul',
        quantity: 2,
        unitPrice: 700000,
        amount: 700000,
      ),
    ];

    return InvoicePreview(
      businessName: 'T&G Parties',
      invoiceNumber: '#001',
      dateOfIssue: 'Jul 24, 2025',
      dueDate: 'Jul 31, 2025',
      fromName: 'T&G Parties',
      fromEmail: 'hello@tgparties.com',
      fromPhone: '+2348088049907',
      toName: 'Purplegate',
      toEmail: 'hello@purplegate.com',
      toPhone: '+2348088049907',
      items: sampleItems,
      subtotal: 1050000,
      tax: 1000,
      shippingFee: 3000,
      totalAmount: 3000,
      notes: 'Payment should be made on time',
      bankName: 'Palmpay',
      accountNumber: '9122112260',
      accountName: 'Temilade Adekeye',
      onClose: () => context.pop(),
    );
  }
}
