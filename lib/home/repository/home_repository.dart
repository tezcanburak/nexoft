import 'package:dio/dio.dart';
import 'package:nexoft/dio/base/dio.dart';

class HomeRepository {
  Dio? dio;
  DioClient? dioC;

  HomeRepository() {
    dio = Dio();
    if (dio != null) {
      dioC = DioClient(dio!);
    }
  }
}
