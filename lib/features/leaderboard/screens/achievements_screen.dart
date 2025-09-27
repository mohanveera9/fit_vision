import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/utils/mock_data.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  final List<Map<String, dynamic>> _achievements = MockData.mockAchievements;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final unlockedAchievements = _achievements.where((a) => a['unlocked'] == true).length;
    final totalAchievements = _achievements.length;
    final progress = unlockedAchievements / totalAchievements;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Progress Header
            _buildProgressHeader(progress, unlockedAchievements, totalAchievements),
            
            // Achievements Grid
            _buildAchievementsGrid(),
            
            const SizedBox(height: AppDimensions.spacing24),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressHeader(double progress, int unlocked, int total) {
    return Container(
      margin: const EdgeInsets.all(AppDimensions.spacing16),
      padding: const EdgeInsets.all(AppDimensions.spacing24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.primaryContainer.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.scale(
            scale: _animation.value,
            child: Column(
              children: [
                // Trophy Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.warning,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.warning.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.emoji_events,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                
                const SizedBox(height: AppDimensions.spacing16),
                
                // Progress Text
                const Text(
                  'Achievement Progress',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                  ),
                ),
                
                const SizedBox(height: AppDimensions.spacing8),
                
                Text(
                  '$unlocked of $total achievements unlocked',
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                
                const SizedBox(height: AppDimensions.spacing20),
                
                // Progress Bar
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${(progress * 100).round()}%',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          '$unlocked/$total',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.spacing8),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: AppColors.surfaceVariant,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                      minHeight: 8,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAchievementsGrid() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.9,
          crossAxisSpacing: AppDimensions.spacing16,
          mainAxisSpacing: AppDimensions.spacing16,
        ),
        itemCount: _achievements.length,
        itemBuilder: (context, index) {
          final achievement = _achievements[index];
          
          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(milliseconds: 600),
            columnCount: 2,
            child: ScaleAnimation(
              child: FadeInAnimation(
                child: _buildAchievementCard(achievement),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAchievementCard(Map<String, dynamic> achievement) {
    final isUnlocked = achievement['unlocked'] == true;
    
    return GestureDetector(
      onTap: () => _showAchievementDetails(achievement),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spacing20),
        decoration: BoxDecoration(
          color: isUnlocked 
              ? AppColors.success.withOpacity(0.1)
              : AppColors.surfaceVariant.withOpacity(0.5),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          border: Border.all(
            color: isUnlocked 
                ? AppColors.success
                : AppColors.outline.withOpacity(0.3),
            width: isUnlocked ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Achievement Icon
            Stack(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: isUnlocked 
                        ? AppColors.success.withOpacity(0.2)
                        : AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Text(
                      achievement['icon'],
                      style: TextStyle(
                        fontSize: 30,
                        color: isUnlocked 
                            ? AppColors.success 
                            : AppColors.onSurfaceVariant.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
                if (isUnlocked)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
              ],
            ),
            
            const SizedBox(height: AppDimensions.spacing16),
            
            // Title
            Text(
              achievement['title'],
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isUnlocked 
                    ? AppColors.onSurface 
                    : AppColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            
            const SizedBox(height: AppDimensions.spacing8),
            
            // Description
            Text(
              achievement['description'],
              style: TextStyle(
                fontSize: 11,
                color: isUnlocked 
                    ? AppColors.onSurfaceVariant 
                    : AppColors.onSurfaceVariant.withOpacity(0.5),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            
            const SizedBox(height: AppDimensions.spacing12),
            
            // Status
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacing8,
                vertical: AppDimensions.spacing4,
              ),
              decoration: BoxDecoration(
                color: isUnlocked 
                    ? AppColors.success.withOpacity(0.2)
                    : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
              ),
              child: Text(
                isUnlocked ? 'Unlocked' : 'Locked',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: isUnlocked 
                      ? AppColors.success 
                      : AppColors.onSurfaceVariant,
                ),
              ),
            ),
            
            // Unlock Date (if unlocked)
            if (isUnlocked && achievement['unlockedAt'] != null)
              Padding(
                padding: const EdgeInsets.only(top: AppDimensions.spacing8),
                child: Text(
                  'Unlocked ${_formatDate(achievement['unlockedAt'])}',
                  style: const TextStyle(
                    fontSize: 9,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showAchievementDetails(Map<String, dynamic> achievement) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Text(
              achievement['icon'],
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(width: AppDimensions.spacing8),
            Expanded(
              child: Text(
                achievement['title'],
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              achievement['description'],
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: AppDimensions.spacing16),
            if (achievement['unlocked'] == true) ...[
              Container(
                padding: const EdgeInsets.all(AppDimensions.spacing12),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: AppColors.success,
                      size: 20,
                    ),
                    SizedBox(width: AppDimensions.spacing8),
                    Expanded(
                      child: Text(
                        'Achievement Unlocked!',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.success,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (achievement['unlockedAt'] != null) ...[
                const SizedBox(height: AppDimensions.spacing8),
                Text(
                  'Unlocked on ${_formatFullDate(achievement['unlockedAt'])}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ] else ...[
              Container(
                padding: const EdgeInsets.all(AppDimensions.spacing12),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.lock,
                      color: AppColors.warning,
                      size: 20,
                    ),
                    SizedBox(width: AppDimensions.spacing8),
                    Expanded(
                      child: Text(
                        'Keep working to unlock this achievement!',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.warning,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          if (achievement['unlocked'] == true)
            TextButton(
              onPressed: () => _shareAchievement(achievement),
              child: const Text('Share'),
            ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _shareAchievement(Map<String, dynamic> achievement) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing "${achievement['title']}" achievement!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 30) {
      return '${(difference.inDays / 30).round()}mo ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return 'Just now';
    }
  }

  String _formatFullDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
