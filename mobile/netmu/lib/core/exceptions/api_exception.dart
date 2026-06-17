class ApiException implements Exception {
  final int? statusCode;
  final String message;
  final dynamic data;

  const ApiException({required this.message, this.statusCode, this.data});

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException({super.data})
    : super(statusCode: 401, message: 'Unauthorized. Please log in again.');
}

class ForbiddenException extends ApiException {
  const ForbiddenException({super.data})
    : super(statusCode: 403, message: 'Forbidden. Access denied.');
}

class NotFoundException extends ApiException {
  const NotFoundException({super.data})
    : super(statusCode: 404, message: 'Resource not found.');
}

class ServerException extends ApiException {
  const ServerException({super.statusCode, super.data})
    : super(message: 'Internal server error.');
}

class NetworkException extends ApiException {
  const NetworkException()
    : super(message: 'No internet connection or server unreachable.');
}

class TimeoutException extends ApiException {
  const TimeoutException()
    : super(message: 'Request timed out. Please try again.');
}
