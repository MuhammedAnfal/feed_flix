import 'package:dio/dio.dart';
import 'package:feed_flix/core/api/api_endpoints.dart';
import 'package:feed_flix/core/api/api_exception.dart';
import 'package:feed_flix/core/api/dio_client.dart';
import 'package:feed_flix/core/storage_services/storage_service.dart';
import 'package:feed_flix/models/feed_response.dart';
import 'package:feed_flix/models/login_response.dart';

class ApiClient {
  late final DioClient _dioClient;
  final StorageService _localStorage;

  ApiClient({required StorageService localStorage})
    : _localStorage = localStorage,
      _dioClient = DioClient();

  // Fixed token retrieval method
  Future _getAuthToken() async {
    return await _localStorage.loadToken();
  }

  Future<T> get<T>({
    required String endpoint,
    Options? options,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      // Get token first
      final token = await _getAuthToken();

      final finalOptions = options ?? Options();
      finalOptions.headers ??= {};

      // Set correct Content-Type for GET requests
      finalOptions.headers!['Content-Type'] = 'application/json';
      finalOptions.headers!['Accept'] = 'application/json';

      if (token != null) {
        finalOptions.headers!['Authorization'] = 'Bearer $token';
      }

      print('GET Request: $endpoint');
      print('Headers: ${finalOptions.headers}');

      final response = await _dioClient.dio.get(
        endpoint,
        options: finalOptions,
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        return _parseResponse<T>(response.data);
      } else {
        throw ApiException(
          statusCode: response.statusCode ?? 500,
          message: response.statusMessage ?? 'Error occurred',
        );
      }
    } on DioException catch (e) {
      print('GET DioError: ${e.type} - ${e.message}');
      print('Response: ${e.response?.data}');

      if (e.error is ApiException) {
        throw e.error as ApiException;
      }
      throw ApiException(
        statusCode: e.response?.statusCode ?? 500,
        message: e.response?.statusMessage ?? "Error Found",
      );
    } catch (e) {
      print('GET Unexpected error: $e');
      throw ApiException(statusCode: -1, message: 'Unexpected error: $e');
    }
  }

  Future<T> post<T>({
    required String endpoint,
    Options? options,
    Map<String, dynamic>? queryParameters,
    dynamic data,
  }) async {
    try {
      // Get token for POST requests too
      final token = await _getAuthToken();

      final finalOptions = options ?? Options();
      finalOptions.headers ??= {};
      finalOptions.headers!['Content-Type'] = 'application/json';
      finalOptions.headers!['Accept'] = 'application/json';

      if (token != null) {
        finalOptions.headers!['Authorization'] = 'Bearer $token';
      }

      print('POST Request: $endpoint');
      print('Data: $data');
      print('Headers: ${finalOptions.headers}');

      final response = await _dioClient.dio.post(
        endpoint,
        data: data,
        options: finalOptions,
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        return _parseResponse<T>(response.data);
      } else {
        throw ApiException(
          statusCode: response.statusCode ?? 500,
          message: response.statusMessage ?? 'Error occurred',
        );
      }
    } on DioException catch (e) {
      print('POST DioError: ${e.type} - ${e.message}');
      print('Response: ${e.response?.data}');

      if (e.error is ApiException) {
        throw e.error as ApiException;
      }
      throw ApiException(
        statusCode: e.response?.statusCode ?? 500,
        message: e.response?.statusMessage ?? "Error Found",
      );
    } catch (e) {
      print('POST Unexpected error: $e');
      throw ApiException(statusCode: -1, message: 'Unexpected error: $e');
    }
  }

  //-- login section
  Future<LoginResponse> login({required String phoneNo}) async {
    print('Login request for: $phoneNo');
    return post<LoginResponse>(
      endpoint: ApiEndpoints.otp,
      data: {
        'phone': phoneNo,
        'country_code': '+91',
      }, // Use data instead of queryParameters for POST body
    );
  }

  //-- get all feed from api
  Future<List<CategoryDict>> getAllFeed() async {
    final response = await get<List<dynamic>>(endpoint: ApiEndpoints.category);
    return response.map((e) => CategoryDict.fromJson(e)).toList();
  }

  // Fixed uploadFeed method
  Future<T> uploadFeed<T>({
    required String endpoint,
    required Map<String, dynamic> formData,
    required Map<String, dynamic> fields,
    Options? options,
    void Function(int sent, int total)? onSendProgress,
  }) async {
    try {
      print('=== UPLOAD DEBUG START ===');
      print('Token: $token');
      print('Endpoint: $endpoint');
      print('Fields: $fields');
      print('FormData keys: ${formData.keys.toList()}');

      final finalOptions = Options(
        headers: {'Content-Type': 'multipart/form-data', 'Accept': 'application/json'},
      );

      // Add authorization header - THIS WAS THE MAIN ISSUE!
      if (token != null) {
        finalOptions.headers!['Authorization'] = 'Bearer $token';
        print('Authorization header added');
      } else {
        print('WARNING: No token found for upload!');
      }

      final formDataToSend = FormData.fromMap({...fields, ...formData});
      print('FormData created successfully');
      print('1 - About to make upload request');

      final response = await _dioClient.dio.post(
        endpoint,
        data: formDataToSend,
        options: finalOptions,
        onSendProgress: onSendProgress,
      );

      print('0 - Upload request completed');
      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Upload successful!');
        return _parseResponse<T>(response.data);
      } else {
        print('Upload failed with status: ${response.statusCode}');
        throw ApiException(
          statusCode: response.statusCode ?? 500,
          message: response.statusMessage ?? 'Error during upload',
        );
      }
    } on DioException catch (e) {
      print('=== UPLOAD DIO ERROR ===');
      print('Error type: ${e.type}');
      print('Error message: ${e.message}');
      print('Response status: ${e.response?.statusCode}');
      print('Response data: ${e.response?.data}');
      print('Response headers: ${e.response?.headers}');

      // Extract detailed error message from response
      String errorMessage = "Upload failed";
      if (e.response?.data != null) {
        if (e.response!.data is Map) {
          errorMessage =
              e.response!.data['message'] ??
              e.response!.data['error'] ??
              e.response!.data['detail'] ??
              'Server error: ${e.response!.statusCode}';
        } else {
          errorMessage = 'Server response: ${e.response!.data}';
        }
      }

      if (e.error is ApiException) {
        throw e.error as ApiException;
      }
      throw ApiException(statusCode: e.response?.statusCode ?? 500, message: errorMessage);
    } catch (e) {
      print('=== UPLOAD UNEXPECTED ERROR ===');
      print('Error: $e');
      print('Stack trace: ${e.toString()}');
      throw ApiException(statusCode: -1, message: 'Unexpected error: $e');
    }
  }

  // Helper method to parse response based on type T
  T _parseResponse<T>(dynamic data) {
    print('Parsing response for type: $T');

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
