import 'package:flutter/material.dart';

class PaymentProvider extends ChangeNotifier {
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  bool _isProcessing = false;
  bool _isSuccess = false;
  String? _errorMessage;

  bool get isProcessing => _isProcessing;
  bool get isSuccess => _isSuccess;
  String? get errorMessage => _errorMessage;

  Future<bool> processPayment() async {
    if (cardNumberController.text.isEmpty ||
        expiryController.text.isEmpty ||
        cvvController.text.isEmpty) {
      _errorMessage = 'لطفاً تمام فیلدها را پر کنید';
      notifyListeners();
      return false;
    }

    _isProcessing = true;
    _errorMessage = null;
    notifyListeners();

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 2));

    _isProcessing = false;
    _isSuccess = true;
    notifyListeners();

    return true;
  }

  void reset() {
    _isSuccess = false;
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    cardNumberController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    super.dispose();
  }
}
