import 'package:flutter/material.dart';
import 'package:ozzie/core/constants/app_colors.dart';
import 'package:ozzie/core/constants/app_sizes.dart';
import 'package:ozzie/core/constants/app_text_styles.dart';
import 'package:ozzie/core/widgets/ozzie_card.dart';
import 'package:ozzie/features/lesson/data/models/verse_model.dart';

/// 📖 EXPLANATION STEP SCREEN (Step 1 of 6)
/// 
/// Child-friendly explanation with visuals!
/// 
/// WHAT THIS SCREEN DOES:
/// - Shows the Arabic verse text (beautiful!)
/// - Shows transliteration (how to pronounce)
/// - Shows English translation
/// - Shows kid-friendly explanation
/// - Audio button to listen to narration
/// 
/// This is the FIRST step where kids learn what the verse means!

class ExplanationStepScreen extends StatelessWidget {
  final Verse verse;

  const ExplanationStepScreen({
    super.key,
    required this.verse,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Title
          Text(
            'In the name of Allah, the Entirely Merciful, the Especially Merciful.',
            style: AppTextStyles.headingSmall.copyWith(
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSizes.spaceLarge),

          // Arabic Text Card
          OzzieCard(
            backgroundColor: AppColors.white,
            child: Column(
              children: [
                // Arabic verse
                Text(
                  verse.arabicText,
                  style: AppTextStyles.quranVerse.copyWith(
                    fontSize: 32,
                  ),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ),

                const SizedBox(height: AppSizes.spaceMedium),

                // Transliteration
                Text(
                  verse.transliteration,
                  style: AppTextStyles.transliteration,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppSizes.spaceSmall),

                // English translation
                Text(
                  verse.translation,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSizes.spaceLarge),

          // Explanation Section
          _buildExplanationCard(),

          const SizedBox(height: AppSizes.spaceLarge),

          // Audio button (for narration)
          _buildAudioButton(),

          const SizedBox(height: AppSizes.spaceXLarge),

          // Helpful tip
          OzzieInfoCard(
            message: 'Take your time to understand the meaning before moving forward! 📖',
            icon: Icons.lightbulb,
            color: AppColors.info,
          ),
        ],
      ),
    );
  }

  /// Explanation card with kid-friendly content
  Widget _buildExplanationCard() {
    return OzzieCard(
      backgroundColor: AppColors.primary.withOpacity(0.05),
      borderColor: AppColors.primary.withOpacity(0.2),
      borderWidth: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.auto_stories,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSizes.spaceSmall),
              Text(
                'What does this mean?',
                style: AppTextStyles.headingSmall.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSizes.spaceMedium),

          // The actual explanation
          Text(
            verse.explanationForKids,
            style: AppTextStyles.bodyLarge.copyWith(
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  /// Audio button to listen to narration
  Widget _buildAudioButton() {
    return ElevatedButton.icon(
      onPressed: () {
        // TODO: Play narration of the explanation
        // For now, just a placeholder
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.cardPadding,
          vertical: AppSizes.spaceMedium,
        ),
      ),
      icon: const Icon(Icons.volume_up, size: 28),
      label: Text(
        'Listen to Explanation',
        style: AppTextStyles.button.copyWith(fontSize: 16),
      ),
    );
  }
}

