import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ozzie/core/constants/app_colors.dart';
import 'package:ozzie/core/constants/app_sizes.dart';
import 'package:ozzie/core/constants/app_text_styles.dart';
import 'package:ozzie/core/widgets/ozzie_card.dart';
import 'package:ozzie/core/widgets/micro_celebration.dart';
import 'package:ozzie/features/lesson/data/models/verse_model.dart';
import 'package:ozzie/features/lesson/data/models/quiz_model.dart';

/// ❓ QUIZ 2 STEP SCREEN (Step 5 of 6)
/// 
/// Comprehension quiz - One-page, Duolingo-inspired experience!
/// 
/// FLOW:
/// - Shows comprehension question
/// - 4 multiple choice options (A, B, C, D)
/// - Wrong answer → Shake + haptic + bottom toast → Auto-reset
/// - Correct answer → Green highlight → Micro celebration → Auto-advance
/// - No scrolling, no explanation cards, clean one-page UX
/// 
/// NOTE: Quiz questions loaded from JSON! 🎉

class Quiz2StepScreen extends StatefulWidget {
  final Verse verse;
  final Function({required String answer, required String correctAnswer}) onAnswerSubmit;
  final VoidCallback? onStepComplete; // Callback when quiz is done

  const Quiz2StepScreen({
    super.key,
    required this.verse,
    required this.onAnswerSubmit,
    this.onStepComplete,
  });

  @override
  State<Quiz2StepScreen> createState() => _Quiz2StepScreenState();
}

class _Quiz2StepScreenState extends State<Quiz2StepScreen> with SingleTickerProviderStateMixin {
  String? selectedAnswer;
  bool isProcessing = false;
  String? wrongAnswerMessage;
  
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  // Quiz data loaded from verse
  Quiz? get quiz => widget.verse.quiz2;

