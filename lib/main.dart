import 'package:flutter/material.dart';
import 'package:ozzie/core/theme/app_theme.dart';
import 'package:ozzie/features/lesson/ui/screens/verse_display_screen.dart';

/// 🚀 MAIN ENTRY POINT
/// 
/// This is where the Ozzie app starts!
void main() {
  runApp(const MyApp());
}

/// 📱 MY APP WIDGET
/// 
/// The root widget of the entire app.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ozzie - Quranic Learning',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const VerseDisplayScreen(),
    );
  }
}
