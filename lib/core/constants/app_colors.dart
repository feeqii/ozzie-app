import 'package:flutter/material.dart';

/// 🎨 APP COLORS
/// 
/// This file defines all the colors used in the Ozzie app.
/// Think of this like a "color palette" - whenever we need a color,
/// we come here instead of writing it everywhere in the code.
/// 
/// WHY? If we want to change a color later, we only change it here!
/// 
/// Brand colors are from your warm, encouraging palette:
/// - Cream: Light, warm background
/// - Gold: Primary actions and highlights
/// - Orange: Accents and energy
/// - Red: Important highlights
class AppColors {
  // 🚫 Private constructor - we don't create instances of this class
  // We just use it like AppColors.cream, AppColors.gold, etc.
  AppColors._();

  // ========== BRAND COLORS (From your palette) ==========
  
  /// Cream - Warm background color
  /// Usage: Main backgrounds, cards
  static const Color cream = Color(0xFFFEF3E2); // #FEF3E2

  /// Gold - Primary brand color
  /// Usage: Main buttons, active states, primary actions
  static const Color gold = Color(0xFFFAB12F); // #FAB12F

  /// Orange - Accent color
  /// Usage: Highlights, badges, secondary actions
  static const Color orange = Color(0xFFFA812F); // #FA812F

  /// Red - Strong highlight color
  /// Usage: Important items, achievements, stars
  static const Color red = Color(0xFFDD0303); // #DD0303

  // ========== SEMANTIC COLORS (Meaning-based colors) ==========
  
  /// Primary - Main color for important actions
  static const Color primary = gold;

  /// Secondary - For less important actions
  static const Color secondary = orange;

  /// Accent - For highlights and special items
  static const Color accent = red;

  /// Background - Main app background
  static const Color background = cream;

  // ========== NEUTRAL COLORS (Black, white, grays) ==========

  /// Pure white
  static const Color white = Color(0xFFFFFFFF);

  /// Pure black
  static const Color black = Color(0xFF000000);

  /// Dark gray - for text
  static const Color darkGray = Color(0xFF333333);

  /// Medium gray - for secondary text
  static const Color mediumGray = Color(0xFF666666);

  /// Light gray - for borders, dividers
  static const Color lightGray = Color(0xFFE0E0E0);

  // ========== FUNCTIONAL COLORS (For specific purposes) ==========

  /// Success - for correct answers, achievements
  static const Color success = Color(0xFF4CAF50); // Green

  /// Error - for mistakes (we use gently!)
  static const Color error = Color(0xFFFF6B6B); // Soft red

  /// Warning - for hints, tips
  static const Color warning = Color(0xFFFFA726); // Soft orange

  /// Info - for information messages
  static const Color info = Color(0xFF42A5F5); // Soft blue

  // ========== TEXT COLORS ==========

  /// Primary text color (dark, easy to read)
  static const Color textPrimary = darkGray;

  /// Secondary text color (lighter, for less important text)
  static const Color textSecondary = mediumGray;

  /// Text on dark backgrounds
  static const Color textOnDark = white;

  /// Text on colored buttons
  static const Color textOnPrimary = white;

  // ========== SPECIAL COLORS FOR OZZIE ==========

  /// Space theme - dark purple for cosmic background
  static const Color spaceBackground = Color(0xFF1A0E2E);

  /// Star color - for achievement stars
  static const Color star = Color(0xFFFFD700); // Gold star

  /// Planet glow - for completed Surahs
  static const Color planetGlow = Color(0xFF00D9FF); // Cyan glow
}

