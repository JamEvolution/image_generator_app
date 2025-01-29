import 'package:dio/dio.dart';
import '../error/network_error.dart';
import 'dio_client.dart';

abstract class BaseClient {
  late final Dio _dio;

  BaseClient({
    required String baseUrl,
    required String apiKey,
    Map<String, dynamic>? headers,
  }) {
    _dio = DioClient.createDio(
      baseUrl: baseUrl,
      apiKey: apiKey,
      headers: headers,
    );
  }

  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
  );
      return _handleResponse<T>(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw NetworkError(message: e.toString());
    }
  }

  Future<T> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return _handleResponse<T>(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw NetworkError(message: e.toString());
    }
  }

  T _handleResponse<T>(Response response) {
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return response.data as T;
    } else {
    throw NetworkError(
      message: 'İstek başarısız oldu: ${response.statusCode}',
      statusCode: response.statusCode,
    );
    }
  }

  NetworkError _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkError(
            message: 'Bağlantı zaman aşımına uğradı',
            statusCode: error.response?.statusCode,
        );
      case DioExceptionType.badResponse:
        return NetworkError(
            message: error.response?.data?['message'] ?? 'Sunucu hatası',
            statusCode: error.response?.statusCode,
        );
      case DioExceptionType.cancel:
        return NetworkError(
            message: 'İstek iptal edildi',
            statusCode: error.response?.statusCode,
        );
      default:
        return NetworkError(
            message: 'Bir hata oluştu: ${error.message}',
            statusCode: error.response?.statusCode,
        );
    }
  }
} 