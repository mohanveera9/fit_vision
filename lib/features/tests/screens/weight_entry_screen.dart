import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../shared/widgets/custom_button.dart';

class WeightEntryScreen extends StatefulWidget {
  const WeightEntryScreen({super.key});

  @override
  State<WeightEntryScreen> createState() => _WeightEntryScreenState();
}

class _WeightEntryScreenState extends State<WeightEntryScreen>
    with TickerProviderStateMixin {
  late AnimationController _sliderController;
  late Animation<double> _sliderAnimation;
  
  double _weight = 65.0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    
    _sliderController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _sliderAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _sliderController,
      curve: Curves.easeOutBack,
    ));

    _sliderController.forward();
  }

  @override
  void dispose() {
    _sliderController.dispose();
    super.dispose();
  }

  void _saveWeight() {
    setState(() {
      _isLoading = true;
    });

    // Simulate saving weight
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        context.go('/tests');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weight Measurement'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacing24),
          child: Column(
            children: [
              // Header
              _buildHeader(),
              
              const SizedBox(height: AppDimensions.spacing40),
              
              // Weight Display
              _buildWeightDisplay(),
              
              const SizedBox(height: AppDimensions.spacing40),
              
              // Weight Slider
              _buildWeightSlider(),
              
              const SizedBox(height: AppDimensions.spacing40),
              
              // Instructions
              _buildInstructions(),
              
              const Spacer(),
              
              // Save Button
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.secondary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(40),
          ),
          child: const Icon(
            Icons.monitor_weight_outlined,
            size: 40,
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacing20),
        const Text(
          'Enter Your Weight',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: AppDimensions.spacing8),
        const Text(
          'Use the slider to set your current weight accurately',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildWeightDisplay() {
    return AnimatedBuilder(
      animation: _sliderAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _sliderAnimation.value,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacing32,
              vertical: AppDimensions.spacing24,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.1),
                  AppColors.primaryContainer.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Text(
                  _weight.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacing8),
                const Text(
                  'kilograms',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.onSurfaceVariant,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWeightSlider() {
    return Container(
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
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '30 kg',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '150 kg',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacing16),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: AppColors.surfaceVariant,
              thumbColor: AppColors.primary,
              overlayColor: AppColors.primary.withOpacity(0.1),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 16),
              trackHeight: 8,
              trackShape: const RoundedRectSliderTrackShape(),
            ),
            child: Slider(
              value: _weight,
              min: 30.0,
              max: 150.0,
              divisions: 240, // 0.5 kg increments
              onChanged: (value) {
                setState(() {
                  _weight = value;
                });
              },
            ),
          ),
          const SizedBox(height: AppDimensions.spacing16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildQuickWeightButton(50.0, '50 kg'),
              _buildQuickWeightButton(60.0, '60 kg'),
              _buildQuickWeightButton(70.0, '70 kg'),
              _buildQuickWeightButton(80.0, '80 kg'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickWeightButton(double weight, String label) {
    final isSelected = (_weight - weight).abs() < 1.0;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _weight = weight;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing12,
          vertical: AppDimensions.spacing8,
        ),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColors.primary 
              : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected 
                ? AppColors.onPrimary 
                : AppColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  Widget _buildInstructions() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
        border: Border.all(
          color: AppColors.warning.withOpacity(0.3),
        ),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.info_outline,
            color: AppColors.warning,
            size: 20,
          ),
          SizedBox(width: AppDimensions.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'For accurate results:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                  ),
                ),
                SizedBox(height: AppDimensions.spacing4),
                Text(
                  '• Use a digital scale if possible\n'
                  '• Weigh yourself without shoes\n'
                  '• Enter your weight immediately after measurement',
                  style: TextStyle(
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

  Widget _buildSaveButton() {
    return Column(
      children: [
        // BMI Calculation
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppDimensions.spacing16),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.calculate,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: AppDimensions.spacing8),
              Text(
                'BMI: ${_calculateBMI().toStringAsFixed(1)} kg/m²',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: AppDimensions.spacing16),
        
        // Save Button
        CustomButton(
          text: 'Save Weight',
          onPressed: _isLoading ? null : _saveWeight,
          isLoading: _isLoading,
          type: ButtonType.primary,
          icon: Icons.save,
        ),
      ],
    );
  }

  double _calculateBMI() {
    // Assuming average height of 170 cm for BMI calculation
    const heightInMeters = 1.70;
    return _weight / (heightInMeters * heightInMeters);
  }
}
