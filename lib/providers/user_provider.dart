import 'dart:developer';

import 'package:api_handling/data/network/random_users_data_source.dart';
import 'package:api_handling/enum/notifier_state.dart';
import 'package:api_handling/model/random_user.dart';
import 'package:api_handling/services/base_client.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserProvider extends ChangeNotifier {
  NotifierState _state = NotifierState.initial;
  NotifierState get state => _state;

  void _setState(NotifierState value) {
    _state = value;
    notifyListeners();
  }

  RandomUserResponse _userResponse = RandomUserResponse();
  RandomUserResponse get userResponse => _userResponse;

  void _setUserResponse(RandomUserResponse value) {
    _userResponse = value;
    notifyListeners();
  }

  Failure? _failure;
  Failure? get failure => _failure;

  void _setFailure(Failure value) {
    _failure = value;
    notifyListeners();
  }

  fetchUsers(int pageNumber, int limit) async {
    _setState(NotifierState.loading);
    try {
      http.Response response =
          await RandomUsersDataSource.fetchRandomUsers(pageNumber, limit);
      log("Response: ${response.statusCode}");
      if (response.statusCode == 200) {
        _setUserResponse(randomUserResponseFromJson(response.body));
      }
    } on Failure catch (f) {
      _setFailure(f);
    }
    _setState(NotifierState.loaded);
  }
}
