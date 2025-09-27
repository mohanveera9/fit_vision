import 'package:fit_vision/shared/models/test_result_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/utils/mock_data.dart';
import '../../../shared/widgets/app_bar_custom.dart';

class TestSelectionScreen extends StatefulWidget {
  const TestSelectionScreen({super.key});

  @override
  State<TestSelectionScreen> createState() => _TestSelectionScreenState();
}

class _TestSelectionScreenState extends State<TestSelectionScreen>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  final List<TestResultModel> _testResults = MockData.mockTestResults;
  bool _showHiddenTests = false; // Toggle for showing isVisible: false tests

  @override
  void initState() {
    super.initState();

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    final completedTests = _testResults
        .where((test) => test.isCompleted)
        .length;
    _progressAnimation =
        Tween<double>(
          begin: 0.0,
          end: completedTests / _testResults.length,
        ).animate(
          CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
        );

    _progressController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  void _navigateToTest(String testId) {
    switch (testId) {
      case 'height':
        context.go('/tests/height');
        break;
      case 'weight':
        context.go('/tests/weight');
        break;
      case 'verticaljump':
        context.go('/tests/verticaljump/tutorial');
        break;
      case 'situps':
        context.go('/tests/situps/tutorial');
        break;
      case 'running':
        context.go('/tests/running/tutorial');
        break;
      case 'shuttlerun':
        context.go('/tests/shuttlerun/tutorial');
        break;
    }
  }

  void _viewTestResults(String testId) {
    context.go('/tests/$testId/results');
  }

  void _toggleVisibilityMode() {
    setState(() {
      _showHiddenTests = !_showHiddenTests;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Fitness Tests',
        actions: [
          Icon(Icons.help_outline),
          SizedBox(width: AppDimensions.spacing8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Progress Section
            _buildProgressSection(),

            // Tests Grid
            _buildTestsGrid(),

            // Change Height and Weight Section
            _buildChangeHeightWeightSection(),

            const SizedBox(height: AppDimensions.spacing24),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSection() {
    final completedTests = 2;
    final totalTests = 4;

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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Test Progress',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              Text(
                '$completedTests/$totalTests',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacing16),
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
          const SizedBox(height: AppDimensions.spacing12),
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
          if (completedTests == totalTests) ...[
            const SizedBox(height: AppDimensions.spacing16),
            Container(
              padding: const EdgeInsets.all(AppDimensions.spacing12),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.emoji_events,
                    color: AppColors.success,
                    size: 20,
                  ),
                  const SizedBox(width: AppDimensions.spacing8),
                  const Expanded(
                    child: Text(
                      'Congratulations! All tests completed.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.success,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go('/leaderboard'),
                    child: const Text('View Rankings'),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTestsGrid() {
    // Filter tests based on visibility mode
    final filteredTests = _testResults.where((test) {
      final testDefinition = MockData.mockTestDefinitions.firstWhere(
        (def) => def['id'] == test.testId.split('_')[0],
        orElse: () => {},
      );

      if (testDefinition.isEmpty) return false;

      // If showing hidden tests, show only isVisible: false tests
      // Otherwise, show only isVisible: true tests
      return _showHiddenTests
          ? testDefinition['isVisible'] == false
          : testDefinition['isVisible'] == true;
    }).toList();

    // Sort tests: height and weight tests go to the end
    filteredTests.sort((a, b) {
      final aIsHeightWeight =
          a.testId.contains('height') || a.testId.contains('weight');
      final bIsHeightWeight =
          b.testId.contains('height') || b.testId.contains('weight');

      if (aIsHeightWeight && !bIsHeightWeight) return 1;
      if (!aIsHeightWeight && bIsHeightWeight) return -1;

      // For non-height/weight tests, maintain original order
      return 0;
    });

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
        itemCount: filteredTests.length,
        itemBuilder: (context, index) {
          final test = filteredTests[index];
          final testDefinition = MockData.mockTestDefinitions.firstWhere(
            (def) => def['id'] == test.testId.split('_')[0],
          );

          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(milliseconds: 600),
            columnCount: 2,
            child: ScaleAnimation(
              child: FadeInAnimation(
                child: _buildTestCard(test, testDefinition),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTestCard(
    TestResultModel test,
    Map<String, dynamic> testDefinition,
  ) {
    final isCompleted = test.isCompleted;
    final isAvailable = test.isCompleted || _canStartTest(test);

    return GestureDetector(
      onTap: isAvailable
          ? (isCompleted
                ? () => _viewTestResults(test.testId.split('_')[0])
                : () => _navigateToTest(test.testId.split('_')[0]))
          : null,
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
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isAvailable
                          ? AppColors.primary.withOpacity(0.1)
                          : AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      testDefinition['icon'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: isAvailable
                            ? AppColors.primary
                            : AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                  if (isCompleted)
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: AppColors.onError,
                        size: 12,
                      ),
                    ),
                ],
              ),

              const Spacer(),

              // Title
              Text(
                test.testName,
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
                testDefinition['duration'],
                style: TextStyle(
                  fontSize: 12,
                  color: isAvailable
                      ? AppColors.onSurfaceVariant
                      : AppColors.onSurfaceVariant.withOpacity(0.5),
                ),
              ),

              const SizedBox(height: AppDimensions.spacing8),

              // Status/Score
              if (isCompleted) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacing8,
                    vertical: AppDimensions.spacing4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusSmall,
                    ),
                  ),
                  child: Text(
                    'Score: ${test.score}',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.success,
                    ),
                  ),
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacing8,
                    vertical: AppDimensions.spacing4,
                  ),
                  decoration: BoxDecoration(
                    color: _getDifficultyColor(
                      testDefinition['difficulty'],
                    ).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusSmall,
                    ),
                  ),
                  child: Text(
                    isAvailable ? 'Ready' : 'Locked',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: _getDifficultyColor(testDefinition['difficulty']),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  bool _canStartTest(TestResultModel test) {
    // Height and weight tests are always available
    if (test.testId.contains('height') || test.testId.contains('weight')) {
      return true;
    }

    // Other tests require height and weight to be completed first
    final heightCompleted = _testResults.any(
      (t) => t.testId.contains('height') && t.isCompleted,
    );
    final weightCompleted = _testResults.any(
      (t) => t.testId.contains('weight') && t.isCompleted,
    );

    return heightCompleted && weightCompleted;
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

  Widget _buildChangeHeightWeightSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: GestureDetector(
        onTap: _toggleVisibilityMode,
        child: Container(
          
          child: Row(
            children: [
              Icon(
                _showHiddenTests ? Icons.visibility_off : Icons.edit,
                color: _showHiddenTests ? Colors.red : Colors.blue,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _showHiddenTests
                      ? 'Show Fitness Tests'
                      : 'Edit Height & Weight',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: _showHiddenTests ? Colors.red : Colors.blue,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: _showHiddenTests ? Colors.red : Colors.blue,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
