import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';
import 'package:ids_elder_rehab_app/core/constants/app_env_keys.dart';
import 'package:ids_elder_rehab_app/core/constants/app_routes.dart';
import 'package:ids_elder_rehab_app/core/router/app_router.dart';
import 'package:ids_elder_rehab_app/core/utils/secure_storage_helper.dart';

class ApiClient {
  late final Dio dio;
  final SecureStorageHelper _storageHelper;

  final String baseUrl =
      dotenv.env[AppEnvKeys.apiBaseUrl] ?? 'https://api.default.com/v1';
  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Receiving helper through constructor for ease of testing
  ApiClient(this._storageHelper) {
    final options = BaseOptions(
      baseUrl: baseUrl,
      headers: headers,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    );

    dio = Dio(options);

    dio.interceptors.addAll(
      [
        // A. Auth Interceptor
        InterceptorsWrapper(
          onRequest:
              (
                RequestOptions options,
                RequestInterceptorHandler handler,
              ) async {
                // Get token from secure storage
                final String? token = await _storageHelper.getToken();

                if (token != null && token.isNotEmpty) {
                  // Insert token into Authorization header
                  options.headers['Authorization'] = 'Bearer $token';
                }

                return handler.next(options);
              },
          onError:
              (
                DioException exception,
                ErrorInterceptorHandler handler,
              ) async {
                // If token is rejected (401 Unauthorized) or expired, remove token and redirect to login page
                if (exception.response?.statusCode == HttpStatus.unauthorized) {
                  debugPrint(
                    '⚠️ Access Denied: Token is invalid or expired. Clearing local session...',
                  );

                  await _storageHelper.deleteToken();

                  appRouter.goNamed(AppRoutes.login.name);
                }

                return handler.next(exception);
              },
        ),

        // B. Logging Interceptor
        if (kDebugMode)
          LogInterceptor(
            request: true,
            requestHeader: true,
            requestBody: true,
            responseHeader: false,
            responseBody: true,
            error: true,
          ),
      ],
    );
  }
}
