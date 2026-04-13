import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';

class IncomePdfGenerator {
  static Future<Uint8List> generate({
    required Map<String, dynamic> income,
  }) async {
    final doc = pw.Document();
    final fmt = NumberFormat('#,##0', 'en_US');

    double parseDouble(dynamic v) {
      if (v == null) return 0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0;
    }

    String formatDate(dynamic iso) {
      final s = iso?.toString();
      if (s == null || s.isEmpty) return '';
      final dt = DateTime.tryParse(s);
      if (dt == null) return '';
      return DateFormat('MMM dd, yyyy').format(dt);
    }

    String naira(dynamic v) {
      return '₦${fmt.format(parseDouble(v))}';
    }

    final invoiceNumber = income['invoiceNumber']?.toString() ?? '#001';
    final dateOfIssue = formatDate(income['invoiceDate']);
    final dueDate = formatDate(income['dueDate']);

    final customerName =
        (income['customer'] is Map)
            ? '${(income['customer'] as Map)['firstName'] ?? ''} ${(income['customer'] as Map)['lastName'] ?? ''}'
                .trim()
            : (income['customerName']?.toString() ??
                income['customerId']?.toString() ??
                '');

    final notes = income['notes']?.toString() ?? '';

    final bankName = income['bankName']?.toString() ?? '';
    final accountNumber = income['accountNumber']?.toString() ?? '';
    final accountName = income['accountName']?.toString() ?? '';

    final rawItems = (income['items'] as List?) ?? const [];
    final items =
        rawItems.whereType<Map>().map((e) {
          final qty = int.tryParse(e['quantity']?.toString() ?? '') ?? 0;
          final unitPrice = parseDouble(e['unitPrice']);
          final amount =
              e['amount'] != null ? parseDouble(e['amount']) : unitPrice * qty;
          return {
            'description': e['description']?.toString() ?? '',
            'quantity': qty,
            'unitPrice': unitPrice,
            'amount': amount,
          };
        }).toList();

    final subtotal = parseDouble(income['subtotal']);
    final taxAmount = parseDouble(income['taxAmount']);
    final shippingFee = parseDouble(income['shippingFee']);
    final total = parseDouble(income['total']);

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) {
          return [
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Invoice',
                      style: pw.TextStyle(
                        fontSize: 22,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    _pair('Invoice Number', invoiceNumber),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    _pair('Date of Issue', dateOfIssue),
                    pw.SizedBox(height: 6),
                    _pair('Due Date', dueDate),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 18),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(child: _pair('From', 'T&G Parties')),
                pw.SizedBox(width: 12),
                pw.Expanded(
                  child: pw.Align(
                    alignment: pw.Alignment.topRight,
                    child: _pair('Customer', customerName),
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 18),
            pw.Container(
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey300),
                borderRadius: pw.BorderRadius.circular(10),
              ),
              padding: const pw.EdgeInsets.all(12),
              child: pw.Column(
                children: [
                  pw.Row(
                    children: [
                      pw.Expanded(
                        flex: 5,
                        child: pw.Text(
                          'Description',
                          style: pw.TextStyle(
                            fontSize: 10,
                            color: PdfColors.grey600,
                          ),
                        ),
                      ),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Text(
                          'Quantity',
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            fontSize: 10,
                            color: PdfColors.grey600,
                          ),
                        ),
                      ),
                      pw.Expanded(
                        flex: 3,
                        child: pw.Text(
                          'Unit Price',
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            fontSize: 10,
                            color: PdfColors.grey600,
                          ),
                        ),
                      ),
                      pw.Expanded(
                        flex: 3,
                        child: pw.Text(
                          'Amount',
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            fontSize: 10,
                            color: PdfColors.grey600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  pw.Divider(color: PdfColors.grey300),
                  ...items.map(
                    (it) => pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 6),
                      child: pw.Row(
                        children: [
                          pw.Expanded(
                            flex: 5,
                            child: pw.Text(
                              it['description']?.toString() ?? '',
                              style: const pw.TextStyle(fontSize: 11),
                            ),
                          ),
                          pw.Expanded(
                            flex: 2,
                            child: pw.Text(
                              '${it['quantity'] ?? 0}',
                              textAlign: pw.TextAlign.right,
                              style: const pw.TextStyle(fontSize: 11),
                            ),
                          ),
                          pw.Expanded(
                            flex: 3,
                            child: pw.Text(
                              '₦${fmt.format(parseDouble(it['unitPrice']))}',
                              textAlign: pw.TextAlign.right,
                              style: const pw.TextStyle(fontSize: 11),
                            ),
                          ),
                          pw.Expanded(
                            flex: 3,
                            child: pw.Text(
                              '₦${fmt.format(parseDouble(it['amount']))}',
                              textAlign: pw.TextAlign.right,
                              style: const pw.TextStyle(fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 18),
            if (notes.trim().isNotEmpty) ...[
              pw.Text(
                'Notes',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 6),
              pw.Text(notes, style: const pw.TextStyle(fontSize: 11)),
              pw.SizedBox(height: 18),
            ],
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.SizedBox(
                  width: 220,
                  child: pw.Column(
                    children: [
                      _summaryRow('Subtotal', naira(subtotal)),
                      _summaryRow('Tax', naira(taxAmount)),
                      _summaryRow('Shipping Fee', naira(shippingFee)),
                      pw.Divider(color: PdfColors.grey300),
                      _summaryRow('Total', naira(total), bold: true),
                    ],
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 18),
            if (bankName.isNotEmpty ||
                accountNumber.isNotEmpty ||
                accountName.isNotEmpty) ...[
              pw.Text(
                'Bank Account Details',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 8),
              if (bankName.isNotEmpty)
                pw.Text(bankName, style: const pw.TextStyle(fontSize: 11)),
              if (accountNumber.isNotEmpty)
                pw.Text(accountNumber, style: const pw.TextStyle(fontSize: 11)),
              if (accountName.isNotEmpty)
                pw.Text(accountName, style: const pw.TextStyle(fontSize: 11)),
            ],
          ];
        },
      ),
    );

    final data = await doc.save();
    return Uint8List.fromList(data);
  }

  static pw.Widget _pair(String label, String value) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
        ),
        pw.SizedBox(height: 3),
        pw.Text(
          value,
          style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
        ),
      ],
    );
  }

  static pw.Widget _summaryRow(
    String label,
    String value, {
    bool bold = false,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
