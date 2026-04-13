import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'auth_api.dart';
import 'service_providers.dart';
import 'token_storage.dart';

class AuthService {
  AuthService({required this.authApi, required this.tokenStorage});

  final AuthApi authApi;
  final TokenStorage tokenStorage;

  /// Handle authentication error (401 or session expired)
  Future<void> handleAuthError(GoRouter router) async {
    // Clear stored tokens
    await tokenStorage.clear();

    // Navigate to login screen, clearing all previous routes
    if (router.canPop()) {
      while (router.canPop()) {
        router.pop();
      }
    }
    router.go('/login');
  }

  /// Check if user is logged in (has valid access token)
  Future<bool> isLoggedIn() async {
    final token = await tokenStorage.getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// Logout user and navigate to login
  Future<void> logout(GoRouter router) async {
    await authApi.logout();
    await handleAuthError(router);
  }
}

// Provider for AuthService
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(
    authApi: ref.watch(authApiProvider),
    tokenStorage: TokenStorage(),
  );
});
