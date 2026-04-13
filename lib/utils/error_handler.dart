import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../services/api_client.dart';
import '../services/auth_service.dart';
import 'toast_helper.dart';

class ErrorHandler {
  static void handleApiError(
    BuildContext context,
    Object error, {
    VoidCallback? onAuthError,
  }) {
    if (error is ApiException) {
      // Handle authentication errors
      if (error.statusCode == 401) {
        AppToast.error('Session expired. Please login again.');
        onAuthError?.call();
        return;
      }

      // Handle other API errors
      AppToast.error(error.message);
    } else {
      // Handle unexpected errors
      AppToast.error('An unexpected error occurred. Please try again.');
    }
  }

  static Future<T> withAuthHandling<T>(
    WidgetRef ref,
    BuildContext context,
    Future<T> Function() operation, {
    String? successMessage,
  }) async {
    try {
      final result = await operation();
      if (successMessage != null) {
        AppToast.success(successMessage);
      }
      return result;
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        // Handle auth error - navigate to login
        final authService = ref.read(authServiceProvider);
        await authService.handleAuthError(GoRouter.of(context));
      } else {
        AppToast.error(e.message);
      }
      rethrow;
    } catch (e) {
      AppToast.error('An unexpected error occurred. Please try again.');
      rethrow;
    }
  }
}
