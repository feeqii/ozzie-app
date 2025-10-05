import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:ozzie/core/constants/app_colors.dart';
import 'package:ozzie/core/constants/app_sizes.dart';
import 'package:ozzie/core/constants/app_text_styles.dart';
import 'package:ozzie/core/widgets/ozzie_card.dart';
import 'package:ozzie/features/lesson/data/models/verse_model.dart';

/// 🎧 RECITATION STEP SCREEN (Step 2 of 6)
/// 
/// Listen to expert recitation!
/// 
/// WHAT THIS DOES:
/// - Plays the Quranic verse audio from a professional reciter
/// - Shows the Arabic text
/// - Play/Pause controls
/// - Normal and Slow speed options
/// - Replay button
/// 
/// Kids listen and learn proper pronunciation before they try themselves!

class RecitationStepScreen extends StatefulWidget {
  final Verse verse;

  const RecitationStepScreen({
    super.key,
    required this.verse,
  });

  @override
  State<RecitationStepScreen> createState() => _RecitationStepScreenState();
}

class _RecitationStepScreenState extends State<RecitationStepScreen> {
  late AudioPlayer _audioPlayer;
  
  // Audio state
  bool isPlaying = false;
  bool isLoading = false;
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;
  
  // Speed: 1.0 = normal, 0.75 = slow
  double playbackSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _configureAudioSession();
    _setupAudioPlayer();
  }
  
  /// Configure audio to play through SPEAKER (not earpiece!)
  Future<void> _configureAudioSession() async {
    try {
      // Set audio context to play through speaker like music/media
      await _audioPlayer.setAudioContext(
        AudioContext(
          iOS: AudioContextIOS(
            category: AVAudioSessionCategory.playback,
            options: {
              AVAudioSessionOptions.defaultToSpeaker,
              AVAudioSessionOptions.mixWithOthers,
            },
          ),
          android: AudioContextAndroid(
            isSpeakerphoneOn: true,
            stayAwake: true,
            contentType: AndroidContentType.music,
            usageType: AndroidUsageType.media,
            audioFocus: AndroidAudioFocus.gain,
          ),
        ),
      );
      print('✅ Audio configured to play through speaker');
    } catch (e) {
      print('⚠️ Could not configure audio session: $e');
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  /// Setup audio player listeners
  void _setupAudioPlayer() {
    // Listen to player state changes
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          isPlaying = state == PlayerState.playing;
          isLoading = state == PlayerState.playing && currentPosition == Duration.zero;
        });
      }
    });

    // Listen to position changes
    _audioPlayer.onPositionChanged.listen((position) {
      if (mounted) {
        setState(() {
          currentPosition = position;
        });
      }
    });

    // Listen to duration
    _audioPlayer.onDurationChanged.listen((duration) {
      if (mounted) {
        setState(() {
          totalDuration = duration;
        });
      }
    });

    // Auto-stop when complete
    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          isPlaying = false;
          currentPosition = Duration.zero;
        });
      }
    });
  }

  /// Play or pause audio
  Future<void> _togglePlayPause() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      // If at the end, restart
      if (currentPosition >= totalDuration && totalDuration > Duration.zero) {
        await _audioPlayer.seek(Duration.zero);
      }
      await _audioPlayer.play(UrlSource(widget.verse.audioUrl));
      await _audioPlayer.setPlaybackRate(playbackSpeed);
    }
  }

  /// Change playback speed
  Future<void> _toggleSpeed() async {
    setState(() {
      playbackSpeed = playbackSpeed == 1.0 ? 0.75 : 1.0;
    });
    
    if (isPlaying) {
      await _audioPlayer.setPlaybackRate(playbackSpeed);
    }
  }

  /// Replay from beginning
  Future<void> _replay() async {
    await _audioPlayer.seek(Duration.zero);
    await _audioPlayer.play(UrlSource(widget.verse.audioUrl));
    await _audioPlayer.setPlaybackRate(playbackSpeed);
  }

  /// Format duration to mm:ss
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
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
            'Listen Carefully',
            style: AppTextStyles.headingMedium.copyWith(
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSizes.spaceSmall),

          Text(
            'This is how an expert reciter says it',
            style: AppTextStyles.bodyLarge,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSizes.spaceLarge),

          // Arabic Text Card
          OzzieCard(
            backgroundColor: AppColors.white,
            child: Column(
              children: [
                // Arabic verse
                Text(
                  widget.verse.arabicText,
                  style: AppTextStyles.quranVerse.copyWith(
                    fontSize: 32,
                  ),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ),

                const SizedBox(height: AppSizes.spaceMedium),

                // Transliteration
                Text(
                  widget.verse.transliteration,
                  style: AppTextStyles.transliteration,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSizes.spaceLarge),

          // Audio Player Card
          OzzieCard(
            backgroundColor: AppColors.primary.withOpacity(0.1),
            borderColor: AppColors.primary.withOpacity(0.3),
            borderWidth: 2,
            child: Column(
              children: [
                // Play/Pause Button (Big!)
                GestureDetector(
                  onTap: _togglePlayPause,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: isLoading
                        ? const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: CircularProgressIndicator(
                              color: AppColors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : Icon(
                            isPlaying ? Icons.pause : Icons.play_arrow,
                            size: 48,
                            color: AppColors.white,
                          ),
                  ),
                ),

                const SizedBox(height: AppSizes.spaceMedium),

                // Progress bar
                Column(
                  children: [
                    SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 4,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 8,
                        ),
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 16,
                        ),
                      ),
                      child: Slider(
                        value: totalDuration.inSeconds > 0
                            ? currentPosition.inSeconds.toDouble()
                            : 0.0,
                        max: totalDuration.inSeconds > 0
                            ? totalDuration.inSeconds.toDouble()
                            : 1.0,
                        onChanged: (value) async {
                          await _audioPlayer.seek(Duration(seconds: value.toInt()));
                        },
                        activeColor: AppColors.primary,
                        inactiveColor: AppColors.lightGray,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(currentPosition),
                            style: AppTextStyles.bodySmall,
                          ),
                          Text(
                            _formatDuration(totalDuration),
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSizes.spaceMedium),

                // Control buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Replay button
                    _buildControlButton(
                      icon: Icons.replay,
                      label: 'Replay',
                      onTap: _replay,
                    ),

                    // Speed button
                    _buildControlButton(
                      icon: playbackSpeed == 1.0 
                          ? Icons.speed 
                          : Icons.slow_motion_video,
                      label: playbackSpeed == 1.0 ? 'Normal' : 'Slow',
                      onTap: _toggleSpeed,
                      isActive: playbackSpeed != 1.0,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSizes.spaceLarge),

          // Helpful tip
          OzzieInfoCard(
            message: 'Listen multiple times until you feel ready to try yourself! 🎧',
            icon: Icons.tips_and_updates,
            color: AppColors.info,
          ),
        ],
      ),
    );
  }

  /// Helper: Build a control button
  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.cardPadding,
          vertical: AppSizes.spaceSmall,
        ),
        decoration: BoxDecoration(
          color: isActive 
              ? AppColors.primary.withOpacity(0.2)
              : AppColors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.lightGray,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? AppColors.primary : AppColors.textPrimary,
              size: 20,
            ),
            const SizedBox(width: AppSizes.spaceXTiny),
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isActive ? AppColors.primary : AppColors.textPrimary,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
