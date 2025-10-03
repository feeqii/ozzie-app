import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ozzie/core/constants/app_colors.dart';
import 'package:ozzie/core/constants/app_sizes.dart';
import 'package:ozzie/core/constants/app_text_styles.dart';
import 'package:ozzie/core/widgets/ozzie_card.dart';
import 'package:ozzie/features/lesson/data/models/verse_model.dart';

/// ❓ QUIZ 1 STEP SCREEN (Step 4 of 6) - REDESIGNED
/// 
/// Drag and drop words into the correct order!
/// 
/// NEW UX IMPROVEMENTS:
/// - Compact one-page layout (no scrolling needed)
/// - Smart word bank (shows 4-5 relevant words)
/// - Gentle feedback (shake + toast instead of modal)
/// - Duolingo-inspired interactions
/// - Haptic feedback

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

class _Quiz1StepScreenState extends State<Quiz1StepScreen> with TickerProviderStateMixin {
  List<String> availableWords = [];
  List<String?> slots = []; // null = empty slot, String = word in slot
  List<String> correctWords = []; // The correct word order
  int currentSlotIndex = 0; // Which slot we're currently filling (0-based)
  
  bool showHint = false;
  bool showInfoDialog = false;
  String? toastMessage;
  
  // Animation controllers
  late AnimationController _shakeController;
  late AnimationController _toastController;
  late Animation<double> _shakeAnimation;
  late Animation<Offset> _toastSlideAnimation;

  @override
  void initState() {
    super.initState();
    _setupWords();
    _setupAnimations();
  }

