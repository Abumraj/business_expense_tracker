import 'api_client.dart';
import 'token_storage.dart';

class LoginResult {
  const LoginResult({
    required this.email,
    required this.isVerified,
    this.success = true,
    this.error,
  });
  final String email;
  final bool isVerified;
  final bool success;
  final String? error;
}

class AuthApi {
  AuthApi({ApiClient? apiClient, TokenStorage? tokenStorage})
    : _api = apiClient ?? ApiClient(),
      _tokenStorage = tokenStorage ?? TokenStorage();

  final ApiClient _api;
  final TokenStorage _tokenStorage;

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String businessName,
    required String phoneNumber,
    required String password,
    String platform = 'mobile',
  }) async {
    await _api.postJson(
      '/api/v1/auth/register',
      body: {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'businessName': businessName,
        'phoneNumber': phoneNumber,
        'password': password,
        'platform': platform,
      },
    );
  }

  Future<LoginResult> login({
    required String email,
    required String password,
    String platform = 'mobile',
  }) async {
    try {
      print('login called');
      final resp = await _api.postJson(
        '/api/v1/auth/login',
        queryParameters: {'platform': platform},
        body: {'email': email, 'password': password},
      );
      print(resp);
      final data = resp['data'] as Map<String, dynamic>? ?? resp;
      print(data);
      // Store tokens
      final accessToken = data['accessToken']?.toString();
      final refreshToken = data['refreshToken']?.toString();
      if (accessToken != null) await _tokenStorage.saveAccessToken(accessToken);
      if (refreshToken != null)
        await _tokenStorage.saveRefreshToken(refreshToken);

      // Extract user info
      final user = data['user'] as Map<String, dynamic>? ?? {};
      final isVerified = user['isVerified'] == true;
      final userEmail = user['email']?.toString() ?? email;

      return LoginResult(
        email: userEmail,
        isVerified: isVerified,
        success: true,
      );
    } on ApiException catch (e) {
      // API-specific errors (400, 401, 403, etc.)
      return LoginResult(
        email: email,
        isVerified: false,
        success: false,
        error: e.message,
      );
    } catch (e) {
      // Network or other unexpected errors
      return LoginResult(
        email: email,
        isVerified: false,
        success: false,
        error: 'Login failed. Please check your connection and try again.',
      );
    }
  }

  Future<void> requestOtp({required String email}) async {
    await _api.postJson('/api/v1/auth/otp/request', body: {'email': email});
  }

  Future<void> verifyOtp({required String email, required String otp}) async {
    await _api.postJson(
      '/api/v1/auth/otp/verify',
      body: {'email': email, 'otp': otp},
    );
  }

  Future<void> forgotPassword({required String email}) async {
    await _api.postJson('/api/v1/auth/forgot-password', body: {'email': email});
  }

  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    await _api.postJson(
      '/api/v1/auth/reset-password',
      body: {'email': email, 'otp': otp, 'newPassword': newPassword},
    );
  }

  Future<bool> refreshToken() async {
    try {
      final refreshToken = await _tokenStorage.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        return false;
      }

      final resp = await _api.postJson(
        '/api/v1/auth/refresh-token',
        body: {'refreshToken': refreshToken},
      );

      final data = resp['data'] as Map<String, dynamic>? ?? resp;

      // Store new tokens
      final accessToken = data['accessToken']?.toString();
      final newRefreshToken = data['refreshToken']?.toString();

      if (accessToken != null) {
        await _tokenStorage.saveAccessToken(accessToken);
      }
      if (newRefreshToken != null) {
        await _tokenStorage.saveRefreshToken(newRefreshToken);
      }

      return true;
    } catch (_) {
      // Refresh failed, clear tokens
      await _tokenStorage.clear();
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _api.postJson('/api/v1/auth/logout', body: {}, auth: true);
    } catch (_) {
      // ignore
    }
    await _tokenStorage.clear();
  }
}
