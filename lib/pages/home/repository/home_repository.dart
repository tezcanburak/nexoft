import 'package:dio/dio.dart';
import 'package:nexoft/model/user.dart';
import 'package:nexoft/dio/base/dio.dart';
import 'package:nexoft/dio/constants/api_constants.dart';
import 'package:nexoft/dio/network_response/api_result.dart';

class HomeRepository {
  Dio? dio;
  DioClient? dioC;

  HomeRepository() {
    dio = Dio();
    if (dio != null) {
      dioC = DioClient(dio!);
    }
  }

  Future<ApiResult<List<User>?>> getAllUsers() async {
    final Response response = await dioC!.get(
      ApiConstants.userUrl,
      queryParameters: {
        'accept': 'text/plain',
        'ApiKey': '49fbc414-78fb-4fd4-953d-be210be2a829',
      },
    );
    ApiResult<List<User>> apiResult = ApiResult<List<User>>.fromJson(
      response.data,
      (dynamic jsonData) => (jsonData as List).map((e) => User.fromJson(e)).toList(),
    );

    return apiResult;
  }
}
