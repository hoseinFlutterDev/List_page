import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:concentric_transition/page_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:list_veiw/pages/login.dart';
import 'package:list_veiw/providers/onboarding_provider.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OnboardingProvider(),
      child: const _OnboardingScreenContent(),
    );
  }
}

class _OnboardingScreenContent extends StatefulWidget {
  const _OnboardingScreenContent();

  @override
  State<_OnboardingScreenContent> createState() =>
      _OnboardingScreenContentState();
}

class _OnboardingScreenContentState extends State<_OnboardingScreenContent> {
  late PageController _pageController;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    if (!_isNavigating) {
      _pageController.dispose();
    }
    super.dispose();
  }

  void _onPageChanged(int index) {
    if (!_isNavigating && mounted) {
      final provider = Provider.of<OnboardingProvider>(context, listen: false);
      provider.updateIndex(index);
    }
  }

  void _goNext() {
    if (!_isNavigating && mounted) {
      final provider = Provider.of<OnboardingProvider>(context, listen: false);
      if (provider.currentIndex < provider.images.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeInOutCubic,
        );
      }
    }
  }

  void _navigateToLogin() {
    if (_isNavigating || !mounted) return;

    setState(() {
      _isNavigating = true;
    });

    // Navigate immediately without delay
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 800),
        pageBuilder: (context, animation, secondaryAnimation) {
          return const FancyLoginScreen();
        },
        settings: const RouteSettings(name: '/login'),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
  }

  @override
  Widget build(BuildContext context) {
    if (_isNavigating) {
      // Return a simple scaffold while navigating to avoid using disposed PageController
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final provider = Provider.of<OnboardingProvider>(context);
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final isTablet = screenSize.width >= 600 && screenSize.width < 1200;

    return Scaffold(
      body: Stack(
        children: [
          ConcentricPageView(
            colors: provider.colors,
            itemCount: provider.images.length,
            pageController: _pageController,
            onChange: _onPageChanged,
            itemBuilder: (index) {
              final isCurrentPage = index == provider.currentIndex;
              final scale = isCurrentPage ? 1.0 : 0.7;

              return Center(
                child: AnimatedScale(
                  scale: scale,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  child: Image.asset(
                    provider.images[index],
                    fit: BoxFit.cover,
                    width: isSmallScreen
                        ? screenSize.width * 0.6
                        : isTablet
                        ? 300
                        : 350,
                    height: isSmallScreen
                        ? screenSize.width * 0.6
                        : isTablet
                        ? 300
                        : 350,
                  ),
                ),
              );
            },
          ),

          // Indicator
          Positioned(
            bottom: isSmallScreen ? 70 : 100,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: provider.images.length,
                effect: const ExpandingDotsEffect(
                  dotWidth: 8,
                  dotHeight: 8,
                  spacing: 8,
                ),
              ),
            ),
          ),

          // دکمه بعدی / شروع
          Positioned(
            bottom: isSmallScreen ? 20 : 30,
            right: isSmallScreen ? 20 : 30,
            left: isSmallScreen ? null : screenSize.width * 0.7,
            child: ElevatedButton(
              onPressed: _isNavigating
                  ? null
                  : () {
                      if (provider.isLastPage) {
                        _navigateToLogin();
                      } else {
                        _goNext();
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 24 : 32,
                  vertical: isSmallScreen ? 12 : 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
              ),
              child: Text(
                provider.isLastPage ? 'شروع' : 'بعدی',
                style: TextStyle(
                  fontSize: isSmallScreen ? 16 : 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
