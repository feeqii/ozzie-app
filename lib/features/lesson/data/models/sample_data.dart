import 'package:ozzie/features/lesson/data/models/word_model.dart';
import 'package:ozzie/features/lesson/data/models/verse_model.dart';
import 'package:ozzie/features/lesson/data/models/surah_model.dart';

/// 🎯 SAMPLE DATA
/// 
/// Real Quranic content to test our models!
/// 
/// This file contains actual data from Al-Fatiha (The Opening).
/// Later, we'll replace this with data from APIs and JSON files.
/// 
/// For now, this helps us:
/// - Test our models work correctly
/// - See real examples of how data looks
/// - Build UI screens with actual content

class SampleData {
  /// Sample words from "Bismillah ir-Rahman ir-Raheem"
  static final List<Word> bismillahWords = [
    const Word(
      arabic: 'بِسْمِ',
      transliteration: 'Bismi',
      meaning: 'In the name',
      position: 0,
    ),
    const Word(
      arabic: 'اللَّهِ',
      transliteration: 'Allahi',
      meaning: 'of Allah',
      position: 1,
    ),
    const Word(
      arabic: 'الرَّحْمَٰنِ',
      transliteration: 'Ar-Rahmani',
      meaning: 'the Most Gracious',
      position: 2,
    ),
    const Word(
      arabic: 'الرَّحِيمِ',
      transliteration: 'Ar-Raheem',
      meaning: 'the Most Merciful',
      position: 3,
    ),
  ];

  /// Sample Verse 1 of Al-Fatiha
  static final Verse bismillahVerse = Verse(
    verseNumber: 1,
    arabicText: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
    transliteration: 'Bismillah ir-Rahman ir-Raheem',
    translation: 'In the name of Allah, the Entirely Merciful, the Especially Merciful.',
    explanationForKids: '''
🌟 What does this verse mean?

This beautiful verse is like saying "I start everything with Allah's name!"

Think of it like this:
• When you start eating, you say "Bismillah" 
• When you start playing, you can say "Bismillah"
• This verse reminds us to always remember Allah!

The verse tells us that Allah is:
✨ Ar-Rahman: Very kind to EVERYONE (even people who don't know Him!)
✨ Ar-Raheem: Extra special kind to people who love Him!

Just like your parents are kind to you, Allah is even MORE kind! 💙
    ''',
    audioUrl: 'https://everyayah.com/data/Alafasy_128kbps/001001.mp3',
    words: bismillahWords,
    revelationContext: 'This is the opening verse of the Quran, recited before every Surah and in every prayer.',
  );

  /// Sample Surah Al-Fatiha (just first verse for now)
  /// We'll add more verses later!
  static final Surah alFatiha = Surah(
    number: 1,
    nameArabic: 'الفاتحة',
    nameEnglish: 'Al-Fatiha',
    nameMeaning: 'The Opening',
    totalVerses: 7,
    revelationType: RevelationType.meccan,
    verses: [bismillahVerse], // We'll add more verses later!
    description: '''
Al-Fatiha is the very first chapter of the Quran!

✨ Special things about Al-Fatiha:
• We recite it in EVERY prayer (at least 17 times a day!)
• It's like a conversation with Allah
• Prophet Muhammad ﷺ called it "The Greatest Surah in the Quran"
• It has everything: Praise, guidance, and a beautiful prayer!

It's short but SO powerful! 💪
    ''',
    themes: [
      'Praise to Allah',
      'Seeking Guidance',
      'The Straight Path',
      'Prayer and Worship',
    ],
  );

  /// Sample: More verses (placeholders for now)
  /// You can help write these later!
  static final List<Verse> moreFatihaVerses = [
    // Verse 2: Al-hamdu lillahi rabbil 'alamin
    Verse(
      verseNumber: 2,
      arabicText: 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
      transliteration: 'Alhamdu lillahi rabbil \'alamin',
      translation: 'All praise is due to Allah, Lord of all the worlds.',
      explanationForKids: 'This verse teaches us to thank Allah for everything! He takes care of the whole universe - that\'s HUGE! 🌍✨',
      audioUrl: 'https://everyayah.com/data/Alafasy_128kbps/001002.mp3',
      words: [
        const Word(arabic: 'الْحَمْدُ', transliteration: 'Alhamdu', meaning: 'All praise'),
        const Word(arabic: 'لِلَّهِ', transliteration: 'lillahi', meaning: 'is for Allah'),
        const Word(arabic: 'رَبِّ', transliteration: 'rabbi', meaning: 'Lord'),
        const Word(arabic: 'الْعَالَمِينَ', transliteration: 'al-\'alamin', meaning: 'of all the worlds'),
      ],
    ),
    
    // Add more verses here later...
  ];

  /// Helper: Get Al-Fatiha with all verses
  /// For now just returns the sample with 1 verse
  /// Later we'll expand this!
  static Surah getCompleteFatiha() {
    return alFatiha;
  }

  /// Helper: Create a sample JSON representation
  /// Shows how our data will look when saved/loaded
  static Map<String, dynamic> getSampleJson() {
    return alFatiha.toJson();
  }

  /// Helper: Demonstrate loading from JSON
  static Surah loadFromJson(Map<String, dynamic> json) {
    return Surah.fromJson(json);
  }
}

