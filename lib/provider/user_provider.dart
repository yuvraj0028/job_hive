import 'package:flutter/material.dart';
import 'package:job_hive/models/user.dart';

class UserProvider extends ChangeNotifier {
  // storing user and token
  User? _user;

  // getters
  User? get user => _user;

  // setters
  void setUser(Map<String, dynamic> resUser) {
    User user = User.fromJson(resUser);
    _user = user;
    notifyListeners();
  }
}
