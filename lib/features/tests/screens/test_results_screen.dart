import 'package:fit_vision/shared/models/test_result_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/utils/mock_data.dart';
import '../../../shared/widgets/custom_button.dart';

class TestResultsScreen extends StatefulWidget {
  final String testId;

  const TestResultsScreen({super.key, required this.testId});

  @override
  State<TestResultsScreen> createState() => _TestResultsScreenState();
}

class _TestResultsScreenState extends State<TestResultsScreen>
    with TickerProviderStateMixin {
  late AnimationController _resultsController;
  late AnimationController _chartController;
  late Animation<double> _resultsAnimation;
  late Animation<double> _chartAnimation;

  Map<String, dynamic>? _testDefinition;
  TestResultModel? _testResult;

  @override
  void initState() {
    super.initState();

    _testDefinition = MockData.mockTestDefinitions.firstWhere(
      (test) => test['id'] == widget.testId,
      orElse: () => MockData.mockTestDefinitions.first,
    );

    _testResult = MockData.mockTestResults.firstWhere(
      (test) => test.testId.contains(widget.testId),
      orElse: () => TestResultModel(
        testId: '${widget.testId}_1',
        testName: _testDefinition?['name'] ?? 'Test',
        testType: TestType.pushUps,
        score: 0,
        percentile: 0,
        completedAt: DateTime.now(),
        status: TestStatus.completed,
      ),
    );

    _resultsController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _chartController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _resultsAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _resultsController, curve: Curves.easeOutBack),
    );

    _chartAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _chartController, curve: Curves.easeOutCubic),
    );

    _startAnimations();
  }

  void _startAnimations() async {
    await _resultsController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    await _chartController.forward();
  }

  @override
  void dispose() {
    _resultsController.dispose();
    _chartController.dispose();
    super.dispose();
  }

  void _shareResults() {
    // Simulate sharing
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Results shared successfully!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _viewAllResults() {
    context.go('/tests');
  }

  void _startNextTest() {
    // Logic to determine next test
    context.go('/tests');
  }

  @override
  Widget build(BuildContext context) {
    if (_testDefinition == null || _testResult == null) {
      return const Scaffold(
        body: Center(child: Text('Test results not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Results'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/tests');
          },
        ),
        actions: [
          IconButton(icon: const Icon(Icons.share), onPressed: _shareResults),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Success Header
            _buildSuccessHeader(),

            // Score Card
            _buildScoreCard(),

            // Percentile Chart
            _buildPercentileChart(),

            // Performance Analysis
            _buildPerformanceAnalysis(),

            // Comparison Chart
            _buildComparisonChart(),

            const SizedBox(height: AppDimensions.spacing24),

            // Action Buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessHeader() {
    return Container(
      margin: const EdgeInsets.all(AppDimensions.spacing16),
      padding: const EdgeInsets.all(AppDimensions.spacing24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.success.withOpacity(0.1),
            AppColors.success.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: AnimatedBuilder(
        animation: _resultsAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _resultsAnimation.value,
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: const Icon(
                    Icons.check,
                    color: AppColors.onError,
                    size: 40,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacing16),
                const Text(
                  'Test Completed!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacing8),
                Text(
                  _testDefinition!['name'],
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildScoreCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
      padding: const EdgeInsets.all(AppDimensions.spacing24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildScoreItem(
                title: 'Score',
                value: '${_testResult!.score}',
                subtitle: _getScoreUnit(),
                color: AppColors.primary,
              ),
              Container(width: 1, height: 60, color: AppColors.outline),
              _buildScoreItem(
                title: 'Percentile',
                value: '${_testResult!.percentile.toStringAsFixed(1)}%',
                subtitle: 'vs. peers',
                color: AppColors.secondary,
              ),
              Container(width: 1, height: 60, color: AppColors.outline),
              _buildScoreItem(
                title: 'Rating',
                value: _getRating(_testResult!.percentile),
                subtitle: _getRatingText(_testResult!.percentile),
                color: _getRatingColor(_testResult!.percentile),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreItem({
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppDimensions.spacing4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: AppDimensions.spacing4),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildPercentileChart() {
    return Container(
      margin: const EdgeInsets.all(AppDimensions.spacing16),
      padding: const EdgeInsets.all(AppDimensions.spacing20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Performance',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: AppDimensions.spacing20),
          AnimatedBuilder(
            animation: _chartAnimation,
            builder: (context, child) {
              return SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        value: _testResult!.percentile * _chartAnimation.value,
                        color: AppColors.primary,
                        title: 'Your Score',
                        radius: 60,
                        titleStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      PieChartSectionData(
                        value:
                            (100 - _testResult!.percentile) *
                            _chartAnimation.value,
                        color: AppColors.surfaceVariant,
                        title: 'Others',
                        radius: 60,
                        titleStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: AppDimensions.spacing16),
          Center(
            child: Text(
              'You scored better than ${_testResult!.percentile.toStringAsFixed(1)}% of participants',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceAnalysis() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
      padding: const EdgeInsets.all(AppDimensions.spacing20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Performance Analysis',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: AppDimensions.spacing16),
          _buildAnalysisItem(
            title: 'Strength Level',
            value: _getStrengthLevel(),
            icon: Icons.fitness_center,
            color: AppColors.primary,
          ),
          const SizedBox(height: AppDimensions.spacing12),
          _buildAnalysisItem(
            title: 'Improvement Area',
            value: _getImprovementArea(),
            icon: Icons.trending_up,
            color: AppColors.secondary,
          ),
          const SizedBox(height: AppDimensions.spacing12),
          _buildAnalysisItem(
            title: 'Next Goal',
            value: _getNextGoal(),
            icon: Icons.flag,
            color: AppColors.success,
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisItem({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Row(
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
        const SizedBox(width: AppDimensions.spacing16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildComparisonChart() {
    return Container(
      margin: const EdgeInsets.all(AppDimensions.spacing16),
      padding: const EdgeInsets.all(AppDimensions.spacing20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Age Group Comparison',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: AppDimensions.spacing20),
          AnimatedBuilder(
            animation: _chartAnimation,
            builder: (context, child) {
              return SizedBox(
                height: 150,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 100,
                    barTouchData: BarTouchData(enabled: false),
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const titles = ['12-17', '18-25', '26-35'];
                            return Text(
                              titles[value.toInt()],
                              style: const TextStyle(
                                color: AppColors.onSurfaceVariant,
                                fontSize: 12,
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              '${value.toInt()}%',
                              style: const TextStyle(
                                color: AppColors.onSurfaceVariant,
                                fontSize: 12,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: [
                      BarChartGroupData(
                        x: 0,
                        barRods: [
                          BarChartRodData(
                            toY: 75.0 * _chartAnimation.value,
                            color: AppColors.surfaceVariant,
                            width: 20,
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 1,
                        barRods: [
                          BarChartRodData(
                            toY:
                                _testResult!.percentile * _chartAnimation.value,
                            color: AppColors.primary,
                            width: 20,
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 2,
                        barRods: [
                          BarChartRodData(
                            toY: 82.0 * _chartAnimation.value,
                            color: AppColors.surfaceVariant,
                            width: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: AppDimensions.spacing16),
          const Center(
            child: Text(
              'You\'re performing well in your age group (18-25)',
              style: TextStyle(fontSize: 14, color: AppColors.onSurfaceVariant),
              textAlign: TextAlign.center,
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
            text: 'Continue to Next Test',
            onPressed: _startNextTest,
            type: ButtonType.primary,
            icon: Icons.play_arrow,
          ),
          const SizedBox(height: AppDimensions.spacing12),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'View All Tests',
                  onPressed: _viewAllResults,
                  type: ButtonType.outlined,
                  icon: Icons.list,
                ),
              ),
              const SizedBox(width: AppDimensions.spacing12),
              Expanded(
                child: CustomButton(
                  text: 'Share Results',
                  onPressed: _shareResults,
                  type: ButtonType.outlined,
                  icon: Icons.share,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getScoreUnit() {
    switch (widget.testId) {
      case 'pushups':
      case 'situps':
        return 'reps';
      case 'running':
        return 'meters';
      case 'flexibility':
        return 'cm';
      case 'height':
        return 'cm';
      case 'weight':
        return 'kg';
      default:
        return 'points';
    }
  }

  String _getRating(double percentile) {
    if (percentile >= 90) return 'A+';
    if (percentile >= 80) return 'A';
    if (percentile >= 70) return 'B+';
    if (percentile >= 60) return 'B';
    if (percentile >= 50) return 'C+';
    return 'C';
  }

  String _getRatingText(double percentile) {
    if (percentile >= 90) return 'Excellent';
    if (percentile >= 80) return 'Very Good';
    if (percentile >= 70) return 'Good';
    if (percentile >= 60) return 'Above Average';
    if (percentile >= 50) return 'Average';
    return 'Below Average';
  }

  Color _getRatingColor(double percentile) {
    if (percentile >= 80) return AppColors.success;
    if (percentile >= 60) return AppColors.warning;
    return AppColors.error;
  }

  String _getStrengthLevel() {
    if (_testResult!.percentile >= 80) return 'High';
    if (_testResult!.percentile >= 60) return 'Moderate';
    return 'Developing';
  }

  String _getImprovementArea() {
    if (_testResult!.percentile < 60) return 'Focus on technique';
    if (_testResult!.percentile < 80) return 'Increase intensity';
    return 'Maintain consistency';
  }

  String _getNextGoal() {
    if (widget.testId == 'pushups') {
      return '${_testResult!.score + 5} push-ups';
    } else if (widget.testId == 'situps') {
      return '${_testResult!.score + 3} sit-ups';
    } else {
      return 'Improve by 10%';
    }
  }
}
