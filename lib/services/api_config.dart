class ApiConfig {
  static const String baseUrl = 'https://finance-business-be.fly.dev';

  static Uri uri(String path, [Map<String, String>? queryParameters]) {
    return Uri.parse(baseUrl).replace(
      path: path,
      queryParameters: queryParameters,
    );
  }
}
