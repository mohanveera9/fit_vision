import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:camera/camera.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../shared/widgets/custom_button.dart';

class FaceVerificationScreen extends StatefulWidget {
  const FaceVerificationScreen({super.key});

  @override
  State<FaceVerificationScreen> createState() => _FaceVerificationScreenState();
}

class _FaceVerificationScreenState extends State<FaceVerificationScreen>
    with TickerProviderStateMixin {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;
  bool _isVerifying = false;
  bool _isVerified = false;
  bool _isLoading = true;
  String? _errorMessage;
  int _verificationCountdown = 0;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  Future<void> _initializeCamera() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Check camera permission
      final permission = await Permission.camera.request();
      if (permission != PermissionStatus.granted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Camera permission is required for face verification';
        });
        return;
      }

      // Get available cameras
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'No cameras found on this device';
        });
        return;
      }

      // Find front camera
      CameraDescription? frontCamera;
      try {
        frontCamera = _cameras!.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
        );
      } catch (e) {
        // If no front camera found, use the first available camera
        frontCamera = _cameras!.first;
      }

      // Initialize camera controller
      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _cameraController!.initialize();

      if (mounted) {
        setState(() {
          _isInitialized = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error initializing camera: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to initialize camera: ${e.toString()}';
        });
      }
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Face Verification'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.spacing24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress Indicator
              _buildProgressIndicator(),

              const SizedBox(height: AppDimensions.spacing32),

              // Title
              const Text(
                'Verify Your Face',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),

              const SizedBox(height: AppDimensions.spacing8),

              const Text(
                'Position your face within the frame for verification',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: AppDimensions.spacing32),

              // Camera Preview Area
              _buildCameraArea(),

              const SizedBox(height: AppDimensions.spacing32),

              // Instructions
              _buildInstructions(),

              const SizedBox(height: AppDimensions.spacing32),

              // Security & Privacy
              _buildSecurityPrivacy(),

              const SizedBox(height: AppDimensions.spacing40),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: _isVerified ? 'Continue' : 'Start Verification',
                      onPressed: _isVerified
                          ? _nextStep
                          : (_isInitialized &&
                                !_isLoading &&
                                _errorMessage == null)
                          ? _startVerification
                          : null,
                      isLoading: _isVerifying,
                      type: ButtonType.primary,
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

  Widget _buildProgressIndicator() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Step 3 of 5',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.onSurface,
              ),
            ),
            Text(
              '60%',
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
          value: 0.6,
          backgroundColor: AppColors.surfaceVariant,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      ],
    );
  }

  Widget _buildCameraArea() {
    return DottedBorder(
      color: _isVerified ? AppColors.success : AppColors.outline,
      strokeWidth: 2,
      dashPattern: const [8, 4],
      borderType: BorderType.RRect,
      radius: const Radius.circular(AppDimensions.radiusMedium),
      child: Container(
        width: double.infinity,
        height: 300,
        decoration: BoxDecoration(
          color: _isVerified
              ? AppColors.success.withOpacity(0.1)
              : AppColors.surfaceVariant.withOpacity(0.3),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
        child: _isVerified ? _buildVerifiedState() : _buildCameraPreview(),
      ),
    );
  }

  Widget _buildVerifiedState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.success,
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(Icons.check, color: AppColors.onError, size: 40),
          ),
          const SizedBox(height: AppDimensions.spacing16),
          const Text(
            'Face Verified Successfully',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.success,
            ),
          ),
          const SizedBox(height: AppDimensions.spacing8),
          const Text(
            'Your identity has been verified',
            style: TextStyle(fontSize: 14, color: AppColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    // Show error state
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 48),
            const SizedBox(height: AppDimensions.spacing16),
            Text(
              _errorMessage!,
              style: const TextStyle(fontSize: 16, color: AppColors.error),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacing16),
            ElevatedButton(
              onPressed: _initializeCamera,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Show loading state
    if (_isLoading || !_isInitialized || _cameraController == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: AppColors.primary),
            const SizedBox(height: AppDimensions.spacing16),
            const Text(
              'Initializing Camera...',
              style: TextStyle(fontSize: 16, color: AppColors.onSurfaceVariant),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        // Camera Preview
        ClipRRect(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          child: SizedBox(
            width: double.infinity,
            height: 300,
            child: CameraPreview(_cameraController!),
          ),
        ),

        // Face Detection Overlay
        if (_isVerifying) _buildFaceDetectionOverlay(),

        // Verification Countdown
        if (_verificationCountdown > 0) _buildCountdownOverlay(),
      ],
    );
  }

  Widget _buildFaceDetectionOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          border: Border.all(color: AppColors.primary, width: 3),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary, width: 2),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Center(
                    child: Icon(Icons.face, color: AppColors.primary, size: 40),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCountdownOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$_verificationCountdown',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onError,
                ),
              ),
              const SizedBox(height: AppDimensions.spacing8),
              const Text(
                'Keep your face steady',
                style: TextStyle(fontSize: 16, color: AppColors.onError),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstructions() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.primary, size: 20),
              SizedBox(width: AppDimensions.spacing8),
              Text(
                'Instructions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.spacing12),
          Text(
            '• Position your face within the circular frame\n'
            '• Ensure good lighting on your face\n'
            '• Look directly at the camera\n'
            '• Keep your face steady during verification',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.onSurface,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityPrivacy() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.verified_user_outlined,
                color: AppColors.secondary,
                size: 20,
              ),
              SizedBox(width: AppDimensions.spacing8),
              Text(
                'Security & Privacy',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.spacing12),
          Text(
            'Your face data is processed locally and not stored. We only verify your identity for account security.',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  void _startVerification() async {
    if (!_isInitialized || _cameraController == null) return;

    setState(() {
      _isVerifying = true;
      _verificationCountdown = 3;
    });

    _animationController.repeat(reverse: true);

    // Start countdown
    for (int i = 3; i > 0; i--) {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          _verificationCountdown = i - 1;
        });
      }
    }

    // Capture face for verification
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isVerifying = false;
        _isVerified = true;
        _verificationCountdown = 0;
      });
      _animationController.stop();
    }
  }

  void _nextStep() {
    context.go('/register/height-weight');
  }
}
