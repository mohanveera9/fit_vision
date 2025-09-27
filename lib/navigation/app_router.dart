import 'package:fit_vision/features/authentication/language_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/authentication/screens/splash_screen.dart';
import '../features/authentication/screens/welcome_screen.dart';
import '../features/authentication/screens/name_entry_screen.dart';
import '../features/authentication/screens/aadhaar_upload_screen.dart';
import '../features/authentication/screens/profile_confirmation_screen.dart';
import '../features/dashboard/screens/education_hub_screen.dart';
import '../features/education/screens/module_detail_screen.dart';
import '../features/education/screens/lesson_content_screen.dart';
import '../features/dashboard/screens/home_screen.dart';
import '../features/tests/screens/height_measurement_screen.dart';
import '../features/tests/screens/weight_entry_screen.dart';
import '../features/tests/screens/test_selection_screen.dart';
import '../features/tests/screens/exercise_tutorial_screen.dart';
import '../features/tests/screens/live_test_screen.dart';
import '../features/tests/screens/test_results_screen.dart';
import '../features/progress/screens/progress_screen.dart';
import '../features/leaderboard/screens/leaderboard_screen.dart';
import '../features/leaderboard/screens/achievements_screen.dart';
import '../features/admin/screens/admin_dashboard_screen.dart';
import '../features/dashboard/screens/settings_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      // Splash Screen
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      //language selection screen
      GoRoute(
        path: '/lang',
        name: 'langauge',
        builder: (context, state) => const LanguageSelectionScreen(),
      ),

      // Authentication Flow
      GoRoute(
        path: '/welcome',
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/register/name',
        name: 'nameEntry',
        builder: (context, state) => const NameEntryScreen(),
      ),
      GoRoute(
        path: '/register/aadhaar',
        name: 'aadhaarUpload',
        builder: (context, state) => const AadhaarUploadScreen(),
      ),
      GoRoute(
        path: '/register/confirm',
        name: 'profileConfirmation',
        builder: (context, state) => const ProfileConfirmationScreen(),
      ),

      // Main App with Bottom Navigation
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          // Education routes (inside shell to keep bottom nav visible)
          GoRoute(
            path: '/education',
            name: 'educationHub',
            builder: (context, state) => const EducationHubScreen(),
          ),
          GoRoute(
            path: '/education/:moduleId',
            name: 'educationModule',
            builder: (context, state) {
              final moduleId = state.pathParameters['moduleId']!;
              return ModuleDetailScreen(moduleId: moduleId);
            },
          ),
          GoRoute(
            path: '/education/:moduleId/:lessonId',
            name: 'educationLesson',
            builder: (context, state) {
              final moduleId = state.pathParameters['moduleId']!;
              final lessonId = state.pathParameters['lessonId']!;
              return LessonContentScreen(moduleId: moduleId, lessonId: lessonId);
            },
          ),
          GoRoute(
            path: '/tests',
            name: 'testSelection',
            builder: (context, state) => const TestSelectionScreen(),
          ),
          GoRoute(
            path: '/progress',
            name: 'progress',
            builder: (context, state) => const ProgressScreen(),
          ),
          GoRoute(
            path: '/leaderboard',
            name: 'leaderboard',
            builder: (context, state) => const LeaderboardScreen(),
          ),
        ],
      ),

      // Test Flow
      GoRoute(
        path: '/tests/height',
        name: 'heightMeasurement',
        builder: (context, state) => const HeightMeasurementScreen(),
      ),
      GoRoute(
        path: '/tests/weight',
        name: 'weightEntry',
        builder: (context, state) => const WeightEntryScreen(),
      ),
      GoRoute(
        path: '/tests/:testId/tutorial',
        name: 'exerciseTutorial',
        builder: (context, state) {
          final testId = state.pathParameters['testId']!;
          return ExerciseTutorialScreen(testId: testId);
        },
      ),
      GoRoute(
        path: '/tests/:testId/live',
        name: 'liveTest',
        builder: (context, state) {
          final testId = state.pathParameters['testId']!;
          return LiveTestScreen(testId: testId);
        },
      ),
      GoRoute(
        path: '/tests/:testId/results',
        name: 'testResults',
        builder: (context, state) {
          final testId = state.pathParameters['testId']!;
          return TestResultsScreen(testId: testId);
        },
      ),

      // Achievements
      GoRoute(
        path: '/achievements',
        name: 'achievements',
        builder: (context, state) => const AchievementsScreen(),
      ),

      // // Video Library
      // GoRoute(
      //   path: '/videos',
      //   name: 'videoLibrary',
      //   builder: (context, state) => const VideoLibraryScreen(),
      // ),

      // Admin Routes
      GoRoute(
        path: '/admin/dashboard',
        name: 'adminDashboard',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      // GoRoute(
      //   path: '/admin/videos',
      //   name: 'adminVideoLibrary',
      //   builder: (context, state) => const AdminVideoLibraryScreen(),
      // ),

      // Settings
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}

class MainShell extends StatefulWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<NavigationDestination> _destinations = [
    const NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: 'Home',
    ),
    const NavigationDestination(
      icon: Icon(Icons.menu_book_outlined),
      selectedIcon: Icon(Icons.menu_book),
      label: 'Education',
    ),
    const NavigationDestination(
      icon: Icon(Icons.fitness_center_outlined),
      selectedIcon: Icon(Icons.fitness_center),
      label: 'Tests',
    ),
    const NavigationDestination(
      icon: Icon(Icons.trending_up_outlined),
      selectedIcon: Icon(Icons.trending_up),
      label: 'Progress',
    ),
    const NavigationDestination(
      icon: Icon(Icons.leaderboard_outlined),
      selectedIcon: Icon(Icons.leaderboard),
      label: 'Leaderboard',
    ),
  ];

  void _onDestinationSelected(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/education');
        break;
      case 2:
        context.go('/tests');
        break;
      case 3:
        context.go('/progress');
        break;
      case 4:
        context.go('/leaderboard');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: _destinations,
        backgroundColor: Colors.white,
        indicatorColor: Theme.of(context).primaryColor.withOpacity(0.1),
        surfaceTintColor: Colors.transparent,
      ),
    );
  }
}
