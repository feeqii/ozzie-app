import 'package:flutter/material.dart';
import 'package:ozzie/core/constants/app_colors.dart';
import 'package:ozzie/core/constants/app_sizes.dart';
import 'package:ozzie/core/constants/app_text_styles.dart';

/// 🔘 OZZIE BUTTON
/// 
/// A beautiful, reusable button for the Ozzie app!
/// 
/// WHAT IS THIS?
/// Think of this like a "button template" - instead of creating
/// a new button every time with all the colors, sizes, etc.,
/// we just use OzzieButton and it's already perfect!
/// 
/// WHY?
/// - Consistent look everywhere
/// - Easy to change all buttons at once
/// - Less code to write
/// - Kid-friendly design (big, colorful, easy to tap!)
/// 
/// HOW TO USE:
/// ```dart
/// OzzieButton(
///   text: 'Start Learning',
///   onPressed: () {
///     // Do something when tapped!
///   },
/// )
/// ```

enum OzzieButtonType {
  /// Main button - gold color, used for primary actions
  primary,
  
  /// Secondary button - orange color, used for less important actions
  secondary,
  
  /// Outline button - no fill, just border, for subtle actions
  outline,
  
  /// Text button - no background, just text, for navigation
  text,
}

enum OzzieButtonSize {
  /// Small button - for compact spaces
  small,
  
  /// Medium button - standard size
  medium,
  
  /// Large button - for important actions
  large,
}

class OzzieButton extends StatelessWidget {
  /// The text shown on the button
  final String text;
  
  /// What happens when you tap the button
  /// If null, button is disabled (grayed out, can't tap)
  final VoidCallback? onPressed;
  
  /// Type of button (primary, secondary, outline, text)
  final OzzieButtonType type;
  
  /// Size of button (small, medium, large)
  final OzzieButtonSize size;
  
  /// Optional icon to show before text
  final IconData? icon;
  
  /// Should the button take full width?
  final bool fullWidth;
  
  /// Is the button loading? (shows spinner instead of text)
  final bool isLoading;

  const OzzieButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = OzzieButtonType.primary,
    this.size = OzzieButtonSize.medium,
    this.icon,
    this.fullWidth = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    // Choose button height based on size
    final double height = switch (size) {
      OzzieButtonSize.small => AppSizes.buttonHeightSmall,
      OzzieButtonSize.medium => AppSizes.buttonHeight,
      OzzieButtonSize.large => AppSizes.buttonHeightLarge,
    };

    // Choose font size based on button size
    final double fontSize = switch (size) {
      OzzieButtonSize.small => 14,
      OzzieButtonSize.medium => 16,
      OzzieButtonSize.large => 18,
    };

    // Build the button based on type
    return SizedBox(
      height: height,
      width: fullWidth ? double.infinity : null,
      child: switch (type) {
        // PRIMARY BUTTON - Gold, filled
        OzzieButtonType.primary => ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textOnPrimary,
              disabledBackgroundColor: AppColors.lightGray,
              elevation: AppSizes.cardElevation,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: size == OzzieButtonSize.large 
                    ? AppSizes.buttonPaddingHorizontal * 1.5 
                    : AppSizes.buttonPaddingHorizontal,
              ),
            ),
            child: _buildButtonContent(fontSize),
          ),

        // SECONDARY BUTTON - Orange, filled
        OzzieButtonType.secondary => ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              foregroundColor: AppColors.textOnPrimary,
              disabledBackgroundColor: AppColors.lightGray,
              elevation: AppSizes.cardElevation,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: size == OzzieButtonSize.large 
                    ? AppSizes.buttonPaddingHorizontal * 1.5 
                    : AppSizes.buttonPaddingHorizontal,
              ),
            ),
            child: _buildButtonContent(fontSize),
          ),

        // OUTLINE BUTTON - Transparent with border
        OzzieButtonType.outline => OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              disabledForegroundColor: AppColors.mediumGray,
              side: BorderSide(
                color: onPressed != null ? AppColors.primary : AppColors.lightGray,
                width: AppSizes.borderWidth,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: size == OzzieButtonSize.large 
                    ? AppSizes.buttonPaddingHorizontal * 1.5 
                    : AppSizes.buttonPaddingHorizontal,
              ),
            ),
            child: _buildButtonContent(fontSize, outlined: true),
          ),

        // TEXT BUTTON - Just text, no background
        OzzieButtonType.text => TextButton(
            onPressed: isLoading ? null : onPressed,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              disabledForegroundColor: AppColors.mediumGray,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: size == OzzieButtonSize.large 
                    ? AppSizes.buttonPaddingHorizontal * 1.5 
                    : AppSizes.buttonPaddingHorizontal,
              ),
            ),
            child: _buildButtonContent(fontSize, textOnly: true),
          ),
      },
    );
  }

  /// Helper method to build button content (icon + text or loading spinner)
  Widget _buildButtonContent(double fontSize, {bool outlined = false, bool textOnly = false}) {
    // If loading, show spinner
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            outlined || textOnly ? AppColors.primary : AppColors.white,
          ),
        ),
      );
    }

    // Build text style based on button type
    final textStyle = AppTextStyles.button.copyWith(fontSize: fontSize);

    // If there's an icon, show icon + text
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min, // Don't take more space than needed
        children: [
          Icon(icon, size: fontSize * 1.2),
          SizedBox(width: AppSizes.spaceSmall),
          Text(text, style: textStyle),
        ],
      );
    }

    // Just text
    return Text(text, style: textStyle);
  }
}

