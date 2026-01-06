import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _isUnlocked = false;
  bool _isError = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get isUnlocked => _isUnlocked;
  bool get isError => _isError;
  String? get errorMessage => _errorMessage;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _isError = false;
    _errorMessage = null;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    _isLoading = false;

    // Simple validation (replace with actual API call)
    if (email.isNotEmpty && password.isNotEmpty) {
      _isUnlocked = true;
      _isError = false;
      notifyListeners();
      return true;
    } else {
      _isUnlocked = false;
      _isError = true;
      _errorMessage = 'لطفاً ایمیل و رمز عبور را وارد کنید';
      notifyListeners();
      return false;
    }
  }

  void reset() {
    _isUnlocked = false;
    _isError = false;
    _errorMessage = null;
    notifyListeners();
  }
}
