import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/utils/mock_data.dart';
import '../../../shared/widgets/custom_button.dart';

enum TestPhase {
  positioning,
  scanning,
  userConfirmed,
  testInstructions,
  testing,
  completed
}

class LiveTestScreen extends StatefulWidget {
  final String testId;

  const LiveTestScreen({super.key, required this.testId});

  @override
  State<LiveTestScreen> createState() => _LiveTestScreenState();
}

class _LiveTestScreenState extends State<LiveTestScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _scanController;
  late AnimationController _timerController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scanAnimation;

  Timer? _phaseTimer;
  Timer? _testTimer;
  Timer? _countTimer;

  // Camera related variables
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _isVideoRecording = false;

  TestPhase _currentPhase = TestPhase.positioning;
  
  int _testDuration = 0;
  int _elapsedTime = 0;
  int _correctCount = 0;
  int _incorrectCount = 0;
  int _totalAttempts = 0;
  
  String _currentMessage = "Position yourself in front of the camera";
  String _instructionText = "Stand in the center of the frame";

  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _scanController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _timerController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _scanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scanController, curve: Curves.linear),
    );

    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      
      if (_cameras.isNotEmpty) {
        // Find back camera, fallback to first available camera
        CameraDescription selectedCamera = _cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back,
          orElse: () => _cameras.first,
        );

        _cameraController = CameraController(
          selectedCamera,
          ResolutionPreset.high,
          enableAudio: true,
        );

        await _cameraController!.initialize();
        
        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
          _startPositioningPhase();
        }
      }
    } catch (e) {
      print('Error initializing camera: $e');
      // Fallback to positioning phase even if camera fails
      _startPositioningPhase();
    }
  }

  Future<void> _startVideoRecording() async {
    if (_cameraController != null && 
        _cameraController!.value.isInitialized && 
        !_cameraController!.value.isRecordingVideo) {
      try {
        await _cameraController!.startVideoRecording();
        setState(() {
          _isVideoRecording = true;
        });
        print('Video recording started');
      } catch (e) {
        print('Error starting video recording: $e');
      }
    }
  }

  Future<void> _stopVideoRecording() async {
    if (_cameraController != null && 
        _cameraController!.value.isRecordingVideo) {
      try {
        final XFile videoFile = await _cameraController!.stopVideoRecording();
        setState(() {
          _isVideoRecording = false;
        });
        print('Video saved to: ${videoFile.path}');
        // Here you can save the video file or process it as needed
      } catch (e) {
        print('Error stopping video recording: $e');
      }
    }
  }

  @override
  void dispose() {
    _phaseTimer?.cancel();
    _testTimer?.cancel();
    _countTimer?.cancel();
    _pulseController.dispose();
    _scanController.dispose();
    _timerController.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  void _startPositioningPhase() {
    setState(() {
      _currentPhase = TestPhase.positioning;
      _currentMessage = "Position yourself in front of the camera";
      _instructionText = "Stand in the center of the frame";
    });

    // Start video recording
    _startVideoRecording();

    // Auto-proceed to scanning after 3 seconds
    _phaseTimer = Timer(const Duration(seconds: 3), () {
      _startScanningPhase();
    });
  }

  void _startScanningPhase() {
    setState(() {
      _currentPhase = TestPhase.scanning;
      _currentMessage = "Scanning user...";
      _instructionText = "Please stay still while we scan";
    });

    _scanController.forward();

    // Auto-proceed to user confirmation after 2 seconds
    _phaseTimer = Timer(const Duration(seconds: 2), () {
      _showUserConfirmation();
    });
  }

  void _showUserConfirmation() {
    setState(() {
      _currentPhase = TestPhase.userConfirmed;
      _currentMessage = "User detected successfully!";
      _instructionText = "Ready to start the assessment";
    });

    // Show confirmation for 2 seconds then proceed
    _phaseTimer = Timer(const Duration(seconds: 2), () {
      _startTestInstructions();
    });
  }

  void _startTestInstructions() {
    setState(() {
      _currentPhase = TestPhase.testInstructions;
      _currentMessage = "Get ready for Sit-ups Test";
      _instructionText = "Lie down and prepare to start";
    });

    // Show instructions for 3 seconds then start test
    _phaseTimer = Timer(const Duration(seconds: 3), () {
      _startTest();
    });
  }

  void _startTest() {
    setState(() {
      _currentPhase = TestPhase.testing;
      _currentMessage = "Performing Sit-ups";
      _instructionText = "Keep your form correct";
      _elapsedTime = 0;
    });

    // Start the main timer
    _testTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedTime++;
      });
    });

    // Start the counting simulation
    _startCountingSimulation();
  }

  void _startCountingSimulation() {
    int countInterval = 0;
    
    _countTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      countInterval++;
      
      if (countInterval <= 3) {
        // First 3 counts are correct
        setState(() {
          _correctCount++;
          _totalAttempts++;
          _instructionText = "Good form! Count: $_correctCount";
        });
      } else if (countInterval == 4) {
        // 4th attempt is incorrect
        setState(() {
          _incorrectCount++;
          _totalAttempts++;
          _instructionText = "Incorrect form detected!";
        });
      } else if (countInterval <= 7) {
        // Next 3 are correct again
        setState(() {
          _correctCount++;
          _totalAttempts++;
          _instructionText = "Good form! Count: $_correctCount";
        });
      } else {
        // Stop after 7 total attempts
        _completeTest();
      }
    });
  }

  void _completeTest() {
    _countTimer?.cancel();
    _testTimer?.cancel();
    
    setState(() {
      _currentPhase = TestPhase.completed;
      _currentMessage = "Test Completed!";
      _instructionText = "Processing results...";
    });

    // Stop video recording
    _stopVideoRecording();

    // Show completion for 2 seconds then go to results
    Timer(const Duration(seconds: 2), () {
      _goToResults();
    });
  }

  void _goToResults() {
    context.go('/tests/${widget.testId}/results');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera Preview or Loading
          _buildCameraPreview(),
          
          // Recording Indicator
          _buildRecordingIndicator(),
          
          // Back Button
          _buildBackButton(),
          
          // Scan Overlay
          if (_currentPhase == TestPhase.scanning) _buildScanOverlay(),
          
          // Main Content
          _buildMainContent(),
          
          // Stats Display (during testing)
          if (_currentPhase == TestPhase.testing) _buildStatsDisplay(),
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    if (!_isCameraInitialized || _cameraController == null) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.grey[900],
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 16),
              Text(
                'Initializing Camera...',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    return Stack(
      children: [
        // Full screen camera preview
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: CameraPreview(_cameraController!),
        ),
        
        // Overlay elements on top of camera
        Container(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              // Positioning guide overlay
              if (_currentPhase == TestPhase.positioning)
                Center(
                  child: AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Container(
                          width: 250,
                          height: 350,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white.withOpacity(0.7),
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Center(
                            child: Text(
                              'Stand Here',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    offset: Offset(1, 1),
                                    blurRadius: 3,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              
              // User detection indicator (after positioning)
              if (_currentPhase != TestPhase.positioning && _currentPhase != TestPhase.completed)
                Center(
                  child: Container(
                    width: 200,
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: _getPhaseColor().withOpacity(0.8),
                        width: 3,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecordingIndicator() {
    if (!_isVideoRecording) return const SizedBox.shrink();
    
    return Positioned(
      top: 60,
      right: 20,
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(_pulseAnimation.value * 0.3 + 0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'REC',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBackButton() {
    return Positioned(
      top: 60,
      left: 20,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          onPressed: () {
            _stopVideoRecording();
            context.go('/tests/${widget.testId}');
          },
        ),
      ),
    );
  }

  Widget _buildScanOverlay() {
    return AnimatedBuilder(
      animation: _scanAnimation,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: ScanLinePainter(_scanAnimation.value),
        );
      },
    );
  }

  Widget _buildMainContent() {
    return Positioned(
      bottom: 100,
      left: 20,
      right: 20,
      child: Column(
        children: [
          // Phase Indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: _getPhaseColor().withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _getPhaseColor(), width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              _getPhaseText(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Main Message
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  _currentMessage,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: Offset(1, 1),
                        blurRadius: 3,
                        color: Colors.black,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  _instructionText,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                    shadows: const [
                      Shadow(
                        offset: Offset(1, 1),
                        blurRadius: 2,
                        color: Colors.black,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsDisplay() {
    return Positioned(
      top: 120,
      left: 20,
      right: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatCard('Time', '${_elapsedTime}s', Colors.blue),
          _buildStatCard('Correct', '$_correctCount', Colors.green),
          _buildStatCard('Incorrect', '$_incorrectCount', Colors.red),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Color _getPhaseColor() {
    switch (_currentPhase) {
      case TestPhase.positioning:
        return Colors.orange;
      case TestPhase.scanning:
        return Colors.blue;
      case TestPhase.userConfirmed:
        return Colors.green;
      case TestPhase.testInstructions:
        return Colors.purple;
      case TestPhase.testing:
        return AppColors.primary;
      case TestPhase.completed:
        return Colors.green;
    }
  }

  String _getPhaseText() {
    switch (_currentPhase) {
      case TestPhase.positioning:
        return 'POSITIONING';
      case TestPhase.scanning:
        return 'SCANNING';
      case TestPhase.userConfirmed:
        return 'USER CONFIRMED';
      case TestPhase.testInstructions:
        return 'INSTRUCTIONS';
      case TestPhase.testing:
        return 'TESTING IN PROGRESS';
      case TestPhase.completed:
        return 'COMPLETED';
    }
  }
}

class ScanLinePainter extends CustomPainter {
  final double progress;

  ScanLinePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.8)
      ..strokeWidth = 3.0;

    final shadowPaint = Paint()
      ..color = Colors.blue.withOpacity(0.3)
      ..strokeWidth = 8.0;

    final y = size.height * 0.2 + (size.height * 0.6 * progress);

    // Draw shadow line
    canvas.drawLine(
      Offset(size.width * 0.2, y),
      Offset(size.width * 0.8, y),
      shadowPaint,
    );

    // Draw main scan line
    canvas.drawLine(
      Offset(size.width * 0.2, y),
      Offset(size.width * 0.8, y),
      paint,
    );

    // Draw side indicators
    canvas.drawCircle(Offset(size.width * 0.15, y), 4, paint);
    canvas.drawCircle(Offset(size.width * 0.85, y), 4, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}