  @override
  void initState() {
    super.initState();
    
    // Shake animation for wrong answers
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _shakeAnimation = Tween<double>(begin: 0, end: 10).chain(
      CurveTween(curve: Curves.elasticIn),
    ).animate(_shakeController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _shakeController.reverse();
        }
      });
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  /// Get quiz question - now from JSON data!
  /// 
  /// If quiz2 is not in the JSON, we show a fallback question
  Quiz _getQuestion() {
    // Try to get quiz from verse data
    if (quiz != null) {
      return quiz!;
    }
    
    // Fallback question if quiz2 is missing from JSON
    return _getFallbackQuestion(widget.verse.verseNumber);
  }

  /// Fallback question (for backwards compatibility)
  /// This is only used if quiz2 is missing from the JSON
  Quiz _getFallbackQuestion(int verseNumber) {
    // Default fallback question
    return Quiz(
      question: "What is the main message of this verse?",
      options: [
        "To remember Allah and follow His guidance",
        "To be kind to animals",
        "To study hard in school",
        "To play sports",
      ],
      correctAnswerIndex: 0,
      explanation: "The Quran teaches us to always remember Allah and follow His guidance in our lives!",
    );
  }

  void _selectAnswer(String answer) {
    if (isProcessing) return; // Prevent multiple taps
    
    final question = _getQuestion();
    final isCorrect = answer == question.correctAnswer;
    
    setState(() {
      selectedAnswer = answer;
      isProcessing = true;
    });
    
    // Submit to controller
    widget.onAnswerSubmit(
      answer: answer,
      correctAnswer: question.correctAnswer,
    );
    
    if (isCorrect) {
      // ✅ CORRECT: Wait → Micro celebration → Auto-advance
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          MicroCelebration.show(
            context,
            onComplete: () {
              widget.onStepComplete?.call();
            },
          );
        }
      });
    } else {
      // ❌ WRONG: Shake + haptic + toast → Auto-reset
      HapticFeedback.heavyImpact();
      _shakeController.forward();
      
      setState(() {
        wrongAnswerMessage = "Not quite! Try again 💭";
      });
      
      // Auto-reset after 1 second
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) {
          setState(() {
            selectedAnswer = null;
            isProcessing = false;
            wrongAnswerMessage = null;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = _getQuestion();
    
    return Stack(
      children: [
        // Main content
        Padding(
          padding: const EdgeInsets.all(AppSizes.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Compact header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Understanding Check',
                    style: AppTextStyles.headingMedium.copyWith(
                      color: AppColors.primary,
                      fontSize: 20,
                    ),
                  ),
                  // Info icon (optional - could show hints later)
                  IconButton(
                    icon: const Icon(Icons.info_outline, color: AppColors.primary),
                    onPressed: () {
                      // Could show explanation or hint
                    },
                  ),
                ],
              ),

              const SizedBox(height: AppSizes.spaceMedium),

              // Question card - more compact
              AnimatedBuilder(
                animation: _shakeAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_shakeAnimation.value, 0),
                    child: child,
                  );
                },
                child: OzzieCard(
                  backgroundColor: AppColors.primary.withOpacity(0.05),
                  borderColor: AppColors.primary.withOpacity(0.2),
                  borderWidth: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSizes.cardPadding),
                    child: Text(
                      question.question,
                      style: AppTextStyles.headingSmall.copyWith(
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSizes.spaceLarge),

              // Answer options - more compact
              Expanded(
                child: ListView(
                  children: question.options.asMap().entries.map((entry) {
                    final index = entry.key;
                    final option = entry.value;
                    final isSelected = selectedAnswer == option;
                    final isCorrect = option == question.correctAnswer;
                    
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSizes.spaceSmall),
                      child: _buildAnswerOption(
                        option: option,
                        index: index,
                        isSelected: isSelected,
                        showAsCorrect: isSelected && isCorrect && isProcessing,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),

        // Bottom toast for wrong answers
        if (wrongAnswerMessage != null)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomToast(),
          ),
      ],
    );
  }

  /// Answer option button - clean, one-page design
  Widget _buildAnswerOption({
    required String option,
    required int index,
    required bool isSelected,
    required bool showAsCorrect,
  }) {
    // Determine color based on state
    Color backgroundColor;
    Color borderColor;
    
    if (showAsCorrect) {
      // Correct answer selected
      backgroundColor = AppColors.success.withOpacity(0.2);
      borderColor = AppColors.success;
    } else if (isSelected && isProcessing) {
      // Wrong answer selected (during processing)
      backgroundColor = AppColors.error.withOpacity(0.2);
      borderColor = AppColors.error;
    } else if (isSelected) {
      // Selected but not yet processed
      backgroundColor = AppColors.primary.withOpacity(0.1);
      borderColor = AppColors.primary;
    } else {
      // Default state
      backgroundColor = AppColors.white;
      borderColor = AppColors.lightGray;
    }

    // Letter labels (A, B, C, D)
    final labels = ['A', 'B', 'C', 'D'];
    final label = labels[index];

    return GestureDetector(
      onTap: isProcessing ? null : () => _selectAnswer(option),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.cardPadding,
          vertical: AppSizes.spaceMedium,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          border: Border.all(
            color: borderColor,
            width: isSelected ? 3 : 2,
          ),
        ),
        child: Row(
          children: [
            // Letter badge
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: borderColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  label,
                  style: AppTextStyles.button.copyWith(
                    color: AppColors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ),

            const SizedBox(width: AppSizes.spaceMedium),

            // Answer text
            Expanded(
              child: Text(
                option,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),

            // Icons only for selected answers
            if (isSelected && isProcessing) ...[
              const SizedBox(width: AppSizes.spaceSmall),
              if (showAsCorrect)
                const Icon(Icons.check_circle, color: AppColors.success, size: 24)
              else
                const Icon(Icons.cancel, color: AppColors.error, size: 24),
            ],
          ],
        ),
      ),
    );
  }

  /// Bottom toast for wrong answers (like Quiz 1)
  Widget _buildBottomToast() {
    return Container(
      margin: const EdgeInsets.all(AppSizes.screenPadding),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.cardPadding,
        vertical: AppSizes.spaceMedium,
      ),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.9),
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.info_outline,
            color: AppColors.white,
            size: 20,
          ),
          const SizedBox(width: AppSizes.spaceSmall),
          Text(
            wrongAnswerMessage!,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
