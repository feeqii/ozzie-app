import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ozzie/core/constants/app_colors.dart';
import 'package:ozzie/core/constants/app_sizes.dart';
import 'package:ozzie/core/constants/app_text_styles.dart';
import 'package:ozzie/core/widgets/micro_celebration.dart';
import 'package:ozzie/features/lesson/logic/lesson_flow_controller.dart';
import 'package:ozzie/features/lesson/logic/lesson_flow_state.dart';
import 'package:ozzie/features/lesson/logic/progress_controller.dart';
import 'package:ozzie/features/lesson/ui/screens/steps/explanation_step_screen.dart';
import 'package:ozzie/features/lesson/ui/screens/steps/recitation_step_screen.dart';
import 'package:ozzie/features/lesson/ui/screens/steps/recording_step_screen.dart';
import 'package:ozzie/features/lesson/ui/screens/steps/quiz1_step_screen.dart';
import 'package:ozzie/features/lesson/ui/screens/steps/quiz2_step_screen.dart';
import 'package:ozzie/features/lesson/ui/screens/steps/celebration_step_screen.dart';
import 'package:ozzie/core/widgets/ozzie_card.dart';

/// 🎬 LESSON FLOW SCREEN
/// 
/// The main container for the 6-step lesson experience!
/// 
/// WHAT IS THIS?
/// This screen manages the entire lesson flow from start to finish.
/// It shows:
/// - Progress indicator (Step X of 6)
/// - The current step screen (Explanation, Quiz, etc.)
/// - Navigation buttons (Back, Next)
/// 
/// HOW IT WORKS:
/// 1. Uses Riverpod to get lesson state from LessonFlowController
/// 2. Shows the appropriate step screen based on currentStep
/// 3. Updates when user moves between steps
/// 
/// EXAMPLE:
/// Navigate here with:
/// ```dart
/// context.go('/lesson/1/2'); // Surah 1, Verse 2
/// ```

class LessonFlowScreen extends ConsumerWidget {
  final int surahNumber;
  final int verseNumber;

