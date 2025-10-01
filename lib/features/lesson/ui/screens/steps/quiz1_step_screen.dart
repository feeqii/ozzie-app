import 'package:flutter/material.dart';
import 'package:ozzie/core/constants/app_colors.dart';
import 'package:ozzie/core/constants/app_sizes.dart';
import 'package:ozzie/core/constants/app_text_styles.dart';
import 'package:ozzie/core/widgets/ozzie_card.dart';
import 'package:ozzie/core/widgets/ozzie_placeholder.dart';
import 'package:ozzie/features/lesson/data/models/verse_model.dart';

/// ❓ QUIZ 1 STEP SCREEN (Step 4 of 6)
/// 
/// Drag and drop words into the correct order!
/// 
/// WHAT THIS DOES:
/// - Shows empty slots for the verse (right-to-left for Arabic)
/// - Shows scrambled Arabic words below
/// - Kid drags words into slots
/// - Check answer button
/// - Feedback (correct/incorrect)
/// - Hint option if stuck

class Quiz1StepScreen extends StatefulWidget {
  final Verse verse;
  final Function(List<String>) onAnswerSubmit;

  const Quiz1StepScreen({
    super.key,
    required this.verse,
    required this.onAnswerSubmit,
  });

  @override
  State<Quiz1StepScreen> createState() => _Quiz1StepScreenState();
}

class _Quiz1StepScreenState extends State<Quiz1StepScreen> {
  List<String> availableWords = [];
  List<String?> slots = []; // null = empty slot, String = word in slot
  bool hasSubmitted = false;
  bool? isCorrect;
  bool showHint = false;

  @override
  void initState() {
    super.initState();
    _setupWords();
  }

  void _setupWords() {
    // Get all words from the verse
    final words = widget.verse.words.map((w) => w.arabic).toList();
    
    // Create empty slots (one for each word)
    slots = List<String?>.filled(words.length, null);
    
    // Shuffle words for the word bank
    availableWords = List.from(words)..shuffle();
    
    setState(() {});
  }

  void _placeWordInSlot(String word, int slotIndex) {
    if (hasSubmitted) return;

    setState(() {
      // Remove word from any existing slot
      for (int i = 0; i < slots.length; i++) {
        if (slots[i] == word) {
          slots[i] = null;
        }
      }
      
      // Place word in new slot
      slots[slotIndex] = word;
    });
  }

  void _removeWordFromSlot(int slotIndex) {
    if (hasSubmitted) return;
    
    setState(() {
      slots[slotIndex] = null;
    });
  }

  void _checkAnswer() {
    // Build answer from slots (slots are already in correct position order)
    final answer = slots.whereType<String>().toList();
    
    // Submit answer to controller
    final correct = widget.onAnswerSubmit(answer);
    
    setState(() {
      hasSubmitted = true;
      isCorrect = correct;
    });
  }

  void _tryAgain() {
    setState(() {
      hasSubmitted = false;
      isCorrect = null;
      showHint = false;
    });
    _setupWords();
  }

  void _toggleHint() {
    setState(() {
      showHint = !showHint;
    });
  }

