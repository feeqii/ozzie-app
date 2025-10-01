import 'package:flutter/material.dart';
import 'package:ozzie/core/constants/app_colors.dart';
import 'package:ozzie/core/constants/app_sizes.dart';

/// 📇 OZZIE CARD
/// 
/// A beautiful card container for content!
/// 
/// WHAT IS THIS?
/// Think of a card like a piece of paper with rounded corners
/// and a slight shadow. We put content inside it (text, images, buttons).
/// 
/// WHY?
/// - Makes content look organized and separated
/// - Gives depth to the UI (shadow effect)
/// - Easy to tap (if we make it tappable)
/// - Consistent look across the app
/// 
/// HOW TO USE:
/// ```dart
/// OzzieCard(
///   child: Text('Hello!'),
/// )
/// ```
/// 
/// Or make it tappable:
/// ```dart
/// OzzieCard(
///   onTap: () {
///     print('Card tapped!');
///   },
///   child: Text('Tap me!'),
/// )
/// ```

class OzzieCard extends StatelessWidget {
  /// The content inside the card (text, images, buttons, etc.)
  final Widget child;
  
  /// What happens when you tap the card (optional)
  /// If null, card is not tappable
  final VoidCallback? onTap;
  
  /// Background color of the card
  final Color? backgroundColor;
  
  /// Padding inside the card
  final EdgeInsetsGeometry? padding;
  
  /// Margin outside the card (space around it)
  final EdgeInsetsGeometry? margin;
  
  /// How "lifted" the card looks (shadow depth)
  final double? elevation;
  
  /// Border radius (how rounded the corners are)
  final double? borderRadius;
  
  /// Optional border color
  final Color? borderColor;
  
  /// Border width (if borderColor is set)
  final double? borderWidth;

  const OzzieCard({
    super.key,
    required this.child,
    this.onTap,
    this.backgroundColor,
    this.padding,
    this.margin,
    this.elevation,
    this.borderRadius,
    this.borderColor,
    this.borderWidth,
  });

  @override
  Widget build(BuildContext context) {
    // Build the card content
    final cardContent = Container(
      padding: padding ?? const EdgeInsets.all(AppSizes.cardPadding),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.white,
        borderRadius: BorderRadius.circular(
          borderRadius ?? AppSizes.radiusMedium,
        ),
        border: borderColor != null
            ? Border.all(
                color: borderColor!,
                width: borderWidth ?? AppSizes.borderWidth,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.1),
            blurRadius: elevation ?? AppSizes.cardElevation,
            offset: Offset(0, (elevation ?? AppSizes.cardElevation) / 2),
          ),
        ],
      ),
      child: child,
    );

    // If tappable, wrap in InkWell (adds tap ripple effect)
    if (onTap != null) {
      return Padding(
        padding: margin ?? const EdgeInsets.all(AppSizes.spaceSmall),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(
              borderRadius ?? AppSizes.radiusMedium,
            ),
            child: cardContent,
          ),
        ),
      );
    }

    // If not tappable, just return the card
    return Padding(
      padding: margin ?? const EdgeInsets.all(AppSizes.spaceSmall),
      child: cardContent,
    );
  }
}

/// 🌟 SPECIAL VARIANT: Ozzie Info Card
/// 
/// A card specifically for showing tips, info, or Ozzie's messages
/// 
/// HOW TO USE:
/// ```dart
/// OzzieInfoCard(
///   message: 'Great job! Keep going!',
///   icon: Icons.star,
/// )
/// ```
class OzzieInfoCard extends StatelessWidget {
  /// The message to display
  final String message;
  
  /// Optional icon to show
  final IconData? icon;
  
  /// Color theme (default is gold/primary)
  final Color? color;
  
  /// Optional action button text
  final String? actionText;
  
  /// What happens when action is tapped
  final VoidCallback? onActionTap;

  const OzzieInfoCard({
    super.key,
    required this.message,
    this.icon,
    this.color,
    this.actionText,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = color ?? AppColors.primary;
    
    return OzzieCard(
      backgroundColor: cardColor.withOpacity(0.1),
      borderColor: cardColor,
      borderWidth: 2,
      child: Row(
        children: [
          // Icon (if provided)
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(AppSizes.spaceSmall),
              decoration: BoxDecoration(
                color: cardColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppColors.white,
                size: AppSizes.iconMedium,
              ),
            ),
            const SizedBox(width: AppSizes.spaceMedium),
          ],
          
          // Message
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                  ),
            ),
          ),
          
          // Action button (if provided)
          if (actionText != null && onActionTap != null) ...[
            const SizedBox(width: AppSizes.spaceMedium),
            TextButton(
              onPressed: onActionTap,
              style: TextButton.styleFrom(
                foregroundColor: cardColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spaceSmall,
                  vertical: AppSizes.spaceXTiny,
                ),
              ),
              child: Text(actionText!),
            ),
          ],
        ],
      ),
    );
  }
}

