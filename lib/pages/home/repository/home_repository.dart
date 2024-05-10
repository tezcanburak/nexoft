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
      queryParameters: {'take': 10},
    );
    ApiResult<List<User>> apiResult = ApiResult<List<User>>.fromJson(
      response.data,
      (dynamic jsonData) => (jsonData as List).map((e) => User.fromJson(e)).toList(),
    );

    return apiResult;
  }

  Future<bool> createUser(User user) async {
    final Response response = await dioC!.post(ApiConstants.userUrl,data: user.toJson() );

     User? userResult = User.fromJson(response.data);
    if (userResult.id != null && userResult.id!.isNotEmpty) {
      return true;
    }
    return false;
  }
}
