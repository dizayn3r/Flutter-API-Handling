import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:api_handling/services/app_exceptions.dart';
import 'package:http/http.dart' as http;

class BaseClient {
  static const int timeOutDuration = 20;

  // GET
  static Future<dynamic> get({
    required String baseUrl,
    required String endpoint,
    required Map<String, String> headers,
  }) async {
    Uri uri = Uri.parse(baseUrl + endpoint);
    try {
      http.Response response = await http.get(uri, headers: headers).timeout(
            const Duration(seconds: timeOutDuration),
          );
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException(
        "No Internet connection",
        uri.toString(),
      );
    } on TimeoutException {
      throw ApiNotRespondingException(
        "API not responded in time",
        uri.toString(),
      );
    }
  }

  // POST
  static Future<dynamic> post({
    required String baseUrl,
    required String endpoint,
    required Map<String, String> headers,
  }) async {
    Uri uri = Uri.parse(baseUrl + endpoint);
    try {
      http.Response response = await http.post(uri, headers: headers).timeout(
            const Duration(seconds: timeOutDuration),
          );
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException(
        "No Internet connection",
        uri.toString(),
      );
    } on TimeoutException {
      throw ApiNotRespondingException(
        "API not responded in time",
        uri.toString(),
      );
    }
  }

  static dynamic _processResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic jsonResponse = utf8.decode(response.bodyBytes);
        return jsonResponse;
      case 400:
        BadRequestException(
          utf8.decode(response.bodyBytes),
          response.request!.url.toString(),
        );
      case 401:
      case 403:
        throw UnauthorizedException(
          utf8.decode(response.bodyBytes),
          response.request!.url.toString(),
        );
      case 500:
      default:
        FetchDataException(
          'Error occurred with code: ${response.statusCode}',
          response.request!.url.toString(),
        );
    }
  }
}
