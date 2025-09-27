// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import '../../../core/constants/app_colors.dart';
// import '../../../core/constants/app_dimensions.dart';
// import '../../../core/utils/mock_data.dart';
// import '../../../shared/widgets/custom_button.dart';
// import '../../../shared/widgets/custom_text_field.dart';

// class AdminVideoLibraryScreen extends StatefulWidget {
//   const AdminVideoLibraryScreen({super.key});

//   @override
//   State<AdminVideoLibraryScreen> createState() => _AdminVideoLibraryScreenState();
// }

// class _AdminVideoLibraryScreenState extends State<AdminVideoLibraryScreen>
//     with TickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _animation;

//   final TextEditingController _searchController = TextEditingController();
//   String _searchQuery = '';
//   String _selectedFilter = 'All';
//   bool _isExpanded = {};

//   final List<String> _filters = ['All', 'Pending', 'Approved', 'Rejected'];

//   @override
//   void initState() {
//     super.initState();
    
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 1000),
//       vsync: this,
//     );

//     _animation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeOutBack,
//     ));

//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     _animationController.dispose();
//     super.dispose();
//   }

//   List<Map<String, dynamic>> _getFilteredVideos() {
//     // Mock admin video data with user information
//     final adminVideos = [
//       {
//         'id': '1',
//         'title': 'Push-up Tutorial by Arjun Singh',
//         'description': 'Step-by-step guide to perfect push-ups',
//         'thumbnailUrl': 'https://picsum.photos/300/200?random=1',
//         'duration': '5:30',
//         'uploadedAt': DateTime.now().subtract(const Duration(days: 2)),
//         'status': 'Pending',
//         'userId': '1',
//         'userName': 'Arjun Singh',
//         'userEmail': 'arjun.singh@email.com',
//         'category': 'Tutorial',
//         'views': 156,
//         'likes': 23,
//       },
//       {
//         'id': '2',
//         'title': 'Flexibility Exercises by Priya Sharma',
//         'description': 'Daily flexibility routine for athletes',
//         'thumbnailUrl': 'https://picsum.photos/300/200?random=2',
//         'duration': '8:15',
//         'uploadedAt': DateTime.now().subtract(const Duration(days: 5)),
//         'status': 'Approved',
//         'userId': '2',
//         'userName': 'Priya Sharma',
//         'userEmail': 'priya.sharma@email.com',
//         'category': 'Exercise',
//         'views': 324,
//         'likes': 45,
//       },
//       {
//         'id': '3',
//         'title': 'Running Form Tips by Raj Patel',
//         'description': 'Improve your running technique',
//         'thumbnailUrl': 'https://picsum.photos/300/200?random=3',
//         'duration': '6:45',
//         'uploadedAt': DateTime.now().subtract(const Duration(days: 7)),
//         'status': 'Approved',
//         'userId': '3',
//         'userName': 'Raj Patel',
//         'userEmail': 'raj.patel@email.com',
//         'category': 'Tutorial',
//         'views': 278,
//         'likes': 38,
//       },
//     ];

//     var videos = adminVideos;
    
//     if (_selectedFilter != 'All') {
//       videos = videos.where((video) => video['status'] == _selectedFilter).toList();
//     }
    
//     if (_searchQuery.isNotEmpty) {
//       videos = videos.where((video) => 
//         (video['title'] as String).toLowerCase().contains(_searchQuery.toLowerCase()) ||
//         (video['userName'] as String).toLowerCase().contains(_searchQuery.toLowerCase()) ||
//         (video['description'] as String).toLowerCase().contains(_searchQuery.toLowerCase())
//       ).toList();
//     }
    
//     return videos;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final filteredVideos = _getFilteredVideos();
    
//     return Scaffold(
//       appBar: AppBar(
//         title: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: AppDimensions.spacing8,
//                 vertical: AppDimensions.spacing4,
//               ),
//               decoration: BoxDecoration(
//                 color: AppColors.primary,
//                 borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
//               ),
//               child: const Text(
//                 'SAI',
//                 style: TextStyle(
//                   color: AppColors.onPrimary,
//                   fontSize: 12,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             const SizedBox(width: AppDimensions.spacing8),
//             const Text('Admin Panel'),
//           ],
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.analytics),
//             onPressed: _showAnalytics,
//           ),
//           IconButton(
//             icon: const Icon(Icons.settings),
//             onPressed: _showSettings,
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Search and Filter Section
//           _buildSearchAndFilter(),
          
