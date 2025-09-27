// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import '../../../core/constants/app_colors.dart';
// import '../../../core/constants/app_dimensions.dart';
// import '../../../core/utils/mock_data.dart';
// import '../../../shared/widgets/custom_button.dart';
// import '../../../shared/widgets/custom_text_field.dart';

// class VideoLibraryScreen extends StatefulWidget {
//   const VideoLibraryScreen({super.key});

//   @override
//   State<VideoLibraryScreen> createState() => _VideoLibraryScreenState();
// }

// class _VideoLibraryScreenState extends State<VideoLibraryScreen>
//     with TickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _animation;

//   final TextEditingController _searchController = TextEditingController();
//   String _searchQuery = '';
//   String _selectedCategory = 'All';

//   final List<String> _categories = ['All', 'Tutorial', 'Exercise', 'Motivation'];

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
//     var videos = MockData.mockVideos;
    
//     if (_selectedCategory != 'All') {
//       videos = videos.where((video) => video['category'] == _selectedCategory).toList();
//     }
    
//     if (_searchQuery.isNotEmpty) {
//       videos = videos.where((video) => 
//         video['title'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
//         video['description'].toLowerCase().contains(_searchQuery.toLowerCase())
//       ).toList();
//     }
    
//     return videos;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final filteredVideos = _getFilteredVideos();
    
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Video Library'),
//         centerTitle: true,
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.download),
//             onPressed: _showDownloadOptions,
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
//       child: Column(
//         children: [
//           // Search Bar
//           CustomSearchField(
//             controller: _searchController,
//             hint: 'Search videos...',
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
          
//           // Category Filters
//           SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Row(
//               children: _categories.map((category) {
//                 final isSelected = _selectedCategory == category;
//                 return Padding(
//                   padding: const EdgeInsets.only(right: AppDimensions.spacing8),
//                   child: FilterChip(
//                     label: Text(category),
//                     selected: isSelected,
//                     onSelected: (selected) {
//                       setState(() {
//                         _selectedCategory = category;
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
          
//           // Results Count
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 '${filteredVideos.length} videos found',
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: AppColors.onSurfaceVariant,
//                 ),
//               ),
//               TextButton(
//                 onPressed: _showSortOptions,
//                 child: const Text('Sort'),
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
//         padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
//         itemCount: videos.length,
//         itemBuilder: (context, index) {
//           final video = videos[index];
          
//           return AnimationConfiguration.staggeredList(
//             position: index,
//             duration: const Duration(milliseconds: 600),
//             child: SlideAnimation(
//               horizontalOffset: 50.0,
//               child: FadeInAnimation(
//                 child: _buildVideoCard(video),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildVideoCard(Map<String, dynamic> video) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: AppDimensions.spacing16),
//       decoration: BoxDecoration(
//         color: AppColors.surface,
//         borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Video Thumbnail
//           GestureDetector(
//             onTap: () => _playVideo(video),
//             child: Stack(
//               children: [
//                 Container(
//                   width: double.infinity,
//                   height: 200,
//                   decoration: BoxDecoration(
//                     borderRadius: const BorderRadius.vertical(
//                       top: Radius.circular(AppDimensions.radiusMedium),
//                     ),
//                     image: DecorationImage(
//                       image: NetworkImage(video['thumbnailUrl']),
//                       fit: BoxFit.cover,
//                       onError: (exception, stackTrace) {
//                         // Handle image load error
//                       },
//                     ),
//                   ),
//                 ),
                
//                 // Play Button Overlay
//                 Center(
//                   child: Container(
//                     width: 60,
//                     height: 60,
//                     decoration: BoxDecoration(
//                       color: Colors.black.withOpacity(0.6),
//                       shape: BoxShape.circle,
//                     ),
//                     child: const Icon(
//                       Icons.play_arrow,
//                       color: Colors.white,
//                       size: 30,
//                     ),
//                   ),
//                 ),
                
//                 // Duration Badge
//                 Positioned(
//                   bottom: 8,
//                   right: 8,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: AppDimensions.spacing8,
//                       vertical: AppDimensions.spacing4,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.black.withOpacity(0.7),
//                       borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
//                     ),
//                     child: Text(
//                       video['duration'],
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 12,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ),
                
//                 // Category Badge
//                 Positioned(
//                   top: 8,
//                   left: 8,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: AppDimensions.spacing8,
//                       vertical: AppDimensions.spacing4,
//                     ),
//                     decoration: BoxDecoration(
//                       color: _getCategoryColor(video['category']).withOpacity(0.9),
//                       borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
//                     ),
//                     child: Text(
//                       video['category'],
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 10,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
          
