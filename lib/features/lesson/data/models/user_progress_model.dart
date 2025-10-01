/// 📊 USER PROGRESS MODEL
/// 
/// Tracks a user's learning progress through the Quran.
/// 
/// WHAT IS THIS?
/// Think of this like a "progress report card" for the student.
/// It remembers:
/// - Which verses they've completed
/// - How many stars they earned
/// - Their current streak
/// - Badges they've unlocked
/// 
/// WHY?
/// - Shows progress to kids (motivating!)
/// - Shows progress to parents
/// - Saves progress (so they don't lose it!)
/// - Unlocks achievements and badges
class UserProgress {
  /// User's unique ID (for when we add authentication later)
  final String userId;
  
  /// Progress for each Surah (Surah number → progress details)
  /// Example: {1: SurahProgress(...), 112: SurahProgress(...)}
  final Map<int, SurahProgress> surahProgress;
  
  /// Total badges earned
  final int totalBadges;
  
  /// Current learning streak (days in a row)
  /// Example: 7 means studied 7 days in a row
  final int currentStreak;
  
  /// Longest streak ever achieved
  final int longestStreak;
  
  /// Total study time in minutes
  final int totalStudyTimeMinutes;
  
  /// Last time the user studied (for calculating streaks)
  final DateTime? lastStudyDate;
  
  /// List of badge IDs earned
  /// Example: ['first_verse', 'week_streak', 'perfect_recitation']
  final List<String> badgesEarned;

  const UserProgress({
    required this.userId,
    required this.surahProgress,
    this.totalBadges = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.totalStudyTimeMinutes = 0,
    this.lastStudyDate,
    this.badgesEarned = const [],
  });

  /// Create from JSON
  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      userId: json['userId'] as String,
      surahProgress: (json['surahProgress'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          int.parse(key),
          SurahProgress.fromJson(value as Map<String, dynamic>),
        ),
      ),
      totalBadges: json['totalBadges'] as int? ?? 0,
      currentStreak: json['currentStreak'] as int? ?? 0,
      longestStreak: json['longestStreak'] as int? ?? 0,
      totalStudyTimeMinutes: json['totalStudyTimeMinutes'] as int? ?? 0,
      lastStudyDate: json['lastStudyDate'] != null
          ? DateTime.parse(json['lastStudyDate'] as String)
          : null,
      badgesEarned: (json['badgesEarned'] as List<dynamic>?)
          ?.map((badge) => badge as String)
          .toList() ?? const [],
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'surahProgress': surahProgress.map(
        (key, value) => MapEntry(key.toString(), value.toJson()),
      ),
      'totalBadges': totalBadges,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'totalStudyTimeMinutes': totalStudyTimeMinutes,
      if (lastStudyDate != null) 
        'lastStudyDate': lastStudyDate!.toIso8601String(),
      'badgesEarned': badgesEarned,
    };
  }

  /// Copy with modifications
  UserProgress copyWith({
    String? userId,
    Map<int, SurahProgress>? surahProgress,
    int? totalBadges,
    int? currentStreak,
    int? longestStreak,
    int? totalStudyTimeMinutes,
    DateTime? lastStudyDate,
    List<String>? badgesEarned,
  }) {
    return UserProgress(
      userId: userId ?? this.userId,
      surahProgress: surahProgress ?? this.surahProgress,
      totalBadges: totalBadges ?? this.totalBadges,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      totalStudyTimeMinutes: totalStudyTimeMinutes ?? this.totalStudyTimeMinutes,
      lastStudyDate: lastStudyDate ?? this.lastStudyDate,
      badgesEarned: badgesEarned ?? this.badgesEarned,
    );
  }

  /// Helper: Get progress for a specific Surah
  SurahProgress? getSurahProgress(int surahNumber) {
    return surahProgress[surahNumber];
  }

  /// Helper: Total verses completed across all Surahs
  int get totalVersesCompleted {
    return surahProgress.values.fold(
      0,
      (total, surah) => total + surah.versesCompleted.length,
    );
  }

  /// Helper: Overall completion percentage
  double get overallCompletionPercentage {
    if (surahProgress.isEmpty) return 0.0;
    
    final totalProgress = surahProgress.values.fold(
      0.0,
      (total, surah) => total + surah.completionPercentage,
    );
    
    return totalProgress / surahProgress.length;
  }

  @override
  String toString() {
    return 'UserProgress(userId: $userId, streak: $currentStreak days, badges: $totalBadges)';
  }
}

