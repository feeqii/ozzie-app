import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:ozzie/features/lesson/data/models/surah_model.dart';
import 'package:ozzie/features/lesson/data/models/verse_model.dart';

/// 🔌 QURAN DATA SERVICE
/// 
/// Loads Quranic content from JSON files.
/// 
/// WHAT IS THIS?
/// Think of this like a "librarian" that fetches books (Surahs)
/// for you! Instead of typing all the Quran data in code,
/// we store it in JSON files and this service loads it.
/// 
/// WHY?
/// - Easy to update content (just edit JSON)
/// - Organized and clean
/// - Can load data from files, APIs, or databases
/// - Content separate from code
/// 
/// HOW TO USE:
/// ```dart
/// final service = QuranDataService();
/// final fatiha = await service.loadSurah(1); // Load Al-Fatiha
/// print(fatiha.nameEnglish); // "Al-Fatiha"
/// ```
class QuranDataService {
  /// Cache loaded Surahs so we don't load them again
  /// Think of this like a bookmark - once we read a book,
  /// we remember it and don't need to fetch it again!
  final Map<int, Surah> _cachedSurahs = {};

  /// Load a Surah by its number
  /// 
  /// WHAT DOES THIS DO?
  /// 1. Checks if we already loaded this Surah (cache)
  /// 2. If not, loads the JSON file from assets
  /// 3. Converts JSON to a Surah object
  /// 4. Saves it in cache for next time
  /// 5. Returns the Surah!
  /// 
  /// Example:
  /// ```dart
  /// final fatiha = await service.loadSurah(1);
  /// ```
  Future<Surah> loadSurah(int surahNumber) async {
    // Check if we already have it in cache
    if (_cachedSurahs.containsKey(surahNumber)) {
      return _cachedSurahs[surahNumber]!;
    }

    // Build the file path
    // Surah 1 → "surah_001_al_fatiha.json"
    // Surah 112 → "surah_112_al_ikhlas.json"
    final String fileName = 'surah_${surahNumber.toString().padLeft(3, '0')}_${_getSurahFileName(surahNumber)}.json';
    final String filePath = 'assets/data/$fileName';

    try {
      // Load the JSON file from assets
      final String jsonString = await rootBundle.loadString(filePath);
      
      // Convert JSON string to a Map (like a dictionary)
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      // Convert the Map to a Surah object using our model
      final Surah surah = Surah.fromJson(jsonData);
      
      // Save in cache so we don't load again
      _cachedSurahs[surahNumber] = surah;
      
      return surah;
    } catch (e) {
      // If something goes wrong, throw a helpful error
      throw Exception('Failed to load Surah $surahNumber: $e');
    }
  }

  /// Load multiple Surahs at once
  /// 
  /// Example:
  /// ```dart
  /// final surahs = await service.loadMultipleSurahs([1, 112]);
  /// // Returns [Al-Fatiha, Al-Ikhlas]
  /// ```
  Future<List<Surah>> loadMultipleSurahs(List<int> surahNumbers) async {
    final List<Surah> surahs = [];
    
    for (final number in surahNumbers) {
      final surah = await loadSurah(number);
      surahs.add(surah);
    }
    
    return surahs;
  }

  /// Get all available Surahs
  /// 
  /// For now, returns the Surahs we have JSON files for
  /// Later, we can expand this to all 114 Surahs!
  Future<List<Surah>> getAllAvailableSurahs() async {
    // For MVP, we only have Al-Fatiha (and will add Al-Ikhlas later)
    return await loadMultipleSurahs([1]);
  }

  /// Clear the cache (if needed)
  /// 
  /// Sometimes you might want to reload fresh data
  void clearCache() {
    _cachedSurahs.clear();
  }

  /// Get a specific verse from a Surah
  /// 
  /// Example:
  /// ```dart
  /// final verse = await service.getVerse(surahNumber: 1, verseNumber: 1);
  /// print(verse.arabicText); // "بِسْمِ اللَّهِ..."
  /// ```
  Future<Verse?> getVerse({
    required int surahNumber,
    required int verseNumber,
  }) async {
    final surah = await loadSurah(surahNumber);
    return surah.getVerse(verseNumber);
  }

  /// Helper: Get file name for a Surah number
  /// 
  /// WHAT IS THIS?
  /// Converts Surah number to the file name we use
  /// 
  /// For now, we only have Al-Fatiha
  /// Later, we'll add all 114 Surahs!
  String _getSurahFileName(int surahNumber) {
    switch (surahNumber) {
      case 1:
        return 'al_fatiha';
      case 112:
        return 'al_ikhlas';
      // Add more as we create them!
      default:
        throw Exception('Surah $surahNumber not available yet');
    }
  }

  /// Get Surah name in English (useful for file names)
  /// 
  /// Example:
  /// ```dart
  /// final name = service.getSurahEnglishName(1); // "Al-Fatiha"
  /// ```
  String getSurahEnglishName(int surahNumber) {
    switch (surahNumber) {
      case 1:
        return 'Al-Fatiha';
      case 112:
        return 'Al-Ikhlas';
      default:
        return 'Unknown';
    }
  }
}

