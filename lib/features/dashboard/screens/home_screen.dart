import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/utils/mock_data.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/app_bar_custom.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _welcomeController;
  late AnimationController _metricsController;
  late Animation<double> _welcomeAnimation;
  late Animation<double> _metricsAnimation;

  @override
  void initState() {
    super.initState();

    _welcomeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _metricsController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _welcomeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _welcomeController, curve: Curves.easeOutBack),
    );

    _metricsAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _metricsController, curve: Curves.easeOutCubic),
    );

    _startAnimations();
  }

  void _startAnimations() async {
    await _welcomeController.forward();
    await Future.delayed(const Duration(milliseconds: 50));
    await _metricsController.forward();
  }

  @override
  void dispose() {
    _welcomeController.dispose();
    _metricsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NotificationAppBar(
        title: 'FitVision',
        notificationCount: 3,
        onNotificationTap: () {
          // Handle notification tap
        },
        onMenuTap: () {
          context.go('/settings');
        },
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Welcome Banner
              _buildWelcomeBanner(),

              // Metrics Cards
              _buildMetricsSection(),

              // Quick Actions
              _buildQuickActions(),

              // Recent Activity
              _buildRecentActivity(),

              // Leaderboard Preview
              _buildLeaderboardPreview(),

              const SizedBox(height: AppDimensions.spacing24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeBanner() {
    final user = MockData.mockUsers.first;

    return Container(
      margin: const EdgeInsets.all(AppDimensions.spacing16),
      padding: const EdgeInsets.all(AppDimensions.spacing24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryContainer],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: AnimatedBuilder(
        animation: _welcomeAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, 20 * (1 - _welcomeAnimation.value)),
            child: Opacity(
              opacity: _welcomeAnimation.value.clamp(0.0, 1.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.onPrimary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Icon(
                          Icons.person,
                          color: AppColors.onPrimary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.spacing16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome back,',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.onPrimary.withOpacity(0.8),
                              ),
                            ),
                            Text(
                              user.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.onPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.spacing12,
                          vertical: AppDimensions.spacing4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.onPrimary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusLarge,
                          ),
                        ),
                        child: Text(
                          user.league,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.spacing16),
                  const Text(
                    'Ready to continue your fitness journey?',
                    style: TextStyle(fontSize: 14, color: AppColors.onPrimary),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetricsSection() {
    final testResults = MockData.mockTestResults;
    final completedTests = testResults.where((test) => test.isCompleted).length;
    final totalScore = testResults
        .where((test) => test.isCompleted)
        .fold(0, (sum, test) => sum + test.score);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
      child: AnimatedBuilder(
        animation: _metricsAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _metricsAnimation.value,
            child: Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    title: 'Completed',
                    value: '$completedTests/6',
                    icon: Icons.check_circle,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(width: AppDimensions.spacing12),
                Expanded(
                  child: _buildMetricCard(
                    title: 'Total Score',
                    value: totalScore.toString(),
                    icon: Icons.star,
                    color: AppColors.warning,
                  ),
                ),
                const SizedBox(width: AppDimensions.spacing12),
                Expanded(
                  child: _buildMetricCard(
                    title: 'Rank',
                    value: '#${MockData.mockLeaderboardEntries.first.rank}',
                    icon: Icons.leaderboard,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: AppDimensions.spacing8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: AppDimensions.spacing4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      margin: const EdgeInsets.all(AppDimensions.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: AppDimensions.spacing16),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Start New Test',
                  onPressed: () => context.go('/tests'),
                  type: ButtonType.primary,
                  icon: Icons.play_arrow,
                ),
              ),
              const SizedBox(width: AppDimensions.spacing12),
              Expanded(
                child: CustomButton(
                  text: 'View Progress',
                  onPressed: () => context.go('/progress'),
                  type: ButtonType.outlined,
                  icon: Icons.trending_up,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Container(
      margin: const EdgeInsets.all(AppDimensions.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Activity',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              TextButton(
                onPressed: () => context.go('/progress'),
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacing16),
          ...MockData.mockTestResults
              .where((test) => test.isCompleted)
              .take(3)
              .map(
                (test) => AnimationConfiguration.staggeredList(
                  position: MockData.mockTestResults.indexOf(test),
                  duration: const Duration(milliseconds: 600),
                  child: SlideAnimation(
                    horizontalOffset: 50.0,
                    child: FadeInAnimation(child: _buildActivityItem(test)),
                  ),
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(test) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacing12),
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(color: AppColors.outline),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.check, color: AppColors.success, size: 20),
          ),
          const SizedBox(width: AppDimensions.spacing16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  test.testName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacing4),
                Text(
                  'Score: ${test.score} • ${test.percentile.toStringAsFixed(1)}% percentile',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            _formatDate(test.completedAt),
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardPreview() {
    return Container(
      margin: const EdgeInsets.all(AppDimensions.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Leaderboard',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              TextButton(
                onPressed: () => context.go('/leaderboard'),
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacing16),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              border: Border.all(color: AppColors.outline),
            ),
            child: Column(
              children: MockData.mockLeaderboardEntries
                  .take(3)
                  .map((entry) => _buildLeaderboardItem(entry))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardItem(entry) {
    final isCurrentUser =
        entry.rank == 1; // Assuming first entry is current user

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      decoration: BoxDecoration(
        color: isCurrentUser ? AppColors.primary.withOpacity(0.05) : null,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: isCurrentUser
                  ? AppColors.primary
                  : AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                entry.rankDisplay,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: isCurrentUser
                      ? AppColors.onPrimary
                      : AppColors.onSurface,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.spacing12),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.person,
              size: 16,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: AppDimensions.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.userName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isCurrentUser
                        ? AppColors.primary
                        : AppColors.onSurface,
                  ),
                ),
                Text(
                  entry.leagueDisplayName,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${entry.totalScore} pts',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshData() async {
    // Simulate data refresh
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      // Trigger rebuild
    });
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return 'Just now';
    }
  }
}