//           // Videos List
//           Expanded(
//             child: filteredVideos.isEmpty
//                 ? _buildEmptyState()
//                 : _buildVideosList(filteredVideos),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSearchAndFilter() {
//     return Container(
//       padding: const EdgeInsets.all(AppDimensions.spacing16),
//       decoration: BoxDecoration(
//         color: AppColors.surface,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           // Search Bar
//           CustomSearchField(
//             controller: _searchController,
//             hint: 'Search videos, users, or content...',
//             onChanged: (value) {
//               setState(() {
//                 _searchQuery = value;
//               });
//             },
//             onClear: () {
//               _searchController.clear();
//               setState(() {
//                 _searchQuery = '';
//               });
//             },
//           ),
          
//           const SizedBox(height: AppDimensions.spacing16),
          
//           // Filter Chips
//           SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Row(
//               children: _filters.map((filter) {
//                 final isSelected = _selectedFilter == filter;
//                 return Padding(
//                   padding: const EdgeInsets.only(right: AppDimensions.spacing8),
//                   child: FilterChip(
//                     label: Text(filter),
//                     selected: isSelected,
//                     onSelected: (selected) {
//                       setState(() {
//                         _selectedFilter = filter;
//                       });
//                     },
//                     selectedColor: AppColors.primary.withOpacity(0.2),
//                     checkmarkColor: AppColors.primary,
//                   ),
//                 );
//               }).toList(),
//             ),
//           ),
          
//           const SizedBox(height: AppDimensions.spacing16),
          
//           // Results Count and Actions
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               // Text(
//               //   '${filteredVideos.length} videos found',
//               //   style: TextStyle(
//               //     fontSize: 14,
//               //     color: AppColors.onSurfaceVariant,
//               //   ),
//               // ),
//               Row(
//                 children: [
//                   TextButton.icon(
//                     onPressed: _exportData,
//                     icon: const Icon(Icons.download, size: 16),
//                     label: const Text('Export'),
//                   ),
//                   const SizedBox(width: AppDimensions.spacing8),
//                   TextButton.icon(
//                     onPressed: _bulkActions,
//                     icon: const Icon(Icons.checklist, size: 16),
//                     label: const Text('Bulk Actions'),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildVideosList(List<Map<String, dynamic>> videos) {
//     return RefreshIndicator(
//       onRefresh: _refreshData,
//       child: ListView.builder(
//         padding: const EdgeInsets.all(AppDimensions.spacing16),
//         itemCount: videos.length,
//         itemBuilder: (context, index) {
//           final video = videos[index];
//           final videoId = video['id'];
          
//           return AnimationConfiguration.staggeredList(
//             position: index,
//             duration: const Duration(milliseconds: 600),
//             child: SlideAnimation(
//               horizontalOffset: 50.0,
//               child: FadeInAnimation(
//                 child: _buildVideoCard(video, videoId),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildVideoCard(Map<String, dynamic> video, String videoId) {
//     final isExpanded = _isExpanded[videoId] ?? false;
    
//     return Container(
//       margin: const EdgeInsets.only(bottom: AppDimensions.spacing16),
//       decoration: BoxDecoration(
//         color: AppColors.surface,
//         borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
//         border: Border.all(
//           color: _getStatusColor(video['status']).withOpacity(0.3),
//           width: 2,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           // Video Header
//           InkWell(
//             onTap: () {
//               setState(() {
//                 _isExpanded[videoId] = !isExpanded;
//               });
//             },
//             child: Padding(
//               padding: const EdgeInsets.all(AppDimensions.spacing16),
//               child: Row(
//                 children: [
//                   // Thumbnail
//                   Container(
//                     width: 80,
//                     height: 60,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
//                       image: DecorationImage(
//                         image: NetworkImage(video['thumbnailUrl']),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
                  
//                   const SizedBox(width: AppDimensions.spacing16),
                  
//                   // Video Info
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           video['title'],
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             color: AppColors.onSurface,
//                           ),
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         const SizedBox(height: AppDimensions.spacing4),
//                         Text(
//                           'By ${video['userName']} • ${video['duration']}',
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: AppColors.onSurfaceVariant,
//                           ),
//                         ),
//                         const SizedBox(height: AppDimensions.spacing4),
//                         Row(
//                           children: [
//                             _buildStatusChip(video['status']),
//                             const Spacer(),
//                             Text(
//                               _formatUploadDate(video['uploadedAt']),
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: AppColors.onSurfaceVariant,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
                  
