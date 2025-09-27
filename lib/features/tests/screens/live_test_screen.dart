import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/utils/mock_data.dart';
import '../../../shared/widgets/custom_button.dart';

class LiveTestScreen extends StatefulWidget {
  final String testId;

  const LiveTestScreen({super.key, required this.testId});

  @override
  State<LiveTestScreen> createState() => _LiveTestScreenState();
}

class _LiveTestScreenState extends State<LiveTestScreen>
    with TickerProviderStateMixin {
  late AnimationController _timerController;
  late AnimationController _counterController;
  late Animation<double> _timerAnimation;
  late Animation<double> _counterAnimation;

  Timer? _testTimer;
  Timer? _countdownTimer;

  bool _isTestRunning = false;
  bool _isTestCompleted = false;
  int _testDuration = 60; // seconds
  int _currentTime = 60;
  int _currentCount = 0;
  int _targetCount = 0;

  Map<String, dynamic>? _testDefinition;

  @override
  void initState() {
    super.initState();

    _testDefinition = MockData.mockTestDefinitions.firstWhere(
      (test) => test['id'] == widget.testId,
      orElse: () => MockData.mockTestDefinitions.first,
    );

    _timerController = AnimationController(
      duration: Duration(seconds: _testDuration),
      vsync: this,
    );

    _counterController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _timerAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _timerController, curve: Curves.linear));

    _counterAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _counterController, curve: Curves.elasticOut),
    );

    _setupTestParameters();
  }

  void _setupTestParameters() {
    switch (widget.testId) {
      case 'pushups':
        _testDuration = 60;
        _targetCount = 30;
        break;
      case 'situps':
        _testDuration = 60;
        _targetCount = 25;
        break;
      case 'running':
        _testDuration = 720; // 12 minutes
        _targetCount = 0; // Distance-based
        break;
      case 'flexibility':
        _testDuration = 180; // 3 minutes
        _targetCount = 0; // Distance-based
        break;
    }
    _currentTime = _testDuration;
    _timerController.duration = Duration(seconds: _testDuration);
  }

  @override
  void dispose() {
    _testTimer?.cancel();
    _countdownTimer?.cancel();
    _timerController.dispose();
    _counterController.dispose();
    super.dispose();
  }

  void _startTest() {
    setState(() {
      _isTestRunning = true;
    });

    _timerController.forward();

    _testTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = _testDuration - timer.tick;
      });

      if (_currentTime <= 0) {
        _completeTest();
      }
    });
  }

  void _incrementCount() {
    if (!_isTestRunning || _isTestCompleted) return;

    setState(() {
      _currentCount++;
    });

    _counterController.forward(from: 0.0);

    // Haptic feedback simulation
    // HapticFeedback.mediumImpact();
  }

  void _completeTest() {
    setState(() {
      _isTestRunning = false;
      _isTestCompleted = true;
    });

    _testTimer?.cancel();
    _timerController.stop();

    // Show completion dialog
    _showCompletionDialog();
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Test Completed!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Icon(
                Icons.check,
                color: AppColors.success,
                size: 40,
              ),
            ),
            const SizedBox(height: AppDimensions.spacing16),
            Text(
              _getResultText(),
              style: const TextStyle(fontSize: 16, color: AppColors.onSurface),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/tests/${widget.testId}/results');
            },
            child: const Text('View Results'),
          ),
        ],
      ),
    );
  }

  String _getResultText() {
    if (widget.testId == 'pushups' || widget.testId == 'situps') {
      return 'You completed $_currentCount reps in ${_testDuration - _currentTime} seconds!';
    } else if (widget.testId == 'running') {
      return 'You completed the running test in ${_testDuration - _currentTime} seconds!';
    } else {
      return 'You completed the flexibility test successfully!';
    }
  }

  void _pauseTest() {
    setState(() {
      _isTestRunning = false;
    });
    _testTimer?.cancel();
    _timerController.stop();
  }

  void _resumeTest() {
    setState(() {
      _isTestRunning = true;
    });
    _timerController.forward();

    _testTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = _testDuration - timer.tick;
      });

      if (_currentTime <= 0) {
        _completeTest();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_testDefinition == null) {
      return const Scaffold(body: Center(child: Text('Test not found')));
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera Preview (Simulated)
          _buildCameraPreview(),

          // Top Controls
          _buildTopControls(),

          // Test Information
          _buildTestInfo(),

          // Timer and Counter
          _buildTimerAndCounter(),

          // Bottom Controls
          _buildBottomControls(),
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey[900],
      child: Stack(
        children: [
          // Simulated camera feed
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getTestIcon(),
                  size: 100,
                  color: Colors.white.withOpacity(0.3),
                ),
                const SizedBox(height: AppDimensions.spacing16),
                Text(
                  _testDefinition!['name'],
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white.withOpacity(0.5),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Test status overlay
          if (_isTestCompleted)
            Container(
              color: Colors.black.withOpacity(0.8),
              child: const Center(
                child: Text(
                  'Test Completed!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTopControls() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacing16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                if (_isTestRunning) {
                  _pauseTest();
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Pause Test'),
                      content: const Text(
                        'Are you sure you want to leave? Your progress will be saved.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () =>
                              context.go('/tests/${widget.testId}'),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            context.go('/tests/${widget.testId}');
                          },
                          child: const Text('Leave'),
                        ),
                      ],
                    ),
                  );
                } else {
                  context.go('/tests/${widget.testId}');
                }
              },
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacing12,
                vertical: AppDimensions.spacing4,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
              ),
              child: Text(
                _isTestRunning
                    ? 'Recording'
                    : _isTestCompleted
                    ? 'Completed'
                    : 'Ready',
                style: TextStyle(
                  color: _isTestRunning ? Colors.red : Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                _isTestRunning ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
              ),
              onPressed: _isTestRunning ? _pauseTest : _resumeTest,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestInfo() {
    return Positioned(
      top: 100,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spacing16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _testDefinition!['name'],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimensions.spacing8),
            Text(
              _testDefinition!['description'],
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerAndCounter() {
    return Positioned(
      top: 220,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Timer
          _buildTimerWidget(),

          // Counter (for count-based tests)
          if (widget.testId == 'pushups' || widget.testId == 'situps')
            _buildCounterWidget(),
        ],
      ),
    );
  }

  Widget _buildTimerWidget() {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _timerAnimation,
          builder: (context, child) {
            return SizedBox(
              width: 80,
              height: 80,
              child: Stack(
                children: [
                  CircularProgressIndicator(
                    value: _timerAnimation.value,
                    strokeWidth: 6,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _currentTime <= 10 ? Colors.red : Colors.white,
                    ),
                  ),
                  Center(
                    child: Text(
                      '${_currentTime}s',
                      style: TextStyle(
                        color: _currentTime <= 10 ? Colors.red : Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: AppDimensions.spacing8),
        const Text('Time', style: TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }

  Widget _buildCounterWidget() {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _counterAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: 1.0 + (_counterAnimation.value * 0.2),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: AppColors.primary, width: 3),
                ),
                child: Center(
                  child: Text(
                    '$_currentCount',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: AppDimensions.spacing8),
        const Text(
          'Count',
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildBottomControls() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacing24),
          child: Column(
            children: [
              // Tap to Count Button (for count-based tests)
              if (widget.testId == 'pushups' || widget.testId == 'situps')
                GestureDetector(
                  onTap: _incrementCount,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: _isTestRunning
                          ? AppColors.primary
                          : Colors.white54,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    child: const Icon(
                      Icons.touch_app,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),

              const SizedBox(height: AppDimensions.spacing24),

              // Start/Pause/Complete Button
              if (!_isTestCompleted)
                CustomButton(
                  text: _isTestRunning ? 'Pause Test' : 'Start Test',
                  onPressed: _isTestRunning ? _pauseTest : _startTest,
                  type: ButtonType.primary,
                  backgroundColor: _isTestRunning
                      ? Colors.orange
                      : AppColors.primary,
                  textColor: Colors.white,
                ),

              if (_isTestCompleted)
                CustomButton(
                  text: 'View Results',
                  onPressed: () =>
                      context.go('/tests/${widget.testId}/results'),
                  type: ButtonType.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getTestIcon() {
    switch (widget.testId) {
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
}
