import 'package:flutter/material.dart';
import 'package:ozzie/core/constants/app_colors.dart';
import 'package:ozzie/core/constants/app_sizes.dart';
import 'package:ozzie/core/constants/app_text_styles.dart';
import 'package:ozzie/core/widgets/ozzie_placeholder.dart';
import 'package:ozzie/core/widgets/ozzie_card.dart';

/// 🎉 CELEBRATION STEP SCREEN (Step 6 of 6)
/// 
/// Celebrate completion with stars and encouragement!
/// 
/// WHAT THIS DOES:
/// - Shows "You Mastered Verse X!" message
/// - Displays stars earned (1-3)
/// - Animated confetti (simulated for now)
/// - Ozzie celebrates with you
/// - Encouraging message based on performance
/// - "Next" button to continue journey
/// 
/// This is the REWARD that makes kids want to keep learning!

class CelebrationStepScreen extends StatefulWidget {
  final int stars;
  final int surahNumber;
  final int verseNumber;

  const CelebrationStepScreen({
    super.key,
    required this.stars,
    required this.surahNumber,
    required this.verseNumber,
  });

  @override
  State<CelebrationStepScreen> createState() => _CelebrationStepScreenState();
}

class _CelebrationStepScreenState extends State<CelebrationStepScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    
    // Setup star animation
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Start animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Get encouraging message based on stars
  String get _encouragementMessage {
    switch (widget.stars) {
      case 3:
        return "Perfect! You're a Quran star! 🌟";
      case 2:
        return "Excellent work! Keep it up! 💪";
      case 1:
      default:
        return "Great job! You completed the verse! 🎉";
    }
  }

  /// Get detailed feedback
  String get _detailedMessage {
    switch (widget.stars) {
      case 3:
        return "You nailed the recitation, aced both quizzes, and showed amazing understanding! Ozzie is so proud of you! 🎊";
      case 2:
        return "You did really well! Your understanding is growing. Keep practicing and you'll get all 3 stars next time! 📚";
      case 1:
      default:
        return "You completed the verse! That's a huge achievement. Every step forward is progress! 💙";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSizes.spaceLarge),

          // Confetti effect (simulated)
          _buildConfettiEffect(),

          const SizedBox(height: AppSizes.spaceLarge),

          // Ozzie celebrating
          const AnimatedOzzie(
            size: OzzieSize.large,
            expression: OzzieExpression.celebrating,
          ),

          const SizedBox(height: AppSizes.spaceLarge),

          // "You Mastered Verse X!" message
          Text(
            'You Mastered\nVerse ${widget.verseNumber}!',
            style: AppTextStyles.headingLarge.copyWith(
              color: AppColors.primary,
              fontSize: 36,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSizes.spaceMedium),

          // Stars earned
          _buildStarsDisplay(),

          const SizedBox(height: AppSizes.spaceLarge),

          // Encouragement message
          OzzieCard(
            backgroundColor: AppColors.success.withOpacity(0.1),
            borderColor: AppColors.success.withOpacity(0.3),
            borderWidth: 2,
            child: Column(
              children: [
                Text(
                  _encouragementMessage,
                  style: AppTextStyles.headingSmall.copyWith(
                    color: AppColors.success,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSizes.spaceSmall),
                Text(
                  _detailedMessage,
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSizes.spaceLarge),

          // Stats summary
          _buildStatsCard(),

          const SizedBox(height: AppSizes.spaceLarge),

          // Next steps message
          OzzieInfoCard(
            message: 'Ready to learn the next verse? Keep your streak going! 🔥',
            icon: Icons.emoji_events,
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }

  /// Confetti effect (simple colored circles falling)
  Widget _buildConfettiEffect() {
    return SizedBox(
      height: 100,
      child: Stack(
        children: [
          // Scattered confetti pieces
          Positioned(top: 0, left: 30, child: _confettiPiece(AppColors.star)),
          Positioned(top: 20, right: 40, child: _confettiPiece(AppColors.primary)),
          Positioned(top: 10, left: 100, child: _confettiPiece(AppColors.secondary)),
          Positioned(top: 40, right: 100, child: _confettiPiece(AppColors.success)),
          Positioned(top: 5, left: 200, child: _confettiPiece(AppColors.info)),
          Positioned(top: 30, right: 200, child: _confettiPiece(AppColors.star)),
          Positioned(top: 60, left: 50, child: _confettiPiece(AppColors.primary)),
          Positioned(top: 70, right: 60, child: _confettiPiece(AppColors.secondary)),
        ],
      ),
    );
  }

  Widget _confettiPiece(Color color) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 2000),
      tween: Tween(begin: -50.0, end: 100.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, value),
          child: child,
        );
      },
      child: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  /// Stars display with animation
  Widget _buildStarsDisplay() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                final earned = index < widget.stars;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(
                    earned ? Icons.star : Icons.star_border,
                    size: 64,
                    color: earned ? AppColors.star : AppColors.mediumGray,
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }

  /// Stats summary card
  Widget _buildStatsCard() {
    return OzzieCard(
      backgroundColor: AppColors.white,
      child: Column(
        children: [
          Text(
            'Lesson Summary',
            style: AppTextStyles.headingSmall,
          ),
          const SizedBox(height: AppSizes.spaceMedium),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                icon: Icons.menu_book,
                label: 'Verse',
                value: '${widget.verseNumber}',
              ),
              _buildStatItem(
                icon: Icons.star,
                label: 'Stars',
                value: '${widget.stars}/3',
              ),
              _buildStatItem(
                icon: Icons.check_circle,
                label: 'Status',
                value: 'Complete',
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
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 28,
          ),
        ),
        const SizedBox(height: AppSizes.spaceSmall),
        Text(
          value,
          style: AppTextStyles.headingSmall.copyWith(
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
}
