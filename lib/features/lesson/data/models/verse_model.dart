import 'package:ozzie/features/lesson/data/models/word_model.dart';

/// 📖 VERSE MODEL
/// 
/// Represents a single verse (Ayah) from the Quran.
/// 
/// WHAT IS THIS?
/// Think of this like a "lesson package" for one verse.
/// It contains:
/// - The Arabic text
/// - Translation (English)
/// - Transliteration (how to say it)
/// - Explanation for kids
/// - Audio file location
/// - All the individual words
/// 
/// WHY?
/// This is the CORE of our app! Each verse is a complete lesson.
/// Everything revolves around this model.
/// 
/// EXAMPLE:
/// Verse 1 of Al-Fatiha:
/// "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ"
/// "In the name of Allah, the Entirely Merciful..."
class Verse {
  /// Which verse is this? (1, 2, 3...)
  final int verseNumber;
  
  /// The complete Arabic text
  /// Example: "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ"
  final String arabicText;
  
  /// How to pronounce it in English letters
  /// Example: "Bismillah ir-Rahman ir-Raheem"
  final String transliteration;
  
  /// English translation
  /// Example: "In the name of Allah, the Entirely Merciful, the Especially Merciful."
  final String translation;
  
  /// Simple explanation for kids to understand
  /// Example: "This verse is like saying 'I start with Allah's name!' 
  /// It reminds us that Allah is very kind and caring."
  final String explanationForKids;
  
  /// URL or path to the audio file
  /// Example: "https://everyayah.com/data/Alafasy_128kbps/001001.mp3"
  final String audioUrl;
  
  /// List of individual words in this verse
  /// Used for word-by-word learning and games
  final List<Word> words;
  
  /// Optional: Revelation context (Meccan/Medinan, story behind it)
  final String? revelationContext;

  /// Constructor
  const Verse({
    required this.verseNumber,
    required this.arabicText,
    required this.transliteration,
    required this.translation,
    required this.explanationForKids,
    required this.audioUrl,
    required this.words,
    this.revelationContext,
  });

  /// Create a Verse from JSON
  /// 
  /// Example JSON:
  /// ```json
  /// {
  ///   "verseNumber": 1,
  ///   "arabicText": "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ",
  ///   "transliteration": "Bismillah ir-Rahman ir-Raheem",
  ///   "translation": "In the name of Allah...",
  ///   "explanationForKids": "This verse means...",
  ///   "audioUrl": "https://...",
  ///   "words": [...]
  /// }
  /// ```
  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      verseNumber: json['verseNumber'] as int,
      arabicText: json['arabicText'] as String,
      transliteration: json['transliteration'] as String,
      translation: json['translation'] as String,
      explanationForKids: json['explanationForKids'] as String,
      audioUrl: json['audioUrl'] as String,
      words: (json['words'] as List<dynamic>)
          .map((wordJson) => Word.fromJson(wordJson as Map<String, dynamic>))
          .toList(),
      revelationContext: json['revelationContext'] as String?,
    );
  }

  /// Convert Verse to JSON
  Map<String, dynamic> toJson() {
    return {
      'verseNumber': verseNumber,
      'arabicText': arabicText,
      'transliteration': transliteration,
      'translation': translation,
      'explanationForKids': explanationForKids,
      'audioUrl': audioUrl,
      'words': words.map((word) => word.toJson()).toList(),
      if (revelationContext != null) 'revelationContext': revelationContext,
    };
  }

  /// Copy with modifications
  Verse copyWith({
    int? verseNumber,
    String? arabicText,
    String? transliteration,
    String? translation,
    String? explanationForKids,
    String? audioUrl,
    List<Word>? words,
    String? revelationContext,
  }) {
    return Verse(
      verseNumber: verseNumber ?? this.verseNumber,
      arabicText: arabicText ?? this.arabicText,
      transliteration: transliteration ?? this.transliteration,
      translation: translation ?? this.translation,
      explanationForKids: explanationForKids ?? this.explanationForKids,
      audioUrl: audioUrl ?? this.audioUrl,
      words: words ?? this.words,
      revelationContext: revelationContext ?? this.revelationContext,
    );
  }

  /// Helper: Get total word count
  int get wordCount => words.length;

  /// Helper: Is this verse memorized? (based on user progress - we'll add this later)
  /// For now, always returns false
  bool get isMemorized => false;

  /// For debugging
  @override
  String toString() {
    return 'Verse(#$verseNumber: ${arabicText.substring(0, 20)}...)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is Verse &&
        other.verseNumber == verseNumber &&
        other.arabicText == arabicText &&
        other.transliteration == transliteration &&
        other.translation == translation;
  }

  @override
  int get hashCode {
    return verseNumber.hashCode ^
        arabicText.hashCode ^
        transliteration.hashCode ^
        translation.hashCode;
  }
}

