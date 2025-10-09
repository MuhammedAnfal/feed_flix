import 'package:dio/dio.dart';
import 'package:feed_flix/core/api/api_exception.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Accept'] = 'application/json';
    if (options.data is FormData) {
      options.headers['Content-Type'] = 'multipart/form-data';
    } else {
      options.headers['Content-Type'] = 'application/json';
    }

    print('Request: ${options.method} ${options.uri}');
    // TODO: implement onRequest
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.statusCode == 401) {
      handler.reject(
        DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        ),
      );
      return;
    }
    // TODO: implement onResponse
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    ApiException apiException;
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        apiException = ApiException(statusCode: 408, message: 'Request timeout');
        break;
      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode ?? 500;
        final message = _getErrorMessage(err.response?.data) ?? 'Server Error';
        apiException = ApiException(message: message, statusCode: statusCode);
        break;
      case DioExceptionType.cancel:
        apiException = ApiException(message: 'Request cancelled', statusCode: -1);
        break;
      case DioExceptionType.unknown:
      case DioExceptionType.connectionError:
        apiException = ApiException(message: 'No internet connection', statusCode: 0);
        break;
      default:
        apiException = ApiException(message: 'Network error', statusCode: -1);
    }

    handler.reject(err.copyWith(error: apiException));
    // TODO: implement onError
    super.onError(err, handler);
  }

  String? _getErrorMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message']?.toString() ?? data['error']?.toString();
    }
    return null;
  }
}
