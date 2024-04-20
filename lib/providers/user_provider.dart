import 'package:api_handling/enum/notifier_state.dart';
import 'package:api_handling/model/random_user.dart';
import 'package:api_handling/services/base_client.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  final _baseClient = BaseClient();

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
    Map<String, String> headers = {"Content-Type": "application/json"};
    try {
      dynamic response = await _baseClient.get(
        baseUrl: "https://api.freeapi.app/api/v1",
        endpoint: "/public/randomusers?page=$pageNumber&limit=$limit",
        headers: headers,
      );
      _setUserResponse(randomUserResponseFromJson(response));
    } on Failure catch (f) {
      _setFailure(f);
    }
    _setState(NotifierState.loaded);
  }
}
