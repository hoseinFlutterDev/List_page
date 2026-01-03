import 'dart:ui';
import 'package:concentric_transition/page_view.dart';
import 'package:flutter/material.dart';
import 'package:list_veiw/pages/login.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  final List<String> images = [
    'assets/images/image5.gif',
    'assets/images/image4.gif',
    'assets/images/image6.gif',
  ];

  final List<Color> colors = [
    const Color(0xffF1A951),
    const Color(0xffFB7C67),
    Color(0xff5A9DED),
  ];

  void _goNext() {
    if (currentIndex == images.length - 1) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (context, animation, secondaryAnimation) {
            return const FancyLoginScreen();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Scale + Fade
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
                ),
                child: child,
              ),
            );
          },
        ),
      );
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 1000), // <- طولانی‌تر
        curve: Curves.easeInOutCubic, // <- انیمیشن نرم‌تر
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ConcentricPageView(
            colors: colors,
            itemCount: images.length,
            pageController: _controller,
            onChange: (index) {
              setState(() => currentIndex = index);
            },
            itemBuilder: (index) {
              // اندازه عکس را با AnimatedScale تغییر می‌دهیم
              double scale = index == currentIndex ? 1.0 : 0.7;

              return Center(
                child: AnimatedScale(
                  scale: scale,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  child: Image.asset(
                    images[index],
                    fit: BoxFit.cover,
                    width: 250, // اندازه پایه
                    height: 250,
                  ),
                ),
              );
            },
          ),

          // indicator
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _controller,
                count: images.length,
                effect: const ExpandingDotsEffect(),
              ),
            ),
          ),

          // دکمه بعدی / شروع
          Positioned(
            bottom: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: _goNext,
              child: Text(currentIndex == images.length - 1 ? 'شروع' : 'بعدی'),
            ),
          ),
        ],
      ),
    );
  }
}
