import 'package:flutter/material.dart';
import 'package:ozzie/core/theme/app_theme.dart';

/// 🚀 MAIN ENTRY POINT
/// 
/// This is where the Ozzie app starts!
/// Think of this like the "front door" of our app.
/// 
/// When you run the app, Flutter comes here first and says:
/// "Okay, what should I show?"
/// 
/// We tell it: "Show the MyApp widget!"
void main() {
  // This line starts the app
  // runApp() tells Flutter to display our app on the screen
  runApp(const MyApp());
}

/// 📱 MY APP WIDGET
/// 
/// This is the "root" widget - the top level of our entire app.
/// It sets up important things like:
/// - What theme to use (colors, fonts, etc.)
/// - What the first screen should be
/// - App title and configuration
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp is like the "container" for our entire app
    // It provides navigation, theme, and other important features
    return MaterialApp(
      // ========== APP CONFIGURATION ==========
      
      /// Title - shown in task switcher (when you switch between apps)
      title: 'Ozzie - Quranic Learning',

      /// Theme - Our custom beautiful theme!
      /// This makes EVERYTHING in the app look consistent
      theme: AppTheme.lightTheme,

      /// Debug banner - that red "DEBUG" banner in top right
      /// Turn it off for a cleaner look
      debugShowCheckedModeBanner: false,

      // ========== HOME SCREEN ==========
      
      /// The first screen users see when they open the app
      /// For now, we'll show a simple welcome screen
      /// Later, we'll replace this with our real home screen!
      home: const WelcomeScreen(),
    );
  }
}

/// 🏠 WELCOME SCREEN (Temporary)
/// 
/// This is just a placeholder screen to test our theme!
/// We'll replace this with the real home screen later.
/// 
/// This screen shows:
/// - A welcome message
/// - Our brand colors
/// - Different text styles
/// - So we can see if everything looks good!
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold is like a "template" for a screen
    // It provides: app bar (top), body (content), bottom navigation, etc.
    return Scaffold(
      // ========== APP BAR (Top bar) ==========
      appBar: AppBar(
        title: const Text('Ozzie'),
        // Our theme automatically styles this beautifully!
      ),

      // ========== BODY (Main content) ==========
      body: Center(
        // Center widget puts everything in the middle of the screen
        child: Padding(
          // Padding adds space around the content
          padding: const EdgeInsets.all(24.0),
          child: Column(
            // Column stacks widgets vertically (top to bottom)
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ========== WELCOME TEXT ==========
              Text(
                '🌟 Welcome to Ozzie! 🌟',
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 24), // Empty space
              
              // ========== SUBTITLE ==========
              Text(
                'Quranic Learning for Children',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              // ========== DESCRIPTION ==========
              Text(
                'An engaging, fun way to learn and memorize the Quran!',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 40),
              
              // ========== SAMPLE ARABIC TEXT ==========
              Text(
                'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 28,
                  height: 1.8,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 12),
              
              // ========== TRANSLITERATION ==========
              Text(
                'Bismillah ir-Rahman ir-Raheem',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 48),
              
              // ========== BUTTON ==========
              ElevatedButton(
                onPressed: () {
                  // For now, just show a message
                  // Later, this will start the app!
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Coming soon! 🚀'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  child: Text('Start Learning'),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // ========== INFO TEXT ==========
              Text(
                '✅ Flutter Setup Complete\n✅ Design System Ready\n✅ Ready to Build!',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
