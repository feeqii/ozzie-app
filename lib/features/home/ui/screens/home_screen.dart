import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ozzie/core/constants/app_colors.dart';
import 'package:ozzie/core/constants/app_sizes.dart';
import 'package:ozzie/core/constants/app_text_styles.dart';
import 'package:ozzie/core/widgets/ozzie_button.dart';
import 'package:ozzie/core/widgets/ozzie_card.dart';
import 'package:ozzie/core/widgets/ozzie_placeholder.dart';
import 'package:ozzie/core/widgets/ozzie_progress_bar.dart';

/// 🏠 HOME SCREEN
/// 
/// The main dashboard where kids start their Quranic learning journey!
/// 
/// WHAT IS THIS?
/// This is like the "home base" of the Ozzie app. When kids open the app,
/// this is the first thing they see. It shows:
/// - A friendly greeting from Ozzie
/// - Their current learning streak (how many days in a row they've studied)
/// - Progress on different Surahs
/// - Recent badges they've earned
/// - Buttons to continue learning or start something new
/// 
/// WHY?
/// - Motivates kids by showing their progress
/// - Makes them feel welcomed and encouraged
/// - Quick access to continue where they left off
/// - Celebrates achievements (streaks, badges)
/// 
/// DESIGN PHILOSOPHY:
/// - Warm and encouraging (not intimidating!)
/// - Visual and colorful (kids love colors!)
/// - Clear call-to-action (big buttons they can't miss)
/// - Celebratory (every bit of progress is celebrated!)

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // No app bar - we want a clean, immersive experience
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ========== OZZIE GREETING SECTION ==========
              _buildOzzieGreeting(context),

              const SizedBox(height: AppSizes.spaceLarge),

              // ========== STREAK COUNTER SECTION ==========
              _buildStreakCounter(context),

              const SizedBox(height: AppSizes.spaceLarge),

              // ========== PROGRESS SECTION ==========
              _buildProgressSection(context),

              const SizedBox(height: AppSizes.spaceLarge),

              // ========== RECENT BADGES SECTION ==========
              _buildRecentBadges(context),

              const SizedBox(height: AppSizes.spaceXLarge),

              // ========== ACTION BUTTONS ==========
              _buildActionButtons(context),

              const SizedBox(height: AppSizes.spaceLarge),

              // ========== DEVELOPER TOOLS (Hidden for kids!) ==========
              // This is just for us during development
              _buildDeveloperTools(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Ozzie greeting at the top
  Widget _buildOzzieGreeting(BuildContext context) {
    // Get current hour to determine greeting
    final hour = DateTime.now().hour;
    final String greeting;
    if (hour < 12) {
      greeting = 'Good Morning';
    } else if (hour < 17) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
    }

    return OzzieCard(
      backgroundColor: AppColors.cream,
      padding: const EdgeInsets.all(AppSizes.cardPadding * 1.5),
      child: Column(
        children: [
          // Ozzie mascot
          const OzziePlaceholder(
            size: OzzieSize.medium,
            expression: OzzieExpression.happy,
            animated: true,
          ),

          const SizedBox(height: AppSizes.spaceMedium),

          // Greeting text
          Text(
            '$greeting, Ahmad!',
            style: AppTextStyles.headingLarge.copyWith(
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSizes.spaceSmall),

          // Motivational message
          Text(
            'Ready to learn today? 🌟',
            style: AppTextStyles.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Daily streak counter with fire icon
  Widget _buildStreakCounter(BuildContext context) {
    const int currentStreak = 7; // TODO: Get from user progress state

    return OzzieCard(
      backgroundColor: AppColors.white,
      child: Row(
        children: [
          // Fire icon
          Container(
            padding: const EdgeInsets.all(AppSizes.spaceSmall),
            decoration: BoxDecoration(
              color: AppColors.orange.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_fire_department,
              color: AppColors.orange,
              size: AppSizes.iconLarge,
            ),
          ),

          const SizedBox(width: AppSizes.spaceMedium),

          // Streak info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Streak',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSizes.spaceXTiny),
                Text(
                  '$currentStreak Days',
                  style: AppTextStyles.headingMedium.copyWith(
                    color: AppColors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Encouraging message
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spaceSmall,
              vertical: AppSizes.spaceXTiny,
            ),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
            ),
            child: Text(
              '🎉 Amazing!',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.success,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Progress section showing Surah completion
  Widget _buildProgressSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Text(
          'Your Progress',
          style: AppTextStyles.headingMedium,
        ),

        const SizedBox(height: AppSizes.spaceMedium),

        // Surah Al-Fatiha progress
        OzzieCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Surah name
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Surah Al-Fatiha',
                        style: AppTextStyles.headingSmall,
                      ),
                      const SizedBox(height: AppSizes.spaceXTiny),
                      Text(
                        'الفاتحة',
                        style: AppTextStyles.arabicSmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),

                  // Completion percentage
                  Text(
                    '75%',
                    style: AppTextStyles.headingMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSizes.spaceMedium),

              // Progress bar
              const OzzieProgressBar(
                current: 5, // 5 verses completed
                total: 7,   // Out of 7 total verses
                height: 12,
                showPercentage: false,
                showFraction: false, // We'll show text separately below
              ),

              const SizedBox(height: AppSizes.spaceSmall),

              // Verses completed
              Text(
                '5 of 7 verses completed',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),

        // Add more Surahs here later (Al-Ikhlas, etc.)
      ],
    );
  }

  /// Recent badges showcase
  Widget _buildRecentBadges(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Text(
          'Recent Badges',
          style: AppTextStyles.headingMedium,
        ),

        const SizedBox(height: AppSizes.spaceMedium),

        // Badge grid
        OzzieCard(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildBadgeItem(
                icon: Icons.star,
                label: 'First\nVerse',
                color: AppColors.star,
              ),
              _buildBadgeItem(
                icon: Icons.wb_sunny,
                label: 'Week 1\nStreak',
                color: AppColors.orange,
              ),
              _buildBadgeItem(
                icon: Icons.check_circle,
                label: 'Perfect\nScore',
                color: AppColors.success,
              ),
              _buildBadgeItem(
                icon: Icons.emoji_events,
                label: 'Voice of\nAllah',
                color: AppColors.primary,
                isLocked: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Individual badge item
  Widget _buildBadgeItem({
    required IconData icon,
    required String label,
    required Color color,
    bool isLocked = false,
  }) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: isLocked 
                ? AppColors.lightGray 
                : color.withOpacity(0.2),
            shape: BoxShape.circle,
            border: Border.all(
              color: isLocked ? AppColors.mediumGray : color,
              width: 2,
            ),
          ),
          child: Icon(
            isLocked ? Icons.lock : icon,
            color: isLocked ? AppColors.mediumGray : color,
            size: 28,
          ),
        ),
        const SizedBox(height: AppSizes.spaceXTiny),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Main action buttons
  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // Continue Learning button (primary action)
        OzzieButton(
          text: 'Continue Learning',
          icon: Icons.play_arrow,
          onPressed: () {
            // TODO: Navigate to last incomplete verse
            // For now, show a message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Lesson flow coming soon! 🚀'),
                duration: Duration(seconds: 2),
              ),
            );
          },
          size: OzzieButtonSize.large,
          fullWidth: true,
        ),

        const SizedBox(height: AppSizes.spaceMedium),

        // Start New Journey button (secondary action)
        OzzieButton(
          text: 'Start New Journey',
          icon: Icons.rocket_launch,
          onPressed: () {
            // Navigate to Surah map screen
            context.push('/surah-map');
          },
          type: OzzieButtonType.outline,
          size: OzzieButtonSize.large,
          fullWidth: true,
        ),
      ],
    );
  }

  /// Developer tools (only visible during development)
  Widget _buildDeveloperTools(BuildContext context) {
    return OzzieCard(
      backgroundColor: AppColors.lightGray.withOpacity(0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.build, size: 20, color: AppColors.mediumGray),
              const SizedBox(width: AppSizes.spaceSmall),
              Text(
                'Developer Tools',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.mediumGray,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spaceSmall),
          OzzieButton(
            text: 'View Data Verification Screen',
            icon: Icons.code,
            onPressed: () {
              context.go('/dev/verse-display');
            },
            type: OzzieButtonType.text,
            size: OzzieButtonSize.small,
          ),
        ],
      ),
    );
  }
}