  void _setupAnimations() {
    // Shake animation for wrong answers
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticIn,
    ));

    // Toast slide animation
    _toastController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _toastSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _toastController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _toastController.dispose();
    super.dispose();
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
      HapticFeedback.lightImpact(); // Gentle vibration
      
      setState(() {
        slots[slotIndex] = word;
        currentSlotIndex++;
        
        // Check if we've completed all slots
        if (currentSlotIndex >= slots.length) {
          _onAllSlotsCorrect();
        }
      });
    } else {
      // ❌ WRONG! Show gentle feedback
      _showWrongFeedback();
    }
  }

  /// Show gentle wrong answer feedback (Duolingo style)
  void _showWrongFeedback() {
    // Haptic feedback
    HapticFeedback.mediumImpact();
    
    // Shake animation
    _shakeController.forward().then((_) {
      _shakeController.reverse();
    });
    
    // Show toast message
    setState(() {
      toastMessage = 'Not quite! Try another word 💭';
    });
    
    _toastController.forward();
    
    // Auto-hide toast after 1.5 seconds
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        _toastController.reverse().then((_) {
          if (mounted) {
            setState(() {
              toastMessage = null;
            });
          }
        });
      }
    });
  }

  /// Called when all slots are filled correctly
  void _onAllSlotsCorrect() {
    // Haptic feedback for completion
    HapticFeedback.heavyImpact();
    
    // Submit the complete answer
    widget.onAnswerSubmit(slots.whereType<String>().toList());
  }

  void _toggleHint() {
    setState(() {
      showHint = !showHint;
    });
  }
  
  void _showInfoDialog() {
    setState(() {
      showInfoDialog = true;
    });
    
    // Auto-hide after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          showInfoDialog = false;
        });
      }
    });
  }
  
  /// Check if a slot is locked (already filled correctly)
  bool _isSlotLocked(int index) => index < currentSlotIndex;
  
  /// Check if a slot is the active one
  bool _isSlotActive(int index) => index == currentSlotIndex;
  
  /// Check if all slots are completed
  bool get _isCompleted => currentSlotIndex >= slots.length;

  /// Get smart word bank (4-5 words: correct options + distractors)
  List<String> _getSmartWordBank() {
    final List<String> smartBank = [];
    
    // Filter out words already placed in slots
    final List<String> remainingWords = [];
    
    for (int i = 0; i < availableWords.length; i++) {
      final word = availableWords[i];
      
      // Count how many times this word appears in slots
      final countInSlots = slots.where((slotWord) => slotWord == word).length;
      
      // Count how many times this word appears in available words up to current index
      final countInAvailable = availableWords.sublist(0, i + 1).where((w) => w == word).length;
      
      // Only include this word if we haven't used all instances yet
      if (countInAvailable > countInSlots) {
        remainingWords.add(word);
      }
    }
    
    if (remainingWords.isEmpty) {
      return [];
    }
    
    // Smart selection: Show 4 correct options for upcoming positions + 1 random
    final int wordsToShow = 5;
    
    // Get correct words for current and next 3 positions
    for (int i = currentSlotIndex; i < correctWords.length && smartBank.length < wordsToShow - 1; i++) {
      final correctWord = correctWords[i];
      if (remainingWords.contains(correctWord) && !smartBank.contains(correctWord)) {
        smartBank.add(correctWord);
        remainingWords.remove(correctWord);
      }
    }
    
    // Add 1 random distractor from remaining words (if available)
    if (remainingWords.isNotEmpty && smartBank.length < wordsToShow) {
      final random = remainingWords.toList()..shuffle();
      smartBank.add(random.first);
    }
    
    // Shuffle the smart bank so correct answer isn't always first
    smartBank.shuffle();
    
    return smartBank;
  }

  @override
  Widget build(BuildContext context) {
    final smartWordBank = _getSmartWordBank();
    
    return Stack(
      children: [
        // Main content
        Padding(
          padding: const EdgeInsets.all(AppSizes.screenPadding),
          child: Column(
            children: [
              // Compact header with info and hint icons
              _buildCompactHeader(),
              
              const SizedBox(height: AppSizes.spaceSmall),
              
              // One-line instruction
              _buildInstructionLine(),
              
              const SizedBox(height: AppSizes.spaceLarge),
              
              // Answer slots (horizontal, at top)
              _buildAnswerSlots(),
              
              // Large breathing room in the middle
              const Spacer(),
              
              // Smart word bank (4-5 words at bottom)
              _buildSmartWordBank(smartWordBank),
              
              const SizedBox(height: AppSizes.spaceMedium),
            ],
          ),
        ),
        
        // Toast message at bottom
        if (toastMessage != null)
          Positioned(
            bottom: 80,
            left: AppSizes.screenPadding,
            right: AppSizes.screenPadding,
            child: SlideTransition(
              position: _toastSlideAnimation,
              child: _buildToast(toastMessage!),
            ),
          ),
        
        // Info dialog overlay
        if (showInfoDialog)
          _buildInfoOverlay(),
      ],
    );
  }

  /// Compact header with icons
  Widget _buildCompactHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Put the Words in Order',
          style: AppTextStyles.headingSmall.copyWith(
            color: AppColors.primary,
          ),
        ),
        Row(
          children: [
            // Info button
            IconButton(
              onPressed: _showInfoDialog,
              icon: const Icon(Icons.info_outline, size: 20),
              color: AppColors.info,
              tooltip: 'Instructions',
            ),
            // Hint button
            if (!_isCompleted)
              IconButton(
                onPressed: _toggleHint,
                icon: Icon(showHint ? Icons.visibility_off : Icons.lightbulb_outline, size: 20),
                color: AppColors.warning,
                tooltip: showHint ? 'Hide hint' : 'Show hint',
              ),
          ],
        ),
      ],
    );
  }

  /// One-line instruction
  Widget _buildInstructionLine() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Drag words from right to left',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '←',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  /// Answer slots (horizontal, compact)
  Widget _buildAnswerSlots() {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        // Apply shake to active slot when wrong
        return Transform.translate(
          offset: Offset(_shakeAnimation.value, 0),
          child: child,
        );
      },
      child: OzzieCard(
        backgroundColor: AppColors.white,
        borderColor: _isCompleted ? AppColors.success : AppColors.primary.withOpacity(0.3),
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
            const SizedBox(height: AppSizes.spaceSmall),
            
            // Horizontal scrollable slots (RTL)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true, // Start from right for RTL
              child: Row(
                children: List.generate(slots.length, (index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: index < slots.length - 1 ? AppSizes.spaceSmall : 0,
                    ),
                    child: _buildSlot(index),
                  );
                }).toList(), // No reverse - already RTL with reverse scroll
              ),
            ),
            
            // Hint display
            if (showHint) ...[
              const SizedBox(height: AppSizes.spaceSmall),
              Container(
                padding: const EdgeInsets.all(AppSizes.spaceSmall),
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lightbulb, color: AppColors.warning, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.verse.transliteration,
                        style: AppTextStyles.bodySmall.copyWith(
                          fontStyle: FontStyle.italic,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
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
      onWillAccept: (data) => isActive,
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
          backgroundColor = AppColors.success.withOpacity(0.15);
          borderColor = AppColors.success;
          borderWidth = 2;
        } else if (isActive) {
          backgroundColor = isHovering 
              ? AppColors.primary.withOpacity(0.2) 
              : AppColors.primary.withOpacity(0.1);
          borderColor = AppColors.primary;
          borderWidth = isHovering ? 3 : 2;
        } else {
          backgroundColor = AppColors.lightGray.withOpacity(0.1);
          borderColor = AppColors.mediumGray.withOpacity(0.3);
          borderWidth = 1;
        }
        
        return Container(
          width: 75,
          height: 80,
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
                  child: Text(
                    '${index + 1}',
                    style: AppTextStyles.headingMedium.copyWith(
                      color: isActive ? AppColors.primary : AppColors.mediumGray.withOpacity(0.4),
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                )
              : Stack(
                  children: [
                    Center(
                      child: Text(
                        word!,
                        style: AppTextStyles.quranWord.copyWith(fontSize: 20),
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                    if (isLocked)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            size: 10,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
        );
      },
    );
  }

  /// Smart word bank (4-5 words)
  Widget _buildSmartWordBank(List<String> smartWords) {
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
        
        smartWords.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.spaceLarge),
                  child: Column(
                    children: [
                      const Icon(Icons.check_circle, color: AppColors.success, size: 48),
                      const SizedBox(height: AppSizes.spaceSmall),
                      Text(
                        'All words placed!',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Wrap(
                spacing: AppSizes.spaceSmall,
                runSpacing: AppSizes.spaceSmall,
                alignment: WrapAlignment.center,
                children: smartWords.map((word) {
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
          opacity: 0.9,
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
        horizontal: 20,
        vertical: 12,
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
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Text(
        word,
        style: AppTextStyles.quranWord.copyWith(
          fontSize: 24,
          color: isDragging ? AppColors.white : AppColors.textPrimary,
        ),
        textDirection: TextDirection.rtl,
      ),
    );
  }

  /// Toast message
  Widget _buildToast(String message) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceLarge,
        vertical: AppSizes.spaceMedium,
      ),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.95),
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Text(
            message,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Info overlay
  Widget _buildInfoOverlay() {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () {
          setState(() {
            showInfoDialog = false;
          });
        },
        child: Container(
          color: Colors.black.withOpacity(0.5),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.screenPadding),
              child: OzzieCard(
                backgroundColor: AppColors.white,
                borderColor: AppColors.info,
                borderWidth: 3,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.info, color: AppColors.info, size: 48),
                    const SizedBox(height: AppSizes.spaceMedium),
                    Text(
                      'How to Play',
                      style: AppTextStyles.headingMedium.copyWith(
                        color: AppColors.info,
                      ),
                    ),
                    const SizedBox(height: AppSizes.spaceSmall),
                    Text(
                      '1. Drag words from the bottom\n'
                      '2. Drop them in order from RIGHT to LEFT ←\n'
                      '3. Each word must be correct!\n'
                      '4. Use the hint if you need help 💡',
                      style: AppTextStyles.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSizes.spaceMedium),
                    Text(
                      'Tap anywhere to close',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}