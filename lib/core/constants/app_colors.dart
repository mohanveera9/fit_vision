import 'package:flutter/material.dart';

class AppColors {
  // Primary Color Scheme
  static const Color primary = Color(0xFF1E40AF); // Deep blue
  static const Color onPrimary = Color(0xFFFFFFFF); // White text on primary
  static const Color primaryContainer = Color(0xFF3B82F6); // Bright blue
  static const Color onPrimaryContainer = Color(0xFFFFFFFF);

  // Secondary Colors
  static const Color secondary = Color(0xFFF59E0B); // Orange accent
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFFEF3C7);
  static const Color onSecondaryContainer = Color(0xFF92400E);

  // Surface Colors
  static const Color surface = Color(0xFFFFFFFF); // Card backgrounds
  static const Color onSurface = Color(0xFF1F2937); // Primary text
  static const Color surfaceVariant = Color(0xFFF8FAFC); // Light gray backgrounds
  static const Color onSurfaceVariant = Color(0xFF6B7280); // Secondary text

  // Semantic Colors
  static const Color error = Color(0xFFEF4444);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color success = Color(0xFF10B981); // Custom success color
  static const Color warning = Color(0xFFF59E0B); // Custom warning color

  // Additional Colors
  static const Color background = Color(0xFFFAFAFA);
  static const Color onBackground = Color(0xFF1F2937);
  static const Color outline = Color(0xFFE5E7EB);
  static const Color shadow = Color(0x1A000000);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryContainer],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [success, Color(0xFF34D399)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Status Colors
  static const Color completed = success;
  static const Color pending = warning;
  static const Color failed = error;
  static const Color inProgress = primary;
}
