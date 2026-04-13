import 'api_client.dart';
import '../models/income_model.dart';
import '../models/income_summary_model.dart';

class IncomeApi {
  IncomeApi({ApiClient? apiClient}) : _api = apiClient ?? ApiClient();

  final ApiClient _api;

  Future<IncomeListResponse> getIncomes({
    String? search,
    String? customerId,
    String? status,
    String? startDate,
    String? endDate,
    int skip = 0,
    int take = 20,
  }) async {
    final q = <String, String>{'skip': '$skip', 'take': '$take'};
    if (search != null && search.isNotEmpty) q['search'] = search;
    if (customerId != null && customerId.isNotEmpty)
      q['customerId'] = customerId;
    if (status != null && status.isNotEmpty) q['status'] = status;
    if (startDate != null && startDate.isNotEmpty) q['startDate'] = startDate;
    if (endDate != null && endDate.isNotEmpty) q['endDate'] = endDate;
    final response = await _api.getJson(
      '/api/v1/income',
      queryParameters: q,
      auth: true,
    );
    return IncomeListResponse.fromJson(response);
  }

  Future<Map<String, dynamic>> getIncome(String id) async {
    return _api.getJson('/api/v1/income/$id', auth: true);
  }

  Future<IncomeSummary> getSummary() async {
    final response = await _api.getJson('/api/v1/income/summary', auth: true);
    return IncomeSummary.fromJson(response);
  }

  Future<Map<String, dynamic>> createIncome({
    required String invoiceDate,
    required String dueDate,
    required String customerId,
    required List<Map<String, dynamic>> items,
    double taxRate = 0,
    double discount = 0,
    double shippingFee = 0,
    String notes = '',
    String bankName = '',
    String accountNumber = '',
    String accountName = '',
    String status = 'PENDING',
  }) async {
    return _api.postJson(
      '/api/v1/income',
      body: {
        'invoiceDate': invoiceDate,
        'dueDate': dueDate,
        'customerId': customerId,
        'items': items,
        'taxRate': taxRate,
        'discount': discount,
        'shippingFee': shippingFee,
        'notes': notes,
        'bankName': bankName,
        'accountNumber': accountNumber,
        'accountName': accountName,
        'status': status,
      },
      auth: true,
    );
  }

  Future<Map<String, dynamic>> updateIncome(
    String id, {
    required String invoiceDate,
    required String dueDate,
    required String customerId,
    required List<Map<String, dynamic>> items,
    double taxRate = 0,
    double discount = 0,
    double shippingFee = 0,
    String notes = '',
    String bankName = '',
    String accountNumber = '',
    String accountName = '',
    String status = 'PENDING',
  }) async {
    return _api.putJson(
      '/api/v1/income/$id',
      body: {
        'invoiceDate': invoiceDate,
        'dueDate': dueDate,
        'customerId': customerId,
        'items': items,
        'taxRate': taxRate,
        'discount': discount,
        'shippingFee': shippingFee,
        'notes': notes,
        'bankName': bankName,
        'accountNumber': accountNumber,
        'accountName': accountName,
        'status': status,
      },
      auth: true,
    );
  }

  Future<Map<String, dynamic>> deleteIncome(String id) async {
    return _api.deleteJson('/api/v1/income/$id', auth: true);
  }

  Future<Map<String, dynamic>> generatePdf(String id) async {
    return _api.postJson(
      '/api/v1/income/$id/generate-pdf',
      body: {},
      auth: true,
    );
  }
}
