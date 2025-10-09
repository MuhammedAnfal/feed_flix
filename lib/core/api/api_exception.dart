class ApiException implements Exception {
  final String message;
  final int statusCode;
  final String? errorCode;
  ApiException({this.errorCode, required this.statusCode, required this.message});

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

class NetworkException extends ApiException {
  NetworkException(String message) : super(message: message, statusCode: 0);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(String message) : super(message: message, statusCode: 401);
}

class NotFoundException extends ApiException {
  NotFoundException(String message) : super(message: message, statusCode: 404);
}

class ServerException extends ApiException {
  ServerException(String message) : super(message: message, statusCode: 500);
}
