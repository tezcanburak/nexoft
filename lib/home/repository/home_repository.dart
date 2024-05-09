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

  Future<List<User>?> getAllUsers() async {
    final Response response = await dioC!.get(
      ApiConstants.userUrl,
    );
    ApiResult<List<User>> apiResult = ApiResult<List<User>>.fromJson(
      response.data,
      (dynamic jsonData) => (jsonData as List).map((e) => User.fromJson(e)).toList(),
    );

    if (apiResult.success == false) {
      return null;
    } else {
      return apiResult.data;
    }
  }
}
