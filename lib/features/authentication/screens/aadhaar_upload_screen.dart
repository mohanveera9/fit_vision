import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dotted_border/dotted_border.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../shared/widgets/custom_button.dart';

class AadhaarUploadScreen extends StatefulWidget {
  const AadhaarUploadScreen({super.key});

  @override
  State<AadhaarUploadScreen> createState() => _AadhaarUploadScreenState();
}

class _AadhaarUploadScreenState extends State<AadhaarUploadScreen> {
  bool _isLoading = false;
  String? _uploadedImagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aadhaar Verification'),
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
                'Verify Your Identity',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),

              const SizedBox(height: AppDimensions.spacing8),

              const Text(
                'Upload a clear photo of your Aadhaar card for verification',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: AppDimensions.spacing32),

              // Upload Area
              _buildUploadArea(),

              const SizedBox(height: AppDimensions.spacing32),

              // Instructions
              _buildInstructions(),

              const SizedBox(height: AppDimensions.spacing32),

              // Requirements
              _buildRequirements(),

              const SizedBox(height: AppDimensions.spacing40),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Continue',
                      onPressed: _uploadedImagePath != null ? _nextStep : null,
                      isLoading: _isLoading,
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
              'Step 2 of 5',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.onSurface,
              ),
            ),
            Text(
              '40%',
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
          value: 0.4,
          backgroundColor: AppColors.surfaceVariant,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      ],
    );
  }

  Widget _buildUploadArea() {
    return DottedBorder(
      color: _uploadedImagePath != null ? AppColors.success : AppColors.outline,
      strokeWidth: 2,
      dashPattern: const [8, 4],
      borderType: BorderType.RRect,
      radius: const Radius.circular(AppDimensions.radiusMedium),
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: _uploadedImagePath != null
              ? AppColors.success.withOpacity(0.1)
              : AppColors.surfaceVariant.withOpacity(0.3),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
        child: _uploadedImagePath != null
            ? _buildUploadedImage()
            : _buildUploadPrompt(),
      ),
    );
  }

  Widget _buildUploadedImage() {
    return Stack(
      children: [
        Center(
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
                child: const Icon(
                  Icons.check,
                  color: AppColors.onError,
                  size: 40,
                ),
              ),
              const SizedBox(height: AppDimensions.spacing16),
              const Text(
                'Aadhaar Card Uploaded',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(height: AppDimensions.spacing8),
              const Text(
                'Tap to change image',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: AppDimensions.spacing8,
          right: AppDimensions.spacing8,
          child: GestureDetector(
            onTap: _removeImage,
            child: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: AppColors.onError,
                size: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadPrompt() {
    return InkWell(
      onTap: _showImageSourceDialog,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.cloud_upload_outlined,
                color: AppColors.primary,
                size: 30,
              ),
            ),
            const SizedBox(height: AppDimensions.spacing16),
            const Text(
              'Tap to Upload Aadhaar Card',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: AppDimensions.spacing8),
            const Text(
              'Camera or Gallery',
              style: TextStyle(fontSize: 14, color: AppColors.onSurfaceVariant),
            ),
          ],
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
            '• Ensure all 4 corners of the Aadhaar card are visible\n'
            '• Make sure the text is clear and readable\n'
            '• Avoid glare and shadows\n'
            '• Use good lighting conditions',
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

  Widget _buildRequirements() {
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
            'Your Aadhaar information is encrypted and used only for age verification. We do not store your Aadhaar number and comply with all government regulations.',
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

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppDimensions.spacing24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Image Source',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: AppDimensions.spacing24),
            Row(
              children: [
                Expanded(
                  child: _buildSourceOption(
                    icon: Icons.camera_alt,
                    title: 'Camera',
                    onTap: () {
                      Navigator.pop(context);
                      _uploadFromCamera();
                    },
                  ),
                ),
                const SizedBox(width: AppDimensions.spacing16),
                Expanded(
                  child: _buildSourceOption(
                    icon: Icons.photo_library,
                    title: 'Gallery',
                    onTap: () {
                      Navigator.pop(context);
                      _uploadFromGallery();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spacing16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
          border: Border.all(color: AppColors.outline),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: AppColors.primary),
            const SizedBox(height: AppDimensions.spacing8),
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  void _uploadFromCamera() {
    // Simulate camera upload
    setState(() {
      _uploadedImagePath = 'camera_image_path';
    });
  }

  void _uploadFromGallery() {
    // Simulate gallery upload
    setState(() {
      _uploadedImagePath = 'gallery_image_path';
    });
  }

  void _removeImage() {
    setState(() {
      _uploadedImagePath = null;
    });
  }

  void _skipVerification() {
    context.go('/register/confirm');
  }

  void _nextStep() {
    setState(() {
      _isLoading = true;
    });

    // Simulate verification process
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        context.go('/register/face-verification');
      }
    });
  }
}
