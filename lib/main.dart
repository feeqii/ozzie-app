import 'package:flutter/material.dart';
import 'package:ozzie/core/theme/app_theme.dart';
import 'package:ozzie/core/widgets/ozzie_button.dart';
import 'package:ozzie/core/widgets/ozzie_card.dart';
import 'package:ozzie/core/widgets/ozzie_placeholder.dart';
import 'package:ozzie/core/widgets/ozzie_progress_bar.dart';
import 'package:ozzie/core/constants/app_sizes.dart';

/// 🚀 MAIN ENTRY POINT
void main() {
  runApp(const MyApp());
}

/// 📱 MY APP WIDGET
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ozzie - Quranic Learning',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const WidgetShowcaseScreen(),
    );
  }
}

/// 🎨 WIDGET SHOWCASE SCREEN
/// 
/// Shows off all our beautiful new widgets!
/// This is temporary - just to see what we built!
class WidgetShowcaseScreen extends StatelessWidget {
  const WidgetShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ozzie Widgets Showcase'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ========== OZZIE MASCOT ==========
            const Text(
              '🎭 Ozzie Mascot',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSizes.spaceMedium),
            
            // Different Ozzie expressions
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OzziePlaceholder(
                  size: OzzieSize.small,
                  expression: OzzieExpression.happy,
                ),
                OzziePlaceholder(
                  size: OzzieSize.small,
                  expression: OzzieExpression.excited,
                ),
                OzziePlaceholder(
                  size: OzzieSize.small,
                  expression: OzzieExpression.thinking,
                ),
                OzziePlaceholder(
                  size: OzzieSize.small,
                  expression: OzzieExpression.celebrating,
                ),
              ],
            ),
            
            const SizedBox(height: AppSizes.spaceMedium),
            
            // Ozzie with message
            const Center(
              child: OzziePlaceholder(
                size: OzzieSize.medium,
                expression: OzzieExpression.happy,
                message: 'Welcome to Ozzie! Let\'s learn together! 🌟',
                animated: true,
              ),
            ),
            
            const SizedBox(height: AppSizes.spaceXLarge),
            
            // ========== BUTTONS ==========
            const Text(
              '🔘 Buttons',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSizes.spaceMedium),
            
            // Primary button
            OzzieButton(
              text: 'Start Learning',
              icon: Icons.play_arrow,
              onPressed: () {
                _showSnackBar(context, 'Primary button tapped!');
              },
            ),
            
            const SizedBox(height: AppSizes.spaceSmall),
            
            // Secondary button
            OzzieButton(
              text: 'Continue',
              type: OzzieButtonType.secondary,
              onPressed: () {
                _showSnackBar(context, 'Secondary button tapped!');
              },
            ),
            
            const SizedBox(height: AppSizes.spaceSmall),
            
            // Outline button
            OzzieButton(
              text: 'View Progress',
              type: OzzieButtonType.outline,
              icon: Icons.trending_up,
              onPressed: () {
                _showSnackBar(context, 'Outline button tapped!');
              },
            ),
            
            const SizedBox(height: AppSizes.spaceSmall),
            
            // Different sizes
            Row(
              children: [
                Expanded(
                  child: OzzieButton(
                    text: 'Small',
                    size: OzzieButtonSize.small,
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: AppSizes.spaceSmall),
                Expanded(
                  child: OzzieButton(
                    text: 'Medium',
                    size: OzzieButtonSize.medium,
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: AppSizes.spaceSmall),
                Expanded(
                  child: OzzieButton(
                    text: 'Large',
                    size: OzzieButtonSize.large,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppSizes.spaceXLarge),
            
            // ========== CARDS ==========
            const Text(
              '📇 Cards',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSizes.spaceMedium),
            
            // Regular card
            OzzieCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Surah Al-Fatiha',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: AppSizes.spaceXTiny),
                  Text(
                    'The Opening • 7 Verses',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: AppSizes.spaceMedium),
                  const OzzieProgressBar(
                    current: 5,
                    total: 7,
                    label: 'Progress',
                  ),
                ],
              ),
            ),
            
            // Tappable card
            OzzieCard(
              onTap: () {
                _showSnackBar(context, 'Card tapped!');
              },
              child: Row(
                children: [
                  const Icon(Icons.book, size: 40),
                  const SizedBox(width: AppSizes.spaceMedium),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tap me!',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          'This card is interactive',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),
            
            // Info card
            OzzieInfoCard(
              message: 'Great job! You completed your first verse! 🎉',
              icon: Icons.celebration,
              actionText: 'Continue',
              onActionTap: () {
                _showSnackBar(context, 'Continue tapped!');
              },
            ),
            
            const SizedBox(height: AppSizes.spaceXLarge),
            
            // ========== PROGRESS INDICATORS ==========
            const Text(
              '📊 Progress Indicators',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSizes.spaceMedium),
            
            // Linear progress bars
            const OzzieProgressBar(
              current: 3,
              total: 7,
              label: 'Verses Completed',
            ),
            
            const SizedBox(height: AppSizes.spaceMedium),
            
            const OzzieProgressBar(
              current: 85,
              total: 100,
              label: 'Accuracy Score',
              showPercentage: true,
              showFraction: false,
            ),
            
            const SizedBox(height: AppSizes.spaceXLarge),
            
            // Circular progress
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OzzieCircularProgress(
                  current: 75,
                  total: 100,
                  label: 'Overall',
                  size: 80,
                ),
                OzzieCircularProgress(
                  current: 5,
                  total: 7,
                  centerText: '5/7',
                  label: 'Verses',
                  size: 80,
                ),
              ],
            ),
            
            const SizedBox(height: AppSizes.spaceXLarge),
            
            // Star ratings
            const Center(
              child: Column(
                children: [
                  Text('Star Ratings', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: AppSizes.spaceSmall),
                  OzzieStarRating(stars: 1),
                  SizedBox(height: AppSizes.spaceSmall),
                  OzzieStarRating(stars: 2),
                  SizedBox(height: AppSizes.spaceSmall),
                  OzzieStarRating(stars: 3),
                ],
              ),
            ),
            
            const SizedBox(height: AppSizes.spaceXLarge),
            
            // ========== ANIMATED OZZIE ==========
            const Text(
              '🎬 Animated Ozzie',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSizes.spaceMedium),
            
            const Center(
              child: AnimatedOzzie(
                size: OzzieSize.large,
                expression: OzzieExpression.celebrating,
                message: 'You\'re doing amazing! Keep going! 🌟',
              ),
            ),
            
            const SizedBox(height: AppSizes.spaceHuge),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
