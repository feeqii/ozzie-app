import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ozzie/core/constants/app_colors.dart';
import 'package:ozzie/core/constants/app_sizes.dart';
import 'package:ozzie/core/constants/app_text_styles.dart';
import 'package:ozzie/core/widgets/ozzie_card.dart';
import 'package:ozzie/core/widgets/ozzie_placeholder.dart';
import 'package:ozzie/features/lesson/data/models/verse_model.dart';

/// 🎤 RECORDING STEP SCREEN (Step 3 of 6)
/// 
/// ONE-PAGE, NO-SCROLL recording experience!
/// 
/// DESIGN GOALS:
/// - Everything fits on screen (no scrolling)
/// - Big, fun record button
/// - Smooth state transitions
/// - Kid-friendly celebration after recording
/// 
/// STATES:
/// 1. Ready to record (big mic button)
/// 2. Recording (pulsing red button)
/// 3. Analyzing (loading + Ozzie)
/// 4. Result (score + playback options)

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
  // Flutter Sound instances
  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _player;
  
  // Recording state
  bool _isRecorderInitialized = false;
  bool _isPlayerInitialized = false;
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
    _initializeRecorder();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _closeRecorder();
    _closePlayer();
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

  /// Initialize the recorder
  /// 
  /// flutter_sound will automatically request microphone permission
  /// when openRecorder() is called for the first time
  Future<void> _initializeRecorder() async {
    _recorder = FlutterSoundRecorder();
    _player = FlutterSoundPlayer();

    // Open audio session - flutter_sound handles permission request automatically
    try {
      print('🎤 Opening audio recorder...');
      await _recorder!.openRecorder();
      
      // Open player - this will play through speaker by default in newer versions
      await _player!.openPlayer();
      
      // Set volume to 1.0 (max) to ensure it plays through speaker
      await _player!.setVolume(1.0);
      
      print('✅ Recorder initialized successfully!');
      
      setState(() {
        _isRecorderInitialized = true;
        _isPlayerInitialized = true;
      });
    } catch (e) {
      print('❌ Error initializing recorder: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error setting up recorder: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  /// Close recorder
  Future<void> _closeRecorder() async {
    if (_recorder != null) {
      await _recorder!.closeRecorder();
      _recorder = null;
    }
  }

  /// Close player
  Future<void> _closePlayer() async {
    if (_player != null) {
      await _player!.closePlayer();
      _player = null;
    }
  }

  /// Start recording
  Future<void> _startRecording() async {
    if (!_isRecorderInitialized || _recorder == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Recorder not ready. Please wait...'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    try {
      // Get temporary directory
      final directory = await getTemporaryDirectory();
      final path = '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.aac';

      // Start recording
      await _recorder!.startRecorder(
        toFile: path,
        codec: Codec.aacADTS,
      );
      
      setState(() {
        isRecording = true;
        hasRecorded = false;
        showingFeedback = false;
        aiScore = null;
        recordingPath = path;
      });
    } catch (e) {
      print('Error starting recording: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to start recording: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  /// Stop recording
  Future<void> _stopRecording() async {
    if (!_isRecorderInitialized || _recorder == null) return;

    try {
      print('⏹ Stopping recording...');
      final path = await _recorder!.stopRecorder();
      print('✅ Recording stopped. Path: $path');
      
      // Verify file exists
      if (path != null) {
        final file = File(path);
        final exists = await file.exists();
        final size = exists ? await file.length() : 0;
        print('  - File exists: $exists');
        print('  - File size: $size bytes');
      }
      
      setState(() {
        isRecording = false;
        hasRecorded = true;
        recordingPath = path; // Update with returned path
      });

      // Simulate AI processing delay
      await Future.delayed(const Duration(seconds: 2));

      // Generate simulated AI score (80-95%)
      _simulateAIFeedback();
    } catch (e) {
      print('❌ Error stopping recording: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error stopping recording: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  /// Simulate AI feedback
  void _simulateAIFeedback() {
    final random = Random();
    final score = 80 + random.nextInt(16); // 80-95

    setState(() {
      aiScore = score;
      showingFeedback = true;
    });

    // Submit to controller
    if (recordingPath != null) {
      widget.onRecordingSubmit(
        recordingPath: recordingPath!,
        aiScore: score,
      );
    }
  }

  /// Play recording
  Future<void> _playRecording() async {
    print('🎵 Play recording called');
    print('  - Player initialized: $_isPlayerInitialized');
    print('  - Player exists: ${_player != null}');
    print('  - Recording path: $recordingPath');
    
    if (!_isPlayerInitialized || _player == null || recordingPath == null) {
      print('❌ Cannot play: player not ready or no recording');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Recording not available'),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return;
    }

    // Check if file exists
    final file = File(recordingPath!);
    final exists = await file.exists();
    print('  - File exists: $exists');
    
    if (!exists) {
      print('❌ Recording file not found!');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Recording file not found'),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return;
    }

    try {
      print('▶️ Starting playback...');
      setState(() {
        isPlaying = true;
      });

      await _player!.startPlayer(
        fromURI: recordingPath!,
        codec: Codec.aacADTS,
        whenFinished: () {
          print('✅ Playback finished');
          if (mounted) {
            setState(() {
              isPlaying = false;
            });
          }
        },
      );
      
      print('✅ Playback started successfully');
    } catch (e) {
      print('❌ Error playing recording: $e');
      setState(() {
        isPlaying = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Playback error: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  /// Stop playing
  Future<void> _stopPlaying() async {
    if (_player != null && isPlaying) {
      await _player!.stopPlayer();
      setState(() {
        isPlaying = false;
      });
    }
  }

  /// Re-record (start over)
  void _reRecord() {
    setState(() {
      hasRecorded = false;
      showingFeedback = false;
      aiScore = null;
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
    // Get safe area height to ensure no scrolling
    final safeHeight = MediaQuery.of(context).size.height - 
                      MediaQuery.of(context).padding.top - 
                      MediaQuery.of(context).padding.bottom;

    return Container(
      height: safeHeight,
      padding: const EdgeInsets.all(AppSizes.screenPadding),
      child: Column(
        children: [
          // ========== COMPACT VERSE DISPLAY ==========
          _buildCompactVerseSection(),
          
          // ========== MAIN CONTENT AREA (DYNAMIC) ==========
          Expanded(
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: _buildMainContent(),
              ),
            ),
          ),
          
          // ========== TIP (only show before recording) ==========
          if (!hasRecorded && !isRecording)
            _buildInlineTip(),
        ],
      ),
    );
  }

  /// Compact verse display - no card, just text
  Widget _buildCompactVerseSection() {
    return Column(
      children: [
        Text(
          widget.verse.arabicText,
          style: AppTextStyles.quranVerse.copyWith(fontSize: 22),
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
        ),
        const SizedBox(height: AppSizes.spaceTiny),
        Text(
          widget.verse.transliteration,
          style: AppTextStyles.transliteration.copyWith(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSizes.spaceLarge),
      ],
    );
  }

  /// Main content - changes based on state
  Widget _buildMainContent() {
    if (!_isRecorderInitialized) {
      return _buildLoadingState();
    }

    if (hasRecorded && showingFeedback && aiScore != null) {
      return _buildResultState();
    }

    if (hasRecorded && !showingFeedback) {
      return _buildAnalyzingState();
    }

    if (isRecording) {
      return _buildRecordingState();
    }

    return _buildReadyState();
  }

  /// Loading state
  Widget _buildLoadingState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: AppSizes.spaceMedium),
        Text(
          'Setting up microphone...',
          style: AppTextStyles.bodyMedium,
        ),
      ],
    );
  }

  /// Ready to record state (BIG button)
  Widget _buildReadyState() {
    return Column(
      key: const ValueKey('ready'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Now You Try!',
          style: AppTextStyles.headingMedium.copyWith(
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: AppSizes.spaceSmall),
        Text(
          'Record yourself reciting the verse',
          style: AppTextStyles.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSizes.spaceXLarge),
        
        // BIG RECORD BUTTON
        GestureDetector(
          onTap: _startRecording,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.accent,
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withOpacity(0.4),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const Icon(
              Icons.mic,
              size: 64,
              color: AppColors.white,
            ),
          ),
        ),
        
        const SizedBox(height: AppSizes.spaceMedium),
        
        Text(
          'Tap to Record',
          style: AppTextStyles.headingSmall,
        ),
      ],
    );
  }

  /// Recording state (pulsing button)
  Widget _buildRecordingState() {
    return Column(
      key: const ValueKey('recording'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: GestureDetector(
                onTap: _stopRecording,
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.error,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.error.withOpacity(0.5),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.stop,
                    size: 64,
                    color: AppColors.white,
                  ),
                ),
              ),
            );
          },
        ),
        
        const SizedBox(height: AppSizes.spaceLarge),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.error,
              ),
            ),
            const SizedBox(width: AppSizes.spaceSmall),
            Text(
              'Recording...',
              style: AppTextStyles.headingSmall.copyWith(
                color: AppColors.error,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: AppSizes.spaceSmall),
        
        Text(
          'Tap again to stop',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  /// Analyzing state
  Widget _buildAnalyzingState() {
    return Column(
      key: const ValueKey('analyzing'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OzziePlaceholder(
          size: OzzieSize.large,
          expression: OzzieExpression.thinking,
          animated: true,
        ),
        const SizedBox(height: AppSizes.spaceLarge),
        const CircularProgressIndicator(),
        const SizedBox(height: AppSizes.spaceMedium),
        Text(
          'Analyzing your recitation...',
          style: AppTextStyles.bodyLarge,
        ),
      ],
    );
  }

  /// Result state (score + actions)
  Widget _buildResultState() {
    return SingleChildScrollView(
      key: const ValueKey('result'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Ozzie celebrating
          OzziePlaceholder(
            size: OzzieSize.large,
            expression: aiScore! >= 90
                ? OzzieExpression.celebrating
                : OzzieExpression.happy,
            animated: true,
          ),
          
          const SizedBox(height: AppSizes.spaceLarge),
          
          // Score card - compact
          Container(
            padding: const EdgeInsets.all(AppSizes.cardPadding),
            decoration: BoxDecoration(
              color: _getScoreColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              border: Border.all(
                color: _getScoreColor().withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Text(
                  'AI Pronunciation Score',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSizes.spaceTiny),
                Text(
                  '$aiScore%',
                  style: AppTextStyles.scoreText.copyWith(
                    color: _getScoreColor(),
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSizes.spaceTiny),
                Text(
                  _getFeedbackMessage(aiScore!),
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSizes.spaceTiny),
                Text(
                  '⚠️ Simulated AI',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.warning,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: AppSizes.spaceLarge),
          
          // Action buttons - horizontal
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Listen button
              ElevatedButton.icon(
                onPressed: isPlaying ? _stopPlaying : _playRecording,
                icon: Icon(isPlaying ? Icons.stop : Icons.play_arrow),
                label: Text(isPlaying ? 'Stop' : 'Listen'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.cardPadding,
                    vertical: AppSizes.spaceSmall,
                  ),
                ),
              ),
              
              const SizedBox(width: AppSizes.spaceMedium),
              
              // Re-record button
              OutlinedButton.icon(
                onPressed: _reRecord,
                icon: const Icon(Icons.refresh),
                label: const Text('Again'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.cardPadding,
                    vertical: AppSizes.spaceSmall,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Inline tip (compact)
  Widget _buildInlineTip() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.cardPadding,
        vertical: AppSizes.spaceSmall,
      ),
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        border: Border.all(
          color: AppColors.info.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.lightbulb_outline,
            color: AppColors.info,
            size: 20,
          ),
          const SizedBox(width: AppSizes.spaceSmall),
          Text(
            'Tip: Find a quiet place and speak clearly!',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.info,
            ),
          ),
        ],
      ),
    );
  }

  Color _getScoreColor() {
    if (aiScore == null) return AppColors.info;
    if (aiScore! >= 90) return AppColors.success;
    if (aiScore! >= 85) return AppColors.primary;
    return AppColors.warning;
  }
}
