import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../shared/widgets/custom_button.dart';

class ProfileConfirmationScreen extends StatefulWidget {
  const ProfileConfirmationScreen({super.key});

  @override
  State<ProfileConfirmationScreen> createState() => _ProfileConfirmationScreenState();
}

class _ProfileConfirmationScreenState extends State<ProfileConfirmationScreen>
    with TickerProviderStateMixin {
  late AnimationController _checkmarkController;
  late AnimationController _cardController;
  late Animation<double> _checkmarkAnimation;
  late Animation<double> _cardAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    
    _checkmarkController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _cardController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _checkmarkAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _checkmarkController,
      curve: Curves.elasticOut,
    ));

    _cardAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cardController,
      curve: Curves.easeOutBack,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _cardController,
      curve: Curves.easeOutCubic,
    ));

    _startAnimations();
  }

  void _startAnimations() async {
    await _cardController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    await _checkmarkController.forward();
  }

  @override
  void dispose() {
    _checkmarkController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  void _completeRegistration() {
    setState(() {
      _isLoading = true;
    });

    // Simulate registration completion
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        context.go('/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.spacing24),
          child: Column(
            children: [
              const SizedBox(height: AppDimensions.spacing32),

              // Progress Indicator
              _buildProgressIndicator(),
              
              const SizedBox(height: AppDimensions.spacing40),

              // Success Checkmark Animation
              AnimatedBuilder(
                animation: _checkmarkAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _checkmarkAnimation.value,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.success.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.check,
                        color: AppColors.onError,
                        size: 50,
                      ),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: AppDimensions.spacing32),

              // Title
              const Text(
                'Profile Created Successfully!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: AppDimensions.spacing12),
              
              const Text(
                'Your account has been set up and verified',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: AppDimensions.spacing40),

              // Profile Card
              AnimatedBuilder(
                animation: _cardAnimation,
                builder: (context, child) {
                  return SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _cardAnimation,
                      child: _buildProfileCard(),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: AppDimensions.spacing32),

              // League Information
              _buildLeagueInfo(),
              
              const SizedBox(height: AppDimensions.spacing40),

              // Continue Button
              CustomButton(
                text: 'Continue to FitVision',
                onPressed: _isLoading ? null : _completeRegistration,
                isLoading: _isLoading,
                type: ButtonType.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Step 3 of 3',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.onSurface,
              ),
            ),
            Text(
              '100%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        SizedBox(height: AppDimensions.spacing8),
        LinearProgressIndicator(
          value: 1.0,
          backgroundColor: AppColors.surfaceVariant,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.success),
        ),
      ],
    );
  }

  Widget _buildProfileCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spacing24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(
              Icons.person,
              size: 40,
              color: AppColors.primary,
            ),
          ),
          
          const SizedBox(height: AppDimensions.spacing16),
          
          // Name
          const Text(
            'Arjun Singh',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
          
          const SizedBox(height: AppDimensions.spacing8),
          
          // Email
          const Text(
            'arjun.singh@email.com',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          
          const SizedBox(height: AppDimensions.spacing16),
          
          // Profile Details
          Row(
            children: [
              Expanded(
                child: _buildDetailItem(
                  icon: Icons.cake,
                  label: 'Age',
                  value: '24 years',
                ),
              ),
              Expanded(
                child: _buildDetailItem(
                  icon: Icons.person,
                  label: 'Gender',
                  value: 'Male',
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppDimensions.spacing16),
          
          // League Chip
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacing16,
              vertical: AppDimensions.spacing8,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.emoji_events,
                  color: AppColors.primary,
                  size: 16,
                ),
                SizedBox(width: AppDimensions.spacing8),
                Text(
                  'Youth League (18-25)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: 20,
        ),
        const SizedBox(height: AppDimensions.spacing4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppDimensions.spacing4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildLeagueInfo() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.info_outline,
            color: AppColors.secondary,
            size: 20,
          ),
          SizedBox(width: AppDimensions.spacing12),
          Expanded(
            child: Text(
              'You\'re competing in the Youth League (18-25 years). Your scores will be compared with athletes in the same age group.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.onSurface,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
