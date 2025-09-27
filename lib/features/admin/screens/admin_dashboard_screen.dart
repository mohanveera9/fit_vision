import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacing8,
                vertical: AppDimensions.spacing4,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
              ),
              child: const Text(
                'SAI',
                style: TextStyle(
                  color: AppColors.onPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.spacing8),
            const Text('Admin Dashboard'),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshDashboard,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSettings,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Key Metrics
            _buildKeyMetrics(),
            
            // Charts Section
            _buildChartsSection(),
            
            // Recent Activity
            _buildRecentActivity(),
            
            // Quick Actions
            _buildQuickActions(),
            
            // Geographic Distribution
            _buildGeographicDistribution(),
            
            const SizedBox(height: AppDimensions.spacing24),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyMetrics() {
    return Container(
      margin: const EdgeInsets.all(AppDimensions.spacing16),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.scale(
            scale: _animation.value,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Key Metrics',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacing16),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: AppDimensions.spacing16,
                  mainAxisSpacing: AppDimensions.spacing16,
                  childAspectRatio: 1.2,
                  children: [
                    _buildMetricCard(
                      title: 'Total Users',
                      value: '12,547',
                      change: '+12.5%',
                      icon: Icons.people,
                      color: AppColors.primary,
                    ),
                    _buildMetricCard(
                      title: 'Active Today',
                      value: '3,284',
                      change: '+8.2%',
                      icon: Icons.online_prediction,
                      color: AppColors.success,
                    ),
                    _buildMetricCard(
                      title: 'Tests Completed',
                      value: '45,672',
                      change: '+15.3%',
                      icon: Icons.assignment_turned_in,
                      color: AppColors.secondary,
                    ),
                    _buildMetricCard(
                      title: 'Videos Uploaded',
                      value: '1,234',
                      change: '+5.7%',
                      icon: Icons.video_library,
                      color: AppColors.warning,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String change,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacing16),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacing4,
                  vertical: AppDimensions.spacing4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                ),
                child: Text(
                  change,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.success,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacing12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: AppDimensions.spacing4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Analytics',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: AppDimensions.spacing16),
          
          // User Growth Chart
          _buildUserGrowthChart(),
          
          const SizedBox(height: AppDimensions.spacing16),
          
          // Test Completion Chart
          _buildTestCompletionChart(),
        ],
      ),
    );
  }

  Widget _buildUserGrowthChart() {
    return Container(
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
            'User Growth (Last 6 Months)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: AppDimensions.spacing20),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: true),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const months = ['Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                        return Text(
                          months[value.toInt()],
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
                          '${(value / 1000).toStringAsFixed(0)}K',
                          style: const TextStyle(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 8500),
                      const FlSpot(1, 9200),
                      const FlSpot(2, 10800),
                      const FlSpot(3, 11500),
                      const FlSpot(4, 12100),
                      const FlSpot(5, 12547),
                    ],
                    isCurved: true,
                    color: AppColors.primary,
                    barWidth: 3,
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.primary.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestCompletionChart() {
    return Container(
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
            'Test Completion by Category',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: AppDimensions.spacing20),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const categories = ['Height', 'Weight', 'Push-ups', 'Sit-ups', 'Running', 'Flexibility'];
                        return Text(
                          categories[value.toInt()],
                          style: const TextStyle(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 10,
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
                  BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 95, color: AppColors.success, width: 16)]),
                  BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 92, color: AppColors.success, width: 16)]),
                  BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 78, color: AppColors.warning, width: 16)]),
                  BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 82, color: AppColors.warning, width: 16)]),
                  BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 65, color: AppColors.error, width: 16)]),
                  BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 88, color: AppColors.success, width: 16)]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Container(
      margin: const EdgeInsets.all(AppDimensions.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Activity',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              TextButton(
                onPressed: _viewAllActivity,
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacing16),
          ...List.generate(5, (index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 600),
              child: SlideAnimation(
                horizontalOffset: 50.0,
                child: FadeInAnimation(
                  child: _buildActivityItem(index),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildActivityItem(int index) {
    final activities = [
      {'user': 'Arjun Singh', 'action': 'completed Push-ups test', 'time': '2 min ago', 'type': 'success'},
      {'user': 'Priya Sharma', 'action': 'uploaded new video', 'time': '15 min ago', 'type': 'info'},
      {'user': 'Raj Patel', 'action': 'achieved new personal best', 'time': '1 hour ago', 'type': 'success'},
      {'user': 'Sneha Reddy', 'action': 'joined the platform', 'time': '2 hours ago', 'type': 'primary'},
      {'user': 'Vikram Kumar', 'action': 'reported technical issue', 'time': '3 hours ago', 'type': 'warning'},
    ];

    final activity = activities[index];
    final typeColor = _getActivityTypeColor(activity['type']!);

    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacing12),
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(color: AppColors.outline),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: typeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              _getActivityIcon(activity['type']!),
              color: typeColor,
              size: 20,
            ),
          ),
          const SizedBox(width: AppDimensions.spacing16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${activity['user']} ${activity['action']}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacing4),
                Text(
                  activity['time']!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      margin: const EdgeInsets.all(AppDimensions.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: AppDimensions.spacing16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: AppDimensions.spacing16,
            mainAxisSpacing: AppDimensions.spacing16,
            childAspectRatio: 2.5,
            children: [
              _buildQuickActionCard(
                title: 'Manage Users',
                icon: Icons.people,
                color: AppColors.primary,
                onTap: _manageUsers,
              ),
              _buildQuickActionCard(
                title: 'Video Approval',
                icon: Icons.video_library,
                color: AppColors.secondary,
                onTap: _videoApproval,
              ),
              _buildQuickActionCard(
                title: 'Analytics',
                icon: Icons.analytics,
                color: AppColors.success,
                onTap: _viewAnalytics,
              ),
              _buildQuickActionCard(
                title: 'System Health',
                icon: Icons.monitor_heart,
                color: AppColors.warning,
                onTap: _systemHealth,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spacing16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: color,
              size: 24,
            ),
            const SizedBox(width: AppDimensions.spacing12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGeographicDistribution() {
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
            'Geographic Distribution',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: AppDimensions.spacing20),
          // Simplified India map representation
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.map,
                    size: 60,
                    color: AppColors.onSurfaceVariant,
                  ),
                  SizedBox(height: AppDimensions.spacing8),
                  Text(
                    'India Map Visualization',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                    ),
                  ),
                  Text(
                    'Top regions: Maharashtra, Karnataka, Tamil Nadu',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getActivityTypeColor(String type) {
    switch (type) {
      case 'success':
        return AppColors.success;
      case 'info':
        return AppColors.primary;
      case 'warning':
        return AppColors.warning;
      case 'primary':
        return AppColors.primary;
      default:
        return AppColors.onSurfaceVariant;
    }
  }

  IconData _getActivityIcon(String type) {
    switch (type) {
      case 'success':
        return Icons.check_circle;
      case 'info':
        return Icons.info;
      case 'warning':
        return Icons.warning;
      case 'primary':
        return Icons.person_add;
      default:
        return Icons.notifications;
    }
  }

  void _refreshDashboard() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Refreshing dashboard data...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _showSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening admin settings...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _viewAllActivity() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening activity log...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _manageUsers() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening user management...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _videoApproval() {
    context.go('/admin/videos');
  }

  void _viewAnalytics() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening detailed analytics...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _systemHealth() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Checking system health...'),
        backgroundColor: AppColors.success,
      ),
    );
  }
}
