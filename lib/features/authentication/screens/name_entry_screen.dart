import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';

class NameEntryScreen extends StatefulWidget {
  const NameEntryScreen({super.key});

  @override
  State<NameEntryScreen> createState() => _NameEntryScreenState();
}

class _NameEntryScreenState extends State<NameEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController();
  final _genderController = TextEditingController();

  String _selectedGender = 'Male';
  bool _isLoading = false;

  final List<String> _genders = ['Male', 'Female', 'Other'];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          context.go('/register/aadhaar');
        }
      });
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your full name';
    }
    if (value.trim().split(' ').length < 2) {
      return 'Please enter your full name (First and Last name)';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your phone number';
    }
    if (value.length < 10) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  String? _validateAge(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your age';
    }
    final age = int.tryParse(value);
    if (age == null) {
      return 'Please enter a valid age';
    }
    if (age < 12 || age > 35) {
      return 'Age must be between 12 and 35 years';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text('Create Account'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/welcome'),
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
                  'Let\'s Get Started',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                  ),
                ),

                const SizedBox(height: AppDimensions.spacing8),

                const Text(
                  'Tell us a bit about yourself to create your profile',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: AppDimensions.spacing32),

                // Form Fields
                CustomTextField(
                  label: 'Full Name',
                  hint: 'Enter your first and last name',
                  controller: _nameController,
                  validator: _validateName,
                  isRequired: true,
                  prefixIcon: const Icon(Icons.person_outline),
                ),

                const SizedBox(height: AppDimensions.spacing20),

                CustomTextField(
                  label: 'Email Address',
                  hint: 'Enter your email address',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                  isRequired: true,
                  prefixIcon: const Icon(Icons.email_outlined),
                ),

                const SizedBox(height: AppDimensions.spacing20),

                CustomTextField(
                  label: 'Phone Number',
                  hint: 'Enter your phone number',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: _validatePhone,
                  isRequired: true,
                  prefixIcon: const Icon(Icons.phone_outlined),
                ),

                const SizedBox(height: AppDimensions.spacing20),

                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'Age',
                        hint: 'Enter your age',
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        validator: _validateAge,
                        isRequired: true,
                        prefixIcon: const Icon(Icons.cake_outlined),
                      ),
                    ),

                    const SizedBox(width: AppDimensions.spacing16),

                    Expanded(
                      child: CustomDropdownField<String>(
                        label: 'Gender',
                        value: _selectedGender,
                        items: _genders.map((gender) {
                          return DropdownMenuItem(
                            value: gender,
                            child: Text(gender),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value!;
                          });
                        },
                        isRequired: true,
                        prefixIcon: const Icon(Icons.person_outline),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppDimensions.spacing40),

                // Terms and Privacy
                Container(
                  padding: const EdgeInsets.all(AppDimensions.spacing16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusSmall,
                    ),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      SizedBox(width: AppDimensions.spacing12),
                      Expanded(
                        child: Text(
                          'By continuing, you agree to our Terms of Service and Privacy Policy. Your information will be used for fitness assessment purposes only.',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppDimensions.spacing32),

                // Next Button
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
              'Step 1 of 5',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.onSurface,
              ),
            ),
            Text(
              '20%',
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
          value: 0.2,
          backgroundColor: AppColors.surfaceVariant,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      ],
    );
  }
}
