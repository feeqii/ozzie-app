import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ozzie/core/constants/app_colors.dart';
import 'package:ozzie/core/constants/app_sizes.dart';
import 'package:ozzie/core/constants/app_text_styles.dart';
import 'package:ozzie/core/widgets/ozzie_card.dart';

/// 🪐 SURAH MAP SCREEN
/// 
/// The "Cosmic Quest" - where kids choose which Surah to learn!
/// 
/// WHAT IS THIS?
/// This is the main navigation screen for choosing Surahs.
/// Each Surah is represented as a PLANET in space!
/// - Dim/grey planets = locked (not started yet)
/// - Glowing planets = in progress
/// - Bright planets with stars = completed!
/// 
/// WHY?
/// - Makes learning feel like an adventure
/// - Visual progress (see planets light up!)
/// - Fun space theme appeals to kids
/// - Clear what's done vs. what's next
/// 
/// THEME INSPIRATION:
/// Think of it like a journey through the solar system,
/// but instead of visiting planets, you're learning Surahs!
/// Each planet has its own color and "personality".

class SurahMapScreen extends StatelessWidget {
  const SurahMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Space background gradient
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0D0221), // Deep purple-black (top of space)
              Color(0xFF1A0E2E), // Lighter purple (horizon)
              Color(0xFF2D1B4E), // Even lighter purple (bottom)
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ========== HEADER ==========
              _buildHeader(context),

              // ========== PLANET MAP (Scrollable) ==========
              Expanded(
                child: _buildPlanetMap(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Header with back button and title
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.screenPadding),
      child: Row(
        children: [
          // Back button
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back_ios),
            color: AppColors.white,
          ),

          const SizedBox(width: AppSizes.spaceSmall),

          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cosmic Quest',
                  style: AppTextStyles.headingLarge.copyWith(
                    color: AppColors.white,
                  ),
                ),
                Text(
                  'Choose your journey',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),

          // Info button
          IconButton(
            onPressed: () {
              _showMapInfo(context);
            },
            icon: const Icon(Icons.info_outline),
            color: AppColors.white,
          ),
        ],
      ),
    );
  }

  /// The main planet map
  Widget _buildPlanetMap(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
        child: Column(
          children: [
            const SizedBox(height: AppSizes.spaceLarge),

            // ========== PLANET 1: AL-FATIHA ==========
            _buildPlanetCard(
              context,
              surahNumber: 1,
              nameArabic: 'الفاتحة',
              nameEnglish: 'Al-Fatiha',
              nameMeaning: 'The Opening',
              totalVerses: 7,
              completedVerses: 5,
              color: AppColors.primary, // Gold
              isUnlocked: true,
            ),

            const SizedBox(height: AppSizes.spaceXLarge),

            // Path connector (dotted line between planets)
            _buildPathConnector(),

            const SizedBox(height: AppSizes.spaceXLarge),

            // ========== PLANET 2: AL-IKHLAS ==========
            _buildPlanetCard(
              context,
              surahNumber: 112,
              nameArabic: 'الإخلاص',
              nameEnglish: 'Al-Ikhlas',
              nameMeaning: 'The Sincerity',
              totalVerses: 4,
              completedVerses: 0,
              color: AppColors.secondary, // Orange
              isUnlocked: false, // Locked until Al-Fatiha is complete
            ),

            const SizedBox(height: AppSizes.spaceXLarge),

            // Coming soon message
            _buildComingSoonMessage(),

            const SizedBox(height: AppSizes.spaceXLarge),
          ],
        ),
      ),
    );
  }

  /// Individual planet card
  Widget _buildPlanetCard(
    BuildContext context, {
    required int surahNumber,
    required String nameArabic,
    required String nameEnglish,
    required String nameMeaning,
    required int totalVerses,
    required int completedVerses,
    required Color color,
    required bool isUnlocked,
  }) {
    final bool isCompleted = completedVerses == totalVerses;
    final bool isInProgress = completedVerses > 0 && !isCompleted;
    final double progress = completedVerses / totalVerses;

    return GestureDetector(
      onTap: isUnlocked
          ? () {
              // Navigate to first incomplete verse (or verse 1 for testing)
              // TODO: Later, show verse trail and let user pick
              context.push('/lesson/$surahNumber/1');
            }
          : null,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Glow effect (if in progress or completed)
          if (isInProgress || isCompleted)
            Container(
              width: AppSizes.planetLarge + 40,
              height: AppSizes.planetLarge + 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.5),
                    blurRadius: 30,
                    spreadRadius: 10,
                  ),
                ],
              ),
            ),

          // The planet itself
          Container(
            width: AppSizes.planetLarge,
            height: AppSizes.planetLarge,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isUnlocked
                  ? RadialGradient(
                      colors: [
                        color.withOpacity(0.8),
                        color,
                        color.withOpacity(0.6),
                      ],
                    )
                  : RadialGradient(
                      colors: [
                        AppColors.mediumGray.withOpacity(0.5),
                        AppColors.darkGray.withOpacity(0.3),
                      ],
                    ),
              border: Border.all(
                color: isUnlocked ? color : AppColors.mediumGray,
                width: 3,
              ),
            ),
            child: Center(
              child: isUnlocked
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Arabic name
                        Text(
                          nameArabic,
                          style: AppTextStyles.quranWord.copyWith(
                            color: AppColors.white,
                            fontSize: 32,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Progress indicator
                        if (isInProgress)
                          Text(
                            '$completedVerses/$totalVerses',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        // Completion checkmark
                        if (isCompleted)
                          const Icon(
                            Icons.check_circle,
                            color: AppColors.white,
                            size: 32,
                          ),
                      ],
                    )
                  : const Icon(
                      Icons.lock,
                      color: AppColors.white,
                      size: 40,
                    ),
            ),
          ),

          // Stars (if completed)
          if (isCompleted) ...[
            Positioned(
              top: 0,
              child: Icon(
                Icons.star,
                color: AppColors.star,
                size: AppSizes.starMedium,
              ),
            ),
            Positioned(
              left: 20,
              top: 20,
              child: Icon(
                Icons.star,
                color: AppColors.star,
                size: AppSizes.starMedium,
              ),
            ),
            Positioned(
              right: 20,
              top: 20,
              child: Icon(
                Icons.star,
                color: AppColors.star,
                size: AppSizes.starMedium,
              ),
            ),
          ],

          // Info card below planet
          Positioned(
            bottom: -80,
            child: OzzieCard(
              backgroundColor: AppColors.white.withOpacity(0.9),
              padding: const EdgeInsets.all(AppSizes.cardPadding),
              child: Column(
                children: [
                  Text(
                    nameEnglish,
                    style: AppTextStyles.headingSmall,
                  ),
                  Text(
                    nameMeaning,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$totalVerses verses',
                    style: AppTextStyles.caption,
                  ),
                  if (isInProgress) ...[
                    const SizedBox(height: 8),
                    SizedBox(
                      width: 120,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: AppColors.lightGray,
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                          minHeight: 6,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Dotted path connector between planets
  Widget _buildPathConnector() {
    return Column(
      children: List.generate(
        5,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Container(
            width: 3,
            height: 10,
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

  /// Coming soon message
  Widget _buildComingSoonMessage() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        border: Border.all(
          color: AppColors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.rocket_launch,
            color: AppColors.white.withOpacity(0.7),
            size: 20,
          ),
          const SizedBox(width: AppSizes.spaceSmall),
          Text(
            'More Surahs coming soon!',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  /// Show info dialog
  void _showMapInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.stars, color: AppColors.primary),
            const SizedBox(width: AppSizes.spaceSmall),
            const Text('How It Works'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoItem('🔒 Locked', 'Complete previous Surahs to unlock'),
            const SizedBox(height: AppSizes.spaceSmall),
            _buildInfoItem('✨ Glowing', 'Currently learning this Surah'),
            const SizedBox(height: AppSizes.spaceSmall),
            _buildInfoItem('⭐ Stars', 'Completed! Well done!'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String icon, String text) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: AppSizes.spaceSmall),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodyMedium,
          ),
        ),
      ],
    );
  }
}

