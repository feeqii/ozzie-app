import 'package:flutter/material.dart';
import 'package:ozzie/core/constants/app_colors.dart';
import 'package:ozzie/core/constants/app_sizes.dart';
import 'package:ozzie/core/constants/app_text_styles.dart';
import 'package:ozzie/core/widgets/ozzie_card.dart';
import 'package:ozzie/core/widgets/ozzie_placeholder.dart';
import 'package:ozzie/features/lesson/data/models/verse_model.dart';

/// ❓ QUIZ 2 STEP SCREEN (Step 5 of 6)
/// 
/// Comprehension quiz - Test understanding!
/// 
/// WHAT THIS DOES:
/// - Shows a comprehension question about the verse
/// - 4 multiple choice answers
/// - Kid selects one answer
/// - Submit button
/// - Immediate feedback (correct/incorrect)
/// - Explanation if wrong
/// 
/// NOTE: Questions are hardcoded for now
/// TODO: Add questions to verse JSON data for scalability

class Quiz2StepScreen extends StatefulWidget {
  final Verse verse;
  final Function({required String answer, required String correctAnswer}) onAnswerSubmit;

  const Quiz2StepScreen({
    super.key,
    required this.verse,
    required this.onAnswerSubmit,
  });

  @override
  State<Quiz2StepScreen> createState() => _Quiz2StepScreenState();
}

class _Quiz2StepScreenState extends State<Quiz2StepScreen> {
  String? selectedAnswer;
  bool hasSubmitted = false;
  bool? isCorrect;

  // Quiz data (hardcoded for now)
  late QuizQuestion question;

  @override
  void initState() {
    super.initState();
    question = _getQuestionForVerse(widget.verse.verseNumber);
  }

  /// Get quiz question based on verse number
  /// 
  /// TODO: Move these to JSON data for easier management
  QuizQuestion _getQuestionForVerse(int verseNumber) {
    // Questions for Al-Fatiha verses
    switch (verseNumber) {
      case 1:
        return QuizQuestion(
          question: "What does 'Bismillah' mean?",
          options: [
            "In the name of Allah",
            "Praise be to Allah",
            "There is no god but Allah",
            "Allah is the Greatest",
          ],
          correctAnswer: "In the name of Allah",
          explanation: "'Bismillah' means 'In the name of Allah'. Muslims say this before starting anything to remember Allah!",
        );
      
      case 2:
        return QuizQuestion(
          question: "Who is this verse praising?",
          options: [
            "Allah, the Lord of all worlds",
            "The Prophet Muhammad",
            "The angels",
            "Our parents",
          ],
          correctAnswer: "Allah, the Lord of all worlds",
          explanation: "This verse praises Allah, who is the Lord and Creator of everything in all the worlds!",
        );
      
      case 3:
        return QuizQuestion(
          question: "What are the two names of Allah mentioned?",
          options: [
            "Ar-Rahman and Ar-Raheem (The Most Merciful)",
            "Al-Malik and Al-Quddus (The King and The Holy)",
            "As-Salam and Al-Mumin (The Peace and The Believer)",
            "Al-Aziz and Al-Hakeem (The Mighty and The Wise)",
          ],
          correctAnswer: "Ar-Rahman and Ar-Raheem (The Most Merciful)",
          explanation: "Ar-Rahman means Allah is very merciful to everyone, and Ar-Raheem means He is especially merciful to believers!",
        );
      
      case 4:
        return QuizQuestion(
          question: "What day is mentioned in this verse?",
          options: [
            "The Day of Judgment",
            "The Day of Friday",
            "The Day of Eid",
            "The Day of Arafah",
          ],
          correctAnswer: "The Day of Judgment",
          explanation: "This verse talks about the Day of Judgment, when Allah will judge all people for their deeds!",
        );
      
      case 5:
        return QuizQuestion(
          question: "What do we ask Allah in this verse?",
          options: [
            "To worship only Him and seek His help",
            "To give us food and water",
            "To make us rich",
            "To give us many friends",
          ],
          correctAnswer: "To worship only Him and seek His help",
          explanation: "We promise to worship only Allah and ask only Him for help in everything we do!",
        );
      
      case 6:
        return QuizQuestion(
          question: "What path do we ask Allah to guide us to?",
          options: [
            "The straight path",
            "The easy path",
            "The wide path",
            "The short path",
          ],
          correctAnswer: "The straight path",
          explanation: "The straight path (As-Sirat Al-Mustaqeem) is the path of Islam that leads to Allah's pleasure and Paradise!",
        );
      
      case 7:
        return QuizQuestion(
          question: "Who walked the straight path that we want to follow?",
          options: [
            "Those Allah blessed (the Prophets and righteous people)",
            "The angels in heaven",
            "The rich and famous people",
            "The kings and rulers",
          ],
          correctAnswer: "Those Allah blessed (the Prophets and righteous people)",
          explanation: "We want to follow the path of those Allah blessed, like the Prophets, companions, and all righteous Muslims!",
        );
      
      // Default question for other verses
      default:
        return QuizQuestion(
          question: "What is the main message of this verse?",
          options: [
            "To remember Allah and follow His guidance",
            "To be kind to animals",
            "To study hard in school",
            "To play sports",
          ],
          correctAnswer: "To remember Allah and follow His guidance",
          explanation: "The Quran teaches us to always remember Allah and follow His guidance in our lives!",
        );
    }
  }

  void _selectAnswer(String answer) {
    if (hasSubmitted) return; // Can't change after submission
    
    setState(() {
      selectedAnswer = answer;
    });
  }

