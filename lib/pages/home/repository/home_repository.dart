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

    // Check if response indicates success
    if (response.statusCode == 200) {
      // Extract the list of users from the 'data' object
      final userData = response.data['data'];
      List<User> userList = (userData['users'] as List).map((e) => User.fromJson(e)).toList();

      // Create ApiResult with the mapped user list
      ApiResult<List<User>> apiResult = ApiResult<List<User>>.fromJson(
        response.data,
        (dynamic jsonData) => userList,
      );

      return apiResult;
    } else {
      // Handle error response
      throw Exception('Failed to fetch users');
    }
  }

  Future<bool> createUser(User user) async {
    try {
      final Response response = await dioC!.post(
        ApiConstants.userUrl,
        data: user.toJson(),
      );

      // Check if the response is null or the status code indicates success (2xx range)
      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        // User creation successful
        return true;
      } else {
        // User creation failed
        return false;
      }
    } catch (e) {
      // Handle any errors that occurred during the API call
      print('Error creating user: $e');
      return false;
    }
  }
}