  const LessonFlowScreen({
    super.key,
    required this.surahNumber,
    required this.verseNumber,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the lesson state
    // Whenever state changes, this widget rebuilds!
    final lessonState = ref.watch(
      lessonFlowProvider((
        surahNumber: surahNumber,
        verseNumber: verseNumber,
      )),
    );

    // Get the controller to call methods
    final controller = ref.read(
      lessonFlowProvider((
        surahNumber: surahNumber,
        verseNumber: verseNumber,
      )).notifier,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ========== HEADER (Progress + Back button) ==========
            _buildHeader(context, lessonState, controller),

            // ========== CURRENT STEP SCREEN ==========
            Expanded(
              child: lessonState.isLoading
                  ? _buildLoadingState()
                  : lessonState.error != null
                      ? _buildErrorState(lessonState.error!, controller)
                      : _buildStepScreen(lessonState, controller),
            ),

            // ========== NAVIGATION BUTTONS ==========
            // Hide navigation for quiz steps (they auto-advance after micro celebration)
            if (!lessonState.isLoading && 
                lessonState.error == null &&
                lessonState.currentStep != LessonStep.quiz1 &&
                lessonState.currentStep != LessonStep.quiz2)
              _buildNavigationButtons(
                context,
                ref,
                lessonState,
                controller,
              ),
          ],
        ),
      ),
    );
  }

  /// Header with progress and back button
  Widget _buildHeader(
    BuildContext context,
    LessonFlowState state,
    LessonFlowController controller,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.screenPadding),
      child: Column(
        children: [
          // Back button and title
          Row(
            children: [
              IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back_ios),
              ),
              Expanded(
                child:                   Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Surah ${state.surahNumber} • Verse ${state.verseNumber}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    const SizedBox(height: 2),
                    Text(
                      state.currentStep.displayName,
                      style: AppTextStyles.headingSmall,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSizes.spaceMedium),

          // Progress bar
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: state.progress,
                    backgroundColor: AppColors.lightGray,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.spaceSmall),
              Text(
                'Step ${state.currentStep.stepNumber}/6',
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Loading state
  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: AppSizes.spaceMedium),
          Text('Loading lesson...'),
        ],
      ),
    );
  }

  /// Error state
  Widget _buildErrorState(String error, LessonFlowController controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.screenPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: AppSizes.spaceMedium),
            Text(
              'Oops! Something went wrong',
              style: AppTextStyles.headingMedium,
            ),
            const SizedBox(height: AppSizes.spaceSmall),
            Text(
              error,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.spaceLarge),
            ElevatedButton(
              onPressed: () => controller.loadVerse(),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  /// Render the appropriate step screen
  Widget _buildStepScreen(
    LessonFlowState state,
    LessonFlowController controller,
  ) {
    // Show the right screen based on current step
    switch (state.currentStep) {
      case LessonStep.explanation:
        return ExplanationStepScreen(verse: state.verse!);
      
      case LessonStep.recitation:
        return RecitationStepScreen(verse: state.verse!);
      
      case LessonStep.recording:
        return RecordingStepScreen(
          verse: state.verse!,
          onRecordingSubmit: ({required String recordingPath, int? aiScore}) {
            controller.submitRecording(
              recordingPath: recordingPath,
              aiScore: aiScore,
            );
          },
        );
      
      case LessonStep.quiz1:
        return Quiz1StepScreen(
          verse: state.verse!,
          onAnswerSubmit: controller.submitQuiz1,
          onStepComplete: () {
            // Auto-advance after micro celebration
            controller.nextStep();
          },
        );
      
      case LessonStep.quiz2:
        return Quiz2StepScreen(
          verse: state.verse!,
          onAnswerSubmit: controller.submitQuiz2,
          onStepComplete: () {
            // Auto-advance after micro celebration
            controller.nextStep();
          },
        );
      
      case LessonStep.celebration:
        return CelebrationStepScreen(
          stars: state.starsEarned,
          surahNumber: state.surahNumber,
          verseNumber: state.verseNumber,
        );
    }
  }

  /// Navigation buttons (Back/Next)
  Widget _buildNavigationButtons(
    BuildContext context,
    WidgetRef ref,
    LessonFlowState state,
    LessonFlowController controller,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.screenPadding),
      child: Row(
        children: [
          // Back button
          if (state.canGoBack)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => controller.previousStep(),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back'),
              ),
            ),

          if (state.canGoBack) const SizedBox(width: AppSizes.spaceMedium),

          // Next button
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: state.canGoNext
                  ? () {
                      if (state.currentStep.isLast) {
                        // Last step - complete lesson and check for Surah completion
                        controller.completeLesson();
                        _handleLessonCompletion(context, ref, state);
                      } else {
                        // For passive steps (1-3), show micro celebration then advance
                        if (state.currentStep == LessonStep.explanation ||
                            state.currentStep == LessonStep.recitation ||
                            state.currentStep == LessonStep.recording) {
                          MicroCelebration.show(
                            context,
                            onComplete: () {
                              controller.nextStep();
                            },
                          );
                        } else {
                          // Other steps advance directly
                          controller.nextStep();
                        }
                      }
                    }
                  : null, // Disabled if can't go next
              icon: Icon(
                state.currentStep.isLast ? Icons.check : Icons.arrow_forward,
              ),
              label: Text(
                state.currentStep.isLast ? 'Complete' : 'Next',
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Handle lesson completion and check for Surah completion
  void _handleLessonCompletion(
    BuildContext context,
    WidgetRef ref,
    LessonFlowState state,
  ) {
    // Give progress service a moment to save
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!context.mounted) return;
      
      // Check if Surah is now completed
      final progressController = ref.read(progressControllerProvider.notifier);
      final isSurahComplete = progressController.isSurahCompleted(state.surahNumber);
      
      print('🔍 Surah ${state.surahNumber} complete: $isSurahComplete');
      
      if (isSurahComplete) {
        // Get Surah progress to calculate total stars
        final surahProgress = progressController.getSurahProgress(state.surahNumber);
        final totalStars = surahProgress?.totalStars ?? 0;
        
        // Get Surah name (hardcoded for now, can be fetched from JSON later)
        final surahName = _getSurahName(state.surahNumber);
        
        // URL encode the Surah name to handle special characters
        final encodedName = Uri.encodeComponent(surahName);
        final route = '/surah/${state.surahNumber}/complete?name=$encodedName&stars=$totalStars';
        
        print('🚀 Navigating to: $route');
        
        // Navigate to Surah completion celebration!
        context.go(route);
      } else {
        // Surah not complete yet - return to verse trail
        print('🚀 Navigating to verse trail');
        context.go('/surah/${state.surahNumber}/trail');
      }
    });
  }

  /// Get Surah name by number
  /// TODO: Fetch this from JSON in the future
  String _getSurahName(int surahNumber) {
    switch (surahNumber) {
      case 1:
        return 'Al-Fatiha';
      case 112:
        return 'Al-Ikhlas';
      default:
        return 'Surah $surahNumber';
    }
  }
}

