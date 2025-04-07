import 'package:flutter/widgets.dart';

import '../enums/status_enum.dart';

class ApiResponse<T> {
  ApiResponse();

  Status status = Status.UNDETERMINED;

  ConnectionState connectionStatus = ConnectionState.none;

  late T data;

  String message = '';

  List errors = [];

  ApiResponse.undertermined() : status = Status.UNDETERMINED;

  ApiResponse.loading(this.message) : status = Status.LOADING;

  ApiResponse.completed(this.data) : status = Status.COMPLETED;

  ApiResponse.error(this.message) : status = Status.ERROR;

  ApiResponse.loadingMore(this.message) : status = Status.LOADING_MORE;

  ApiResponse.errors(this.errors) : status = Status.ERROR;

  ApiResponse.noInternet(this.message) : status = Status.NOINTERNET;
}
