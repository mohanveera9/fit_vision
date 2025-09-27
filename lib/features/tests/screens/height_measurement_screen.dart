import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../shared/widgets/custom_button.dart';

class HeightMeasurementScreen extends StatefulWidget {
  const HeightMeasurementScreen({super.key});

  @override
  State<HeightMeasurementScreen> createState() => _HeightMeasurementScreenState();
}

class _HeightMeasurementScreenState extends State<HeightMeasurementScreen>
    with TickerProviderStateMixin {
  late AnimationController _overlayController;
  late AnimationController _instructionController;
  late Animation<double> _overlayAnimation;
  late Animation<double> _instructionAnimation;

  bool _isCapturing = false;
  bool _showInstructions = true;
  double _currentHeight = 0.0;

  @override
  void initState() {
    super.initState();
    
    _overlayController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _instructionController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _overlayAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _overlayController,
      curve: Curves.easeInOut,
    ));

    _instructionAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _instructionController,
      curve: Curves.easeOutBack,
    ));

    _overlayController.repeat(reverse: true);
    _instructionController.forward();
  }

  @override
  void dispose() {
    _overlayController.dispose();
    _instructionController.dispose();
    super.dispose();
  }

  void _startCapture() {
    setState(() {
      _isCapturing = true;
      _showInstructions = false;
    });

    // Simulate measurement process
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isCapturing = false;
          _currentHeight = 175.0; // Mock measurement
        });
        _showMeasurementResult();
      }
    });
  }

  void _showMeasurementResult() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Height Measured'),
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
              '${_currentHeight.toStringAsFixed(1)} cm',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: AppDimensions.spacing8),
            const Text(
              'Height measurement completed successfully!',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/tests/weight');
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _retakeMeasurement() {
    setState(() {
      _isCapturing = false;
      _showInstructions = true;
      _currentHeight = 0.0;
    });
    _instructionController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera Preview (Simulated)
          _buildCameraPreview(),
          
          // Overlay Guides
          if (_showInstructions) _buildOverlayGuides(),
          
          // Top Controls
          _buildTopControls(),
          
          // Bottom Controls
          _buildBottomControls(),
          
          // Instructions Panel
          if (_showInstructions) _buildInstructionsPanel(),
          
          // Capture Overlay
          if (_isCapturing) _buildCaptureOverlay(),
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
            child: Container(
              width: 200,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.person,
                size: 100,
                color: Colors.white54,
              ),
            ),
          ),
          
          // Grid overlay
          CustomPaint(
            painter: GridPainter(),
            size: Size.infinite,
          ),
        ],
      ),
    );
  }

  Widget _buildOverlayGuides() {
    return AnimatedBuilder(
      animation: _overlayAnimation,
      builder: (context, child) {
        return Stack(
          children: [
            // Corner guides
            Positioned(
              top: 100,
              left: 50,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withOpacity(_overlayAnimation.value),
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            Positioned(
              top: 100,
              right: 50,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withOpacity(_overlayAnimation.value),
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            Positioned(
              bottom: 200,
              left: 50,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withOpacity(_overlayAnimation.value),
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            Positioned(
              bottom: 200,
              right: 50,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withOpacity(_overlayAnimation.value),
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            
            // Center alignment line
            Center(
              child: Container(
                width: 2,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(_overlayAnimation.value * 0.5),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ),
          ],
        );
      },
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
              onPressed: () => context.pop(),
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
              child: const Text(
                'Height Measurement',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.flash_off, color: Colors.white),
              onPressed: () {
                // Toggle flash
              },
            ),
          ],
        ),
      ),
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
              // Height Display
              if (_currentHeight > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacing20,
                    vertical: AppDimensions.spacing12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                  ),
                  child: Text(
                    'Height: ${_currentHeight.toStringAsFixed(1)} cm',
                    style: const TextStyle(
                      color: AppColors.onError,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              
              const SizedBox(height: AppDimensions.spacing24),
              
              // Capture Button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_currentHeight > 0) ...[
                    CustomButton(
                      text: 'Retake',
                      onPressed: _retakeMeasurement,
                      type: ButtonType.outlined,
                      backgroundColor: Colors.transparent,
                      textColor: Colors.white,
                    ),
                    const SizedBox(width: AppDimensions.spacing16),
                  ],
                  GestureDetector(
                    onTap: _showInstructions ? _startCapture : null,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: _showInstructions ? Colors.white : Colors.white54,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 4,
                        ),
                      ),
                      child: Icon(
                        _showInstructions ? Icons.camera_alt : Icons.hourglass_empty,
                        color: _showInstructions ? Colors.black : Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionsPanel() {
    return Positioned(
      top: 120,
      left: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: _instructionAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, 20 * (1 - _instructionAnimation.value)),
            child: Opacity(
              opacity: _instructionAnimation.value,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
                padding: const EdgeInsets.all(AppDimensions.spacing20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Position yourself properly:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: AppDimensions.spacing12),
                    Text(
                      '• Stand straight against a wall\n'
                      '• Keep your feet together\n'
                      '• Look straight ahead\n'
                      '• Ensure good lighting',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: AppDimensions.spacing16),
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.orange,
                          size: 16,
                        ),
                        SizedBox(width: AppDimensions.spacing8),
                        Expanded(
                          child: Text(
                            'Position your head and feet within the corner guides',
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildCaptureOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
            SizedBox(height: AppDimensions.spacing24),
            Text(
              'Measuring your height...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: AppDimensions.spacing8),
            Text(
              'Please stay still',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const spacing = 50.0;
    
    // Vertical lines
    for (double x = 0; x <= size.width; x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }
    
    // Horizontal lines
    for (double y = 0; y <= size.height; y += spacing) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
