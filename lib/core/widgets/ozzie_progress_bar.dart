import 'package:flutter/material.dart';
import 'package:ozzie/core/constants/app_colors.dart';
import 'package:ozzie/core/constants/app_sizes.dart';
import 'package:ozzie/core/constants/app_text_styles.dart';

/// 📊 OZZIE PROGRESS BAR
/// 
/// Shows progress visually with a colorful bar!
/// 
/// WHAT IS THIS?
/// A horizontal bar that fills up as you make progress.
/// Like a loading bar, but for learning progress!
/// 
/// WHY?
/// - Visual feedback (kids see their progress!)
/// - Motivating (watch the bar fill up!)
/// - Shows percentage or fraction (3/7 verses done)
/// 
/// HOW TO USE:
/// ```dart
/// OzzieProgressBar(
///   current: 3,
///   total: 7,
///   label: 'Verses Completed',
/// )
/// ```

class OzzieProgressBar extends StatelessWidget {
  /// Current progress value
  final int current;
  
  /// Total/maximum value
  final int total;
  
  /// Optional label to show above the bar
  final String? label;
  
  /// Show percentage text? (e.g., "43%")
  final bool showPercentage;
  
  /// Show fraction text? (e.g., "3/7")
  final bool showFraction;
  
  /// Height of the progress bar
  final double? height;
  
  /// Color of the progress bar
  final Color? color;
  
  /// Background color
  final Color? backgroundColor;
  
  /// Animate the progress?
  final bool animated;

  const OzzieProgressBar({
    super.key,
    required this.current,
    required this.total,
    this.label,
    this.showPercentage = false,
    this.showFraction = true,
    this.height,
    this.color,
    this.backgroundColor,
    this.animated = true,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate progress (0.0 to 1.0)
    final double progress = total > 0 ? current / total : 0.0;
    final int percentage = (progress * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label (if provided)
        if (label != null) ...[
          Text(
            label!,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSizes.spaceXTiny),
        ],

        // Progress bar with text
        Row(
          children: [
            // The actual progress bar
            Expanded(
              child: SizedBox(
                height: height ?? AppSizes.progressBarHeight,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Stack(
                    children: [
                      // Background
                      Container(
                        color: backgroundColor ?? AppColors.lightGray,
                      ),
                      
                      // Progress fill (animated)
                      if (animated)
                        TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.easeOutCubic,
                          tween: Tween<double>(begin: 0, end: progress),
                          builder: (context, value, child) {
                            return FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: value,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      color ?? AppColors.primary,
                                      (color ?? AppColors.primary).withOpacity(0.8),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      else
                        FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: progress,
                          child: Container(
                            color: color ?? AppColors.primary,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Percentage or fraction text
            if (showPercentage || showFraction) ...[
              const SizedBox(width: AppSizes.spaceSmall),
              Text(
                showPercentage ? '$percentage%' : '$current/$total',
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

/// 🌟 CIRCULAR PROGRESS (for achievements, scores)
/// 
/// Shows progress in a circle (like a pie chart)
/// 
/// HOW TO USE:
/// ```dart
/// OzzieCircularProgress(
///   current: 85,
///   total: 100,
///   label: 'Score',
/// )
/// ```
class OzzieCircularProgress extends StatelessWidget {
  /// Current value
  final int current;
  
  /// Total/maximum value
  final int total;
  
  /// Size of the circle
  final double size;
  
  /// Thickness of the progress ring
  final double strokeWidth;
  
  /// Color of the progress
  final Color? color;
  
  /// Background color
  final Color? backgroundColor;
  
  /// Text to show in the center
  final String? centerText;
  
  /// Optional label below
  final String? label;

  const OzzieCircularProgress({
    super.key,
    required this.current,
    required this.total,
    this.size = 100,
    this.strokeWidth = 8,
    this.color,
    this.backgroundColor,
    this.centerText,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = total > 0 ? current / total : 0.0;
    final int percentage = (progress * 100).round();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Circular progress
        SizedBox(
          width: size,
          height: size,
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeOutCubic,
            tween: Tween<double>(begin: 0, end: progress),
            builder: (context, value, child) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  // Progress circle
                  CircularProgressIndicator(
                    value: value,
                    strokeWidth: strokeWidth,
                    backgroundColor: backgroundColor ?? AppColors.lightGray,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      color ?? AppColors.primary,
                    ),
                  ),
                  
                  // Center text (percentage or custom text)
                  Center(
                    child: Text(
                      centerText ?? '$percentage%',
                      style: AppTextStyles.headingMedium.copyWith(
                        fontSize: size * 0.25,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        
        // Label (if provided)
        if (label != null) ...[
          const SizedBox(height: AppSizes.spaceSmall),
          Text(
            label!,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

/// ⭐ STAR RATING (for verse completion)
/// 
/// Shows 1-3 stars based on performance
/// 
/// HOW TO USE:
/// ```dart
/// OzzieStarRating(
///   stars: 3, // 1, 2, or 3
/// )
/// ```
class OzzieStarRating extends StatelessWidget {
  /// Number of stars earned (1-3)
  final int stars;
  
  /// Size of each star
  final double size;
  
  /// Show the stars animated?
  final bool animated;

  const OzzieStarRating({
    super.key,
    required this.stars,
    this.size = AppSizes.starMedium,
    this.animated = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        final bool isEarned = index < stars;
        
        Widget star = Icon(
          isEarned ? Icons.star : Icons.star_border,
          size: size,
          color: isEarned ? AppColors.star : AppColors.mediumGray,
        );

        // Animate stars appearing one by one
        if (animated && isEarned) {
          star = TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 300 + (index * 150)),
            curve: Curves.elasticOut,
            tween: Tween<double>(begin: 0, end: 1),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: child,
              );
            },
            child: star,
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: star,
        );
      }),
    );
  }
}

