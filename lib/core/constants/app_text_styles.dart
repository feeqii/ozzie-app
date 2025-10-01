import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ozzie/core/constants/app_colors.dart';

/// ✍️ APP TEXT STYLES
/// 
/// This file defines how all text looks in the Ozzie app.
/// Think of it like "text recipes" - each style says:
/// - How big should the text be?
/// - What font should we use?
/// - What color?
/// - Bold or normal?
/// 
/// WHY? This makes all text in the app look consistent and professional!
/// 
/// We use:
/// - English: Poppins (friendly, rounded, great for kids)
/// - Arabic: Amiri (beautiful, traditional, easy to read)
class AppTextStyles {
  AppTextStyles._();

  // ========== FONT FAMILIES ==========
  
  /// Get Poppins font family (English text)
  static TextStyle get _poppinsBase => GoogleFonts.poppins();

  /// Get Amiri font family (Arabic text)
  static TextStyle get _amiriBase => GoogleFonts.amiri();

  // ========== ENGLISH TEXT STYLES ==========

  /// Large heading - for screen titles
  /// Example: "Welcome to Ozzie!"
  static TextStyle get headingLarge => _poppinsBase.copyWith(
    fontSize: 32, // Big!
    fontWeight: FontWeight.bold, // Thick, strong text
    color: AppColors.textPrimary,
    height: 1.2, // Space between lines
  );

  /// Medium heading - for section titles
  /// Example: "Your Progress"
  static TextStyle get headingMedium => _poppinsBase.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  /// Small heading - for card titles
  /// Example: "Lesson 1"
  static TextStyle get headingSmall => _poppinsBase.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w600, // Semi-bold
    color: AppColors.textPrimary,
    height: 1.4,
  );

  /// Body text - for regular content
  /// Example: Explanations, descriptions
  static TextStyle get bodyLarge => _poppinsBase.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  /// Smaller body text
  /// Example: Helper text, hints
  static TextStyle get bodyMedium => _poppinsBase.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  /// Small text - for labels, captions
  /// Example: "Tap to continue"
  static TextStyle get bodySmall => _poppinsBase.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  /// Button text - for text on buttons
  /// Example: "Start Learning"
  static TextStyle get button => _poppinsBase.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textOnPrimary,
    letterSpacing: 0.5, // Slight spacing between letters
  );

  /// Caption - very small text
  /// Example: Timestamps, footnotes
  static TextStyle get caption => _poppinsBase.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.3,
  );

  // ========== ARABIC/QURANIC TEXT STYLES ==========

  /// Quranic verse - large, beautiful Arabic text
  /// Example: بِسْمِ اللَّهِ
  static TextStyle get quranVerse => _amiriBase.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.8, // More space for Arabic
  );

  /// Quranic word - individual Arabic words
  /// Example: For word-by-word display
  static TextStyle get quranWord => _amiriBase.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.6,
  );

  /// Transliteration - romanized Arabic
  /// Example: "Bismillah"
  static TextStyle get transliteration => _poppinsBase.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    fontStyle: FontStyle.italic, // Slanted text
    height: 1.5,
  );

  /// Arabic small - for small Arabic text
  static TextStyle get arabicSmall => _amiriBase.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.6,
  );

  // ========== SPECIAL TEXT STYLES ==========

  /// Ozzie mascot speech - playful, fun text
  /// Example: "Great job! 🎉"
  static TextStyle get ozzieSpeech => _poppinsBase.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
    height: 1.4,
  );

  /// Score/number text - big numbers
  /// Example: "75%" or "⭐️⭐️⭐️"
  static TextStyle get scoreText => _poppinsBase.copyWith(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: AppColors.accent,
    height: 1.2,
  );

  /// Badge text - text on badges
  /// Example: "First Verse!"
  static TextStyle get badgeText => _poppinsBase.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    height: 1.2,
  );

  /// Navigation label - bottom navigation
  /// Example: "Home", "Progress"
  static TextStyle get navLabel => _poppinsBase.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.2,
  );

  // ========== HELPER METHODS ==========
  
  /// Change the color of any text style
  /// 
  /// How to use:
  /// final whiteHeading = AppTextStyles.withColor(AppTextStyles.headingLarge, AppColors.white);
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  /// Change the size of any text style
  /// 
  /// How to use:
  /// final biggerButton = AppTextStyles.withSize(AppTextStyles.button, 20);
  static TextStyle withSize(TextStyle style, double size) {
    return style.copyWith(fontSize: size);
  }

  /// Make any text style bold
  /// 
  /// How to use:
  /// final boldBody = AppTextStyles.bold(AppTextStyles.bodyLarge);
  static TextStyle bold(TextStyle style) {
    return style.copyWith(fontWeight: FontWeight.bold);
  }
}
