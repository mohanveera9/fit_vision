import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../data/education_mock_data.dart';
import '../models/education_models.dart';

class LessonContentScreen extends StatefulWidget {
  final String moduleId;
  final String lessonId;
  const LessonContentScreen({super.key, required this.moduleId, required this.lessonId});

  @override
  State<LessonContentScreen> createState() => _LessonContentScreenState();
}

class _LessonContentScreenState extends State<LessonContentScreen> {
  bool bookmarked = false;
  bool markedComplete = false;

  @override
  Widget build(BuildContext context) {
    final EducationModule? module = EducationMockData.getModuleById(widget.moduleId);
    final Lesson? lesson = EducationMockData.getLesson(widget.moduleId, widget.lessonId);

    if (module == null || lesson == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Lesson')),
        body: const Center(child: Text('Lesson not found')),
      );
    }

    final int lessonIndex = module.lessons.indexWhere((l) => l.id == lesson.id);
    final int total = module.lessons.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('${module.title} • Lesson ${lessonIndex + 1}/$total'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/education/${module.id}'),
        ),
        actions: [
          IconButton(
            icon: Icon(bookmarked ? Icons.bookmark : Icons.bookmark_border),
            onPressed: () => setState(() => bookmarked = !bookmarked),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(lesson.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Row(
              children: [
                Text('Lesson ${lessonIndex + 1} of $total', style: const TextStyle(color: AppColors.onSurfaceVariant)),
                const SizedBox(width: 12),
                Chip(label: Text(lesson.duration), visualDensity: VisualDensity.compact),
              ],
            ),
            const SizedBox(height: AppDimensions.spacing12),

            Container(
              height: 160,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              ),
              child: const Center(
                child: Icon(Icons.play_circle_fill, size: 48, color: AppColors.onSurfaceVariant),
              ),
            ),

            const SizedBox(height: AppDimensions.spacing16),
            Text(
              lesson.content,
              style: const TextStyle(height: 1.5),
            ),

            const SizedBox(height: AppDimensions.spacing16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.06),
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Key Points', style: TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  ...lesson.keyPoints.map((kp) => Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.check, size: 16, color: AppColors.primary),
                          const SizedBox(width: 6),
                          Expanded(child: Text(kp)),
                        ],
                      )),
                ],
              ),
            ),

            const SizedBox(height: AppDimensions.spacing16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Quick Quiz', style: TextStyle(fontWeight: FontWeight.w700)),
                  SizedBox(height: 8),
                  Text('1) True or False: Carbohydrates are the main fuel for high-intensity exercise.'),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacing12),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: lessonIndex > 0
                      ? () {
                          final prev = module.lessons[lessonIndex - 1];
                          context.go('/education/${module.id}/${prev.id}');
                        }
                      : null,
                  icon: const Icon(Icons.chevron_left),
                  label: const Text('Previous'),
                ),
              ),
              const SizedBox(width: AppDimensions.spacing12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => setState(() => markedComplete = true),
                  icon: Icon(markedComplete ? Icons.check_circle : Icons.check_circle_outline),
                  label: Text(markedComplete ? 'Completed' : 'Mark as Complete'),
                ),
              ),
              const SizedBox(width: AppDimensions.spacing12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: lessonIndex < total - 1
                      ? () {
                          final next = module.lessons[lessonIndex + 1];
                          context.go('/education/${module.id}/${next.id}');
                        }
                      : null,
                  icon: const Icon(Icons.chevron_right),
                  label: const Text('Next'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


