import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/user_service.dart';

class UserProvider extends ChangeNotifier {
  final UserService _service;

  int? userId;
  bool isLoading = false;

  UserProvider(this._service);

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId');
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();

      final data = await _service.login(email, password);
      userId = data['id'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userId', userId!);

    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signUp(String name, String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();

      final data = await _service.register(name, email, password);
      userId = data["id"];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt("userId", userId!);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');

    userId = null;
    notifyListeners();
  }
}
