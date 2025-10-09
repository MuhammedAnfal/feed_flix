import 'package:dio/dio.dart';
import 'package:feed_flix/core/api/api_endpoints.dart';
import 'package:feed_flix/core/api/api_exception.dart';
import 'package:feed_flix/core/api/dio_client.dart';
import 'package:feed_flix/models/feed_response.dart';
import 'package:feed_flix/models/login_response.dart';

class ApiClient {
  late final DioClient _dioClient;

  ApiClient() : _dioClient = DioClient();

  Future<T> get<T>({
    required String endpoint,
    Options? options,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dioClient.dio.get(
        endpoint,
        options: options,
        queryParameters: queryParameters,
      );
      if (response.statusCode == 200) {
        return _parseResponse<T>(response.data);
      } else {
        throw ApiException(
          statusCode: response.statusCode ?? 500,
          message: response.statusMessage ?? 'Error got',
        );
      }
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw e.error as ApiException;
      }
      throw ApiException(
        statusCode: e.response?.statusCode ?? 500,
        message: e.response?.statusMessage ?? "Error Found",
      );
    } catch (e) {
      throw ApiException(statusCode: -1, message: 'Unexpected error: $e');
    }
  }

  Future<T> post<T>({
    required String endpoint,
    Options? options,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        endpoint,
        options: options,
        queryParameters: queryParameters,
      );
      if (response.statusCode == 200) {
        return _parseResponse<T>(response.data);
      } else {
        throw ApiException(
          statusCode: response.statusCode ?? 500,
          message: response.statusMessage ?? 'Error got',
        );
      }
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw e.error as ApiException;
      }
      throw ApiException(
        statusCode: e.response?.statusCode ?? 500,
        message: e.response?.statusMessage ?? "Error Found",
      );
    } catch (e) {
      throw ApiException(statusCode: -1, message: 'Unexpected error: $e');
    }
  }

  //-- login section

  Future<LoginResponse> login({required String phoneNo}) async {
    print(phoneNo);
    return post<LoginResponse>(
      endpoint: ApiEndpoints.otp,
      queryParameters: {'phone': phoneNo, 'country_code': '+91'},
    );
  }

  //-- get all feed from api

  Future<List<CategoryDict>> getAllFeed(final String ednpoint) async {
    final response = await get<List<dynamic>>(endpoint: ApiEndpoints.category);
    return response.map((e) => CategoryDict.fromJson(e)).toList();
  }

  // Helper method to parse response based on type T
  T _parseResponse<T>(dynamic data) {
    if (T == LoginResponse) {
      return LoginResponse.fromJson(data) as T;
    } else if (T == FeedModel) {
      return FeedModel.fromJson(data) as T;
    } else if (T == Map<String, dynamic>) {
      return data as T;
    } else if (T == List<dynamic>) {
      return data as T;
    } else if (T == String) {
      return data.toString() as T;
    } else if (T == int) {
      return data as T;
    } else if (T == bool) {
      return data as T;
    } else {
      throw ApiException(statusCode: -1, message: 'Unsupported response type: $T');
    }
  }
}
