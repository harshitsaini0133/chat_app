import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'dio_client.dart';

class BaseRepository {
  final DioClient _dioClient;

  BaseRepository(this._dioClient);

  DioClient get dioClient => _dioClient;

  Future<T> safeApiCall<T>({
    required Future<Response> Function() apiCall,
    required T Function(dynamic data) parser,
    T? defaultValue,
    bool resolveData = true,
  }) async {
    try {
      final response = await apiCall();

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final data = response.data;
        if (resolveData && data is Map<String, dynamic>) {
          if (data.containsKey('data')) {
            return parser(data['data']);
          }
          if (data.containsKey('true') && data['true'] == true) {
            if (data.containsKey('data')) {
              return parser(data['data']);
            }
            return parser(data);
          }
          return parser(data);
        }
        return parser(data);
      } else {
        throw ApiException(
          message: 'Request failed with status: ${response.statusCode}',
          statusCode: response.statusCode,
          data: response.data,
        );
      }
    } on DioException catch (e) {
      _handleDioError(e);
      if (defaultValue != null) return defaultValue;
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected error in safeApiCall: $e');
        if (e is TypeError) {
          print('TypeError trace: ${e.stackTrace}');
        }
      }
      if (defaultValue != null) return defaultValue;
      rethrow;
    }
  }

  void _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw ApiException(
          message: 'Connection timeout. Please check your internet connection.',
          statusCode: error.response?.statusCode,
        );
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final data = error.response?.data;
        String message = 'Request failed';
        if (data is Map<String, dynamic>) {
          message = data['data'] ?? data['message'] ?? data['error'] ?? message;
        }
        throw ApiException(
          message: message,
          statusCode: statusCode,
          data: data,
        );
      case DioExceptionType.cancel:
        throw ApiException(message: 'Request cancelled');
      case DioExceptionType.unknown:
        throw ApiException(
          message: 'Network error. Please check your internet connection.',
        );
      default:
        throw ApiException(
          message: error.message ?? 'Unknown error occurred',
          statusCode: error.response?.statusCode,
        );
    }
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException({required this.message, this.statusCode, this.data});

  @override
  String toString() {
    return 'ApiException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
  }
}
