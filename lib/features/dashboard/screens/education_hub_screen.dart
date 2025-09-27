import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../education/data/education_mock_data.dart';
import '../../education/models/education_models.dart';

class EducationHubScreen extends StatefulWidget {
  const EducationHubScreen({super.key});

  @override
  State<EducationHubScreen> createState() => _EducationHubScreenState();
}

class _EducationHubScreenState extends State<EducationHubScreen>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  int _completedModules = 0;
  int _totalModules = 0;
  final List<EducationModule> _modules = EducationMockData.modules;

  @override
  void initState() {
    super.initState();

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _recalculateProgress();

    _progressController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  void _navigateToHome() {
    context.go('/home');
  }

  void _recalculateProgress() {
    _totalModules = _modules.length;
    _completedModules = _modules.where((m) => m.completedLessons == m.totalLessons).length;
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: _totalModules == 0 ? 0 : _completedModules / _totalModules,
    ).animate(CurvedAnimation(parent: _progressController, curve: Curves.easeInOut));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

            // Progress Section
            _buildProgressSection(),

            // Quick Tips Section
            _buildTipsSection(),

            // Modules Grid
            Expanded(child: _buildModulesGrid()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(left:  AppDimensions.spacing24 , right: AppDimensions.spacing24, top: AppDimensions.spacing24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const Text(
            'Learn & Improve',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: AppDimensions.spacing16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            ),
            child: const Text(
              'Knowledge is your strongest muscle',
              style: TextStyle(fontSize: 14, color: AppColors.onSurface),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing24, vertical: AppDimensions.spacing12),
      padding: const EdgeInsets.all(AppDimensions.spacing20),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Learning Progress',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
              ),
              AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  final percent = (_progressAnimation.value * 100).round();
                  return Text(
                    '$percent% completed',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacing12),
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return LinearProgressIndicator(
                value: _progressAnimation.value,
                backgroundColor: AppColors.surfaceVariant,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.primary,
                ),
                minHeight: 8,
              );
            },
          ),
          const SizedBox(height: AppDimensions.spacing8),
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return Text(
                '${(_progressAnimation.value * 100).round()}% Complete',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.onSurfaceVariant,
                ),
              );
            },
          ),

        ],
      ),
    );
  }

  Widget _buildModulesGrid() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacing24),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.9,
          crossAxisSpacing: AppDimensions.spacing16,
          mainAxisSpacing: AppDimensions.spacing16,
        ),
        itemCount: _modules.length,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(milliseconds: 600),
            columnCount: 2,
            child: ScaleAnimation(
              child: FadeInAnimation(
                child: _buildModuleCard(_modules[index], index),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildModuleCard(EducationModule module, int index) {
    final isCompleted = module.completedLessons == module.totalLessons;
    final isAvailable = true;

    return GestureDetector(
      onTap: isAvailable ? () => context.go('/education/${module.id}') : null,
      child: Container(
        decoration: BoxDecoration(
          color: isCompleted
              ? AppColors.success.withOpacity(0.1)
              : isAvailable
              ? AppColors.surface
              : AppColors.surfaceVariant.withOpacity(0.5),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          border: Border.all(
            color: isCompleted
                ? AppColors.success
                : isAvailable
                ? AppColors.outline
                : AppColors.outline.withOpacity(0.3),
            width: isCompleted ? 2 : 1,
          ),
          boxShadow: isAvailable
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon and Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: module.color.withOpacity(0.15),
                    child: Icon(module.icon, color: module.color),
                  ),
                  if (isCompleted)
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.success,
                      size: 20,
                    ),
                ],
              ),

              const Spacer(),

              // Title
              Text(
                module.title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isAvailable
                      ? AppColors.onSurface
                      : AppColors.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: AppDimensions.spacing4),

              // Duration
              Text(
                module.duration,
                style: TextStyle(
                  fontSize: 12,
                  color: isAvailable
                      ? AppColors.onSurfaceVariant
                      : AppColors.onSurfaceVariant.withOpacity(0.5),
                ),
              ),

              const SizedBox(height: AppDimensions.spacing8),

              // Difficulty Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacing8,
                  vertical: AppDimensions.spacing4,
                ),
                decoration: BoxDecoration(
                  color: _getDifficultyColor(module.difficulty).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusSmall,
                  ),
                ),
                child: Text(
                  module.difficulty,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: _getDifficultyColor(module.difficulty),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return AppColors.success;
      case 'medium':
        return AppColors.warning;
      case 'hard':
        return AppColors.error;
      default:
        return AppColors.onSurfaceVariant;
    }
  }


  // Quick Tips Section
  Widget _buildTipsSection() {
    const tips = [
      'Hydrate: 500ml water 2 hours pre-training',
      'Sleep: Aim for 7-9 hours nightly',
      'Warm-up: Raise, Activate, Mobilize',
      'Recovery: Protein + carbs post training',
    ];
    return SizedBox(
      height: 120,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing24),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tip = tips[index % tips.length];
          return Container(
            width: 240,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              border: Border.all(color: AppColors.outline),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tip of the Day', style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Expanded(child: Text(tip, style: const TextStyle(color: AppColors.onSurface))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Chip(label: Text('Nutrition'), visualDensity: VisualDensity.compact),
                    Icon(Icons.share, size: 18),
                  ],
                )
              ],
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemCount: 4,
      ),
    );
  }
}
