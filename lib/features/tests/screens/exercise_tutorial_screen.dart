import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/utils/mock_data.dart';
import '../../../shared/widgets/custom_button.dart';

class ExerciseTutorialScreen extends StatefulWidget {
  final String testId;

  const ExerciseTutorialScreen({super.key, required this.testId});

  @override
  State<ExerciseTutorialScreen> createState() => _ExerciseTutorialScreenState();
}

class _ExerciseTutorialScreenState extends State<ExerciseTutorialScreen>
    with TickerProviderStateMixin {
  late AnimationController _videoController;
  late AnimationController _instructionsController;
  late Animation<double> _videoAnimation;
  late Animation<double> _instructionsAnimation;

  bool _isPlaying = false;
  final bool _showInstructions = true;

  Map<String, dynamic>? _testDefinition;

  @override
  void initState() {
    super.initState();

    _testDefinition = MockData.mockTestDefinitions.firstWhere(
      (test) => test['id'] == widget.testId,
      orElse: () => MockData.mockTestDefinitions.first,
    );

    _videoController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _instructionsController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _videoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _videoController, curve: Curves.easeOutBack),
    );

    _instructionsAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _instructionsController,
        curve: Curves.easeOutCubic,
      ),
    );

    _videoController.forward();
    _instructionsController.forward();
  }

  @override
  void dispose() {
    _videoController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  void _startTest() {
    context.go('/tests/${widget.testId}/live');
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_testDefinition == null) {
      return const Scaffold(body: Center(child: Text('Test not found')));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_testDefinition!['name']),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/tests'),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Video Player Section
            _buildVideoPlayer(),

            // Test Info
            _buildTestInfo(),

            // Instructions
            _buildInstructions(),

            // Tips
            _buildTips(),

            const SizedBox(height: AppDimensions.spacing24),

            // Action Buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return Container(
      margin: const EdgeInsets.all(AppDimensions.spacing16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: AnimatedBuilder(
        animation: _videoAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _videoAnimation.value,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  children: [
                    // Video Background (Simulated)
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.grey[900],
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _getTestIcon(widget.testId),
                              size: 60,
                              color: Colors.white54,
                            ),
                            const SizedBox(height: AppDimensions.spacing16),
                            Text(
                              _testDefinition!['name'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: AppDimensions.spacing8),
                            Text(
                              'Tutorial Video',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Play Button Overlay
                    Center(
                      child: GestureDetector(
                        onTap: _togglePlayPause,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ),

                    // Video Controls (Bottom)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(AppDimensions.spacing16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: _togglePlayPause,
                              child: Icon(
                                _isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: AppDimensions.spacing16),
                            Expanded(
                              child: Container(
                                height: 4,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: FractionallySizedBox(
                                  alignment: Alignment.centerLeft,
                                  widthFactor: 0.3, // Simulated progress
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppDimensions.spacing16),
                            const Text(
                              '2:30 / 5:00',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTestInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
      padding: const EdgeInsets.all(AppDimensions.spacing20),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    _testDefinition!['icon'],
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.spacing16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _testDefinition!['name'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacing4),
                    Text(
                      _testDefinition!['description'],
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacing16),
          Row(
            children: [
              _buildInfoChip(
                icon: Icons.timer,
                label: 'Duration',
                value: _testDefinition!['duration'],
              ),
              const SizedBox(width: AppDimensions.spacing12),
              _buildInfoChip(
                icon: Icons.trending_up,
                label: 'Difficulty',
                value: _testDefinition!['difficulty'],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spacing12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: AppColors.primary),
            const SizedBox(width: AppDimensions.spacing8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructions() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Instructions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: AppDimensions.spacing16),
          ..._testDefinition!['instructions'].map<Widget>((instruction) {
            final index = _testDefinition!['instructions'].indexOf(instruction);
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 600),
              child: SlideAnimation(
                horizontalOffset: 50.0,
                child: FadeInAnimation(
                  child: Container(
                    margin: const EdgeInsets.only(
                      bottom: AppDimensions.spacing12,
                    ),
                    padding: const EdgeInsets.all(AppDimensions.spacing16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusSmall,
                      ),
                      border: Border.all(color: AppColors.outline),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                color: AppColors.onPrimary,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppDimensions.spacing12),
                        Expanded(
                          child: Text(
                            instruction,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.onSurface,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTips() {
    return Container(
      margin: const EdgeInsets.all(AppDimensions.spacing16),
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
        border: Border.all(color: AppColors.warning.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.lightbulb_outline,
            color: AppColors.warning,
            size: 20,
          ),
          const SizedBox(width: AppDimensions.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pro Tip',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacing4),
                Text(
                  _getProTip(widget.testId),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      child: Column(
        children: [
          CustomButton(
            text: 'Start Test',
            onPressed: _startTest,
            type: ButtonType.primary,
            icon: Icons.play_arrow,
          ),
          const SizedBox(height: AppDimensions.spacing12),
          CustomButton(
            text: 'Watch Again',
            onPressed: () {
              setState(() {
                _isPlaying = true;
              });
            },
            type: ButtonType.outlined,
            icon: Icons.replay,
          ),
        ],
      ),
    );
  }

  IconData _getTestIcon(String testId) {
    switch (testId) {
      case 'pushups':
        return Icons.fitness_center;
      case 'situps':
        return Icons.accessibility_new;
      case 'running':
        return Icons.directions_run;
      case 'flexibility':
        return Icons.accessibility;
      default:
        return Icons.fitness_center;
    }
  }

  String _getProTip(String testId) {
    switch (testId) {
      case 'pushups':
        return 'Focus on maintaining a straight line from head to heels. Lower your chest until it nearly touches the ground, then push up with controlled movement.';
      case 'situps':
        return 'Keep your feet flat on the ground and your hands behind your head. Lift your shoulders off the ground and return to starting position smoothly.';
      case 'running':
        return 'Start at a comfortable pace and maintain steady breathing. Use your arms to help propel you forward and land on the balls of your feet.';
      case 'flexibility':
        return 'Warm up your muscles before stretching. Move slowly and hold each position for 2-3 seconds. Don\'t bounce or force the stretch.';
      default:
        return 'Follow the instructions carefully and maintain proper form throughout the test.';
    }
  }
}