  bool get _canSubmit {
    // All slots must be filled
    return !slots.contains(null);
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
            'Put the Words in Order',
            style: AppTextStyles.headingMedium.copyWith(
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSizes.spaceSmall),

          OzzieCard(
            backgroundColor: AppColors.info.withOpacity(0.1),
            borderColor: AppColors.info,
            child: Column(
              children: [
                const Icon(Icons.info_outline, color: AppColors.info, size: 20),
                const SizedBox(height: AppSizes.spaceSmall),
                Text(
                  'Drag words in order: 1st → 2nd → 3rd → 4th',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSizes.spaceSmall),
                Text(
                  'Hint: بِسْمِ is the FIRST word!',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontStyle: FontStyle.italic,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSizes.spaceLarge),

          // Answer slots (where words go)
          _buildAnswerSlots(),

          const SizedBox(height: AppSizes.spaceXLarge),

          // Available words (to drag from)
          _buildWordBank(),

          const SizedBox(height: AppSizes.spaceLarge),

          // Hint button
          if (!hasSubmitted)
            OutlinedButton.icon(
              onPressed: _toggleHint,
              icon: Icon(showHint ? Icons.visibility_off : Icons.lightbulb),
              label: Text(showHint ? 'Hide Hint' : 'Show Hint'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
              ),
            ),

          if (showHint) ...[
            const SizedBox(height: AppSizes.spaceMedium),
            OzzieCard(
              backgroundColor: AppColors.info.withOpacity(0.1),
              borderColor: AppColors.info,
              child: Column(
                children: [
                  const Icon(Icons.lightbulb, color: AppColors.info),
                  const SizedBox(height: AppSizes.spaceSmall),
                  Text(
                    'Hint: ${widget.verse.transliteration}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: AppSizes.spaceLarge),

          // Check answer button
          if (!hasSubmitted && _canSubmit)
            ElevatedButton.icon(
              onPressed: _checkAnswer,
              icon: const Icon(Icons.check_circle),
              label: const Text('Check Answer'),
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

  /// Answer slots (drag targets)
  Widget _buildAnswerSlots() {
    return OzzieCard(
      backgroundColor: AppColors.white,
      borderColor: hasSubmitted
          ? (isCorrect! ? AppColors.success : AppColors.error)
          : AppColors.primary.withOpacity(0.3),
      borderWidth: hasSubmitted ? 3 : 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Answer:',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSizes.spaceMedium),
          
          // Slots displayed in a single row, horizontally scrollable if needed
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(slots.length, (index) {
                return Padding(
                  padding: EdgeInsets.only(
                    right: index < slots.length - 1 ? AppSizes.spaceSmall : 0,
                  ),
                  child: _buildSlot(index),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  /// Individual slot (drag target)
  Widget _buildSlot(int index) {
    final word = slots[index];
    final isEmpty = word == null;

    return DragTarget<String>(
      onWillAccept: (data) => !hasSubmitted, // Only accept if not submitted
      onAccept: (data) {
        _placeWordInSlot(data, index);
      },
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;
        
        return Container(
          width: 90,
          height: 100,
          decoration: BoxDecoration(
            color: isEmpty
                ? (isHovering ? AppColors.primary.withOpacity(0.1) : AppColors.lightGray.withOpacity(0.3))
                : AppColors.primary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            border: Border.all(
              color: isHovering
                  ? AppColors.primary
                  : (isEmpty ? AppColors.mediumGray : AppColors.primary),
              width: isHovering ? 3 : 2,
            ),
          ),
          child: isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${index + 1}',
                        style: AppTextStyles.headingMedium.copyWith(
                          color: AppColors.mediumGray,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        index == 0 ? '1st word' 
                        : index == 1 ? '2nd word'
                        : index == 2 ? '3rd word'
                        : '4th word',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.mediumGray,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                )
              : GestureDetector(
                  onTap: hasSubmitted ? null : () => _removeWordFromSlot(index),
                  child: Stack(
                    children: [
                      Center(
                        child: Text(
                          word!,
                          style: AppTextStyles.quranWord.copyWith(fontSize: 24),
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                      if (!hasSubmitted)
                        Positioned(
                          top: 2,
                          right: 2,
                          child: Icon(
                            Icons.cancel,
                            size: 16,
                            color: AppColors.error.withOpacity(0.7),
                          ),
                        ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  /// Word bank (draggable words)
  Widget _buildWordBank() {
    // Filter out words that are already placed in slots
    final wordsInSlots = slots.whereType<String>().toSet();
    final draggableWords = availableWords.where((word) => !wordsInSlots.contains(word)).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Words:',
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSizes.spaceSmall),
        
        draggableWords.isEmpty
            ? Center(
                child: Text(
                  '✓ All words placed',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.success,
                  ),
                ),
              )
            : Wrap(
                spacing: AppSizes.spaceSmall,
                runSpacing: AppSizes.spaceSmall,
                alignment: WrapAlignment.center,
                children: draggableWords.map((word) {
                  return _buildDraggableWord(word);
                }).toList(),
              ),
      ],
    );
  }

  /// Draggable word
  Widget _buildDraggableWord(String word) {
    if (hasSubmitted) {
      // Not draggable after submission
      return _buildWordChip(word, isDragging: false);
    }

    return Draggable<String>(
      data: word,
      feedback: Material(
        color: Colors.transparent,
        child: Opacity(
          opacity: 0.8,
          child: _buildWordChip(word, isDragging: true),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: _buildWordChip(word, isDragging: false),
      ),
      child: _buildWordChip(word, isDragging: false),
    );
  }

  /// Word chip widget
  Widget _buildWordChip(String word, {required bool isDragging}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceLarge,
        vertical: AppSizes.spaceMedium,
      ),
      decoration: BoxDecoration(
        color: isDragging ? AppColors.primary : AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        border: Border.all(
          color: AppColors.primary,
          width: 2,
        ),
        boxShadow: isDragging
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Text(
        word,
        style: AppTextStyles.quranWord.copyWith(
          fontSize: 28,
          color: isDragging ? AppColors.white : AppColors.textPrimary,
        ),
        textDirection: TextDirection.rtl,
      ),
    );
  }

  /// Feedback after submission
  Widget _buildFeedback() {
    return Column(
      children: [
        const SizedBox(height: AppSizes.spaceLarge),
        
        OzziePlaceholder(
          size: OzzieSize.medium,
          expression: isCorrect! 
              ? OzzieExpression.celebrating 
              : OzzieExpression.thinking,
          animated: true,
        ),

        const SizedBox(height: AppSizes.spaceMedium),

        OzzieCard(
          backgroundColor: isCorrect!
              ? AppColors.success.withOpacity(0.1)
              : AppColors.error.withOpacity(0.1),
          borderColor: isCorrect! ? AppColors.success : AppColors.error,
          borderWidth: 2,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isCorrect! ? Icons.emoji_events : Icons.info,
                    color: isCorrect! ? AppColors.success : AppColors.error,
                    size: 32,
                  ),
                  const SizedBox(width: AppSizes.spaceSmall),
                  Text(
                    isCorrect! ? 'Perfect!' : 'Not Quite',
                    style: AppTextStyles.headingMedium.copyWith(
                      color: isCorrect! ? AppColors.success : AppColors.error,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.spaceMedium),
              Text(
                isCorrect!
                    ? 'Amazing! You put all the words in the right order! 🎉'
                    : 'Not quite right. Try again! Remember: ${widget.verse.transliteration}',
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
                    foregroundColor: AppColors.error,
                  ),
                ),
              ],
            ],
          ),
        ),

        if (isCorrect!) ...[
          const SizedBox(height: AppSizes.spaceMedium),
          Text(
            'Tap "Next" to continue! 🚀',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}
