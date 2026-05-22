import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String userName = "Guest";
  String userEmail = "";
  String userPhone = "";
  
  bool get isLoggedIn => _isLoggedIn;

  void login({String name = "User", String email = "", String phone = ""}) {
    _isLoggedIn = true;
    userName = name;
    userEmail = email;
    userPhone = phone;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    userName = "Guest";
    userEmail = "";
    userPhone = "";
    notifyListeners();
  }
}
