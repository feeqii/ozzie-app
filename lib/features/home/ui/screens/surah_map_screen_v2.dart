import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ozzie/core/constants/app_colors.dart';
import 'package:ozzie/core/constants/app_sizes.dart';
import 'package:ozzie/core/constants/app_text_styles.dart';
import 'package:ozzie/core/widgets/ozzie_card.dart';
import 'package:ozzie/features/lesson/logic/progress_controller.dart';

/// 🪐 SURAH MAP SCREEN (REDESIGNED)
/// 
/// Beautiful, clean cosmic quest with planets from bottom to top
/// Info section at bottom for clear progress display

class SurahMapScreenV2 extends ConsumerWidget {
  const SurahMapScreenV2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressState = ref.watch(progressControllerProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1a1a2e), // Dark blue
              Color(0xFF0f0f1e), // Darker blue
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(context),
              
              // Planet map (scrollable)
              Expanded(
                child: progressState.when(
                  data: (progress) => _buildPlanetMap(context, ref, progress),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(child: Text('Error: $err')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.screenPadding),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
          ),
          Expanded(
            child: Column(
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
          IconButton(
            onPressed: () {
              // TODO: Show help/info
            },
            icon: const Icon(Icons.info_outline, color: AppColors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanetMap(BuildContext context, WidgetRef ref, userProgress) {
    // Get progress
    final fatihaProgress = userProgress.surahProgress[1];
    final ikhlasProgress = userProgress.surahProgress[112];
    
    final fatihaCompleted = fatihaProgress?.versesCompleted.length ?? 0;
    final fatihaStars = fatihaProgress?.verseStars.values.fold(0, (sum, stars) => sum + stars) ?? 0;
    final isFatihaCompleted = fatihaProgress?.isCompleted ?? false;
    
    final ikhlasCompleted = ikhlasProgress?.versesCompleted.length ?? 0;
    final ikhlasStars = ikhlasProgress?.verseStars.values.fold(0, (sum, stars) => sum + stars) ?? 0;

    // Determine which Surah is active/current
    final currentSurah = isFatihaCompleted ? 112 : 1;
    
    return Column(
      children: [
        // Planet area (scrollable)
        Expanded(
          child: SingleChildScrollView(
            reverse: true, // Start from bottom
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(height: 100), // Top spacing
                  
                  // Al-Ikhlas (TOP - Locked initially)
                  _buildPlanet(
                    context,
                    ref: ref,
                    nameArabic: 'الإخلاص',
                    nameEnglish: 'Al-Ikhlas',
                    surahNumber: 112,
                    isUnlocked: isFatihaCompleted,
                    isCompleted: ikhlasProgress?.isCompleted ?? false,
                    isActive: currentSurah == 112,
                    color: AppColors.secondary,
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Path connector
                  _buildPathConnector(),
                  
                  const SizedBox(height: 40),
                  
                  // Al-Fatiha (BOTTOM - Always unlocked)
                  _buildPlanet(
                    context,
                    ref: ref,
                    nameArabic: 'الفاتحة',
                    nameEnglish: 'Al-Fatiha',
                    surahNumber: 1,
                    isUnlocked: true,
                    isCompleted: isFatihaCompleted,
                    isActive: currentSurah == 1,
                    color: AppColors.primary,
                  ),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
        
        // Info section at bottom
        _buildInfoSection(
          context,
          ref: ref,
          currentSurah: currentSurah,
          fatihaCompleted: fatihaCompleted,
          fatihaStars: fatihaStars,
          isFatihaCompleted: isFatihaCompleted,
          ikhlasCompleted: ikhlasCompleted,
          ikhlasStars: ikhlasStars,
        ),
      ],
    );
  }

  Widget _buildPlanet(
    BuildContext context, {
    required WidgetRef ref,
    required String nameArabic,
    required String nameEnglish,
    required int surahNumber,
    required bool isUnlocked,
    required bool isCompleted,
    required bool isActive,
    required Color color,
  }) {
    final size = isActive ? 200.0 : 140.0;
    
    return GestureDetector(
      onTap: isUnlocked
          ? () => context.push('/surah/$surahNumber/trail')
          : null,
      child: Column(
        children: [
          // Planet
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isUnlocked
                  ? RadialGradient(
                      colors: [
                        color.withOpacity(0.8),
                        color.withOpacity(0.4),
                      ],
                    )
                  : RadialGradient(
                      colors: [
                        AppColors.lightGray.withOpacity(0.3),
                        AppColors.lightGray.withOpacity(0.1),
                      ],
                    ),
              boxShadow: isActive && isUnlocked
                  ? [
                      BoxShadow(
                        color: color.withOpacity(0.5),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ]
                  : [],
            ),
            child: Center(
              child: !isUnlocked
                  ? const Icon(Icons.lock, color: AppColors.white, size: 40)
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          nameArabic,
                          style: AppTextStyles.arabicMedium.copyWith(
                            color: AppColors.white,
                            fontSize: isActive ? 28 : 24,
                          ),
                        ),
                        if (isCompleted)
                          const Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Icon(
                              Icons.check_circle,
                              color: AppColors.white,
                              size: 32,
                            ),
                          ),
                      ],
                    ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Name below
          Text(
            nameEnglish,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isUnlocked ? AppColors.white : AppColors.white.withOpacity(0.4),
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPathConnector() {
    return SizedBox(
      height: 60,
      child: Column(
        children: List.generate(
          6,
          (index) => Container(
            margin: const EdgeInsets.symmetric(vertical: 2),
            width: 3,
            height: 6,
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(
    BuildContext context, {
    required WidgetRef ref,
    required int currentSurah,
    required int fatihaCompleted,
    required int fatihaStars,
    required bool isFatihaCompleted,
    required int ikhlasCompleted,
    required int ikhlasStars,
  }) {
    final isAlFatiha = currentSurah == 1;
    final surahName = isAlFatiha ? 'Al-Fatiha' : 'Al-Ikhlas';
    final surahMeaning = isAlFatiha ? 'The Opening' : 'The Sincerity';
    final completed = isAlFatiha ? fatihaCompleted : ikhlasCompleted;
    final total = isAlFatiha ? 7 : 4;
    final stars = isAlFatiha ? fatihaStars : ikhlasStars;
    
    return Container(
      margin: const EdgeInsets.all(AppSizes.screenPadding),
      child: OzzieCard(
        backgroundColor: AppColors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      surahName,
                      style: AppTextStyles.headingMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      surahMeaning,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                if (completed > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: AppColors.warning,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$stars',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            
            const SizedBox(height: AppSizes.spaceMedium),
            
            Row(
              children: [
                Icon(
                  Icons.menu_book,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  '$completed of $total verses completed',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppSizes.spaceMedium),
            
            ElevatedButton(
              onPressed: () => context.push('/surah/$currentSurah/trail'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Continue Learning',
                    style: AppTextStyles.button.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, color: AppColors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

