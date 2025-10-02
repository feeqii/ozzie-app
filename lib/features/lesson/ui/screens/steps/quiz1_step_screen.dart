import 'package:flutter/material.dart';
import 'package:ozzie/core/constants/app_colors.dart';
import 'package:ozzie/core/constants/app_sizes.dart';
import 'package:ozzie/core/constants/app_text_styles.dart';
import 'package:ozzie/core/widgets/ozzie_card.dart';
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
  List<String> correctWords = []; // The correct word order
  int currentSlotIndex = 0; // Which slot we're currently filling (0-based)
  bool showHint = false;
  bool showWrongFeedback = false; // For "Try Again!" popup

  @override
  void initState() {
    super.initState();
    _setupWords();
  }

  void _setupWords() {
    // Get all words from the verse in correct order
    correctWords = widget.verse.words.map((w) => w.arabic).toList();
    
    // Create empty slots (one for each word)
    slots = List<String?>.filled(correctWords.length, null);
    
    // Shuffle words for the word bank
    availableWords = List.from(correctWords)..shuffle();
    
    // Start at the first slot
    currentSlotIndex = 0;
    
    setState(() {});
  }

  /// Handle word placement with immediate validation
  void _placeWordInSlot(String word, int slotIndex) {
    // Only allow placing in the current active slot
    if (slotIndex != currentSlotIndex) {
      return; // Ignore drops on non-active slots
    }
    
    // Check if this is the correct word for this position
    final correctWord = correctWords[slotIndex];
    
    if (word == correctWord) {
      // ✅ CORRECT! Lock it in and move to next slot
      setState(() {
        slots[slotIndex] = word;
        currentSlotIndex++;
        
        // Check if we've completed all slots
        if (currentSlotIndex >= slots.length) {
          _onAllSlotsCorrect();
        }
      });
    } else {
      // ❌ WRONG! Show feedback and bounce back
      setState(() {
        showWrongFeedback = true;
      });
      
      // Hide feedback after 1.5 seconds
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          setState(() {
            showWrongFeedback = false;
          });
        }
      });
    }
  }

  /// Called when all slots are filled correctly
  void _onAllSlotsCorrect() {
    // Submit the complete answer
    widget.onAnswerSubmit(slots.whereType<String>().toList());
    
    // Small delay then show success feedback
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        // The parent will handle navigation to next step
      }
    });
  }

  void _toggleHint() {
    setState(() {
      showHint = !showHint;
    });
  }
  
  /// Check if a slot is locked (already filled correctly)
  bool _isSlotLocked(int index) => index < currentSlotIndex;
  
  /// Check if a slot is the active one
  bool _isSlotActive(int index) => index == currentSlotIndex;
  
  /// Check if all slots are completed
  bool get _isCompleted => currentSlotIndex >= slots.length;

  /// Get ordinal label for slot (1st, 2nd, 3rd, etc.)
  String _getOrdinalLabel(int index) {
    final position = index + 1;
    if (position == 1) return '1st word';
    if (position == 2) return '2nd word';
    if (position == 3) return '3rd word';
    return '${position}th word';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Drag words starting from the ',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'RIGHT',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          ' ←',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.spaceSmall),
                    Text(
                      'Place words one at a time - each must be correct!',
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

              // Hint button (only show if not completed)
              if (!_isCompleted)
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
            ],
          ),
        ),
        
        // "Try Again!" popup overlay (shown when wrong word is dropped)
        if (showWrongFeedback)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: OzzieCard(
                  backgroundColor: AppColors.error.withOpacity(0.95),
                  borderColor: AppColors.error,
                  borderWidth: 3,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 64,
                      ),
                      const SizedBox(height: AppSizes.spaceMedium),
                      Text(
                        'Try Again!',
                        style: AppTextStyles.headingLarge.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: AppSizes.spaceSmall),
                      Text(
                        'That\'s not the right word for this spot',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// Answer slots (drag targets)
  Widget _buildAnswerSlots() {
    // Card border color: green if all complete, primary if in progress
    final cardBorderColor = _isCompleted 
        ? AppColors.success 
        : AppColors.primary.withOpacity(0.3);
    
    return OzzieCard(
      backgroundColor: AppColors.white,
      borderColor: cardBorderColor,
      borderWidth: _isCompleted ? 3 : 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Answer:',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '← Read this way',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spaceMedium),
          
          // Slots displayed RTL (right-to-left), horizontally scrollable if needed
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
              }).reversed.toList(), // ← RTL: Reverse visual order!
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
    final isLocked = _isSlotLocked(index);
    final isActive = _isSlotActive(index);

    return DragTarget<String>(
      onWillAccept: (data) => isActive, // Only accept drops on the active slot
      onAccept: (data) {
        _placeWordInSlot(data, index);
      },
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty && isActive;
        
        // Determine colors based on state
        Color backgroundColor;
        Color borderColor;
        int borderWidth;
        
        if (isLocked) {
          // Locked (correct) - green
          backgroundColor = AppColors.success.withOpacity(0.2);
          borderColor = AppColors.success;
          borderWidth = 3;
        } else if (isActive) {
          // Active slot - highlighted
          backgroundColor = isHovering 
              ? AppColors.primary.withOpacity(0.2) 
              : AppColors.primary.withOpacity(0.1);
          borderColor = isHovering ? AppColors.primary : AppColors.primary.withOpacity(0.5);
          borderWidth = isHovering ? 3 : 2;
        } else {
          // Future slot - dimmed
          backgroundColor = AppColors.lightGray.withOpacity(0.2);
          borderColor = AppColors.mediumGray.withOpacity(0.3);
          borderWidth = 1;
        }
        
        return Container(
          width: 90,
          height: 100,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            border: Border.all(
              color: borderColor,
              width: borderWidth.toDouble(),
            ),
          ),
          child: isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isLocked)
                        const Icon(Icons.check_circle, color: AppColors.success, size: 32)
                      else ...[
                        Text(
                          '${index + 1}',
                          style: AppTextStyles.headingMedium.copyWith(
                            color: isActive ? AppColors.primary : AppColors.mediumGray.withOpacity(0.5),
                            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getOrdinalLabel(index),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: isActive ? AppColors.primary : AppColors.mediumGray.withOpacity(0.5),
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ],
                  ),
                )
              : Center(
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
                      // Locked indicator (checkmark)
                      if (isLocked)
                        Positioned(
                          top: 2,
                          right: 2,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: AppColors.success,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              size: 12,
                              color: Colors.white,
                            ),
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
    // We need to handle duplicate words, so we track by index instead of value
    final List<String> draggableWords = [];
    
    for (int i = 0; i < availableWords.length; i++) {
      final word = availableWords[i];
      
      // Count how many times this word appears in slots
      final countInSlots = slots.where((slotWord) => slotWord == word).length;
      
      // Count how many times this word appears in available words up to current index
      final countInAvailable = availableWords.sublist(0, i + 1).where((w) => w == word).length;
      
      // Only include this word if we haven't used all instances yet
      if (countInAvailable > countInSlots) {
        draggableWords.add(word);
      }
    }

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

}
