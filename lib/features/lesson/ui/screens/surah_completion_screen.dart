import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ozzie/core/constants/app_colors.dart';
import 'package:ozzie/core/constants/app_sizes.dart';
import 'package:ozzie/core/constants/app_text_styles.dart';
import 'package:ozzie/core/widgets/ozzie_placeholder.dart';
import 'package:ozzie/core/widgets/ozzie_card.dart';
import 'package:ozzie/features/lesson/logic/progress_controller.dart';

/// 🎊 SURAH COMPLETION SCREEN
/// 
/// SPECIAL celebration when ALL verses of a Surah are completed!
/// 
/// WHAT THIS DOES:
/// - Shows "You Completed [Surah Name]!" message
/// - Displays total stars earned across all verses
/// - Shows special badge/trophy
/// - Extra confetti and celebration
/// - Ozzie is SUPER proud!
/// - Navigation back to Surah Map
/// 
/// This is the BIG REWARD that makes kids feel accomplished!

class SurahCompletionScreen extends ConsumerStatefulWidget {
  final int surahNumber;
  final String surahName;
  final int totalStars;

  const SurahCompletionScreen({
    super.key,
    required this.surahNumber,
    required this.surahName,
    required this.totalStars,
  });

  @override
  ConsumerState<SurahCompletionScreen> createState() => _SurahCompletionScreenState();
}

