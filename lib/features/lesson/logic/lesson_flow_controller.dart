import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ozzie/features/lesson/data/models/verse_model.dart';
import 'package:ozzie/features/lesson/logic/lesson_flow_state.dart';
import 'package:ozzie/features/lesson/logic/progress_controller.dart';
import 'package:ozzie/services/quran_data_service.dart';

/// 🧠 LESSON FLOW CONTROLLER
/// 
/// This is the "brain" that manages the entire lesson experience!
/// 
/// WHAT IS A CONTROLLER?
/// Think of it like a video game controller:
/// - You press buttons (call methods like nextStep(), checkQuiz())
/// - The controller updates the game state (which step you're on, your score)
/// - The screen updates to show the new state
/// 
/// WHY STATENOTIFIER?
/// StateNotifier is like a smart container that:
/// - Holds the current state
/// - Notifies everyone when state changes
/// - Makes it easy to update state immutably
/// 
/// EXAMPLE FLOW:
/// 1. Kid opens lesson → loadVerse() loads data
/// 2. Kid reads explanation → nextStep() moves to recitation
/// 3. Kid listens to recitation → nextStep() moves to recording
/// 4. Kid records voice → submitRecording() saves it
/// 5. And so on...

class LessonFlowController extends StateNotifier<LessonFlowState> {
  /// Reference to QuranDataService to load verse data
  final QuranDataService _quranDataService;
  
  /// Reference to Riverpod ref for accessing other providers
  final Ref _ref;

  /// Initialize with a starting state
  /// 
  /// Example:
  /// ```dart
  /// final controller = LessonFlowController(
  ///   ref: ref,
  ///   quranDataService: QuranDataService(),
  ///   surahNumber: 1,
  ///   verseNumber: 1,
  /// );
  /// ```
  LessonFlowController({
    required Ref ref,
    required QuranDataService quranDataService,
    required int surahNumber,
    required int verseNumber,
  })  : _ref = ref,
        _quranDataService = quranDataService,
        super(LessonFlowState(
          surahNumber: surahNumber,
          verseNumber: verseNumber,
        )) {
    // Automatically load verse data when controller is created
    loadVerse();
  }

  // ========== DATA LOADING ==========

