import 'package:ozzie/features/lesson/data/models/verse_model.dart';

/// 🎯 LESSON FLOW STATE
/// 
/// This represents the CURRENT STATE of a lesson.
/// Think of it like a "snapshot" of where the kid is in their learning journey.
/// 
/// WHAT IS STATE?
/// State is information that changes over time. For example:
/// - Which verse are we learning? (changes when moving to next verse)
/// - What step are we on? (changes from 1→2→3→4→5→6)
/// - Did they complete the quiz? (changes from false→true)
/// 
/// WHY IMMUTABLE?
/// We use "const" and "copyWith" pattern because it makes the app:
/// - Predictable (we know exactly when things change)
/// - Easy to debug (we can see every state change)
/// - Safe (no accidental modifications)
/// 
/// EXAMPLE:
/// ```dart
/// // Current state
/// final state = LessonFlowState(
///   surahNumber: 1,
///   verseNumber: 1,
///   currentStep: 1,
/// );
/// 
/// // Move to next step (creates NEW state, doesn't modify old one)
/// final newState = state.copyWith(currentStep: 2);
/// ```

enum LessonStep {
  /// Step 1: Child-friendly explanation with visuals
  explanation(1, 'Explanation'),
  
  /// Step 2: Listen to expert recitation (normal & slow speed)
  recitation(2, 'Recitation'),
  
  /// Step 3: Record your own recitation (AI feedback)
  recording(3, 'Recording'),
  
  /// Step 4: Quiz - Word order / drag & drop
  quiz1(4, 'Quiz 1'),
  
  /// Step 5: Quiz - Comprehension / multiple choice
  quiz2(5, 'Quiz 2'),
  
  /// Step 6: Celebration! Stars, badges, encouragement
  celebration(6, 'Celebration');

  final int stepNumber;
  final String displayName;
  
  const LessonStep(this.stepNumber, this.displayName);

  /// Get step by number (1-6)
  static LessonStep fromNumber(int number) {
    return LessonStep.values.firstWhere(
      (step) => step.stepNumber == number,
      orElse: () => LessonStep.explanation,
    );
  }

  /// Is this the first step?
  bool get isFirst => this == LessonStep.explanation;
  
  /// Is this the last step?
  bool get isLast => this == LessonStep.celebration;
  
  /// Get the next step (or null if last)
  LessonStep? get next {
    if (isLast) return null;
    return LessonStep.fromNumber(stepNumber + 1);
  }
  
  /// Get the previous step (or null if first)
  LessonStep? get previous {
    if (isFirst) return null;
    return LessonStep.fromNumber(stepNumber - 1);
  }
}

/// The actual state class
class LessonFlowState {
  /// Which Surah are we learning?
  /// Example: 1 = Al-Fatiha, 112 = Al-Ikhlas
  final int surahNumber;
  
  /// Which verse in that Surah?
  /// Example: 1 = first verse, 2 = second verse, etc.
  final int verseNumber;
  
  /// What step are we on? (1-6)
  final LessonStep currentStep;
  
  /// The actual verse data (Arabic text, translation, etc.)
  /// Loaded from QuranDataService
  final Verse? verse;
  
  /// Is the data loading?
  final bool isLoading;
  
  /// Did something go wrong?
  final String? error;
  
  /// ========== STEP 3: RECORDING STATE ==========
  
  /// Did the kid record their voice?
  final bool hasRecorded;
  
  /// Recording file path (if recorded)
  final String? recordingPath;
  
  /// AI feedback score (0-100)
  final int? aiScore;
  
  /// ========== STEP 4 & 5: QUIZ STATE ==========
  
  /// Quiz 1 answers (word order)
  /// Example: ["بِسْمِ", "اللَّهِ", "الرَّحْمَٰنِ", "الرَّحِيمِ"]
  final List<String>? quiz1Answers;
  
  /// Quiz 1 correct?
  final bool? quiz1Correct;
  
  /// Quiz 2 selected answer
  final String? quiz2SelectedAnswer;
  
  /// Quiz 2 correct?
  final bool? quiz2Correct;
  
  /// ========== STEP 6: COMPLETION STATE ==========
  
  /// How many stars earned? (1-3)
  /// Based on quiz performance and completion
  final int starsEarned;
  
  /// Is this verse completed?
  final bool isCompleted;

  const LessonFlowState({
    required this.surahNumber,
    required this.verseNumber,
    this.currentStep = LessonStep.explanation,
    this.verse,
    this.isLoading = false,
    this.error,
    this.hasRecorded = false,
    this.recordingPath,
    this.aiScore,
    this.quiz1Answers,
    this.quiz1Correct,
    this.quiz2SelectedAnswer,
    this.quiz2Correct,
    this.starsEarned = 0,
    this.isCompleted = false,
  });

  /// Create a copy with some fields changed
  /// 
  /// This is the key to immutable state!
  /// Instead of changing the current state, we create a NEW state.
  /// 
  /// Example:
  /// ```dart
  /// final newState = oldState.copyWith(currentStep: LessonStep.recitation);
  /// ```
  LessonFlowState copyWith({
    int? surahNumber,
    int? verseNumber,
    LessonStep? currentStep,
    Verse? verse,
    bool? isLoading,
    String? error,
    bool? hasRecorded,
    String? recordingPath,
    int? aiScore,
    List<String>? quiz1Answers,
    bool? quiz1Correct,
    String? quiz2SelectedAnswer,
    bool? quiz2Correct,
    int? starsEarned,
    bool? isCompleted,
  }) {
    return LessonFlowState(
      surahNumber: surahNumber ?? this.surahNumber,
      verseNumber: verseNumber ?? this.verseNumber,
      currentStep: currentStep ?? this.currentStep,
      verse: verse ?? this.verse,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      hasRecorded: hasRecorded ?? this.hasRecorded,
      recordingPath: recordingPath ?? this.recordingPath,
      aiScore: aiScore ?? this.aiScore,
      quiz1Answers: quiz1Answers ?? this.quiz1Answers,
      quiz1Correct: quiz1Correct ?? this.quiz1Correct,
      quiz2SelectedAnswer: quiz2SelectedAnswer ?? this.quiz2SelectedAnswer,
      quiz2Correct: quiz2Correct ?? this.quiz2Correct,
      starsEarned: starsEarned ?? this.starsEarned,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  /// Calculate progress (0.0 to 1.0)
  /// Example: Step 3 of 6 = 0.5 (50%)
  double get progress => currentStep.stepNumber / 6.0;

  /// Can we go to next step?
  /// Some steps require completion before moving forward
  bool get canGoNext {
    switch (currentStep) {
      case LessonStep.explanation:
        return true; // Can always move from explanation
      case LessonStep.recitation:
        return true; // Can always move from recitation
      case LessonStep.recording:
        // TODO: Re-enable when recording feature is active
        return true; // Temporarily allow skip since recording is disabled
        // return hasRecorded; // Must record before continuing
      case LessonStep.quiz1:
        return quiz1Correct == true; // Must answer correctly
      case LessonStep.quiz2:
        return quiz2Correct == true; // Must answer correctly
      case LessonStep.celebration:
        return true; // Allow completing the lesson!
    }
  }

  /// Can we go back?
  bool get canGoBack => !currentStep.isFirst;

  @override
  String toString() {
    return 'LessonFlowState(Surah $surahNumber, Verse $verseNumber, Step ${currentStep.stepNumber})';
  }
}

