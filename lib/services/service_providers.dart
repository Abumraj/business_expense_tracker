import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_client.dart';
import 'auth_api.dart';
import 'auth_service.dart';
import 'customer_api.dart';
import 'income_api.dart';
import 'token_storage.dart';
import 'user_api.dart';

final tokenStorageProvider = Provider<TokenStorage>((ref) => TokenStorage());

final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(tokenStorage: ref.read(tokenStorageProvider)),
);

final authApiProvider = Provider<AuthApi>(
  (ref) => AuthApi(
    apiClient: ref.read(apiClientProvider),
    tokenStorage: ref.read(tokenStorageProvider),
  ),
);

final authServiceProvider = Provider<AuthService>(
  (ref) => AuthService(
    authApi: ref.read(authApiProvider),
    tokenStorage: ref.read(tokenStorageProvider),
  ),
);

final customerApiProvider = Provider<CustomerApi>(
  (ref) => CustomerApi(apiClient: ref.read(apiClientProvider)),
);

final incomeApiProvider = Provider<IncomeApi>(
  (ref) => IncomeApi(apiClient: ref.read(apiClientProvider)),
);

final userApiProvider = Provider<UserApi>(
  (ref) => UserApi(apiClient: ref.read(apiClientProvider)),
);
