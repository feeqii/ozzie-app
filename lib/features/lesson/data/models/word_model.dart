/// 📝 WORD MODEL
/// 
/// Represents a single word in a Quranic verse.
/// 
/// WHAT IS THIS?
/// Think of this like a "flashcard" for one Arabic word.
/// It has the Arabic word, how to pronounce it (romanized),
/// and what it means in English.
/// 
/// WHY?
/// - For word-by-word learning
/// - Kids can tap on words to see meanings
/// - Used in word-order quiz games
/// - Helps with understanding, not just memorization
/// 
/// EXAMPLE:
/// Word: بِسْمِ
/// Transliteration: Bismi
/// Meaning: In the name
class Word {
  /// The Arabic word (e.g., "بِسْمِ")
  final String arabic;
  
  /// How to pronounce it in English letters (e.g., "Bismi")
  final String transliteration;
  
  /// What it means in English (e.g., "In the name")
  final String meaning;
  
  /// Optional: Position in the verse (0, 1, 2...)
  final int? position;

  /// Constructor - how to create a Word
  /// 
  /// Example:
  /// ```dart
  /// final word = Word(
  ///   arabic: 'بِسْمِ',
  ///   transliteration: 'Bismi',
  ///   meaning: 'In the name',
  /// );
  /// ```
  const Word({
    required this.arabic,
    required this.transliteration,
    required this.meaning,
    this.position,
  });

  /// Create a Word from JSON data
  /// 
  /// WHAT IS THIS?
  /// When we get data from an API or file, it comes as JSON (text).
  /// This function converts that JSON into a Word object we can use!
  /// 
  /// Example JSON:
  /// ```json
  /// {
  ///   "arabic": "بِسْمِ",
  ///   "transliteration": "Bismi",
  ///   "meaning": "In the name",
  ///   "position": 0
  /// }
  /// ```
  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      arabic: json['arabic'] as String,
      transliteration: json['transliteration'] as String,
      meaning: json['meaning'] as String,
      position: json['position'] as int?,
    );
  }

  /// Convert a Word to JSON data
  /// 
  /// WHAT IS THIS?
  /// The opposite of fromJson! This converts our Word object
  /// back into JSON so we can save it to a file or send to a server.
  /// 
  /// Example output:
  /// ```json
  /// {
  ///   "arabic": "بِسْمِ",
  ///   "transliteration": "Bismi",
  ///   "meaning": "In the name",
  ///   "position": 0
  /// }
  /// ```
  Map<String, dynamic> toJson() {
    return {
      'arabic': arabic,
      'transliteration': transliteration,
      'meaning': meaning,
      if (position != null) 'position': position,
    };
  }

  /// Create a copy of this Word with some values changed
  /// 
  /// WHAT IS THIS?
  /// Sometimes you want a new Word that's almost the same,
  /// but with one thing different. This makes that easy!
  /// 
  /// Example:
  /// ```dart
  /// final newWord = oldWord.copyWith(meaning: 'New meaning');
  /// ```
  Word copyWith({
    String? arabic,
    String? transliteration,
    String? meaning,
    int? position,
  }) {
    return Word(
      arabic: arabic ?? this.arabic,
      transliteration: transliteration ?? this.transliteration,
      meaning: meaning ?? this.meaning,
      position: position ?? this.position,
    );
  }

  /// Convert Word to a readable string (for debugging)
  /// 
  /// Makes it easy to print and see what's in the Word!
  @override
  String toString() {
    return 'Word(arabic: $arabic, meaning: $meaning)';
  }

  /// Check if two Words are the same
  /// 
  /// Compares all the properties to see if they match
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is Word &&
        other.arabic == arabic &&
        other.transliteration == transliteration &&
        other.meaning == meaning &&
        other.position == position;
  }

  /// Generate a unique ID for this Word (used for comparing)
  @override
  int get hashCode {
    return arabic.hashCode ^
        transliteration.hashCode ^
        meaning.hashCode ^
        (position?.hashCode ?? 0);
  }
}

