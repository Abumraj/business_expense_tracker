import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_config.dart';
import 'auth_api.dart';
import 'token_storage.dart';

class ApiException implements Exception {
  ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() =>
      'ApiException(statusCode: $statusCode, message: $message)';
}

class ApiClient {
  ApiClient({http.Client? client, TokenStorage? tokenStorage})
    : _client = client ?? http.Client(),
      _tokenStorage = tokenStorage ?? TokenStorage();

  final http.Client _client;
  final TokenStorage _tokenStorage;

  AuthApi get _authApi => AuthApi(apiClient: this, tokenStorage: _tokenStorage);

  Future<Map<String, dynamic>> getJson(
    String path, {
    Map<String, String>? queryParameters,
    bool auth = false,
  }) async {
    final uri = ApiConfig.uri(path, queryParameters);

    return _handleRequest(() async {
      final headers = await _headers(auth: auth);
      return _client.get(uri, headers: headers);
    });
  }

  Future<Map<String, dynamic>> postJson(
    String path, {
    Map<String, String>? queryParameters,
    required Map<String, dynamic> body,
    bool auth = false,
  }) async {
    final uri = ApiConfig.uri(path, queryParameters);

    return _handleRequest(() async {
      final headers = await _headers(auth: auth);
      return _client.post(uri, headers: headers, body: jsonEncode(body));
    });
  }

  Future<Map<String, dynamic>> putJson(
    String path, {
    Map<String, String>? queryParameters,
    required Map<String, dynamic> body,
    bool auth = false,
  }) async {
    final uri = ApiConfig.uri(path, queryParameters);

    return _handleRequest(() async {
      final headers = await _headers(auth: auth);
      return _client.put(uri, headers: headers, body: jsonEncode(body));
    });
  }

  Future<Map<String, dynamic>> deleteJson(
    String path, {
    Map<String, String>? queryParameters,
    bool auth = false,
  }) async {
    final uri = ApiConfig.uri(path, queryParameters);

    return _handleRequest(() async {
      final headers = await _headers(auth: auth);
      return _client.delete(uri, headers: headers);
    });
  }

  Future<Map<String, String>> _headers({required bool auth}) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (auth) {
      final token = await _tokenStorage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  Map<String, dynamic> _decodeOrThrow(http.Response resp) {
    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      if (resp.body.isEmpty) return <String, dynamic>{};
      final decoded = jsonDecode(resp.body);
      if (decoded is Map<String, dynamic>) return decoded;
      return {'data': decoded};
    }

    String message = 'Request failed';
    try {
      final decoded = jsonDecode(resp.body);
      if (decoded is Map && decoded['message'] != null) {
        message = decoded['message'].toString();
      } else {
        message = resp.body;
      }
    } catch (_) {
      message = resp.body.isNotEmpty ? resp.body : message;
    }

    throw ApiException(message, statusCode: resp.statusCode);
  }

  Future<Map<String, dynamic>> _handleRequest(
    Future<http.Response> Function() requestFn,
  ) async {
    try {
      final resp = await requestFn();
      return _decodeOrThrow(resp);
    } on ApiException catch (e) {
      // Handle 401 Unauthorized with token refresh
      if (e.statusCode == 401) {
        final refreshSuccess = await _authApi.refreshToken();
        if (refreshSuccess) {
          // Retry the request with new token
          try {
            final resp = await requestFn();
            return _decodeOrThrow(resp);
          } catch (_) {
            // Retry failed, throw the original error
            rethrow;
          }
        } else {
          // Refresh failed, throw a special error to trigger logout
          throw ApiException(
            'Session expired. Please login again.',
            statusCode: 401,
          );
        }
      }
      rethrow;
    }
  }
}