//           // Video Info
//           Padding(
//             padding: const EdgeInsets.all(AppDimensions.spacing16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Title
//                 Text(
//                   video['title'],
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: AppColors.onSurface,
//                   ),
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
                
//                 const SizedBox(height: AppDimensions.spacing8),
                
//                 // Description
//                 Text(
//                   video['description'],
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: AppColors.onSurfaceVariant,
//                   ),
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
                
//                 const SizedBox(height: AppDimensions.spacing12),
                
//                 // Video Metadata
//                 Row(
//                   children: [
//                     Icon(
//                       Icons.schedule,
//                       size: 16,
//                       color: AppColors.onSurfaceVariant,
//                     ),
//                     const SizedBox(width: AppDimensions.spacing4),
//                     Text(
//                       _formatUploadDate(video['uploadedAt']),
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: AppColors.onSurfaceVariant,
//                       ),
//                     ),
//                     const Spacer(),
//                     TextButton.icon(
//                       onPressed: () => _downloadVideo(video),
//                       icon: const Icon(Icons.download, size: 16),
//                       label: const Text('Download'),
//                       style: TextButton.styleFrom(
//                         foregroundColor: AppColors.primary,
//                         textStyle: const TextStyle(fontSize: 12),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
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
//               Icons.video_library_outlined,
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
//           const SizedBox(height: AppDimensions.spacing24),
//           CustomButton(
//             text: 'Clear Filters',
//             onPressed: () {
//               setState(() {
//                 _searchQuery = '';
//                 _selectedCategory = 'All';
//                 _searchController.clear();
//               });
//             },
//             type: ButtonType.outlined,
//           ),
//         ],
//       ),
//     );
//   }

//   void _playVideo(Map<String, dynamic> video) {
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
//           FilledButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//               _downloadVideo(video);
//             },
//             child: const Text('Download'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _downloadVideo(Map<String, dynamic> video) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Downloading "${video['title']}"...'),
//         backgroundColor: AppColors.success,
//       ),
//     );
//   }

//   void _showDownloadOptions() {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) => Container(
//         padding: const EdgeInsets.all(AppDimensions.spacing24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text(
//               'Download Options',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: AppDimensions.spacing24),
//             ListTile(
//               leading: const Icon(Icons.download),
//               title: const Text('Download All Videos'),
//               onTap: () {
//                 Navigator.pop(context);
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text('Starting download of all videos...'),
//                     backgroundColor: AppColors.primary,
//                   ),
//                 );
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.category),
//               title: const Text('Download by Category'),
//               onTap: () {
//                 Navigator.pop(context);
//                 _showCategoryDownloadDialog();
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.settings),
//               title: const Text('Download Settings'),
//               onTap: () {
//                 Navigator.pop(context);
//                 // Show download settings
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showCategoryDownloadDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Download by Category'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: _categories.where((cat) => cat != 'All').map((category) {
//             return ListTile(
//               title: Text(category),
//               trailing: const Icon(Icons.download),
//               onTap: () {
//                 Navigator.of(context).pop();
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text('Downloading all $category videos...'),
//                     backgroundColor: AppColors.primary,
//                   ),
//                 );
//               },
//             );
//           }).toList(),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('Cancel'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showSortOptions() {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) => Container(
//         padding: const EdgeInsets.all(AppDimensions.spacing24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text(
//               'Sort Videos',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: AppDimensions.spacing24),
//             const ListTile(
//               leading: Icon(Icons.access_time),
//               title: Text('Recently Added'),
//             ),
//             const ListTile(
//               leading: Icon(Icons.alphabetical),
//               title: Text('Alphabetical'),
//             ),
//             const ListTile(
//               leading: Icon(Icons.timer),
//               title: Text('Duration'),
//             ),
//             const ListTile(
//               leading: Icon(Icons.category),
//               title: Text('Category'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Color _getCategoryColor(String category) {
//     switch (category) {
//       case 'Tutorial':
//         return AppColors.primary;
//       case 'Exercise':
//         return AppColors.success;
//       case 'Motivation':
//         return AppColors.secondary;
//       default:
//         return AppColors.onSurfaceVariant;
//     }
//   }

//   String _formatUploadDate(DateTime date) {
//     final now = DateTime.now();
//     final difference = now.difference(date);
    
//     if (difference.inDays > 30) {
//       return '${(difference.inDays / 30).round()}mo ago';
//     } else if (difference.inDays > 0) {
//       return '${difference.inDays}d ago';
//     } else if (difference.inHours > 0) {
//       return '${difference.inHours}h ago';
//     } else {
//       return 'Just now';
//     }
//   }

//   Future<void> _refreshData() async {
//     await Future.delayed(const Duration(seconds: 1));
//     setState(() {
//       // Trigger rebuild
//     });
//   }
// }
