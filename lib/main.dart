import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ozzie/core/router/app_router.dart';
import 'package:ozzie/core/theme/app_theme.dart';

/// 🚀 MAIN ENTRY POINT
/// 
/// This is where the Ozzie app starts!
/// 
/// WHAT CHANGED?
/// We now use:
/// 1. ProviderScope - Wraps the app for Riverpod state management
/// 2. MaterialApp.router - Uses our GoRouter for navigation
/// 3. Hive - Initialize local database for progress tracking
/// 
/// WHY?
/// - ProviderScope: Lets us use Riverpod for managing app state (user progress, lesson flow, etc.)
/// - GoRouter: Gives us professional navigation with deep links and organized routes
/// - Hive: Fast local database to save user progress (works offline!)
void main() async {
  // Ensure Flutter is initialized before running async code
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive for local storage
  await Hive.initFlutter();
  
  print('✅ Hive initialized successfully!');
  
  runApp(
    // ProviderScope enables Riverpod state management throughout the app
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

/// 📱 MY APP WIDGET
/// 
/// The root widget of the entire app.
/// Now uses MaterialApp.router instead of regular MaterialApp!
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // App title
      title: 'Ozzie - Quranic Learning',
      
      // Our beautiful theme
      theme: AppTheme.lightTheme,
      
      // Hide the debug banner (that red ribbon in the corner)
      debugShowCheckedModeBanner: false,
      
      // Router configuration - this manages all navigation!
      routerConfig: AppRouter.router,
    );
  }
}
