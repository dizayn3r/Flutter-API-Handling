import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:api_handling/services/app_exceptions.dart';
import 'package:http/http.dart' as http;

class BaseClient {
  // GET
  static Future<dynamic> get(String baseUrl, String endpoint) async {
    Uri uri = Uri.parse(baseUrl + endpoint);
    try {
      http.Response response = await http.get(uri);
      return _processResponse(response);
    } on SocketException {
    } on TimeoutException {}
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
