import 'package:ozzie/features/lesson/data/models/verse_model.dart';

/// 📚 SURAH MODEL
/// 
/// Represents a complete Surah (chapter) of the Quran.
/// 
/// WHAT IS THIS?
/// A Surah is a chapter of the Quran. The Quran has 114 Surahs.
/// Each Surah has a name, number, and contains multiple verses.
/// 
/// WHY?
/// - Organizes verses into chapters
/// - Shows progress at Surah level
/// - Used for the "planet map" navigation
/// 
/// EXAMPLE:
/// Surah #1: Al-Fatiha
/// - Has 7 verses
/// - Revealed in Mecca
/// - Means "The Opening"
class Surah {
  /// Surah number (1-114)
  /// Example: 1 for Al-Fatiha
  final int number;
  
  /// Arabic name
  /// Example: "الفاتحة" (Al-Fatiha)
  final String nameArabic;
  
  /// English name
  /// Example: "Al-Fatiha" or "The Opening"
  final String nameEnglish;
  
  /// English translation of the name
  /// Example: "The Opening"
  final String nameMeaning;
  
  /// Total number of verses in this Surah
  /// Example: 7 for Al-Fatiha
  final int totalVerses;
  
  /// Where was this Surah revealed?
  /// Either "Meccan" or "Medinan"
  final RevelationType revelationType;
  
  /// List of all verses in this Surah
  final List<Verse> verses;
  
  /// Optional: Brief description of the Surah
  /// Example: "This is the opening chapter, recited in every prayer..."
  final String? description;
  
  /// Optional: Main themes/topics
  /// Example: ["Praise", "Guidance", "Prayer"]
  final List<String>? themes;

  const Surah({
    required this.number,
    required this.nameArabic,
    required this.nameEnglish,
    required this.nameMeaning,
    required this.totalVerses,
    required this.revelationType,
    required this.verses,
    this.description,
    this.themes,
  });

  /// Create Surah from JSON
  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      number: json['number'] as int,
      nameArabic: json['nameArabic'] as String,
      nameEnglish: json['nameEnglish'] as String,
      nameMeaning: json['nameMeaning'] as String,
      totalVerses: json['totalVerses'] as int,
      revelationType: RevelationType.fromString(
        json['revelationType'] as String,
      ),
      verses: (json['verses'] as List<dynamic>)
          .map((verseJson) => Verse.fromJson(verseJson as Map<String, dynamic>))
          .toList(),
      description: json['description'] as String?,
      themes: (json['themes'] as List<dynamic>?)
          ?.map((theme) => theme as String)
          .toList(),
    );
  }

  /// Convert Surah to JSON
  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'nameArabic': nameArabic,
      'nameEnglish': nameEnglish,
      'nameMeaning': nameMeaning,
      'totalVerses': totalVerses,
      'revelationType': revelationType.name,
      'verses': verses.map((verse) => verse.toJson()).toList(),
      if (description != null) 'description': description,
      if (themes != null) 'themes': themes,
    };
  }

  /// Copy with modifications
  Surah copyWith({
    int? number,
    String? nameArabic,
    String? nameEnglish,
    String? nameMeaning,
    int? totalVerses,
    RevelationType? revelationType,
    List<Verse>? verses,
    String? description,
    List<String>? themes,
  }) {
    return Surah(
      number: number ?? this.number,
      nameArabic: nameArabic ?? this.nameArabic,
      nameEnglish: nameEnglish ?? this.nameEnglish,
      nameMeaning: nameMeaning ?? this.nameMeaning,
      totalVerses: totalVerses ?? this.totalVerses,
      revelationType: revelationType ?? this.revelationType,
      verses: verses ?? this.verses,
      description: description ?? this.description,
      themes: themes ?? this.themes,
    );
  }

  /// Helper: Get a specific verse by number
  Verse? getVerse(int verseNumber) {
    try {
      return verses.firstWhere((v) => v.verseNumber == verseNumber);
    } catch (e) {
      return null; // Verse not found
    }
  }

  /// Helper: Get completion percentage (based on user progress - we'll add later)
  /// For now, returns 0
  double get completionPercentage => 0.0;

  /// Helper: Is this Surah fully completed?
  bool get isCompleted => completionPercentage >= 100;

  @override
  String toString() {
    return 'Surah(#$number: $nameEnglish, $totalVerses verses)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is Surah &&
        other.number == number &&
        other.nameEnglish == nameEnglish &&
        other.totalVerses == totalVerses;
  }

  @override
  int get hashCode {
    return number.hashCode ^
        nameEnglish.hashCode ^
        totalVerses.hashCode;
  }
}

/// 🌍 REVELATION TYPE
/// 
/// Where a Surah was revealed.
/// 
/// WHAT IS THIS?
/// Surahs were revealed in two main places:
/// - Mecca: Early revelations, focus on faith and belief
/// - Medina: Later revelations, focus on laws and community
enum RevelationType {
  meccan('Meccan'),
  medinan('Medinan');

  final String displayName;
  const RevelationType(this.displayName);

  /// Create from string (useful for JSON)
  static RevelationType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'meccan':
        return RevelationType.meccan;
      case 'medinan':
        return RevelationType.medinan;
      default:
        throw ArgumentError('Invalid revelation type: $value');
    }
  }
}

