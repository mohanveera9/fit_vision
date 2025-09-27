import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../data/education_mock_data.dart';
import '../models/education_models.dart';

class ModuleDetailScreen extends StatelessWidget {
  final String moduleId;
  const ModuleDetailScreen({super.key, required this.moduleId});

  @override
  Widget build(BuildContext context) {
    final EducationModule? module = EducationMockData.getModuleById(moduleId);
    if (module == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Module')),
        body: const Center(child: Text('Module not found')),
      );
    }

    final progress = module.completedLessons / module.totalLessons;

    return Scaffold(
      appBar: AppBar(
        title: Text(module.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: module.color.withOpacity(0.15),
                    child: Icon(module.icon, color: module.color),
                  ),
                  const SizedBox(width: AppDimensions.spacing12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(module.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Expanded(
                              child: LinearProgressIndicator(value: progress, minHeight: 8),
                            ),
                            const SizedBox(width: AppDimensions.spacing8),
                            Text('${(progress * 100).round()}%'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppDimensions.spacing16),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Chip(label: Text('Lessons: ${module.totalLessons}')),
                    const SizedBox(width: AppDimensions.spacing8),
                    Chip(label: Text('Duration: ${module.duration}')),
                    const SizedBox(width: AppDimensions.spacing8),
                    Chip(label: Text('Difficulty: ${module.difficulty}')),
                  ],
                ),
              ),

              const SizedBox(height: AppDimensions.spacing16),

              Text(module.overview, style: const TextStyle(color: AppColors.onSurfaceVariant)),

              const SizedBox(height: AppDimensions.spacing16),
              const Text('Learning Objectives', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: AppDimensions.spacing8),
              ...module.objectives.map((o) => Row(
                    children: [
                      const Icon(Icons.check_circle, size: 16, color: AppColors.success),
                      const SizedBox(width: 6),
                      Expanded(child: Text(o)),
                    ],
                  )),

              const SizedBox(height: AppDimensions.spacing16),
              ElevatedButton.icon(
                onPressed: () {
                  final firstUnlock = module.lessons.firstWhere((l) => !l.isLocked, orElse: () => module.lessons.first);
                  context.go('/education/${module.id}/${firstUnlock.id}');
                },
                icon: const Icon(Icons.play_arrow),
                label: Text(module.completedLessons > 0 ? 'Resume' : 'Start'),
              ),

              const SizedBox(height: AppDimensions.spacing16),
              const Text('Lessons', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: AppDimensions.spacing8),
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: module.lessons.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final lesson = module.lessons[index];
                  return _LessonCard(
                    index: index,
                    lesson: lesson,
                    locked: lesson.isLocked,
                    onTap: lesson.isLocked
                        ? null
                        : () => context.go('/education/${module.id}/${lesson.id}'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LessonCard extends StatelessWidget {
  final int index;
  final Lesson lesson;
  final bool locked;
  final VoidCallback? onTap;

  const _LessonCard({
    required this.index,
    required this.lesson,
    required this.locked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spacing12),
        decoration: BoxDecoration(
          color: locked ? AppColors.surfaceVariant : AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          border: Border.all(color: AppColors.outline),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: locked ? AppColors.surface : AppColors.primary.withOpacity(0.1),
              child: Icon(locked ? Icons.lock : Icons.play_arrow, color: locked ? AppColors.onSurfaceVariant : AppColors.primary),
            ),
            const SizedBox(width: AppDimensions.spacing12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Lesson ${index + 1}: ${lesson.title}', style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Chip(label: Text(lesson.duration), visualDensity: VisualDensity.compact),
                      const SizedBox(width: 8),
                      if (lesson.isCompleted)
                        const Icon(Icons.check_circle, color: AppColors.success, size: 18),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


