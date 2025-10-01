/// 📏 APP SIZES
/// 
/// This file defines all spacing, padding, and sizes used in the app.
/// Think of it like a "ruler" with pre-set measurements!
/// 
/// WHY? Instead of randomly choosing 10px here, 12px there,
/// we use consistent sizes that look good together.
/// 
/// The app follows an 8px grid system:
/// - Everything is multiples of 8 (8, 16, 24, 32...)
/// - This makes the app look clean and professional
/// - Easy to remember: just multiply by 8!
class AppSizes {
  AppSizes._();

  // ========== SPACING (Gaps between elements) ==========

  /// Extra tiny space - 4px
  /// Usage: Very tight spacing
  static const double spaceXTiny = 4.0;

  /// Tiny space - 8px (1 unit)
  /// Usage: Tight spacing, minimal gaps
  static const double spaceTiny = 8.0;

  /// Small space - 12px
  /// Usage: Small gaps between related items
  static const double spaceSmall = 12.0;

  /// Medium space - 16px (2 units) - MOST COMMON
  /// Usage: Standard spacing between elements
  static const double spaceMedium = 16.0;

  /// Large space - 24px (3 units)
  /// Usage: Larger gaps, section spacing
  static const double spaceLarge = 24.0;

  /// Extra large space - 32px (4 units)
  /// Usage: Major section breaks
  static const double spaceXLarge = 32.0;

  /// Huge space - 48px (6 units)
  /// Usage: Screen padding, major separations
  static const double spaceHuge = 48.0;

  // ========== PADDING (Space inside containers) ==========

  /// Screen padding - padding around entire screen
  static const double screenPadding = 20.0;

  /// Card padding - padding inside cards
  static const double cardPadding = 16.0;

  /// Button padding - padding inside buttons
  static const double buttonPaddingVertical = 16.0;
  static const double buttonPaddingHorizontal = 24.0;

  /// List item padding
  static const double listItemPadding = 12.0;

  // ========== BORDER RADIUS (Rounded corners) ==========

  /// Small radius - 8px
  /// Usage: Small elements, chips, tags
  static const double radiusSmall = 8.0;

  /// Medium radius - 12px - MOST COMMON
  /// Usage: Buttons, cards, containers
  static const double radiusMedium = 12.0;

  /// Large radius - 16px
  /// Usage: Large cards, modals
  static const double radiusLarge = 16.0;

  /// Extra large radius - 24px
  /// Usage: Very rounded elements
  static const double radiusXLarge = 24.0;

  /// Circular - 9999px (makes perfect circles)
  /// Usage: Profile pictures, circular buttons
  static const double radiusCircular = 9999.0;

  // ========== BUTTON SIZES ==========

  /// Button height
  static const double buttonHeight = 56.0;

  /// Small button height
  static const double buttonHeightSmall = 40.0;

  /// Large button height (for important actions)
  static const double buttonHeightLarge = 64.0;

  /// Button minimum width
  static const double buttonMinWidth = 120.0;

  // ========== ICON SIZES ==========

  /// Tiny icon - 16px
  static const double iconTiny = 16.0;

  /// Small icon - 20px
  static const double iconSmall = 20.0;

  /// Medium icon - 24px - MOST COMMON
  static const double iconMedium = 24.0;

  /// Large icon - 32px
  static const double iconLarge = 32.0;

  /// Extra large icon - 48px
  static const double iconXLarge = 48.0;

  /// Huge icon - 64px
  static const double iconHuge = 64.0;

  // ========== APP BAR ==========

  /// App bar height (top navigation bar)
  static const double appBarHeight = 56.0;

  /// Bottom navigation bar height
  static const double bottomNavHeight = 72.0;

  // ========== CARD SIZES ==========

  /// Card elevation (shadow depth)
  static const double cardElevation = 2.0;

  /// Card elevation when pressed
  static const double cardElevationPressed = 8.0;

  // ========== OZZIE MASCOT SIZES ==========

  /// Small Ozzie - for badges, small appearances
  static const double ozzieSmall = 60.0;

  /// Medium Ozzie - for regular appearances
  static const double ozzieMedium = 120.0;

  /// Large Ozzie - for celebrations, welcome screens
  static const double ozzieLarge = 200.0;

  // ========== STAR SIZES (For ratings) ==========

  /// Small star - for compact displays
  static const double starSmall = 16.0;

  /// Medium star - standard size
  static const double starMedium = 24.0;

  /// Large star - for celebrations
  static const double starLarge = 48.0;

  // ========== LESSON SPECIFIC SIZES ==========

  /// Audio player height
  static const double audioPlayerHeight = 80.0;

  /// Quiz option card height
  static const double quizOptionHeight = 60.0;

  /// Recording button size (big red button!)
  static const double recordButtonSize = 100.0;

  /// Progress bar height
  static const double progressBarHeight = 8.0;

  // ========== BORDERS ==========

  /// Border width - standard
  static const double borderWidth = 1.0;

  /// Border width - thick (for emphasis)
  static const double borderWidthThick = 2.0;

  // ========== ANIMATIONS ==========

  /// Standard animation duration in milliseconds
  static const int animationDurationMs = 300;

  /// Fast animation
  static const int animationDurationFastMs = 150;

  /// Slow animation
  static const int animationDurationSlowMs = 500;

  // ========== COSMIC THEME (Space theme) ==========

  /// Planet size on map - small
  static const double planetSmall = 80.0;

  /// Planet size on map - medium
  static const double planetMedium = 120.0;

  /// Planet size on map - large (for current planet)
  static const double planetLarge = 150.0;

  /// Star size in space background
  static const double spaceStarSize = 3.0;

  // ========== TOUCH TARGETS (For kids' fingers) ==========

  /// Minimum touch target size (easy for kids to tap)
  /// Apple recommends 44x44, we use 48x48 for safety
  static const double minTouchTarget = 48.0;
}

