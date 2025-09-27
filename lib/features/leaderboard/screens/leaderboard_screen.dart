import 'package:fit_vision/shared/models/leaderboard_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/utils/mock_data.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _animation;

  String _selectedCategory = 'Youth';
  String _selectedGender = 'All';

  final List<String> _categories = ['Junior', 'Youth', 'Senior'];
  final List<String> _genders = ['All', 'Male', 'Female'];

  @override
  void initState() {
    super.initState();
    
    _tabController = TabController(length: 3, vsync: this);
    
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
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  List<LeaderboardEntry> _getFilteredEntries() {
    return MockData.mockLeaderboardEntries.where((entry) {
      final categoryMatch = entry.league == _selectedCategory;
      final genderMatch = _selectedGender == 'All' || entry.gender == _selectedGender;
      return categoryMatch && genderMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredEntries = _getFilteredEntries();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overall'),
            Tab(text: 'Weekly'),
            Tab(text: 'Monthly'),
          ],
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.onSurfaceVariant,
          indicatorColor: AppColors.primary,
        ),
      ),
      body: Column(
        children: [
          // Current User Rank
          _buildCurrentUserRank(),
          
          // Leaderboard List
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildLeaderboardList(filteredEntries),
                _buildLeaderboardList(filteredEntries, isWeekly: true),
                _buildLeaderboardList(filteredEntries, isMonthly: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentUserRank() {
    final currentUser = MockData.mockLeaderboardEntries.first;
    
    return Container(
      margin: const EdgeInsets.all(AppDimensions.spacing16),
      padding: const EdgeInsets.all(AppDimensions.spacing20),
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
                // Rank Badge
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      currentUser.rankDisplay,
                      style: const TextStyle(
                        color: AppColors.onPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(width: AppDimensions.spacing16),
                
                // User Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Rank',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacing4),
                      Text(
                        currentUser.userName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacing4),
                      Text(
                        '${currentUser.totalScore} points • ${currentUser.leagueDisplayName}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Score
                Column(
                  children: [
                    Text(
                      '${currentUser.totalScore}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const Text(
                      'points',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.onSurfaceVariant,
                      ),
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

  Widget _buildLeaderboardList(List<LeaderboardEntry> entries, {bool isWeekly = false, bool isMonthly = false}) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
        itemCount: entries.length + 1, // +1 for header
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildLeaderboardHeader();
          }
          
          final entry = entries[index - 1];
          final isCurrentUser = entry.rank == 1; // Assuming first entry is current user
          
          return AnimationConfiguration.staggeredList(
            position: index - 1,
            duration: const Duration(milliseconds: 600),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: _buildLeaderboardItem(entry, isCurrentUser),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLeaderboardHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing16,
        vertical: AppDimensions.spacing12,
      ),
      margin: const EdgeInsets.only(bottom: AppDimensions.spacing8),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
      ),
      child: const Row(
        children: [
          SizedBox(width: 40), // Space for rank
          SizedBox(width: AppDimensions.spacing12),
          SizedBox(width: 40), // Space for avatar
          SizedBox(width: AppDimensions.spacing12),
          Expanded(
            child: Text(
              'Name',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
              ),
            ),
          ),
          Text(
            'Score',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardItem(LeaderboardEntry entry, bool isCurrentUser) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacing8),
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      decoration: BoxDecoration(
        color: isCurrentUser 
            ? AppColors.primary.withOpacity(0.05)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(
          color: isCurrentUser 
              ? AppColors.primary.withOpacity(0.3)
              : AppColors.outline,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Rank
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getRankColor(entry.rank),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                entry.rank.toString(),
                style: TextStyle(
                  color: _getRankTextColor(entry.rank),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
          const SizedBox(width: AppDimensions.spacing12),
          
          // Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.person,
              color: AppColors.onSurfaceVariant,
              size: 20,
            ),
          ),
          
          const SizedBox(width: AppDimensions.spacing12),
          
          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.userName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isCurrentUser ? AppColors.primary : AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacing4),
                Text(
                  entry.leagueDisplayName,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          
          // Score
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${entry.totalScore}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isCurrentUser ? AppColors.primary : AppColors.onSurface,
                ),
              ),
              const Text(
                'points',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Filter Leaderboard'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Category Filter
              const Text(
                'Age Category',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppDimensions.spacing8),
              Wrap(
                spacing: AppDimensions.spacing8,
                children: _categories.map((category) {
                  final isSelected = _selectedCategory == category;
                  return FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    selectedColor: AppColors.primary.withOpacity(0.2),
                    checkmarkColor: AppColors.primary,
                  );
                }).toList(),
              ),
              
              const SizedBox(height: AppDimensions.spacing16),
              
              // Gender Filter
              const Text(
                'Gender',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppDimensions.spacing8),
              Wrap(
                spacing: AppDimensions.spacing8,
                children: _genders.map((gender) {
                  final isSelected = _selectedGender == gender;
                  return FilterChip(
                    label: Text(gender),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedGender = gender;
                      });
                    },
                    selectedColor: AppColors.primary.withOpacity(0.2),
                    checkmarkColor: AppColors.primary,
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                setState(() {
                  // Update the main state
                });
                Navigator.of(context).pop();
              },
              child: const Text('Apply'),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey[400]!;
      case 3:
        return Colors.orange[300]!;
      default:
        return AppColors.surfaceVariant;
    }
  }

  Color _getRankTextColor(int rank) {
    switch (rank) {
      case 1:
      case 2:
      case 3:
        return Colors.white;
      default:
        return AppColors.onSurface;
    }
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      // Trigger rebuild
    });
  }
}
