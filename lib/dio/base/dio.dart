import 'package:dio/dio.dart';
import 'package:nexoft/dio/constants/api_constants.dart';
import 'package:nexoft/model/shared_preferences/item.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DioClient {
  final Dio _dio;

  DioClient(this._dio) {
    _dio
      ..options.baseUrl = ApiConstants.baseUrl
      ..options.connectTimeout = const Duration(seconds: 1500)
      ..options.receiveTimeout = const Duration(seconds: 1500)
      ..options.responseType = ResponseType.json;
  }

  final _storage = const FlutterSecureStorage();

  IOSOptions _getIOSOptions() => const IOSOptions(
        accountName: 'flutter_secure_storage_service',
      );

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  Future<List<Item>> _readAll() async {
    const storage = FlutterSecureStorage();

    final all = await storage.readAll(
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
    return all.entries.map((entry) => Item(entry.key, entry.value)).toList(growable: false);
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
      List<Item> listOf = await _readAll();
      String token = "";
      if (listOf.isNotEmpty) {
        Item? tokenItem = listOf.firstWhere((item) => item.key == 'token');
        token = tokenItem.value;
      }

      if (token != "") {
        options ??= Options();
        options.headers ??= {};

        // Add the token to the headers
        options.headers!['Token'] = token;
      }

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
}
