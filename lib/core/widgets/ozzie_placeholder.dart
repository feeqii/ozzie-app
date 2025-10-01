import 'package:flutter/material.dart';
import 'package:ozzie/core/constants/app_colors.dart';
import 'package:ozzie/core/constants/app_sizes.dart';
import 'package:ozzie/core/constants/app_text_styles.dart';

/// 🎭 OZZIE PLACEHOLDER
/// 
/// A cute placeholder for the Ozzie mascot!
/// 
/// WHAT IS THIS?
/// Until we have the real Ozzie mascot designed, this shows
/// a friendly circular avatar with "Ozzie" written on it.
/// Later, we'll replace this with actual Rive animations!
/// 
/// WHY?
/// - Placeholder for mascot in the app
/// - Shows where Ozzie will appear
/// - Looks friendly and professional even without real design
/// 
/// HOW TO USE:
/// ```dart
/// OzziePlaceholder(
///   size: OzzieSize.medium,
/// )
/// ```
/// 
/// Or with a message bubble:
/// ```dart
/// OzziePlaceholder(
///   size: OzzieSize.large,
///   message: 'Great job!',
/// )
/// ```

enum OzzieSize {
  /// Tiny Ozzie - 40px
  tiny,
  
  /// Small Ozzie - 60px
  small,
  
  /// Medium Ozzie - 120px (default)
  medium,
  
  /// Large Ozzie - 200px (for celebrations!)
  large,
}

enum OzzieExpression {
  /// Happy Ozzie - default
  happy,
  
  /// Excited Ozzie - for achievements
  excited,
  
  /// Thinking Ozzie - for questions/hints
  thinking,
  
  /// Celebrating Ozzie - for success
  celebrating,
}

class OzziePlaceholder extends StatelessWidget {
  /// Size of Ozzie
  final OzzieSize size;
  
  /// Ozzie's expression
  final OzzieExpression expression;
  
  /// Optional message from Ozzie (shown in speech bubble)
  final String? message;
  
  /// Should Ozzie have a subtle bounce animation?
  final bool animated;

  const OzziePlaceholder({
    super.key,
    this.size = OzzieSize.medium,
    this.expression = OzzieExpression.happy,
    this.message,
    this.animated = false,
  });

  @override
  Widget build(BuildContext context) {
    // Get size in pixels
    final double sizeInPixels = switch (size) {
      OzzieSize.tiny => 40,
      OzzieSize.small => AppSizes.ozzieSmall,
      OzzieSize.medium => AppSizes.ozzieMedium,
      OzzieSize.large => AppSizes.ozzieLarge,
    };

    // Get emoji for expression
    final String emoji = switch (expression) {
      OzzieExpression.happy => '😊',
      OzzieExpression.excited => '🤩',
      OzzieExpression.thinking => '🤔',
      OzzieExpression.celebrating => '🎉',
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Ozzie avatar
        _OzzieAvatar(
          size: sizeInPixels,
          emoji: emoji,
          animated: animated,
        ),
        
        // Message bubble (if provided)
        if (message != null) ...[
          const SizedBox(height: AppSizes.spaceSmall),
          _OzzieMessageBubble(message: message!),
        ],
      ],
    );
  }
}

/// Ozzie's circular avatar
class _OzzieAvatar extends StatefulWidget {
  final double size;
  final String emoji;
  final bool animated;

  const _OzzieAvatar({
    required this.size,
    required this.emoji,
    required this.animated,
  });

  @override
  State<_OzzieAvatar> createState() => _OzzieAvatarState();
}

class _OzzieAvatarState extends State<_OzzieAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    if (widget.animated) {
      // Create bounce animation
      _controller = AnimationController(
        duration: const Duration(milliseconds: 1000),
        vsync: this,
      )..repeat(reverse: true);

      _scaleAnimation = Tween<double>(
        begin: 0.95,
        end: 1.05,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ));
    }
  }

  @override
  void dispose() {
    if (widget.animated) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final avatar = Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        // Gradient background (gold to orange)
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.secondary,
          ],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Emoji
          Text(
            widget.emoji,
            style: TextStyle(fontSize: widget.size * 0.3),
          ),
          // "Ozzie" text
          Text(
            'Ozzie',
            style: AppTextStyles.button.copyWith(
              fontSize: widget.size * 0.15,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );

    // If animated, wrap in scale animation
    if (widget.animated) {
      return ScaleTransition(
        scale: _scaleAnimation,
        child: avatar,
      );
    }

    return avatar;
  }
}

/// Ozzie's speech bubble for messages
class _OzzieMessageBubble extends StatelessWidget {
  final String message;

  const _OzzieMessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 280),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.cardPadding,
        vertical: AppSizes.spaceSmall,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        message,
        style: AppTextStyles.ozzieSpeech,
        textAlign: TextAlign.center,
      ),
    );
  }
}

/// 🎬 ANIMATED OZZIE (for special moments!)
/// 
/// Shows Ozzie with a pulsing glow effect
class AnimatedOzzie extends StatefulWidget {
  final OzzieSize size;
  final OzzieExpression expression;
  final String? message;

  const AnimatedOzzie({
    super.key,
    this.size = OzzieSize.medium,
    this.expression = OzzieExpression.happy,
    this.message,
  });

  @override
  State<AnimatedOzzie> createState() => _AnimatedOzzieState();
}

class _AnimatedOzzieState extends State<AnimatedOzzie>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(_glowAnimation.value * 0.5),
                blurRadius: 30 * _glowAnimation.value,
                spreadRadius: 10 * _glowAnimation.value,
              ),
            ],
          ),
          child: OzziePlaceholder(
            size: widget.size,
            expression: widget.expression,
            message: widget.message,
            animated: true,
          ),
        );
      },
    );
  }
}

