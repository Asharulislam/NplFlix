// ignore_for_file: prefer_typing_uninitialized_variables

class AppException implements Exception {
  final _message;
  final code;

  AppException([this.code, this._message]);

  @override
  String toString() {
    return "$code$_message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([int? code, String? message]) : super(code, message);
}

class BadRequestException extends AppException {
  BadRequestException([int? code, message]) : super(code, message);
}

class UnauthorisedException extends AppException {
  UnauthorisedException([int? code, message]) : super(code, message);
}

class NotFoundRequestException extends AppException {
  NotFoundRequestException([int? code, String? message]) : super(code, message);
}

class RequestTimeOutException extends AppException {
  RequestTimeOutException([int? code, String? message]) : super(code, message);
}

class InvalidInputException extends AppException {
  InvalidInputException([int? code, String? message]) : super(code, message);
}

class AuthenticationException extends AppException {
  AuthenticationException([int? code, String? message]) : super(code, message);
}

class UnprocessableContent extends AppException {
  UnprocessableContent([int? code, String? message]) : super(code, message);
}

class SocketConnectionError extends AppException {
  SocketConnectionError([String? message]) : super(message);
}