  /// Load the verse data from QuranDataService
  /// 
  /// This fetches the Arabic text, translation, explanation, etc.
  Future<void> loadVerse() async {
    // Set loading state
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Get verse from service
      final verse = await _quranDataService.getVerse(
        surahNumber: state.surahNumber,
        verseNumber: state.verseNumber,
      );

      if (verse == null) {
        throw Exception('Verse not found');
      }

      // Update state with loaded verse
      state = state.copyWith(
        verse: verse,
        isLoading: false,
      );
    } catch (e) {
      // Handle error
      state = state.copyWith(
        error: 'Failed to load verse: $e',
        isLoading: false,
      );
    }
  }

  // ========== NAVIGATION ==========

  /// Move to the next step
  /// 
  /// Example: From explanation → recitation
  void nextStep() {
    // Check if we can go next
    if (!state.canGoNext) {
      return; // Can't proceed (e.g., quiz not answered correctly)
    }

    final nextStep = state.currentStep.next;
    if (nextStep != null) {
      state = state.copyWith(currentStep: nextStep);
    }
  }

  /// Go back to the previous step
  /// 
  /// Example: From recitation → explanation
  void previousStep() {
    if (!state.canGoBack) {
      return; // Already at first step
    }

    final previousStep = state.currentStep.previous;
    if (previousStep != null) {
      state = state.copyWith(currentStep: previousStep);
    }
  }

  /// Jump to a specific step
  /// 
  /// Example: Skip directly to quiz for testing
  void goToStep(LessonStep step) {
    state = state.copyWith(currentStep: step);
  }

  // ========== STEP 3: RECORDING ==========

  /// Save the kid's voice recording
  /// 
  /// Parameters:
  /// - recordingPath: Where the audio file is saved
  /// - aiScore: AI pronunciation score (0-100)
  void submitRecording({
    required String recordingPath,
    int? aiScore,
  }) {
    state = state.copyWith(
      hasRecorded: true,
      recordingPath: recordingPath,
      aiScore: aiScore,
    );
  }

  /// Clear recording (let them try again)
  void clearRecording() {
    state = state.copyWith(
      hasRecorded: false,
      recordingPath: null,
      aiScore: null,
    );
  }

  // ========== STEP 4: QUIZ 1 (WORD ORDER) ==========

  /// Submit Quiz 1 answer (word order)
  /// 
  /// Parameters:
  /// - answers: List of words in the order the kid arranged them
  /// 
  /// Returns: true if correct, false if wrong
  bool submitQuiz1(List<String> answers) {
    // Check if answer is correct
    // For word order, we need the words in the right sequence
    final correctOrder = _getCorrectWordOrder();
    final isCorrect = _checkWordOrder(answers, correctOrder);

    state = state.copyWith(
      quiz1Answers: answers,
      quiz1Correct: isCorrect,
    );

    return isCorrect;
  }

  /// Get the correct word order from the verse
  List<String> _getCorrectWordOrder() {
    if (state.verse == null) return [];
    return state.verse!.words.map((word) => word.arabic).toList();
  }

  /// Check if the word order is correct
  bool _checkWordOrder(List<String> userOrder, List<String> correctOrder) {
    if (userOrder.length != correctOrder.length) return false;
    
    for (int i = 0; i < userOrder.length; i++) {
      if (userOrder[i] != correctOrder[i]) return false;
    }
    
    return true;
  }

  // ========== STEP 5: QUIZ 2 (COMPREHENSION) ==========

  /// Submit Quiz 2 answer (comprehension)
  /// 
  /// Parameters:
  /// - answer: The selected answer
  /// - correctAnswer: What the correct answer should be
  /// 
  /// Returns: true if correct, false if wrong
  bool submitQuiz2({
    required String answer,
    required String correctAnswer,
  }) {
    final isCorrect = answer == correctAnswer;

    state = state.copyWith(
      quiz2SelectedAnswer: answer,
      quiz2Correct: isCorrect,
    );

    return isCorrect;
  }

  // ========== STEP 6: COMPLETION ==========

  /// Calculate stars earned based on performance
  /// 
  /// Star calculation:
  /// - 1 star: Completed (minimum)
  /// - 2 stars: Both quizzes correct
  /// - 3 stars: Perfect (quizzes + good AI score)
  int _calculateStars() {
    int stars = 1; // Base star for completing

    // Bonus star for both quizzes correct
    if (state.quiz1Correct == true && state.quiz2Correct == true) {
      stars++;
    }

    // Bonus star for excellent AI score (90%+)
    if (state.aiScore != null && state.aiScore! >= 90) {
      stars++;
    }

    return stars;
  }

  /// Complete the lesson
  /// 
  /// This marks the verse as completed and calculates stars
  void completeLesson() {
    final stars = _calculateStars();

    state = state.copyWith(
      isCompleted: true,
      starsEarned: stars,
    );

    // TODO: Save progress to database/local storage
    _saveProgress();
  }

  /// Save progress to Hive
  Future<void> _saveProgress() async {
    try {
      // Get progress controller
      final progressController = _ref.read(progressControllerProvider.notifier);
      
      // Save verse completion with stars
      await progressController.saveVerseCompletion(
        surahNumber: state.surahNumber,
        verseNumber: state.verseNumber,
        stars: state.starsEarned,
      );
      
      print('💾 Progress saved successfully: ${state.surahNumber}:${state.verseNumber} - ${state.starsEarned} stars');
    } catch (e) {
      print('❌ Error saving progress: $e');
      // Don't throw - we don't want to crash the app if saving fails
    }
  }

  // ========== HELPER METHODS ==========

  /// Reset the lesson (start over)
  void reset() {
    state = LessonFlowState(
      surahNumber: state.surahNumber,
      verseNumber: state.verseNumber,
      verse: state.verse, // Keep the loaded verse
    );
  }

  /// Get current step number (1-6)
  int get currentStepNumber => state.currentStep.stepNumber;

  /// Get total steps
  int get totalSteps => 6;

  /// Get progress percentage (0-100)
  int get progressPercentage => (state.progress * 100).toInt();
}

// ========== RIVERPOD PROVIDER ==========

/// Provider family for lesson flow
/// 
/// WHAT IS THIS?
/// This creates a controller for a specific Surah:Verse combination.
/// Think of it like a "factory" that creates controllers on demand.
/// 
/// USAGE:
/// ```dart
/// // In a widget
/// final lessonController = ref.watch(lessonFlowProvider((
///   surahNumber: 1,
///   verseNumber: 1,
/// )));
/// 
/// // Access state
/// final currentStep = lessonController.currentStep;
/// 
/// // Call methods
/// ref.read(lessonFlowProvider((surahNumber: 1, verseNumber: 1)).notifier)
///    .nextStep();
/// ```
final lessonFlowProvider = StateNotifierProvider.family<
    LessonFlowController,
    LessonFlowState,
    ({int surahNumber, int verseNumber})>(
  (ref, params) {
    return LessonFlowController(
      ref: ref,
      quranDataService: QuranDataService(),
      surahNumber: params.surahNumber,
      verseNumber: params.verseNumber,
    );
  },
);

