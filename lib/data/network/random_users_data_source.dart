import 'dart:developer';

import 'package:http/http.dart' as http;

class RandomUsersDataSource {
  static Future<http.Response> fetchRandomUsers(
      int pageNumber, int limit) async {
    log("In fetchRandomUsers | Limit: $limit, Page: $pageNumber", name: "RandomUsersDataSource");
    Map<String, String> headers = {"Content-Type": "application/json"};
    Uri uri = Uri.parse(
        "https://api.freeapi.app/api/v1/public/randomusers?page=$pageNumber&limit=$limit");
    return await http.get(uri, headers: headers);
  }
}
