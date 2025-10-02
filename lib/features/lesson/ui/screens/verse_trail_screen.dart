import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ozzie/core/constants/app_colors.dart';
import 'package:ozzie/core/constants/app_sizes.dart';
import 'package:ozzie/core/constants/app_text_styles.dart';
import 'package:ozzie/core/widgets/ozzie_card.dart';
import 'package:ozzie/features/lesson/data/models/surah_model.dart';
import 'package:ozzie/features/lesson/data/models/user_progress_model.dart';
import 'package:ozzie/features/lesson/logic/progress_controller.dart';
import 'package:ozzie/services/quran_data_service.dart';

/// 🗺️ VERSE TRAIL SCREEN
/// 
/// Vertical trail showing all verses in a Surah.
/// Think of it like levels in a game!
/// 
/// WHAT THIS DOES:
/// - Shows all verses in the Surah
/// - Displays progress (stars, completion)
/// - Locks/unlocks verses sequentially
/// - Navigates to lesson when verse is tapped
/// 
/// DESIGN:
/// - Vertical scrolling trail
/// - Bottom verse = unlocked (accessible)
/// - Top verses = locked (greyed out)
/// - Each verse card shows: number, preview text, stars earned

class VerseTrailScreen extends ConsumerStatefulWidget {
  final int surahNumber;

  const VerseTrailScreen({
    super.key,
    required this.surahNumber,
  });

  @override
  ConsumerState<VerseTrailScreen> createState() => _VerseTrailScreenState();
}

class _VerseTrailScreenState extends ConsumerState<VerseTrailScreen> {
  Surah? surah;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadSurah();
  }

  Future<void> _loadSurah() async {
    try {
      final quranService = QuranDataService();
      final loadedSurah = await quranService.loadSurah(widget.surahNumber);
      
      setState(() {
        surah = loadedSurah;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Loading...'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (error != null || surah == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: Center(
          child: Text('Error loading Surah: $error'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              surah!.nameEnglish,
              style: AppTextStyles.headingMedium,
            ),
            Text(
              surah!.nameMeaning,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: _buildVerseTrail(),
    );
  }

  Widget _buildVerseTrail() {
    final progressState = ref.watch(progressControllerProvider);

    return progressState.when(
      data: (userProgress) {
        final surahProgress = userProgress.surahProgress[widget.surahNumber];
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Surah description
              OzzieCard(
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Column(
                  children: [
                    Text(
                      surah!.nameArabic,
                      style: AppTextStyles.arabicLarge.copyWith(
                        fontSize: 32,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: AppSizes.spaceSmall),
                    Text(
                      surah!.description ?? '',
                      style: AppTextStyles.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSizes.spaceMedium),
                    // Progress summary
                    _buildProgressSummary(surahProgress),
                  ],
                ),
              ),

              const SizedBox(height: AppSizes.spaceLarge),

              // Verse trail (reversed so first verse is at top)
              ...List.generate(surah!.verses.length, (index) {
                final verseNumber = index + 1;
                final verse = surah!.verses[index];
                
                // Check if verse is completed
                final isCompleted = surahProgress?.versesCompleted.contains(verseNumber) ?? false;
                
                // Check if verse is unlocked
                // Sequential unlock: verse N is unlocked if verse N-1 is completed
                final isUnlocked = verseNumber == 1 || 
                    (surahProgress?.versesCompleted.contains(verseNumber - 1) ?? false);
                
                // Get stars for this verse
                final stars = surahProgress?.verseStars[verseNumber] ?? 0;
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSizes.spaceMedium),
                  child: _buildVerseCard(
                    verseNumber: verseNumber,
                    arabicText: verse.arabicText,
                    transliteration: verse.transliteration,
                    isCompleted: isCompleted,
                    isUnlocked: isUnlocked,
                    stars: stars,
                  ),
                );
              }),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }

  Widget _buildProgressSummary(SurahProgress? surahProgress) {
    final versesCompleted = surahProgress?.versesCompleted.length ?? 0;
    final totalVerses = surah!.totalVerses;
    final totalStars = surahProgress?.verseStars.values.fold(0, (sum, stars) => sum + stars) ?? 0;
    final maxStars = totalVerses * 3; // 3 stars per verse

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem(
          icon: Icons.menu_book,
          label: 'Verses',
          value: '$versesCompleted/$totalVerses',
        ),
        _buildStatItem(
          icon: Icons.star,
          label: 'Stars',
          value: '$totalStars/$maxStars',
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 32),
        const SizedBox(height: AppSizes.spaceSmall),
        Text(
          value,
          style: AppTextStyles.headingMedium.copyWith(
            color: AppColors.primary,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildVerseCard({
    required int verseNumber,
    required String arabicText,
    required String transliteration,
    required bool isCompleted,
    required bool isUnlocked,
    required int stars,
  }) {
    return GestureDetector(
      onTap: isUnlocked
          ? () {
              // Navigate to lesson
              context.push('/lesson/${widget.surahNumber}/$verseNumber');
            }
          : null,
      child: Opacity(
        opacity: isUnlocked ? 1.0 : 0.5,
        child: OzzieCard(
          backgroundColor: isCompleted
              ? AppColors.success.withOpacity(0.1)
              : isUnlocked
                  ? AppColors.white
                  : AppColors.lightGray.withOpacity(0.3),
          borderColor: isCompleted
              ? AppColors.success
              : isUnlocked
                  ? AppColors.primary.withOpacity(0.3)
                  : AppColors.lightGray,
          borderWidth: isCompleted ? 3 : 2,
          child: Row(
            children: [
              // Verse number circle
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted
                      ? AppColors.success
                      : isUnlocked
                          ? AppColors.primary
                          : AppColors.lightGray,
                ),
                child: Center(
                  child: isCompleted
                      ? const Icon(
                          Icons.check,
                          color: AppColors.white,
                          size: 32,
                        )
                      : Text(
                          '$verseNumber',
                          style: AppTextStyles.headingMedium.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                ),
              ),

              const SizedBox(width: AppSizes.spaceMedium),

              // Verse preview
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Verse $verseNumber',
                      style: AppTextStyles.headingSmall.copyWith(
                        color: isUnlocked ? AppColors.textPrimary : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSizes.spaceSmall),
                    Text(
                      arabicText.length > 40 
                          ? '${arabicText.substring(0, 40)}...' 
                          : arabicText,
                      style: AppTextStyles.arabicMedium.copyWith(
                        color: isUnlocked ? AppColors.textPrimary : AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (isCompleted) ...[
                      const SizedBox(height: AppSizes.spaceSmall),
                      Row(
                        children: List.generate(3, (index) {
                          final isFilled = index < stars;
                          return Icon(
                            isFilled ? Icons.star : Icons.star_border,
                            color: isFilled ? AppColors.warning : AppColors.lightGray,
                            size: 20,
                          );
                        }),
                      ),
                    ],
                  ],
                ),
              ),

              // Lock icon or arrow
              Icon(
                isUnlocked ? Icons.arrow_forward_ios : Icons.lock,
                color: isUnlocked ? AppColors.primary : AppColors.lightGray,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

