import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/utils/mock_data.dart';
import '../../../shared/widgets/custom_button.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _darkModeEnabled = false;
  bool _dataSavingMode = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = MockData.mockUsers.first;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // User Profile Section
            _buildUserProfileSection(user),

            // Settings Sections
            _buildSettingsSections(),

            // App Information
            _buildAppInformation(),

            const SizedBox(height: AppDimensions.spacing24),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfileSection(user) {
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
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.scale(
            scale: _animation.value,
            child: Row(
              children: [
                // Profile Image
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 30,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(width: AppDimensions.spacing16),

                // User Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacing4),
                      Text(
                        user.email,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacing8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.spacing8,
                          vertical: AppDimensions.spacing4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusSmall,
                          ),
                        ),
                        child: Text(
                          user.league,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Edit Button
                IconButton(
                  onPressed: _editProfile,
                  icon: const Icon(Icons.edit),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.surface,
                    foregroundColor: AppColors.primary,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSettingsSections() {
    return Column(
      children: [
        _buildSettingsSection(
          title: 'Preferences',
          children: [
            _buildSettingsItem(
              icon: Icons.notifications,
              title: 'Push Notifications',
              subtitle: 'Receive updates and reminders',
              trailing: Switch(
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
              ),
            ),
            _buildSettingsItem(
              icon: Icons.volume_up,
              title: 'Sound Effects',
              subtitle: 'Play sounds for interactions',
              trailing: Switch(
                value: _soundEnabled,
                onChanged: (value) {
                  setState(() {
                    _soundEnabled = value;
                  });
                },
              ),
            ),
            _buildSettingsItem(
              icon: Icons.dark_mode,
              title: 'Dark Mode',
              subtitle: 'Switch to dark theme',
              trailing: Switch(
                value: _darkModeEnabled,
                onChanged: (value) {
                  setState(() {
                    _darkModeEnabled = value;
                  });
                },
              ),
            ),
            _buildSettingsItem(
              icon: Icons.data_saver_off,
              title: 'Data Saving Mode',
              subtitle: 'Reduce data usage',
              trailing: Switch(
                value: _dataSavingMode,
                onChanged: (value) {
                  setState(() {
                    _dataSavingMode = value;
                  });
                },
              ),
            ),
          ],
        ),

        _buildSettingsSection(
          title: 'Account',
          children: [
            _buildSettingsItem(
              icon: Icons.person_outline,
              title: 'Edit Profile',
              subtitle: 'Update your personal information',
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _editProfile,
            ),
            _buildSettingsItem(
              icon: Icons.security,
              title: 'Privacy & Security',
              subtitle: 'Manage your privacy settings',
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _privacySettings,
            ),
            _buildSettingsItem(
              icon: Icons.lock_outline,
              title: 'Change Password',
              subtitle: 'Update your account password',
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _changePassword,
            ),
            _buildSettingsItem(
              icon: Icons.verified_user,
              title: 'Verification Status',
              subtitle: 'Aadhaar verification completed',
              trailing: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacing8,
                  vertical: AppDimensions.spacing4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusSmall,
                  ),
                ),
                child: const Text(
                  'Verified',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.success,
                  ),
                ),
              ),
            ),
          ],
        ),

        _buildSettingsSection(
          title: 'Support',
          children: [
            _buildSettingsItem(
              icon: Icons.help_outline,
              title: 'Help Center',
              subtitle: 'Get help and support',
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _helpCenter,
            ),
            _buildSettingsItem(
              icon: Icons.feedback_outlined,
              title: 'Send Feedback',
              subtitle: 'Share your thoughts with us',
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _sendFeedback,
            ),
            _buildSettingsItem(
              icon: Icons.bug_report_outlined,
              title: 'Report Issue',
              subtitle: 'Report bugs or problems',
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _reportIssue,
            ),
            _buildSettingsItem(
              icon: Icons.contact_support,
              title: 'Contact Support',
              subtitle: 'Get in touch with our team',
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _contactSupport,
            ),
          ],
        ),

        _buildSettingsSection(
          title: 'About',
          children: [
            _buildSettingsItem(
              icon: Icons.info_outline,
              title: 'About FitVision',
              subtitle: 'Learn more about the app',
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _aboutApp,
            ),
            _buildSettingsItem(
              icon: Icons.description_outlined,
              title: 'Terms of Service',
              subtitle: 'Read our terms and conditions',
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _termsOfService,
            ),
            _buildSettingsItem(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              subtitle: 'How we protect your data',
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _privacyPolicy,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppDimensions.spacing24),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: AppDimensions.spacing16),
          Container(
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
              children: children.asMap().entries.map((entry) {
                final index = entry.key;
                final child = entry.value;
                final isLast = index == children.length - 1;

                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 600),
                  child: SlideAnimation(
                    horizontalOffset: 50.0,
                    child: FadeInAnimation(
                      child: Column(
                        children: [
                          child,
                          if (!isLast)
                            Divider(
                              height: 1,
                              color: AppColors.outline.withOpacity(0.5),
                              indent: 60,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.onSurface,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }

  Widget _buildAppInformation() {
    return Container(
      margin: const EdgeInsets.all(AppDimensions.spacing16),
      padding: const EdgeInsets.all(AppDimensions.spacing20),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Icon(
                  Icons.fitness_center,
                  color: AppColors.onPrimary,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppDimensions.spacing16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'FitVision',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                    Text(
                      'Version 1.0.0',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacing16),
          const Text(
            'Sports Authority of India (SAI) approved fitness testing platform for athletes aged 12-35 in India.',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.onSurfaceVariant,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spacing16),
          CustomButton(
            text: 'Sign Out',
            onPressed: _signOut,
            type: ButtonType.outlined,
            backgroundColor: Colors.transparent,
            textColor: AppColors.error,
            icon: Icons.logout,
          ),
        ],
      ),
    );
  }

  void _editProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening profile editor...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _privacySettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening privacy settings...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _changePassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening password change...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _helpCenter() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening help center...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _sendFeedback() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening feedback form...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _reportIssue() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening issue reporter...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _contactSupport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening contact support...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _aboutApp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About FitVision'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'FitVision is a comprehensive fitness testing platform designed for athletes aged 12-35 in India.',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 16),
            Text('Features:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('• 6 essential fitness tests'),
            Text('• Age-group based leaderboards'),
            Text('• Aadhaar verification'),
            Text('• Government approved'),
            Text('• Real-time progress tracking'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _termsOfService() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening terms of service...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _privacyPolicy() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening privacy policy...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _signOut() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/welcome');
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
