import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../shared/widgets/custom_button.dart';

class HeightWeightInputScreen extends StatefulWidget {
  const HeightWeightInputScreen({super.key});

  @override
  State<HeightWeightInputScreen> createState() =>
      _HeightWeightInputScreenState();
}

class _HeightWeightInputScreenState extends State<HeightWeightInputScreen> {
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Physical Measurements'),
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress Indicator
                _buildProgressIndicator(),

                const SizedBox(height: AppDimensions.spacing32),

                // Title
                const Text(
                  'Physical Measurements',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                  ),
                ),

                const SizedBox(height: AppDimensions.spacing8),

                const Text(
                  'Please provide your accurate height and weight measurements',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: AppDimensions.spacing32),

                // Instructions Card
                _buildInstructionsCard(),

                const SizedBox(height: AppDimensions.spacing32),

                // Height Input
                _buildHeightInput(),

                const SizedBox(height: AppDimensions.spacing24),

                // Weight Input
                _buildWeightInput(),

                const SizedBox(height: AppDimensions.spacing40),

                // Continue Button
                CustomButton(
                  text: 'Continue',
                  onPressed: _isLoading ? null : _nextStep,
                  isLoading: _isLoading,
                  type: ButtonType.primary,
                ),
              ],
            ),
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
              'Step 4 of 5',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.onSurface,
              ),
            ),
            Text(
              '80%',
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
          value: 0.8,
          backgroundColor: AppColors.surfaceVariant,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      ],
    );
  }

  Widget _buildInstructionsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spacing20),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.primary, size: 20),
              const SizedBox(width: AppDimensions.spacing8),
              const Text(
                'Important Information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacing12),
          const Text(
            'Accurate physical measurements are crucial for your fitness assessment.',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.onSurface,
              height: 1.4,
            ),
          ),
          const SizedBox(height: AppDimensions.spacing8),
          const Text(
            'If you enter correct details, you have good chances to be selected by SAI officials for advanced training programs.',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.onSurface,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeightInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Height',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: AppDimensions.spacing8),
        TextFormField(
          controller: _heightController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Enter height in cm (e.g., 175)',
            prefixIcon: const Icon(Icons.height),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
              borderSide: const BorderSide(color: AppColors.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your height';
            }
            final height = double.tryParse(value);
            if (height == null) {
              return 'Please enter a valid height';
            }
            if (height < 100 || height > 250) {
              return 'Height must be between 100-250 cm';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildWeightInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Weight',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: AppDimensions.spacing8),
        TextFormField(
          controller: _weightController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Enter weight in kg (e.g., 70.5)',
            prefixIcon: const Icon(Icons.monitor_weight),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
              borderSide: const BorderSide(color: AppColors.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your weight';
            }
            final weight = double.tryParse(value);
            if (weight == null) {
              return 'Please enter a valid weight';
            }
            if (weight < 20 || weight > 200) {
              return 'Weight must be between 20-200 kg';
            }
            return null;
          },
        ),
      ],
    );
  }

  void _nextStep() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate processing
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          context.go('/register/confirm');
        }
      });
    }
  }
}
