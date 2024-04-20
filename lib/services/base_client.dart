import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;

class BaseClient {
  static const int timeOutDuration = 20;

  // GET
  Future<dynamic> get({
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
      log("Socket Exception");
      throw Failure(
        "No Internet connection",
        uri.toString(),
      );
    } on FormatException {
      throw Failure(
        "Request body is not correct",
        uri.toString(),
      );
    } on TimeoutException {
      throw Failure(
        "API not responded in time",
        uri.toString(),
      );
    }
  }

  // POST
  Future<dynamic> post({
    required String baseUrl,
    required String endpoint,
    required Map<String, String> headers,
    required Map<String, dynamic> payload,
  }) async {
    Uri uri = Uri.parse(baseUrl + endpoint);
    try {
      http.Response response = await http
          .post(
            uri,
            headers: headers,
            body: json.encode(payload),
          )
          .timeout(const Duration(seconds: timeOutDuration));
      return _processResponse(response);
    } on SocketException {
      throw Failure(
        "No Internet connection",
        uri.toString(),
      );
    } on TimeoutException {
      throw Failure(
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
        Failure(
          utf8.decode(response.bodyBytes),
          response.request!.url.toString(),
        );
      case 401:
      case 403:
        throw Failure(
          utf8.decode(response.bodyBytes),
          response.request!.url.toString(),
        );
      case 500:
      default:
        Failure(
          'Error occurred with code: ${response.statusCode}',
          response.request!.url.toString(),
        );
    }
  }
}

class Failure {
  final String message;
  final String url;
  Failure(this.message, this.url);

  @override
  String toString() => message;
}
