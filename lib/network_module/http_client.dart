// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:npflix/utils/helper_methods.dart';
import '../sources/shared_preferences.dart';
import 'api_base.dart';
import 'api_exceptions.dart';

class HttpClient {
  HttpClient._();
  static final HttpClient _singleton = HttpClient._();

  static HttpClient get instance => _singleton;

  //General Get Request
  Future<dynamic> fetchData(
    String url, {
    Map<String, String>? params,
    Map<String, String>? headers,
    bool isToken = true,
  }) async {
    var responseJson;

    var uri = APIBase.baseURL +
        url +
        ((params != null) ? queryParameters(params) : "");
    var parsedUrl = Uri.parse(uri);
    print({uri.toString(), "printing URL"});

    try {
      final response = await http
          .get(
            parsedUrl,
            headers: this.headers(headers, isToken),
          )
          .timeout(
            const Duration(seconds: 35),
          );
      // print(response.body.toString());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw SocketConnectionError('No Internet Connection');
    }
    return responseJson;
  }

  Future<dynamic> fetchLandmarks(
      String url, {
        Map<String, String>? params,
        Map<String, String>? headers,
        bool isToken = true,
      }) async {
    var responseJson;

    var uri = APIBase.baseURL +
        url +
        ((params != null) ? queryParameters(params) : "");
    var parsedUrl = Uri.parse(uri);

    try {
      final response = await http
          .get(
        parsedUrl,
        headers: this.headers(headers, isToken),
      )
          .timeout(
        const Duration(seconds: 35),
      );
      // print(response.body.toString());
      responseJson = response;
    } on SocketException {
      throw SocketConnectionError('No Internet Connection');
    }
    return responseJson;
  }

  //General Post Request
  Future<dynamic> postData(
    String url,
    dynamic body, {
    Map<String, String>? params,
    Map<String, String>? headers,
    bool isToken = true,
  }) async {
    var responseJson;

    var uri = APIBase.baseURL +
        url +
        ((params != null) ? queryParameters(params) : "");
    var parsedUrl = Uri.parse(uri);
    print({uri.toString(), "printing URL"});
    print({body, "printing body"});

    try {
      final response = await http.post(
        parsedUrl,
        body: json.encode(body),
        headers: this.headers(headers, isToken),
      );
      print({response.body, "PRINTING RESPONSE IN POST"});
      responseJson = _returnResponse(response);
    } on SocketException {
      print({ " RESPONSE IN Error"});
      throw SocketConnectionError('No Internet Connection');
    }

    return responseJson;
  }
  //General Put Request
  Future<dynamic> putData(
    String url,
    dynamic body, {
    Map<String, String>? params,
    Map<String, String>? headers,
    bool isPresignedUrl = false,
    bool isToken = true,
  }) async {
    var responseJson;
    var uri;
    if (isPresignedUrl) {
      uri = url + ((params != null) ? queryParameters(params) : "");
    } else {
      uri = APIBase.baseURL +
          url +
          ((params != null) ? queryParameters(params) : "");
    }
    var parsedUrl = Uri.parse(uri);

    try {
      final response = await http.put(
        parsedUrl,
        body: body,
        headers: this.headers(headers, isToken),
      );
      if (isPresignedUrl) {
        if (response.statusCode.toString() == "200" ||
            response.statusCode.toString() == "201") {
          responseJson = {"message": "success"};
        }
      } else {
        responseJson = _returnResponse(response);
      }
    } on SocketException {
      throw SocketConnectionError('No Internet Connection');
    }
    return responseJson;
  }

  //General Patch Request
  Future<dynamic> patchData(
    String url,
    dynamic body, {
    Map<String, String>? params,
    Map<String, String>? headers,
    bool isToken = true,
  }) async {
    var responseJson;

    var uri = APIBase.baseURL +
        url +
        ((params != null) ? queryParameters(params) : "");
    var parsedUrl = Uri.parse(uri);

    try {
      final response = await http.patch(
        parsedUrl,
        body: body,
        headers: this.headers(headers, isToken),
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw SocketConnectionError('No Internet Connection');
    }
    return responseJson;
  }

  //General Delete Request
  Future<dynamic> deleteData(
    String url, {
    Map<dynamic, dynamic>? body,
    Map<String, String>? params,
    Map<String, String>? headers,
    bool isTokene = true,
  }) async {
    var responseJson;
    var uri = APIBase.baseURL +
        url +
        ((params != null) ? queryParameters(params) : "");
    var parsedUrl = Uri.parse(uri);

    try {
      final response = await http.delete(
        parsedUrl,
        body: body,
        headers: this.headers(headers, isTokene),
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw SocketConnectionError('No Internet Connection');
    }
    return responseJson;
  }

  // Query Parameters
  String queryParameters(Map<String, String>? params) {
    if (params != null) {
      final jsonString = Uri(queryParameters: params);
      return '?${jsonString.query}';
    }
    return '';
  }

  // Customs headers would append here or return the default values
  Map<String, String> headers(Map<String, String>? headers, bool isToken) {
    var header = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json'
    };


    header.putIfAbsent("DeviceId", () =>  Helper.getDeviceId().toString());
    header.putIfAbsent("Platform", () =>  Helper.platform);
    header.putIfAbsent("AppVersion", () =>  Helper.appVersion);
    header.putIfAbsent("ApiVersion", () =>  Helper.apiVersion);

    if (isToken) {
      if (SharedPreferenceManager.sharedInstance.hasToken()) {
        header.putIfAbsent(
            "Authorization",
            () =>
                "Bearer ${SharedPreferenceManager.sharedInstance.getToken()}");
      }
    }
    if (headers != null) {
      header.addAll(headers);
    }
    return header;
  }

  dynamic _returnResponse(http.Response response) {
    print("Response Code" + response.statusCode.toString());
    switch (response.statusCode) {
      case 200:
      case 201:
      case 203:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 400:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 401:
      case 403:
         // Navigator.of(navigatorKey.currentContext!)
         //     .pushNamedAndRemoveUntil(loginScreen, (route) => false);
        SharedPreferenceManager.sharedInstance
            .clearKey(SharedPreferenceManager.sharedInstance.TOKEN);
        SharedPreferenceManager.sharedInstance
            .clearKey(SharedPreferenceManager.sharedInstance.PROFILE);

        throw UnauthorisedException(
            response.statusCode, response.body.toString());
      case 404:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 408:
        throw RequestTimeOutException(
            response.statusCode, response.body.toString());
      case 422:
        throw UnprocessableContent(
            response.statusCode, response.body.toString());
      case 423:
        throw UnauthorisedException(
            response.statusCode, response.body.toString());
      case 500:
      default:
        throw FetchDataException(response.statusCode, response.body.toString());
      // default:
      //   throw FetchDataException(500,
      //       "Error occured while Communication with Server with StatusCode");
    }
  }
}
