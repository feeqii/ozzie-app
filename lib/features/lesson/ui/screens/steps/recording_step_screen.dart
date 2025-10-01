import 'dart:math';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:ozzie/core/constants/app_colors.dart';
import 'package:ozzie/core/constants/app_sizes.dart';
import 'package:ozzie/core/constants/app_text_styles.dart';
import 'package:ozzie/core/widgets/ozzie_card.dart';
import 'package:ozzie/core/widgets/ozzie_placeholder.dart';
import 'package:ozzie/features/lesson/data/models/verse_model.dart';

/// 🎤 RECORDING STEP SCREEN (Step 3 of 6)
/// 
/// Record your recitation and get AI feedback!
/// 
/// WHAT THIS DOES:
/// - Big red "Record" button
/// - Records kid's voice reciting the verse
/// - Plays back the recording
/// - Gives AI pronunciation feedback
/// - Shows score (0-100)
/// - Option to re-record
/// 
/// NOTE: AI feedback is currently SIMULATED (random 80-95%)
/// TODO: Replace with real Google Cloud Speech-to-Text API when ready

class RecordingStepScreen extends StatefulWidget {
  final Verse verse;
  final Function({required String recordingPath, int? aiScore}) onRecordingSubmit;

  const RecordingStepScreen({
    super.key,
    required this.verse,
    required this.onRecordingSubmit,
  });

  @override
  State<RecordingStepScreen> createState() => _RecordingStepScreenState();
}