  void _submitAnswer() {
    if (selectedAnswer == null) return;
    
    // Submit to controller
    final correct = widget.onAnswerSubmit(
      answer: selectedAnswer!,
      correctAnswer: question.correctAnswer,
    );
    
    setState(() {
      hasSubmitted = true;
      isCorrect = correct;
    });
  }

  void _tryAgain() {
    setState(() {
      selectedAnswer = null;
      hasSubmitted = false;
      isCorrect = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Title
          Text(
            'Understanding Check',
            style: AppTextStyles.headingMedium.copyWith(
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSizes.spaceSmall),

          Text(
            'Show what you learned!',
            style: AppTextStyles.bodyLarge,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSizes.spaceLarge),

          // Question card
          OzzieCard(
            backgroundColor: AppColors.primary.withOpacity(0.1),
            borderColor: AppColors.primary.withOpacity(0.3),
            borderWidth: 2,
            child: Column(
              children: [
                Icon(
                  Icons.quiz,
                  size: 48,
                  color: AppColors.primary,
                ),
                const SizedBox(height: AppSizes.spaceMedium),
                Text(
                  question.question,
                  style: AppTextStyles.headingSmall.copyWith(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSizes.spaceLarge),

          // Answer options
          ...question.options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            final isSelected = selectedAnswer == option;
            final isCorrectOption = option == question.correctAnswer;
            
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.spaceMedium),
              child: _buildAnswerOption(
                option: option,
                index: index,
                isSelected: isSelected,
                isCorrectOption: isCorrectOption,
              ),
            );
          }),

          const SizedBox(height: AppSizes.spaceLarge),

          // Submit button
          if (!hasSubmitted && selectedAnswer != null)
            ElevatedButton.icon(
              onPressed: _submitAnswer,
              icon: const Icon(Icons.check_circle),
              label: const Text('Submit Answer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.cardPadding,
                  vertical: AppSizes.spaceMedium,
                ),
              ),
            ),

          // Feedback
          if (hasSubmitted) _buildFeedback(),
        ],
      ),
    );
  }

  /// Answer option button
  Widget _buildAnswerOption({
    required String option,
    required int index,
    required bool isSelected,
    required bool isCorrectOption,
  }) {
    // Determine color
    Color? backgroundColor;
    Color? borderColor;
    
    if (hasSubmitted) {
      if (isCorrectOption) {
        backgroundColor = AppColors.success.withOpacity(0.2);
        borderColor = AppColors.success;
      } else if (isSelected) {
        backgroundColor = AppColors.error.withOpacity(0.2);
        borderColor = AppColors.error;
      } else {
        backgroundColor = AppColors.white;
        borderColor = AppColors.lightGray;
      }
    } else {
      backgroundColor = isSelected 
          ? AppColors.primary.withOpacity(0.2) 
          : AppColors.white;
      borderColor = isSelected ? AppColors.primary : AppColors.lightGray;
    }

    // Letter labels (A, B, C, D)
    final labels = ['A', 'B', 'C', 'D'];
    final label = labels[index];

    return GestureDetector(
      onTap: hasSubmitted ? null : () => _selectAnswer(option),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.cardPadding),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          border: Border.all(
            color: borderColor!,
            width: isSelected || (hasSubmitted && isCorrectOption) ? 3 : 2,
          ),
        ),
        child: Row(
          children: [
            // Letter badge
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: borderColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  label,
                  style: AppTextStyles.button.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(width: AppSizes.spaceMedium),

            // Answer text
            Expanded(
              child: Text(
                option,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),

            // Check/X icon (after submission)
            if (hasSubmitted) ...[
              const SizedBox(width: AppSizes.spaceSmall),
              if (isCorrectOption)
                const Icon(Icons.check_circle, color: AppColors.success, size: 28)
              else if (isSelected)
                const Icon(Icons.cancel, color: AppColors.error, size: 28),
            ],
          ],
        ),
      ),
    );
  }

  /// Feedback after submission
  Widget _buildFeedback() {
    return Column(
      children: [
        const SizedBox(height: AppSizes.spaceLarge),
        
        // Ozzie feedback
        OzziePlaceholder(
          size: OzzieSize.medium,
          expression: isCorrect! 
              ? OzzieExpression.celebrating 
              : OzzieExpression.thinking,
          animated: true,
        ),

        const SizedBox(height: AppSizes.spaceMedium),

        // Feedback card
        OzzieCard(
          backgroundColor: isCorrect!
              ? AppColors.success.withOpacity(0.1)
              : AppColors.warning.withOpacity(0.1),
          borderColor: isCorrect! ? AppColors.success : AppColors.warning,
          borderWidth: 2,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isCorrect! ? Icons.emoji_events : Icons.info,
                    color: isCorrect! ? AppColors.success : AppColors.warning,
                    size: 32,
                  ),
                  const SizedBox(width: AppSizes.spaceSmall),
                  Text(
                    isCorrect! ? 'Correct!' : 'Not Quite',
                    style: AppTextStyles.headingMedium.copyWith(
                      color: isCorrect! ? AppColors.success : AppColors.warning,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.spaceMedium),
              Text(
                question.explanation,
                style: AppTextStyles.bodyLarge,
                textAlign: TextAlign.center,
              ),
              if (!isCorrect!) ...[
                const SizedBox(height: AppSizes.spaceMedium),
                OutlinedButton.icon(
                  onPressed: _tryAgain,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.warning,
                  ),
                ),
              ],
            ],
          ),
        ),

        if (isCorrect!) ...[
          const SizedBox(height: AppSizes.spaceMedium),
          Text(
            'Tap "Next" to celebrate! 🎉',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}

/// Quiz question model
class QuizQuestion {
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String explanation;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
  });
}
