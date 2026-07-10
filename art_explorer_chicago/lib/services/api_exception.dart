class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException: $message${statusCode != null ? ' (status: $statusCode)' : ''}';
}

class NetworkException extends ApiException {
  NetworkException(String message) : super(message);
}

class NotFoundException extends ApiException {
  NotFoundException(String message) : super(message, statusCode: 404);
}

class ServerException extends ApiException {
  ServerException(String message, int statusCode) : super(message, statusCode: statusCode);
}
