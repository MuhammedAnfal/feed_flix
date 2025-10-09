import 'package:dio/dio.dart';
import 'package:feed_flix/core/constants/api_costants.dart';

class DioClient {
  late final Dio dio;
  DioClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseApi,
        connectTimeout: Duration(milliseconds: 10000),
        sendTimeout: Duration(milliseconds: 10000),
      ),
    );
  }
}
