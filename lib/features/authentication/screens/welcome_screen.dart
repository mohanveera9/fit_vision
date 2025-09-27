import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../shared/widgets/custom_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'Welcome to FitVision',
      'description':
          'Join thousands of athletes aged 12-35 in comprehensive fitness testing and talent discovery.',
      'image': '🏃‍♂️',
      'color': AppColors.primary,
    },
    {
      'title': 'Comprehensive Testing',
      'subtitle': '6 Essential Fitness Tests',
      'description':
          'Height, Weight, Push-ups, Sit-ups, Running, and Flexibility tests designed by sports experts.',
      'image': '💪',
      'color': AppColors.secondary,
    },
    {
      'title': 'Competitive Rankings',
      'subtitle': 'Compete with Your Peers',
      'description':
          'See how you rank against athletes in your age group and gender category.',
      'image': '🏆',
      'color': AppColors.success,
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToRegister();
    }
  }

  void _navigateToRegister() {
    context.go('/register/name');
  }

  void _navigateToLogin() {
    // For demo purposes, navigate to home
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // PageView
            Expanded(
              flex: 3,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 600),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(child: _buildPageContent(page)),
                    ),
                  );
                },
              ),
            ),

            // Page Indicators
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: AppDimensions.spacing24,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? AppColors.primary
                          : AppColors.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),

            // Action Buttons
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.spacing24),
                child: Column(
                  children: [
                    // Primary Button
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        text: _currentPage == _pages.length - 1
                            ? 'Get Started'
                            : 'Next',
                        onPressed: _nextPage,
                        type: ButtonType.primary,
                      ),
                    ),

                    const SizedBox(height: AppDimensions.spacing16),

                    // Secondary Button
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        text: 'Already have an account?',
                        onPressed: _navigateToLogin,
                        type: ButtonType.text,
                        textColor: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageContent(Map<String, dynamic> page) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacing32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Emoji/Icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: (page['color'] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(60),
            ),
            child: Center(
              child: Text(page['image'], style: const TextStyle(fontSize: 60)),
            ),
          ),

          const SizedBox(height: AppDimensions.spacing32),

          // Title
          Text(
            page['title'],
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppDimensions.spacing16),


          // Description
          Text(
            page['description'],
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.onSurfaceVariant,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
