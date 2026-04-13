import 'api_client.dart';

class CustomerApi {
  CustomerApi({ApiClient? apiClient}) : _api = apiClient ?? ApiClient();

  final ApiClient _api;

  /// GET /api/v1/customers?search=&city=&skip=0&take=20
  Future<Map<String, dynamic>> getCustomers({
    String? search,
    String? city,
    int skip = 0,
    int take = 20,
  }) async {
    final query = <String, String>{
      'skip': skip.toString(),
      'take': take.toString(),
    };
    if (search != null && search.isNotEmpty) query['search'] = search;
    if (city != null && city.isNotEmpty) query['city'] = city;

    return _api.getJson('/api/v1/customers', queryParameters: query, auth: true);
  }

  /// GET /api/v1/customers/{id}
  Future<Map<String, dynamic>> getCustomer(String id) async {
    return _api.getJson('/api/v1/customers/$id', auth: true);
  }

  /// POST /api/v1/customers
  Future<Map<String, dynamic>> createCustomer({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String city,
    required String country,
  }) async {
    return _api.postJson(
      '/api/v1/customers',
      body: {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phoneNumber': phoneNumber,
        'city': city,
        'country': country,
      },
      auth: true,
    );
  }

  /// PUT /api/v1/customers/{id}
  Future<Map<String, dynamic>> updateCustomer({
    required String id,
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String city,
    required String country,
  }) async {
    return _api.putJson(
      '/api/v1/customers/$id',
      body: {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phoneNumber': phoneNumber,
        'city': city,
        'country': country,
      },
      auth: true,
    );
  }

  /// DELETE /api/v1/customers/{id}
  Future<Map<String, dynamic>> deleteCustomer(String id) async {
    return _api.deleteJson('/api/v1/customers/$id', auth: true);
  }

  /// POST /api/v1/customers/import
  Future<Map<String, dynamic>> importCustomers(List<String> rawRecords) async {
    return _api.postJson(
      '/api/v1/customers/import',
      body: {'data': rawRecords},
      auth: true,
    );
  }
}
