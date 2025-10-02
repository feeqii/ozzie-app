import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ozzie/features/lesson/data/models/user_progress_model.dart';
import 'package:ozzie/services/progress_service.dart';

/// 📊 PROGRESS CONTROLLER
/// 
/// Manages user progress state using Riverpod.
/// 
/// WHAT IS THIS?
/// This is the "brain" that manages progress throughout the app.
/// It uses Riverpod to make progress data available everywhere.
/// 
/// WHY?
/// - Centralized progress management
/// - Reactive updates (UI updates automatically)
/// - Easy access from any screen
/// 
/// EXAMPLE USAGE:
/// ```dart
/// // In a widget
/// final progress = ref.watch(progressControllerProvider);
/// 
/// // To save progress
/// ref.read(progressControllerProvider.notifier).saveVerseCompletion(
///   surahNumber: 1,
///   verseNumber: 1,
///   stars: 3,
/// );
/// ```

/// Progress state - holds the current UserProgress
typedef ProgressState = AsyncValue<UserProgress>;

/// Progress Controller - manages progress operations
class ProgressController extends StateNotifier<ProgressState> {
  final ProgressService _progressService;

  ProgressController(this._progressService) : super(const AsyncValue.loading()) {
    // Load progress when controller is created
    loadProgress();
  }

  /// Load progress from Hive
  Future<void> loadProgress() async {
    state = const AsyncValue.loading();
    
    try {
      final progress = await _progressService.loadProgress();
      state = AsyncValue.data(progress);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Save verse completion
  /// 
  /// Call this after a verse is completed in the lesson
  Future<void> saveVerseCompletion({
    required int surahNumber,
    required int verseNumber,
    required int stars,
  }) async {
    try {
      // Save to Hive
      await _progressService.saveVerseProgress(
        surahNumber: surahNumber,
        verseNumber: verseNumber,
        stars: stars,
      );
      
      // Reload progress to update state
      await loadProgress();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Check if a verse is completed
  bool isVerseCompleted(int surahNumber, int verseNumber) {
    return state.maybeWhen(
      data: (progress) {
        final surahProgress = progress.surahProgress[surahNumber];
        if (surahProgress == null) return false;
        return surahProgress.versesCompleted.contains(verseNumber);
      },
      orElse: () => false,
    );
  }

  /// Get stars for a verse
  int getVerseStars(int surahNumber, int verseNumber) {
    return state.maybeWhen(
      data: (progress) {
        final surahProgress = progress.surahProgress[surahNumber];
        if (surahProgress == null) return 0;
        return surahProgress.verseStars[verseNumber] ?? 0;
      },
      orElse: () => 0,
    );
  }

  /// Get Surah progress
  SurahProgress? getSurahProgress(int surahNumber) {
    return state.maybeWhen(
      data: (progress) => progress.surahProgress[surahNumber],
      orElse: () => null,
    );
  }

  /// Check if Surah is completed
  bool isSurahCompleted(int surahNumber) {
    return state.maybeWhen(
      data: (progress) {
        final surahProgress = progress.surahProgress[surahNumber];
        if (surahProgress == null) return false;
        return surahProgress.isCompleted;
      },
      orElse: () => false,
    );
  }

  /// Get total verses completed
  int getTotalVersesCompleted() {
    return state.maybeWhen(
      data: (progress) => progress.totalVersesCompleted,
      orElse: () => 0,
    );
  }

  /// Clear all progress (for testing)
  Future<void> clearProgress() async {
    await _progressService.clearProgress();
    await loadProgress();
  }

  /// Reset Surah progress
  Future<void> resetSurahProgress(int surahNumber) async {
    await _progressService.resetSurahProgress(surahNumber);
    await loadProgress();
  }
}

// ========== RIVERPOD PROVIDERS ==========

/// Progress Service Provider
/// 
/// Provides a single instance of ProgressService throughout the app
final progressServiceProvider = Provider<ProgressService>((ref) {
  return ProgressService();
});

/// Progress Controller Provider
/// 
/// Provides the progress controller and manages state
/// 
/// USAGE:
/// ```dart
/// // Watch progress (rebuilds when progress changes)
/// final progressState = ref.watch(progressControllerProvider);
/// 
/// progressState.when(
///   data: (progress) => Text('Verses completed: ${progress.totalVersesCompleted}'),
///   loading: () => CircularProgressIndicator(),
///   error: (err, stack) => Text('Error: $err'),
/// );
/// 
/// // Call methods
/// ref.read(progressControllerProvider.notifier).saveVerseCompletion(...);
/// ```
final progressControllerProvider = StateNotifierProvider<ProgressController, ProgressState>((ref) {
  final progressService = ref.watch(progressServiceProvider);
  return ProgressController(progressService);
});

/// Helper providers for common queries

/// Check if a specific verse is completed
final verseCompletedProvider = Provider.family<bool, ({int surahNumber, int verseNumber})>((ref, params) {
  final controller = ref.watch(progressControllerProvider.notifier);
  return controller.isVerseCompleted(params.surahNumber, params.verseNumber);
});

/// Get stars for a specific verse
final verseStarsProvider = Provider.family<int, ({int surahNumber, int verseNumber})>((ref, params) {
  final controller = ref.watch(progressControllerProvider.notifier);
  return controller.getVerseStars(params.surahNumber, params.verseNumber);
});

/// Get progress for a specific Surah
final surahProgressProvider = Provider.family<SurahProgress?, int>((ref, surahNumber) {
  final controller = ref.watch(progressControllerProvider.notifier);
  return controller.getSurahProgress(surahNumber);
});

/// Check if a Surah is completed
final surahCompletedProvider = Provider.family<bool, int>((ref, surahNumber) {
  final controller = ref.watch(progressControllerProvider.notifier);
  return controller.isSurahCompleted(surahNumber);
});

