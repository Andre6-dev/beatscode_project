import 'package:beatscode_project/resources/auth_methods.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';

abstract class DisposableProvider with ChangeNotifier {
  void disposeValues();
}

class UserProvider extends DisposableProvider {
  User? _user;
  final AuthMethods _authMethods = AuthMethods();

  User? get getUser => _user;

  // update the value of an user
  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }

  @override
  void disposeValues() {
    _user = null;
  }
}
