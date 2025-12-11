import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'api_routes.dart';

class DioClient {
  late final Dio _dio;
  late final CacheOptions _cacheOptions;

  DioClient() {
    // Global cache options
    _cacheOptions = CacheOptions(
      store: MemCacheStore(),
      policy: CachePolicy.request,
      maxStale: const Duration(days: 1),
    );

    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl, // Adapted to use ApiConstants
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        responseType: ResponseType.json,
      ),
    );

    _dio.interceptors.add(_loggingInterceptor());
    _dio.interceptors.add(DioCacheInterceptor(options: _cacheOptions));
    // _dio.interceptors.add(_authInterceptor());
    _dio.interceptors.add(_errorInterceptor());
  }

  CacheOptions get cacheOptions => _cacheOptions;

  Dio get dio => _dio;

  Interceptor _loggingInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        if (kDebugMode) {
          print('┌──────────────────────────────────────────────────────────');
          print('│ REQUEST: ${options.method} ${options.uri}');
          print('│ Headers: ${options.headers}');
          if (options.queryParameters.isNotEmpty) {
            print('│ Query Parameters: ${options.queryParameters}');
          }
          if (options.data != null) {
            print('│ Body: ${options.data}');
          }
          print('└──────────────────────────────────────────────────────────');
        }
        handler.next(options);
      },
      onResponse: (response, handler) {
        if (kDebugMode) {
          print('┌──────────────────────────────────────────────────────────');
          print(
            '│ RESPONSE: ${response.statusCode} ${response.requestOptions.path}',
          );
          print('│ Headers: ${response.headers}');
          if (response.statusCode == 304) {
            print('│ [CACHE] Status 304: Not Modified (From Cache)');
          }
          if (response.extra.isNotEmpty) {
            print('│ Extra (Cache Info): ${response.extra}');
          }
          print('│ Data: ${response.data}');
          print('└──────────────────────────────────────────────────────────');
        }
        handler.next(response);
      },
      onError: (error, handler) {
        if (kDebugMode) {
          print('┌──────────────────────────────────────────────────────────');
          print(
            '│ ERROR: ${error.response?.statusCode} ${error.requestOptions.path}',
          );
          print('│ Message: ${error.message}');
          if (error.response?.data != null) {
            print('│ Error Data: ${error.response?.data}');
          }
          print('└──────────────────────────────────────────────────────────');
        }
        handler.next(error);
      },
    );
  }

  // Interceptor _authInterceptor() {
  //   return InterceptorsWrapper(
  //     onRequest: (options, handler) async {
  //       final token = await LocalStorage().getToken();
  //       if (token != null && token.isNotEmpty) {
  //         options.headers['Authorization'] = 'Bearer $token';
  //         if (kDebugMode) {
  //           print('│ Adding Authorization header: Bearer $token');
  //         }
  //       }
  //       handler.next(options);
  //     },
  //   );
  // }

  Interceptor _errorInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) {
        if (error.response?.statusCode == 401) {
          if (kDebugMode) {
            print('Unauthorized! Token expired or invalid.');
          }
        }
        handler.next(error);
      },
    );
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<void> clearCache() async {
    await _cacheOptions.store?.clean();
  }
}
