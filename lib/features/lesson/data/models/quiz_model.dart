/// 📝 QUIZ MODEL
/// 
/// Represents a quiz question for a verse.
/// 
/// WHAT IS THIS?
/// This is a reusable structure for quiz questions.
/// Used in both Quiz 1 (word order) and Quiz 2 (comprehension).
/// 
/// WHY?
/// - Keep quiz data consistent across all verses
/// - Easy to load from JSON
/// - Scalable for all 114 Surahs
/// 
/// EXAMPLE USAGE:
/// ```dart
/// Quiz quiz = Quiz(
///   question: "What does Bismillah mean?",
///   options: ["In the name of Allah", "Praise Allah", ...],
///   correctAnswerIndex: 0,
///   explanation: "Bismillah means...",
/// );
/// ```
class Quiz {
  /// The question text
  /// Example: "What does 'Bismillah' mean?"
  final String question;
  
  /// List of answer options (usually 4)
  /// Example: ["In the name of Allah", "Praise Allah", ...]
  final List<String> options;
  
  /// Index of the correct answer (0-based)
  /// Example: 0 means first option is correct
  final int correctAnswerIndex;
  
  /// Explanation of the answer
  /// Shown after user answers (whether correct or not)
  final String explanation;
  
  /// Optional hint (for Quiz 1)
  /// Example: "Listen to the recitation if you need help!"
  final String? hint;
  
  /// Optional instruction text (for Quiz 1)
  /// Example: "Put the words in the correct order"
  final String? instruction;

  const Quiz({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
    this.hint,
    this.instruction,
  });

  /// Create Quiz from JSON
  /// 
  /// Example JSON:
  /// ```json
  /// {
  ///   "question": "What does Bismillah mean?",
  ///   "options": ["Answer 1", "Answer 2", ...],
  ///   "correctAnswerIndex": 0,
  ///   "explanation": "Bismillah means...",
  ///   "hint": "Think about..."
  /// }
  /// ```
  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      question: json['question'] as String,
      options: (json['options'] as List<dynamic>)
          .map((option) => option as String)
          .toList(),
      correctAnswerIndex: json['correctAnswerIndex'] as int,
      explanation: json['explanation'] as String,
      hint: json['hint'] as String?,
      instruction: json['instruction'] as String?,
    );
  }

  /// Convert Quiz to JSON
  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
      'explanation': explanation,
      if (hint != null) 'hint': hint,
      if (instruction != null) 'instruction': instruction,
    };
  }

  /// Helper: Get the correct answer text
  String get correctAnswer {
    if (correctAnswerIndex >= 0 && correctAnswerIndex < options.length) {
      return options[correctAnswerIndex];
    }
    return '';
  }

  /// Helper: Check if an answer is correct
  bool isCorrect(String answer) {
    return answer == correctAnswer;
  }

  /// Helper: Check if an answer index is correct
  bool isCorrectIndex(int index) {
    return index == correctAnswerIndex;
  }

  /// Copy with modifications
  Quiz copyWith({
    String? question,
    List<String>? options,
    int? correctAnswerIndex,
    String? explanation,
    String? hint,
    String? instruction,
  }) {
    return Quiz(
      question: question ?? this.question,
      options: options ?? this.options,
      correctAnswerIndex: correctAnswerIndex ?? this.correctAnswerIndex,
      explanation: explanation ?? this.explanation,
      hint: hint ?? this.hint,
      instruction: instruction ?? this.instruction,
    );
  }

  @override
  String toString() {
    return 'Quiz(question: "$question", ${options.length} options, correct: $correctAnswerIndex)';
  }
}

