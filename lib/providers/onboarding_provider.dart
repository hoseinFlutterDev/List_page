import 'package:flutter/material.dart';

class OnboardingProvider extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  final List<String> images = [
    'assets/images/image5.gif',
    'assets/images/image4.gif',
    'assets/images/image6.gif',
  ];

  final List<Color> colors = [
    const Color(0xffF1A951),
    const Color(0xffFB7C67),
    const Color(0xff5A9DED),
  ];

  void updateIndex(int index) {
    if (_currentIndex != index) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  bool get isLastPage => _currentIndex == images.length - 1;
}