class _RecordingStepScreenState extends State<RecordingStepScreen>
    with SingleTickerProviderStateMixin {
  final _audioRecorder = AudioRecorder();
  final _audioPlayer = AudioPlayer();
  
  // Recording state
  bool isRecording = false;
  bool hasRecorded = false;
  bool isPlaying = false;
  String? recordingPath;
  
  // AI feedback (simulated)
  int? aiScore;
  bool showingFeedback = false;

  // Animation
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _checkPermissions();
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _setupAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );
  }

  Future<void> _checkPermissions() async {
    // Check and request microphone permission
    final hasPermission = await _audioRecorder.hasPermission();
    if (!hasPermission) {
      // Show a message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Microphone permission is required to record'),
          ),
        );
      }
    }
  }

  /// Start recording
  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        // Start recording
        await _audioRecorder.start(
          const RecordConfig(),
          path: 'recording_${DateTime.now().millisecondsSinceEpoch}.m4a',
        );
        
        setState(() {
          isRecording = true;
          hasRecorded = false;
          showingFeedback = false;
          aiScore = null;
        });
      }
    } catch (e) {
      print('Error starting recording: $e');
    }
  }

  /// Stop recording
  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      
      setState(() {
        isRecording = false;
        hasRecorded = true;
        recordingPath = path;
      });

      // Simulate AI processing delay
      await Future.delayed(const Duration(seconds: 2));

      // Generate simulated AI score (80-95%)
      // TODO: Replace with real Google Cloud Speech-to-Text API
      _simulateAIFeedback();
    } catch (e) {
      print('Error stopping recording: $e');
    }
  }

  /// Simulate AI feedback
  /// 
  /// 🚧 TEMPORARY: This generates random scores
  /// TODO: Replace with actual Google Cloud Speech-to-Text integration
  /// See RESEARCH_FINDINGS.md for API details
  void _simulateAIFeedback() {
    final random = Random();
    final score = 80 + random.nextInt(16); // 80-95

    setState(() {
      aiScore = score;
      showingFeedback = true;
    });

    // Submit to controller
    widget.onRecordingSubmit(
      recordingPath: recordingPath!,
      aiScore: score,
    );
  }

  /// Play recording
  Future<void> _playRecording() async {
    if (recordingPath != null) {
      await _audioPlayer.play(DeviceFileSource(recordingPath!));
      setState(() {
        isPlaying = true;
      });

      // Listen for completion
      _audioPlayer.onPlayerComplete.listen((_) {
        if (mounted) {
          setState(() {
            isPlaying = false;
          });
        }
      });
    }
  }

  /// Re-record (start over)
  void _reRecord() {
    setState(() {
      hasRecorded = false;
      showingFeedback = false;
      aiScore = null;
      recordingPath = null;
    });
  }

  /// Get feedback message based on score
  String _getFeedbackMessage(int score) {
    if (score >= 90) {
      return "Excellent pronunciation! You sound like a pro! 🌟";
    } else if (score >= 85) {
      return "Great job! Very clear recitation! 💫";
    } else {
      return "Good effort! Keep practicing! 💪";
    }
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
            'Now You Try!',
            style: AppTextStyles.headingMedium.copyWith(
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSizes.spaceSmall),

          Text(
            'Record yourself reciting the verse',
            style: AppTextStyles.bodyLarge,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSizes.spaceLarge),

          // Arabic Text (what to recite)
          OzzieCard(
            backgroundColor: AppColors.white,
            child: Column(
              children: [
                Text(
                  widget.verse.arabicText,
                  style: AppTextStyles.quranVerse.copyWith(fontSize: 28),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: AppSizes.spaceSmall),
                Text(
                  widget.verse.transliteration,
                  style: AppTextStyles.transliteration,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSizes.spaceXLarge),

          // Recording UI
          if (!hasRecorded) _buildRecordingUI(),

          // Playback & Feedback UI
          if (hasRecorded) _buildPlaybackUI(),

          const SizedBox(height: AppSizes.spaceLarge),

          // Tip
          if (!hasRecorded)
            OzzieInfoCard(
              message: 'Tip: Find a quiet place and speak clearly! 🎤',
              icon: Icons.lightbulb,
              color: AppColors.info,
            ),
        ],
      ),
    );
  }

  /// Recording UI (before recording)
  Widget _buildRecordingUI() {
    return Column(
      children: [
        // Big record button
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: isRecording ? _pulseAnimation.value : 1.0,
              child: GestureDetector(
                onTap: isRecording ? _stopRecording : _startRecording,
                child: Container(
                  width: AppSizes.recordButtonSize,
                  height: AppSizes.recordButtonSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isRecording ? AppColors.error : AppColors.accent,
                    boxShadow: [
                      BoxShadow(
                        color: (isRecording ? AppColors.error : AppColors.accent)
                            .withOpacity(0.5),
                        blurRadius: 30,
                        spreadRadius: isRecording ? 10 : 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    isRecording ? Icons.stop : Icons.mic,
                    size: 48,
                    color: AppColors.white,
                  ),
                ),
              ),
            );
          },
        ),

        const SizedBox(height: AppSizes.spaceMedium),

        // Status text
        Text(
          isRecording ? '🔴 Recording...' : 'Tap to Record',
          style: AppTextStyles.headingSmall.copyWith(
            color: isRecording ? AppColors.error : AppColors.textPrimary,
          ),
        ),

        if (isRecording) ...[
          const SizedBox(height: AppSizes.spaceSmall),
          Text(
            'Tap again to stop',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }

  /// Playback UI (after recording)
  Widget _buildPlaybackUI() {
    return Column(
      children: [
        // Ozzie with feedback
        if (showingFeedback && aiScore != null) ...[
          OzziePlaceholder(
            size: OzzieSize.large,
            expression: aiScore! >= 90
                ? OzzieExpression.celebrating
                : OzzieExpression.happy,
            animated: true,
          ),

          const SizedBox(height: AppSizes.spaceLarge),

          // AI Score
          OzzieCard(
            backgroundColor: _getScoreColor().withOpacity(0.1),
            borderColor: _getScoreColor().withOpacity(0.3),
            borderWidth: 2,
            child: Column(
              children: [
                Text(
                  'AI Pronunciation Score',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSizes.spaceSmall),
                Text(
                  '$aiScore%',
                  style: AppTextStyles.scoreText.copyWith(
                    color: _getScoreColor(),
                    fontSize: 48,
                  ),
                ),
                const SizedBox(height: AppSizes.spaceSmall),
                Text(
                  _getFeedbackMessage(aiScore!),
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSizes.spaceSmall),
                Text(
                  '⚠️ Simulated AI - Real implementation coming soon',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.warning,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSizes.spaceLarge),
        ] else ...[
          const CircularProgressIndicator(),
          const SizedBox(height: AppSizes.spaceMedium),
          Text(
            'Analyzing your recitation...',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: AppSizes.spaceLarge),
        ],

        // Playback button
        ElevatedButton.icon(
          onPressed: isPlaying ? null : _playRecording,
          icon: Icon(isPlaying ? Icons.volume_up : Icons.play_arrow),
          label: Text(isPlaying ? 'Playing...' : 'Listen to Your Recording'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.cardPadding,
              vertical: AppSizes.spaceMedium,
            ),
          ),
        ),

        const SizedBox(height: AppSizes.spaceMedium),

        // Re-record button
        TextButton.icon(
          onPressed: _reRecord,
          icon: const Icon(Icons.refresh),
          label: const Text('Record Again'),
        ),
      ],
    );
  }

  Color _getScoreColor() {
    if (aiScore == null) return AppColors.info;
    if (aiScore! >= 90) return AppColors.success;
    if (aiScore! >= 85) return AppColors.primary;
    return AppColors.warning;
  }
}
