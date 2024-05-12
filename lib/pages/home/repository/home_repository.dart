import 'package:dio/dio.dart';
import 'package:nexoft/model/user.dart';
import 'package:nexoft/dio/base/dio.dart';
import 'package:nexoft/model/image_url.dart';
import 'package:image_picker/image_picker.dart';
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

  Future<ApiResult<List<User>?>> getAllUsers(int skip) async {
    final Response response = await dioC!.get(
      ApiConstants.userUrl,
      queryParameters: {'take': 10, 'skip': skip},
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

  Future<ApiResult<User>?> createUser(User user) async {
    try {
      final Response response = await dioC!.post(
        ApiConstants.userUrl,
        data: user.toJson(),
      );

      // Check if the response is null or the status code indicates success (2xx range)
      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        // User creation successful
        var apiResult = ApiResult<User>.fromJson(response.data, (p0) => User.fromJson(p0));
        return apiResult;
      } else {
        // User creation failed
        return null;
      }
    } catch (e) {
      // Handle any errors that occurred during the API call
      return null;
    }
  }

  Future<bool> updateUser(String userId, User updatedUser) async {
    try {
      final Response response = await dioC!.put(
        '${ApiConstants.userUrl}/$userId', // Assuming userId is the unique identifier for the user
        data: updatedUser.toJson(),
      );

      // Check if the status code indicates success (2xx range)
      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        // User update successful
        return true;
      } else {
        // User update failed
        return false;
      }
    } catch (e) {
      // Handle any errors that occurred during the API call
      return false;
    }
  }

  Future<bool> deleteUser(String userId) async {
    try {
      final Response response = await dioC!.delete(
        '${ApiConstants.userUrl}/$userId', // Assuming userId is the unique identifier for the user
      );

      // Check if the status code indicates success (2xx range)
      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        // User deletion successful
        return true;
      } else {
        // User deletion failed
        return false;
      }
    } catch (e) {
      // Handle any errors that occurred during the API call
      return false;
    }
  }

  // Method to upload photo
  Future<String?> uploadPhoto(XFile photo) async {
    try {
      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(photo.path, filename: 'photo.jpg'),
      });

      final Response response = await dioC!.post(
        ApiConstants.uploadPhotoUrl, // Replace with your photo upload endpoint
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            // Add any other headers if needed
          },
        ),
      );

      // Check if the status code indicates success (2xx range)
      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        // Parse the response to get the image URL
        var apiResult = ApiResult<ImageUrl>.fromJson(response.data, (p0) => ImageUrl.fromJson(p0));

        String? imageUrl = apiResult.data?.imageUrl; // Adjust based on the actual response structure
        return imageUrl;
      } else {
        // Photo upload failed
        return null;
      }
    } catch (e) {
      // Handle any errors that occurred during the photo upload
      return null;
    }
  }

  // Method to create user with uploaded photo
  Future<bool> createUserWithPhoto(User user, String imageUrl) async {
    try {
      User updatedUser = user.copyWith(profileImageUrl: imageUrl);

      final Response response = await dioC!.post(
        ApiConstants.userUrl,
        data: updatedUser.toJson(),
      );

      // Check if the status code indicates success (2xx range)
      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        // User creation successful
        return true;
      } else {
        // User creation failed
        return false;
      }
    } catch (e) {
      // Handle any errors that occurred during the API call
      return false;
    }
  }

// Method to upload photo and create user
  Future<bool> uploadPhotoAndCreateUser(XFile photo, User user) async {
    try {
      // Upload the photo
      String? imageUrl = await uploadPhoto(photo);
      if (imageUrl != null) {
        // If photo upload was successful, create the user with the obtained image URL
        return await createUserWithPhoto(user, imageUrl);
      } else {
        // Photo upload failed
        return false;
      }
    } catch (e) {
      // Handle any errors that occurred during the process
      return false;
    }
  }
}
