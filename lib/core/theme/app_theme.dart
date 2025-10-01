import 'package:flutter/material.dart';
import 'package:ozzie/core/constants/app_colors.dart';
import 'package:ozzie/core/constants/app_text_styles.dart';
import 'package:ozzie/core/constants/app_sizes.dart';

/// 🎨 APP THEME
/// 
/// This file creates the "look and feel" of the entire app!
/// It combines colors, text styles, and other design rules.
/// 
/// Think of it like decorating a house:
/// - Colors = paint on walls
/// - Text styles = font choices  
/// - Theme = the complete interior design
/// 
/// WHY? By setting the theme once, every widget in the app
/// automatically looks consistent and beautiful!
class AppTheme {
  AppTheme._();

  /// ✨ Light Theme (Main theme for Ozzie)
  /// This is what the app will look like!
  static ThemeData get lightTheme {
    return ThemeData(
      // ========== BASICS ==========
      
      /// Use Material Design 3 (latest and greatest!)
      useMaterial3: true,
      
      /// Main colors
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      
      /// Color scheme - tells Flutter what colors to use where
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.white,
        error: AppColors.error,
        onPrimary: AppColors.textOnPrimary,
        onSecondary: AppColors.white,
        onSurface: AppColors.textPrimary,
        onError: AppColors.white,
      ),

      // ========== TEXT THEME ==========
      
      /// How text looks throughout the app
      textTheme: TextTheme(
        // Headlines (big text)
        headlineLarge: AppTextStyles.headingLarge,
        headlineMedium: AppTextStyles.headingMedium,
        headlineSmall: AppTextStyles.headingSmall,
        
        // Body text (regular content)
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        
        // Labels (buttons, chips)
        labelLarge: AppTextStyles.button,
        labelMedium: AppTextStyles.bodyMedium,
        labelSmall: AppTextStyles.caption,
      ),

      // ========== APP BAR THEME ==========
      
      /// Top navigation bar style
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0, // No shadow (clean, modern)
        centerTitle: true, // Center the title
        titleTextStyle: AppTextStyles.headingMedium,
        iconTheme: IconThemeData(
          color: AppColors.textPrimary,
          size: AppSizes.iconMedium,
        ),
      ),

      // ========== BUTTON THEMES ==========

      /// Elevated Button (main buttons with color)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          elevation: AppSizes.cardElevation,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.buttonPaddingHorizontal,
            vertical: AppSizes.buttonPaddingVertical,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          ),
          minimumSize: Size(AppSizes.buttonMinWidth, AppSizes.buttonHeight),
          textStyle: AppTextStyles.button,
        ),
      ),

      /// Text Button (buttons without background)
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.buttonPaddingHorizontal,
            vertical: AppSizes.buttonPaddingVertical,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          ),
          textStyle: AppTextStyles.button,
        ),
      ),

      /// Outlined Button (buttons with border)
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(color: AppColors.primary, width: AppSizes.borderWidth),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.buttonPaddingHorizontal,
            vertical: AppSizes.buttonPaddingVertical,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          ),
          minimumSize: Size(AppSizes.buttonMinWidth, AppSizes.buttonHeight),
          textStyle: AppTextStyles.button,
        ),
      ),

      // ========== CARD THEME ==========
      
      /// How cards look in the app
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: AppSizes.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        ),
        margin: const EdgeInsets.all(AppSizes.spaceSmall),
      ),

      // ========== INPUT DECORATION (Text fields) ==========
      
      /// How text input fields look
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.cardPadding,
          vertical: AppSizes.cardPadding,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          borderSide: BorderSide(color: AppColors.lightGray),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          borderSide: BorderSide(color: AppColors.lightGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          borderSide: BorderSide(color: AppColors.error),
        ),
        labelStyle: AppTextStyles.bodyMedium,
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.mediumGray,
        ),
      ),

      // ========== ICON THEME ==========
      
      /// Default icon styling
      iconTheme: IconThemeData(
        color: AppColors.textPrimary,
        size: AppSizes.iconMedium,
      ),

      // ========== DIVIDER THEME ==========
      
      /// Lines that separate sections
      dividerTheme: DividerThemeData(
        color: AppColors.lightGray,
        thickness: 1,
        space: AppSizes.spaceMedium,
      ),

      // ========== BOTTOM NAVIGATION BAR ==========
      
      /// Bottom navigation bar style
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.mediumGray,
        selectedLabelStyle: AppTextStyles.navLabel.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTextStyles.navLabel,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // ========== CHIP THEME ==========
      
      /// Small rounded containers (tags, filters)
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.cream,
        selectedColor: AppColors.primary,
        disabledColor: AppColors.lightGray,
        labelStyle: AppTextStyles.bodySmall,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spaceSmall,
          vertical: AppSizes.spaceXTiny,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        ),
      ),

      // ========== FLOATING ACTION BUTTON ==========
      
      /// Big circular button (usually bottom right)
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusCircular),
        ),
      ),

      // ========== DIALOG THEME ==========
      
      /// Pop-up boxes
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        ),
        titleTextStyle: AppTextStyles.headingMedium,
        contentTextStyle: AppTextStyles.bodyLarge,
      ),

      // ========== SNACKBAR THEME ==========
      
      /// Bottom notification messages
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkGray,
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.white,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        ),
      ),

      // ========== PROGRESS INDICATOR ==========
      
      /// Loading spinners and bars
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.lightGray,
        circularTrackColor: AppColors.lightGray,
      ),
    );
  }

  /// 🌙 Dark Theme (For future, if needed)
  /// Currently not used, but ready for night mode!
  static ThemeData get darkTheme {
    // For now, just return light theme
    // We can build dark theme later if needed
    return lightTheme;
  }
}