//                   // Expand Icon
//                   Icon(
//                     isExpanded ? Icons.expand_less : Icons.expand_more,
//                     color: AppColors.onSurfaceVariant,
//                   ),
//                 ],
//               ),
//             ),
//           ),
          
//           // Expanded Content
//           if (isExpanded) ...[
//             const Divider(height: 1),
//             Padding(
//               padding: const EdgeInsets.all(AppDimensions.spacing16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // User Information
//                   _buildUserInfo(video),
                  
//                   const SizedBox(height: AppDimensions.spacing16),
                  
//                   // Video Statistics
//                   _buildVideoStats(video),
                  
//                   const SizedBox(height: AppDimensions.spacing16),
                  
//                   // Admin Actions
//                   _buildAdminActions(video),
//                 ],
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _buildUserInfo(Map<String, dynamic> video) {
//     return Container(
//       padding: const EdgeInsets.all(AppDimensions.spacing12),
//       decoration: BoxDecoration(
//         color: AppColors.surfaceVariant,
//         borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 40,
//             height: 40,
//             decoration: BoxDecoration(
//               color: AppColors.primary.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: const Icon(
//               Icons.person,
//               color: AppColors.primary,
//               size: 20,
//             ),
//           ),
//           const SizedBox(width: AppDimensions.spacing12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   video['userName'],
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     color: AppColors.onSurface,
//                   ),
//                 ),
//                 Text(
//                   video['userEmail'],
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: AppColors.onSurfaceVariant,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           TextButton(
//             onPressed: () => _viewUserProfile(video['userId']),
//             child: const Text('View Profile'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildVideoStats(Map<String, dynamic> video) {
//     return Row(
//       children: [
//         Expanded(
//           child: _buildStatItem(
//             icon: Icons.visibility,
//             label: 'Views',
//             value: video['views'].toString(),
//           ),
//         ),
//         Expanded(
//           child: _buildStatItem(
//             icon: Icons.thumb_up,
//             label: 'Likes',
//             value: video['likes'].toString(),
//           ),
//         ),
//         Expanded(
//           child: _buildStatItem(
//             icon: Icons.category,
//             label: 'Category',
//             value: video['category'],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildStatItem({
//     required IconData icon,
//     required String label,
//     required String value,
//   }) {
//     return Column(
//       children: [
//         Icon(
//           icon,
//           size: 20,
//           color: AppColors.primary,
//         ),
//         const SizedBox(height: AppDimensions.spacing4),
//         Text(
//           value,
//           style: const TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//             color: AppColors.onSurface,
//           ),
//         ),
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 10,
//             color: AppColors.onSurfaceVariant,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildAdminActions(Map<String, dynamic> video) {
//     return Row(
//       children: [
//         Expanded(
//           child: CustomButton(
//             text: 'View Video',
//             onPressed: () => _viewVideo(video),
//             type: ButtonType.outlined,
//             icon: Icons.play_arrow,
//           ),
//         ),
//         const SizedBox(width: AppDimensions.spacing12),
//         if (video['status'] == 'Pending') ...[
//           Expanded(
//             child: CustomButton(
//               text: 'Approve',
//               onPressed: () => _approveVideo(video),
//               type: ButtonType.primary,
//               backgroundColor: AppColors.success,
//               icon: Icons.check,
//             ),
//           ),
//           const SizedBox(width: AppDimensions.spacing12),
//           Expanded(
//             child: CustomButton(
//               text: 'Reject',
//               onPressed: () => _rejectVideo(video),
//               type: ButtonType.outlined,
//               backgroundColor: Colors.transparent,
//               textColor: AppColors.error,
//               icon: Icons.close,
//             ),
//           ),
//         ] else ...[
//           Expanded(
//             child: CustomButton(
//               text: 'Edit',
//               onPressed: () => _editVideo(video),
//               type: ButtonType.outlined,
//               icon: Icons.edit,
//             ),
//           ),
//           const SizedBox(width: AppDimensions.spacing12),
//           Expanded(
//             child: CustomButton(
//               text: 'Delete',
//               onPressed: () => _deleteVideo(video),
//               type: ButtonType.outlined,
//               backgroundColor: Colors.transparent,
//               textColor: AppColors.error,
//               icon: Icons.delete,
//             ),
//           ),
//         ],
//       ],
//     );
//   }

//   Widget _buildStatusChip(String status) {
//     return Container(
//       padding: const EdgeInsets.symmetric(
//         horizontal: AppDimensions.spacing8,
//         vertical: AppDimensions.spacing4,
//       ),
//       decoration: BoxDecoration(
//         color: _getStatusColor(status).withOpacity(0.2),
//         borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
//       ),
//       child: Text(
//         status,
//         style: TextStyle(
//           fontSize: 10,
//           fontWeight: FontWeight.w600,
//           color: _getStatusColor(status),
//         ),
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             width: 120,
//             height: 120,
//             decoration: BoxDecoration(
//               color: AppColors.surfaceVariant,
//               borderRadius: BorderRadius.circular(60),
//             ),
//             child: const Icon(
//               Icons.admin_panel_settings,
//               size: 60,
//               color: AppColors.onSurfaceVariant,
//             ),
//           ),
//           const SizedBox(height: AppDimensions.spacing24),
//           const Text(
//             'No videos found',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.w600,
//               color: AppColors.onSurface,
//             ),
//           ),
//           const SizedBox(height: AppDimensions.spacing8),
//           Text(
//             'Try adjusting your search or filters',
//             style: TextStyle(
//               fontSize: 14,
//               color: AppColors.onSurfaceVariant,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Color _getStatusColor(String status) {
//     switch (status) {
//       case 'Approved':
//         return AppColors.success;
//       case 'Pending':
//         return AppColors.warning;
//       case 'Rejected':
//         return AppColors.error;
//       default:
//         return AppColors.onSurfaceVariant;
//     }
//   }

//   String _formatUploadDate(DateTime date) {
//     final now = DateTime.now();
//     final difference = now.difference(date);
    
//     if (difference.inDays > 0) {
//       return '${difference.inDays}d ago';
//     } else if (difference.inHours > 0) {
//       return '${difference.inHours}h ago';
//     } else {
//       return 'Just now';
//     }
//   }

//   void _viewVideo(Map<String, dynamic> video) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(video['title']),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               width: double.infinity,
//               height: 200,
//               decoration: BoxDecoration(
//                 color: Colors.grey[900],
//                 borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
//               ),
//               child: const Center(
//                 child: Icon(
//                   Icons.play_circle_outline,
//                   size: 80,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//             const SizedBox(height: AppDimensions.spacing16),
//             Text(
//               video['description'],
//               style: const TextStyle(fontSize: 14),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('Close'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _approveVideo(Map<String, dynamic> video) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Approve Video'),
//         content: Text('Are you sure you want to approve "${video['title']}"?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('Cancel'),
//           ),
//           FilledButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text('Video "${video['title']}" approved successfully!'),
//                   backgroundColor: AppColors.success,
//                 ),
//               );
//             },
//             child: const Text('Approve'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _rejectVideo(Map<String, dynamic> video) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Reject Video'),
//         content: Text('Are you sure you want to reject "${video['title']}"?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('Cancel'),
//           ),
//           FilledButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text('Video "${video['title']}" rejected.'),
//                   backgroundColor: AppColors.error,
//                 ),
//               );
//             },
//             style: FilledButton.styleFrom(backgroundColor: AppColors.error),
//             child: const Text('Reject'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _editVideo(Map<String, dynamic> video) {
//     // Show edit dialog
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Editing "${video['title']}"...'),
//         backgroundColor: AppColors.primary,
//       ),
//     );
//   }

//   void _deleteVideo(Map<String, dynamic> video) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Delete Video'),
//         content: Text('Are you sure you want to delete "${video['title']}"? This action cannot be undone.'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('Cancel'),
//           ),
//           FilledButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text('Video "${video['title']}" deleted successfully.'),
//                   backgroundColor: AppColors.error,
//                 ),
//               );
//             },
//             style: FilledButton.styleFrom(backgroundColor: AppColors.error),
//             child: const Text('Delete'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _viewUserProfile(String userId) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Opening profile for user $userId...'),
//         backgroundColor: AppColors.primary,
//       ),
//     );
//   }

//   void _showAnalytics() {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Opening analytics dashboard...'),
//         backgroundColor: AppColors.primary,
//       ),
//     );
//   }

//   void _showSettings() {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Opening admin settings...'),
//         backgroundColor: AppColors.primary,
//       ),
//     );
//   }

//   void _exportData() {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Exporting video data...'),
//         backgroundColor: AppColors.success,
//       ),
//     );
//   }

//   void _bulkActions() {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Opening bulk actions menu...'),
//         backgroundColor: AppColors.primary,
//       ),
//     );
//   }

//   Future<void> _refreshData() async {
//     await Future.delayed(const Duration(seconds: 1));
//     setState(() {
//       // Trigger rebuild
//     });
//   }
// }