class _SurahCompletionScreenState extends ConsumerState<SurahCompletionScreen>
    with TickerProviderStateMixin {
  late AnimationController _starAnimationController;
  late AnimationController _trophyAnimationController;
  late Animation<double> _starScaleAnimation;
  late Animation<double> _trophyBounceAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    
    // Setup star animation (pop in)
    _starAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _starScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _starAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    // Setup trophy animation (bounce)
    _trophyAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _trophyBounceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _trophyAnimationController,
        curve: Curves.bounceOut,
      ),
    );

    _glowAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _trophyAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // Start animations
    _starAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _trophyAnimationController.forward();
    });

    // Loop glow animation
    _trophyAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _trophyAnimationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _trophyAnimationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _starAnimationController.dispose();
    _trophyAnimationController.dispose();
    super.dispose();
  }

  /// Get celebration message based on stars
  String get _celebrationMessage {
    final maxStars = 21; // 7 verses × 3 stars
    final percentage = (widget.totalStars / maxStars * 100).round();
    
    if (percentage >= 90) {
      return "INCREDIBLE! You're a Quran Champion! 🏆";
    } else if (percentage >= 70) {
      return "AMAZING! You mastered Al-Fatiha! 🌟";
    } else {
      return "FANTASTIC! You completed Al-Fatiha! 🎉";
    }
  }

  String get _detailedMessage {
    final maxStars = 21;
    final percentage = (widget.totalStars / maxStars * 100).round();
    
    if (percentage >= 90) {
      return "You've achieved excellence! You mastered all 7 verses with incredible skill. The Quran is becoming part of your heart! Keep this amazing journey going! 💫";
    } else if (percentage >= 70) {
      return "What an accomplishment! You've learned all 7 verses of Al-Fatiha with great understanding. You're building such a beautiful connection with the Quran! 📚✨";
    } else {
      return "You did it! All 7 verses of Al-Fatiha are now yours! This is just the beginning of your Quran journey. Every verse you learn is a treasure! 💙";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSizes.spaceLarge),

              // Extra special confetti effect
              _buildConfettiEffect(),

              const SizedBox(height: AppSizes.spaceMedium),

              // Trophy/Badge display
              _buildTrophyDisplay(),

              const SizedBox(height: AppSizes.spaceLarge),

              // Ozzie celebrating (extra excited!)
              const AnimatedOzzie(
                size: OzzieSize.large,
                expression: OzzieExpression.celebrating,
              ),

              const SizedBox(height: AppSizes.spaceLarge),

              // "You Completed Al-Fatiha!" message
              Text(
                '🎊 SURAH COMPLETE! 🎊',
                style: AppTextStyles.headingLarge.copyWith(
                  color: AppColors.primary,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSizes.spaceSmall),

              Text(
                widget.surahName,
                style: AppTextStyles.headingLarge.copyWith(
                  color: AppColors.secondary,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSizes.spaceLarge),

              // Total stars display
              _buildTotalStarsDisplay(),

              const SizedBox(height: AppSizes.spaceLarge),

              // Celebration message
              OzzieCard(
                backgroundColor: AppColors.success.withOpacity(0.15),
                borderColor: AppColors.success.withOpacity(0.4),
                borderWidth: 3,
                child: Column(
                  children: [
                    Text(
                      _celebrationMessage,
                      style: AppTextStyles.headingMedium.copyWith(
                        color: AppColors.success,
                        fontSize: 24,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSizes.spaceMedium),
                    Text(
                      _detailedMessage,
                      style: AppTextStyles.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSizes.spaceLarge),

              // Achievement summary
              _buildAchievementSummary(),

              const SizedBox(height: AppSizes.spaceLarge),

              // Special message
              OzzieInfoCard(
                message: 'Al-Fatiha is called "The Greatest Surah in the Quran" and you just mastered it! You recite it in every prayer - now you know what it means! 🌟',
                icon: Icons.lightbulb,
                color: AppColors.primary,
              ),

              const SizedBox(height: AppSizes.spaceLarge),

              // Action buttons
              _buildActionButtons(context),

              const SizedBox(height: AppSizes.spaceLarge),
            ],
          ),
        ),
      ),
    );
  }

  /// Enhanced confetti effect
  Widget _buildConfettiEffect() {
    return SizedBox(
      height: 120,
      child: Stack(
        children: [
          // More confetti pieces for bigger celebration!
          Positioned(top: 0, left: 30, child: _confettiPiece(AppColors.star, delay: 0)),
          Positioned(top: 20, right: 40, child: _confettiPiece(AppColors.primary, delay: 100)),
          Positioned(top: 10, left: 100, child: _confettiPiece(AppColors.secondary, delay: 200)),
          Positioned(top: 40, right: 100, child: _confettiPiece(AppColors.success, delay: 300)),
          Positioned(top: 5, left: 200, child: _confettiPiece(AppColors.info, delay: 150)),
          Positioned(top: 30, right: 200, child: _confettiPiece(AppColors.star, delay: 250)),
          Positioned(top: 60, left: 50, child: _confettiPiece(AppColors.primary, delay: 350)),
          Positioned(top: 70, right: 60, child: _confettiPiece(AppColors.secondary, delay: 50)),
          Positioned(top: 15, left: 150, child: _confettiPiece(AppColors.star, delay: 400)),
          Positioned(top: 50, right: 150, child: _confettiPiece(AppColors.success, delay: 175)),
          Positioned(top: 80, left: 80, child: _confettiPiece(AppColors.info, delay: 275)),
          Positioned(top: 90, right: 120, child: _confettiPiece(AppColors.primary, delay: 375)),
        ],
      ),
    );
  }

  Widget _confettiPiece(Color color, {int delay = 0}) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 2000 + delay),
      tween: Tween(begin: -80.0, end: 120.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, value),
          child: child,
        );
      },
      child: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  /// Trophy/Badge display with animation
  Widget _buildTrophyDisplay() {
    return AnimatedBuilder(
      animation: _trophyAnimationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _trophyBounceAnimation.value,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.star.withOpacity(0.3 * _glowAnimation.value),
                  AppColors.star.withOpacity(0.0),
                ],
              ),
            ),
            child: Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.star,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.star.withOpacity(0.4),
                      blurRadius: 20 * _glowAnimation.value,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.emoji_events,
                  size: 60,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Total stars display
  Widget _buildTotalStarsDisplay() {
    return AnimatedBuilder(
      animation: _starAnimationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _starScaleAnimation.value,
          child: OzzieCard(
            backgroundColor: AppColors.white,
            borderColor: AppColors.star.withOpacity(0.3),
            borderWidth: 2,
            child: Column(
              children: [
                const Icon(
                  Icons.star,
                  size: 48,
                  color: AppColors.star,
                ),
                const SizedBox(height: AppSizes.spaceSmall),
                Text(
                  '${widget.totalStars} / 21',
                  style: AppTextStyles.headingLarge.copyWith(
                    color: AppColors.star,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Total Stars Earned',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Achievement summary
  Widget _buildAchievementSummary() {
    final surahProgress = ref.watch(surahProgressProvider(widget.surahNumber));
    final versesCompleted = surahProgress?.versesCompleted.length ?? 7;

    return OzzieCard(
      backgroundColor: AppColors.white,
      child: Column(
        children: [
          Text(
            'Your Achievement',
            style: AppTextStyles.headingSmall.copyWith(
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSizes.spaceMedium),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                icon: Icons.check_circle,
                label: 'Verses',
                value: '$versesCompleted/7',
                color: AppColors.success,
              ),
              _buildStatItem(
                icon: Icons.star,
                label: 'Stars',
                value: '${widget.totalStars}',
                color: AppColors.star,
              ),
              _buildStatItem(
                icon: Icons.emoji_events,
                label: 'Status',
                value: 'Complete!',
                color: AppColors.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 28,
          ),
        ),
        const SizedBox(height: AppSizes.spaceSmall),
        Text(
          value,
          style: AppTextStyles.headingSmall.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
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

  /// Action buttons
  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // Return to Surah Map button
        ElevatedButton.icon(
          onPressed: () {
            context.go('/surah-map');
          },
          icon: const Icon(Icons.map),
          label: const Text('View Surah Map'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spaceLarge,
              vertical: AppSizes.spaceMedium,
            ),
            minimumSize: const Size(double.infinity, 56),
          ),
        ),
        const SizedBox(height: AppSizes.spaceMedium),
        // Return home button
        OutlinedButton.icon(
          onPressed: () {
            context.go('/');
          },
          icon: const Icon(Icons.home),
          label: const Text('Return Home'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spaceLarge,
              vertical: AppSizes.spaceMedium,
            ),
            minimumSize: const Size(double.infinity, 56),
          ),
        ),
      ],
    );
  }
}