/// 📈 SURAH PROGRESS
/// 
/// Progress for a single Surah
class SurahProgress {
  /// Surah number
  final int surahNumber;
  
  /// Which verses are completed (verse numbers)
  /// Example: [1, 2, 3] means verses 1, 2, 3 are done
  final List<int> versesCompleted;
  
  /// Stars earned for each verse (verse number → stars)
  /// Example: {1: 3, 2: 2} means verse 1 got 3 stars, verse 2 got 2 stars
  final Map<int, int> verseStars;
  
  /// Is this Surah completely finished?
  final bool isCompleted;
  
  /// When was this Surah started?
  final DateTime? startedDate;
  
  /// When was this Surah completed?
  final DateTime? completedDate;

  const SurahProgress({
    required this.surahNumber,
    this.versesCompleted = const [],
    this.verseStars = const {},
    this.isCompleted = false,
    this.startedDate,
    this.completedDate,
  });

  /// Create from JSON
  factory SurahProgress.fromJson(Map<String, dynamic> json) {
    return SurahProgress(
      surahNumber: json['surahNumber'] as int,
      versesCompleted: (json['versesCompleted'] as List<dynamic>?)
          ?.map((v) => v as int)
          .toList() ?? const [],
      verseStars: (json['verseStars'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(int.parse(key), value as int),
      ) ?? const {},
      isCompleted: json['isCompleted'] as bool? ?? false,
      startedDate: json['startedDate'] != null
          ? DateTime.parse(json['startedDate'] as String)
          : null,
      completedDate: json['completedDate'] != null
          ? DateTime.parse(json['completedDate'] as String)
          : null,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'surahNumber': surahNumber,
      'versesCompleted': versesCompleted,
      'verseStars': verseStars.map(
        (key, value) => MapEntry(key.toString(), value),
      ),
      'isCompleted': isCompleted,
      if (startedDate != null) 'startedDate': startedDate!.toIso8601String(),
      if (completedDate != null) 'completedDate': completedDate!.toIso8601String(),
    };
  }

  /// Copy with modifications
  SurahProgress copyWith({
    int? surahNumber,
    List<int>? versesCompleted,
    Map<int, int>? verseStars,
    bool? isCompleted,
    DateTime? startedDate,
    DateTime? completedDate,
  }) {
    return SurahProgress(
      surahNumber: surahNumber ?? this.surahNumber,
      versesCompleted: versesCompleted ?? this.versesCompleted,
      verseStars: verseStars ?? this.verseStars,
      isCompleted: isCompleted ?? this.isCompleted,
      startedDate: startedDate ?? this.startedDate,
      completedDate: completedDate ?? this.completedDate,
    );
  }

  /// Helper: Completion percentage for this Surah
  /// Requires knowing total verses (pass as parameter)
  double completionPercentage(int totalVerses) {
    if (totalVerses == 0) return 0.0;
    return (versesCompleted.length / totalVerses) * 100;
  }

  /// Helper: Average stars for this Surah
  double get averageStars {
    if (verseStars.isEmpty) return 0.0;
    
    final totalStars = verseStars.values.fold(0, (sum, stars) => sum + stars);
    return totalStars / verseStars.length;
  }

  /// Helper: Has this verse been completed?
  bool isVerseCompleted(int verseNumber) {
    return versesCompleted.contains(verseNumber);
  }

  /// Helper: Get stars for a specific verse
  int getVerseStars(int verseNumber) {
    return verseStars[verseNumber] ?? 0;
  }

  @override
  String toString() {
    return 'SurahProgress(#$surahNumber, ${versesCompleted.length} verses completed)';
  }
}

