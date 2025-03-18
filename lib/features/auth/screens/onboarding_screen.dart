import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/navigation/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _numPages = 3;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  onPressed: () => _navigateToLogin(),
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            
            // Page content
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  _buildPage(
                    title: 'Welcome to Harmony Bridge',
                    description: 'A co-parenting app designed to make communication easier and improve your children\'s lives.',
                    image: 'assets/images/onboarding_1.png',
                    imageSize: 300,
                  ),
                  _buildPage(
                    title: 'Seamless Communication',
                    description: 'Share important updates, schedules, and documents with your co-parent in one secure place.',
                    image: 'assets/images/onboarding_2.png',
                    imageSize: 280,
                  ),
                  _buildPage(
                    title: 'Child-Focused Approach',
                    description: 'Keep your children\'s needs at the center with tools designed to support their well-being.',
                    image: 'assets/images/onboarding_3.png',
                    imageSize: 280,
                  ),
                ],
              ),
            ),
            
            // Page indicators
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _numPages,
                  (index) => _buildPageIndicator(index == _currentPage),
                ),
              ),
            ),
            
            // Navigation buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button (hidden on first page)
                  _currentPage > 0
                      ? AppButton(
                          onPressed: () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          text: 'Back',
                          type: AppButtonType.outlined,
                          width: 120,
                        )
                      : const SizedBox(width: 120),
                  
                  // Next/Get Started button
                  AppButton(
                    onPressed: () {
                      if (_currentPage < _numPages - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        _navigateToLogin();
                      }
                    },
                    text: _currentPage < _numPages - 1 ? 'Next' : 'Get Started',
                    width: 120,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage({
    required String title,
    required String description,
    required String image,
    double imageSize = 250,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image placeholder (will be replaced with actual images)
          Container(
            width: imageSize,
            height: imageSize,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(imageSize / 2),
            ),
            child: Center(
              child: Icon(
                _getIconForPage(_currentPage),
                size: imageSize / 2,
                color: AppColors.primary.withAlpha(150),
              ),
            ),
          ).animate().fadeIn(duration: 600.ms).slideY(
            begin: 0.2,
            end: 0,
            duration: 600.ms,
            curve: Curves.easeOutQuad,
          ),
          
          const SizedBox(height: 40),
          
          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ).animate().fadeIn(
            delay: 200.ms,
            duration: 600.ms,
          ),
          
          const SizedBox(height: 16),
          
          // Description
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ).animate().fadeIn(
            delay: 400.ms,
            duration: 600.ms,
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: isActive ? 24.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.border,
        borderRadius: BorderRadius.circular(4.0),
      ),
    );
  }
  
  IconData _getIconForPage(int page) {
    switch (page) {
      case 0:
        return Icons.family_restroom;
      case 1:
        return Icons.message_rounded;
      case 2:
        return Icons.child_care;
      default:
        return Icons.home;
    }
  }

  void _navigateToLogin() {
    Navigator.pushReplacementNamed(context, AppRouter.login);
  }
}
