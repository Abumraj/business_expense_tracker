import 'api_client.dart';

class UserApi {
  UserApi({ApiClient? apiClient}) : _api = apiClient ?? ApiClient();

  final ApiClient _api;

  /// GET /api/v1/auth/profile
  Future<Map<String, dynamic>> getProfile() async {
    return _api.getJson('/api/v1/auth/profile', auth: true);
  }

  /// GET /api/v1/users/profile/{id}
  Future<Map<String, dynamic>> getProfileById(String id) async {
    return _api.getJson('/api/v1/users/profile/$id', auth: true);
  }

  /// PUT /api/v1/users/profile
  Future<Map<String, dynamic>> updateProfile({
    required String id,
    required String firstName,
    required String lastName,
    String? country,
    String? phoneNumber,
    bool? isVerified,
    String? roleId,
  }) async {
    final body = <String, dynamic>{
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
    };
    if (country != null) body['country'] = country;
    if (phoneNumber != null) body['phoneNumber'] = phoneNumber;
    if (isVerified != null) body['isVerified'] = isVerified;
    if (roleId != null) body['roleId'] = roleId;

    return _api.putJson('/api/v1/users/profile', body: body, auth: true);
  }

  /// POST /api/v1/auth/change-password
  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    return _api.postJson('/api/v1/auth/change-password', body: {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    }, auth: true);
  }

  /// POST /api/v1/auth/refresh-token
  Future<Map<String, dynamic>> refreshToken() async {
    return _api.postJson('/api/v1/auth/refresh-token', body: {});
  }
}
