import 'package:flutter/material.dart';

class EducationModule {
  final String id;
  final String title;
  final IconData icon;
  final Color color;
  final int totalLessons;
  final int completedLessons;
  final String duration;
  final List<Lesson> lessons;
  final String overview;
  final List<String> objectives;
  final String difficulty; // Easy | Medium | Hard

  const EducationModule({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
    required this.totalLessons,
    required this.completedLessons,
    required this.duration,
    required this.lessons,
    required this.overview,
    required this.objectives,
    required this.difficulty,
  });
}

class Lesson {
  final String id;
  final String title;
  final String content;
  final String duration;
  final bool isCompleted;
  final bool isLocked;
  final List<String> keyPoints;

  const Lesson({
    required this.id,
    required this.title,
    required this.content,
    required this.duration,
    required this.isCompleted,
    required this.isLocked,
    required this.keyPoints,
  });
}


