import 'package:hive_flutter/hive_flutter.dart';
import 'package:ozzie/features/lesson/data/models/user_progress_model.dart';

/// 💾 PROGRESS SERVICE
/// 
/// Handles all Hive operations for saving and loading user progress.
/// 
/// WHAT IS THIS?
/// Think of this as the "librarian" for user progress data.
/// It knows how to:
/// - Save progress to Hive (local storage)
/// - Load progress from Hive
/// - Update specific progress data
/// 
/// WHY?
/// We want to save user progress so they don't lose their work!
/// This service handles all the database operations.
/// 
/// EXAMPLE USAGE:
/// ```dart
/// final service = ProgressService();
/// await service.saveVerseProgress(
///   surahNumber: 1,
///   verseNumber: 1,
///   stars: 3,
/// );
/// ```
class ProgressService {
  /// Box name for storing user progress
  static const String _progressBoxName = 'user_progress';
  
  /// Key for the main user progress object
  static const String _progressKey = 'main_user_progress';

  /// Get the Hive box for progress
  /// This is like opening the filing cabinet to access data
  Future<Box> _getBox() async {
    return await Hive.openBox(_progressBoxName);
  }

  /// Initialize the progress service
  /// 
  /// Call this once when the app starts
  Future<void> initialize() async {
    // Hive is already initialized in main.dart
    // This method is here in case we need any setup later
  }

  /// Save verse completion progress
  /// 
  /// This updates or creates progress for a specific verse
  /// 
  /// Example:
  /// ```dart
  /// await service.saveVerseProgress(
  ///   surahNumber: 1,
  ///   verseNumber: 1,
  ///   stars: 3,
  /// );
  /// ```
  Future<void> saveVerseProgress({
    required int surahNumber,
    required int verseNumber,
    required int stars,
  }) async {
    try {
      final box = await _getBox();
      
      // Load existing progress or create new
      UserProgress progress = await loadProgress();
      
      // Get or create Surah progress
      SurahProgress surahProgress = progress.surahProgress[surahNumber] ?? 
        SurahProgress(
          surahNumber: surahNumber,
          startedDate: DateTime.now(),
        );
      
      // Update verse completion
      final updatedVersesCompleted = List<int>.from(surahProgress.versesCompleted);
      if (!updatedVersesCompleted.contains(verseNumber)) {
        updatedVersesCompleted.add(verseNumber);
      }
      
      // Update verse stars
      final updatedVerseStars = Map<int, int>.from(surahProgress.verseStars);
      updatedVerseStars[verseNumber] = stars;
      
      // Check if Surah is completed
      // TODO: Get total verses from Surah data (for now, Al-Fatiha = 7)
      final totalVerses = surahNumber == 1 ? 7 : 4; // Al-Fatiha = 7, Al-Ikhlas = 4
      final isCompleted = updatedVersesCompleted.length >= totalVerses;
      
      // Create updated Surah progress
      final updatedSurahProgress = surahProgress.copyWith(
        versesCompleted: updatedVersesCompleted,
        verseStars: updatedVerseStars,
        isCompleted: isCompleted,
        completedDate: isCompleted ? DateTime.now() : surahProgress.completedDate,
      );
      
      // Update full progress
      final updatedProgress = progress.copyWith(
        surahProgress: {
          ...progress.surahProgress,
          surahNumber: updatedSurahProgress,
        },
        lastStudyDate: DateTime.now(),
      );
      
      // Save to Hive
      await box.put(_progressKey, updatedProgress.toJson());
      
      print('✅ Progress saved: Surah $surahNumber, Verse $verseNumber, $stars stars');
    } catch (e) {
      print('❌ Error saving progress: $e');
      throw Exception('Failed to save progress: $e');
    }
  }

  /// Load user progress from Hive
  /// 
  /// Returns existing progress or creates a new empty one
  Future<UserProgress> loadProgress() async {
    try {
      final box = await _getBox();
      
      final data = box.get(_progressKey);
      
      if (data == null) {
        // No progress yet - return empty progress
        return UserProgress(
          userId: 'default_user', // TODO: Add proper user management later
          surahProgress: {},
        );
      }
      
      // Deep convert Map<dynamic, dynamic> to Map<String, dynamic>
      final Map<String, dynamic> jsonData = _convertToStringMap(data);
      
      // Parse JSON to UserProgress
      return UserProgress.fromJson(jsonData);
    } catch (e) {
      print('❌ Error loading progress: $e');
      // Return empty progress if there's an error
      return UserProgress(
        userId: 'default_user',
        surahProgress: {},
      );
    }
  }
  
  /// Helper: Deep convert Map<dynamic, dynamic> to Map<String, dynamic>
  /// This fixes Hive's type casting issues
  Map<String, dynamic> _convertToStringMap(dynamic data) {
    if (data is Map) {
      return data.map((key, value) {
        if (value is Map) {
          return MapEntry(key.toString(), _convertToStringMap(value));
        } else if (value is List) {
          return MapEntry(key.toString(), value.map((e) => e is Map ? _convertToStringMap(e) : e).toList());
        } else {
          return MapEntry(key.toString(), value);
        }
      });
    }
    return {};
  }

  /// Get progress for a specific Surah
  Future<SurahProgress?> getSurahProgress(int surahNumber) async {
    final progress = await loadProgress();
    return progress.surahProgress[surahNumber];
  }

  /// Check if a verse is completed
  Future<bool> isVerseCompleted(int surahNumber, int verseNumber) async {
    final surahProgress = await getSurahProgress(surahNumber);
    if (surahProgress == null) return false;
    return surahProgress.versesCompleted.contains(verseNumber);
  }

  /// Get stars earned for a specific verse
  Future<int> getVerseStars(int surahNumber, int verseNumber) async {
    final surahProgress = await getSurahProgress(surahNumber);
    if (surahProgress == null) return 0;
    return surahProgress.verseStars[verseNumber] ?? 0;
  }

  /// Check if a Surah is completed
  Future<bool> isSurahCompleted(int surahNumber) async {
    final surahProgress = await getSurahProgress(surahNumber);
    if (surahProgress == null) return false;
    return surahProgress.isCompleted;
  }

  /// Get total verses completed across all Surahs
  Future<int> getTotalVersesCompleted() async {
    final progress = await loadProgress();
    return progress.totalVersesCompleted;
  }

  /// Clear all progress (useful for testing)
  Future<void> clearProgress() async {
    final box = await _getBox();
    await box.delete(_progressKey);
    print('🗑️ Progress cleared');
  }

  /// Reset progress for a specific Surah
  Future<void> resetSurahProgress(int surahNumber) async {
    final progress = await loadProgress();
    
    final updatedSurahProgress = Map<int, SurahProgress>.from(progress.surahProgress);
    updatedSurahProgress.remove(surahNumber);
    
    final updatedProgress = progress.copyWith(
      surahProgress: updatedSurahProgress,
    );
    
    final box = await _getBox();
    await box.put(_progressKey, updatedProgress.toJson());
    print('🔄 Reset progress for Surah $surahNumber');
  }

  /// Close the Hive box (call when app is closing)
  Future<void> close() async {
    final box = await _getBox();
    await box.close();
  }
}

