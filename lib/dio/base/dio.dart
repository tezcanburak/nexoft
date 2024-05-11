import 'package:dio/dio.dart';
import 'package:nexoft/dio/constants/api_constants.dart';

class DioClient {
  final Dio _dio;

  DioClient(this._dio) {
    _dio
      ..options.baseUrl = ApiConstants.baseUrl
      ..options.connectTimeout = const Duration(seconds: 1500)
      ..options.receiveTimeout = const Duration(seconds: 1500)
      ..options.responseType = ResponseType.json;
  }

  // Get:-----------------------------------------------------------------------
  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      options ??= Options();
      options.headers ??= {};

      // Add the token to the headers
      options.headers!['ApiKey'] = 'e2bbbb1c-024d-4f26-9abe-e7874cbc8937';

      final Response response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Post:----------------------------------------------------------------------
  Future<Response> post(
    String url, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      options ??= Options();
      options.headers ??= {};

      // Add the token to the headers
      options.headers!['ApiKey'] = 'e2bbbb1c-024d-4f26-9abe-e7874cbc8937';

      final Response response = await _dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Put:-----------------------------------------------------------------------
  Future<Response> put(
    String url, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      options ??= Options();
      options.headers ??= {};

      // Add the token to the headers
      options.headers!['ApiKey'] = 'e2bbbb1c-024d-4f26-9abe-e7874cbc8937';

      final Response response = await _dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Delete:-----------------------------------------------------------------------
  Future<Response> delete(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      options ??= Options();
      options.headers ??= {};

      // Add the token to the headers
      options.headers!['ApiKey'] = 'e2bbbb1c-024d-4f26-9abe-e7874cbc8937';

      final Response response = await _dio.delete(
        url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
