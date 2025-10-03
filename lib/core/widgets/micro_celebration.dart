import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ozzie/core/constants/app_colors.dart';
import 'package:ozzie/core/constants/app_sizes.dart';
import 'package:ozzie/core/constants/app_text_styles.dart';

/// 🎉 MICRO CELEBRATION WIDGET
/// 
/// A quick, delightful celebration overlay that appears when completing a step.
/// Inspired by Duolingo's success feedback.
/// 
/// Features:
/// - Fade-in overlay
/// - Bouncing checkmark
/// - Small confetti particles
/// - Success message
/// - Auto-dismiss after 1 second
/// - Haptic feedback

class MicroCelebration extends StatefulWidget {
  final VoidCallback onComplete;
  final String message;
  
  const MicroCelebration({
    super.key,
    required this.onComplete,
    this.message = 'Perfect! ✨',
  });

  @override
  State<MicroCelebration> createState() => _MicroCelebrationState();
  
  /// Show the micro celebration as an overlay
  static void show(BuildContext context, {VoidCallback? onComplete, String? message}) {
    // Haptic feedback
    HapticFeedback.heavyImpact();
    
    // Show overlay
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (context) => MicroCelebration(
        onComplete: () {
          Navigator.of(context).pop();
          onComplete?.call();
        },
        message: message ?? 'Perfect! ✨',
      ),
    );
  }
}

class _MicroCelebrationState extends State<MicroCelebration> 
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _checkController;
  late AnimationController _confettiController;
  
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _confettiAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startCelebration();
  }

  void _setupAnimations() {
    // Fade in overlay
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    // Checkmark bounce
    _checkController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _checkController, curve: Curves.elasticOut),
    );

    // Confetti burst
    _confettiController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _confettiAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _confettiController, curve: Curves.easeOut),
    );
  }

  void _startCelebration() async {
    // Start animations in sequence
    await _fadeController.forward();
    _checkController.forward();
    _confettiController.forward();
    
    // Auto-dismiss after 1 second
    await Future.delayed(const Duration(milliseconds: 1000));
    
    // Fade out
    await _fadeController.reverse();
    
    if (mounted) {
      widget.onComplete();
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _checkController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        color: Colors.black.withOpacity(0.3),
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Confetti particles
              ..._buildConfetti(),
              
              // Main celebration card
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  padding: const EdgeInsets.all(AppSizes.spaceLarge),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Success checkmark
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.success.withOpacity(0.3),
                              blurRadius: 15,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                      
                      const SizedBox(height: AppSizes.spaceMedium),
                      
                      // Success message
                      Text(
                        widget.message,
                        style: AppTextStyles.headingMedium.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build confetti particles
  List<Widget> _buildConfetti() {
    final colors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.success,
      AppColors.warning,
      AppColors.info,
      AppColors.star,
    ];
    
    return List.generate(12, (index) {
      final angle = (index * 30.0) * (3.14159 / 180); // Convert to radians
      final distance = 100.0 + (index % 3) * 20.0;
      
      return AnimatedBuilder(
        animation: _confettiAnimation,
        builder: (context, child) {
          final progress = _confettiAnimation.value;
          final x = distance * progress * (index.isEven ? 1 : -1) * (index % 2 == 0 ? 1.2 : 0.8);
          final y = distance * progress * (index < 6 ? -1 : 1) * (index % 3 == 0 ? 1.1 : 0.9);
          
          return Transform.translate(
            offset: Offset(x, y),
            child: Opacity(
              opacity: 1.0 - progress,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: colors[index % colors.length],
                  shape: BoxShape.circle,
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
