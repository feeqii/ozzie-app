import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ozzie/features/home/ui/screens/home_screen.dart';
import 'package:ozzie/features/home/ui/screens/surah_map_screen.dart';
import 'package:ozzie/features/lesson/ui/screens/lesson_flow_screen.dart';
import 'package:ozzie/features/lesson/ui/screens/verse_display_screen.dart';

/// 🗺️ APP ROUTER
/// 
/// This is like a GPS for our app - it knows how to navigate between screens!
/// 
/// WHAT IS THIS?
/// GoRouter manages navigation in our app. Instead of manually pushing
/// and popping screens, we define "routes" (like addresses) and navigate
/// using simple paths like '/home' or '/lesson/1/2'.
/// 
/// WHY?
/// - Clean, organized navigation
/// - Deep linking support (for future features)
/// - Easy to understand and maintain
/// - Type-safe navigation
/// 
/// HOW IT WORKS:
/// Each route has a:
/// - path: The "address" (e.g., '/home')
/// - name: A friendly name we can use in code
/// - builder: What screen to show when we navigate there
/// 
/// EXAMPLE USAGE:
/// ```dart
/// // Navigate to home screen
/// context.go('/');
/// 
/// // Navigate to a specific lesson
/// context.go('/lesson/1/2'); // Surah 1, Verse 2
/// ```

class AppRouter {
  AppRouter._();

  /// Route names - like shortcuts so we don't have to remember paths
  static const String home = 'home';
  static const String surahMap = 'surah-map';
  static const String lessonFlow = 'lesson-flow';
  static const String profile = 'profile';
  static const String verseDisplay = 'verse-display'; // Developer test screen

  /// The actual router configuration
  static final GoRouter router = GoRouter(
    // Where does the app start?
    initialLocation: '/',
    
    // Enable debug logging (helpful for learning!)
    debugLogDiagnostics: true,
    
    // All the routes (screens) in our app
    routes: [
      // ========== HOME SCREEN (Starting point) ==========
      GoRoute(
        path: '/',
        name: home,
        builder: (context, state) => const HomeScreen(),
      ),

      // ========== DEVELOPER TEST SCREEN ==========
      // This is just for us to verify data loading!
      // Kids won't see this - it's a behind-the-scenes tool
      GoRoute(
        path: '/dev/verse-display',
        name: verseDisplay,
        builder: (context, state) => const VerseDisplayScreen(),
      ),

      // ========== SURAH MAP (Planet selector) ==========
      // The cosmic quest map where kids choose which Surah to learn!
      GoRoute(
        path: '/surah-map',
        name: surahMap,
        builder: (context, state) => const SurahMapScreen(),
      ),

      // ========== LESSON FLOW (The 6-step learning experience) ==========
      // The main lesson screen - where kids learn verses!
      // Takes parameters: surahNumber and verseNumber
      // Example: /lesson/1/2 means Surah 1, Verse 2
      GoRoute(
        path: '/lesson/:surahNumber/:verseNumber',
        name: lessonFlow,
        builder: (context, state) {
          final surahNumber = int.parse(state.pathParameters['surahNumber']!);
          final verseNumber = int.parse(state.pathParameters['verseNumber']!);
          return LessonFlowScreen(
            surahNumber: surahNumber,
            verseNumber: verseNumber,
          );
        },
      ),

      // ========== PROFILE/PROGRESS SCREEN ==========
      // Coming soon! Shows user stats, badges, achievements
      // GoRoute(
      //   path: '/profile',
      //   name: profile,
      //   builder: (context, state) => const ProfileScreen(),
      // ),
    ],

    // ========== ERROR HANDLING ==========
    // What to show if user tries to go to a route that doesn't exist
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('Oops!'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.orange),
              const SizedBox(height: 20),
              Text(
                'Page not found!',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 10),
              Text(
                'Looks like this page doesn\'t exist.',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

