import 'package:flutter/material.dart';
import 'package:ozzie/core/constants/app_sizes.dart';
import 'package:ozzie/core/widgets/ozzie_button.dart';
import 'package:ozzie/core/widgets/ozzie_card.dart';
import 'package:ozzie/features/lesson/data/models/surah_model.dart';
import 'package:ozzie/services/quran_data_service.dart';

/// 📖 VERSE DISPLAY SCREEN
/// 
/// Shows verses from a Surah with beautiful formatting!
/// 
/// This is a demo screen to show our data service working.
/// Later, this will become part of the lesson flow!
class VerseDisplayScreen extends StatefulWidget {
  const VerseDisplayScreen({super.key});

  @override
  State<VerseDisplayScreen> createState() => _VerseDisplayScreenState();
}

class _VerseDisplayScreenState extends State<VerseDisplayScreen> {
  final QuranDataService _dataService = QuranDataService();
  Surah? _surah;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadSurah();
  }

  Future<void> _loadSurah() async {
    try {
      final surah = await _dataService.loadSurah(1); // Load Al-Fatiha
      setState(() {
        _surah = surah;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_surah?.nameEnglish ?? 'Loading...'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSizes.screenPadding),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 64, color: Colors.red),
                        const SizedBox(height: AppSizes.spaceMedium),
                        Text('Error: $_error'),
                        const SizedBox(height: AppSizes.spaceLarge),
                        OzzieButton(
                          text: 'Try Again',
                          onPressed: () {
                            setState(() {
                              _isLoading = true;
                              _error = null;
                            });
                            _loadSurah();
                          },
                        ),
                      ],
                    ),
                  ),
                )
              : _surah == null
                  ? const Center(child: Text('No data'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(AppSizes.screenPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Surah header
                          OzzieCard(
                            child: Column(
                              children: [
                                Text(
                                  _surah!.nameArabic,
                                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                        fontSize: 36,
                                        height: 1.8,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: AppSizes.spaceSmall),
                                Text(
                                  '${_surah!.nameMeaning} • ${_surah!.totalVerses} Verses',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                const SizedBox(height: AppSizes.spaceMedium),
                                if (_surah!.description != null)
                                  Text(
                                    _surah!.description!,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                    textAlign: TextAlign.center,
                                  ),
                              ],
                            ),
                          ),

                          const SizedBox(height: AppSizes.spaceLarge),

                          // Verses
                          ..._ surah!.verses.map((verse) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: AppSizes.spaceMedium),
                              child: OzzieCard(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    // Verse number badge
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).primaryColor,
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            'Verse ${verse.verseNumber}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: AppSizes.spaceMedium),

                                    // Arabic text
                                    Text(
                                      verse.arabicText,
                                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                            fontSize: 28,
                                            height: 1.8,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),

                                    const SizedBox(height: AppSizes.spaceMedium),

                                    // Transliteration
                                    Text(
                                      verse.transliteration,
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                            fontStyle: FontStyle.italic,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),

                                    const SizedBox(height: AppSizes.spaceSmall),

                                    // Translation
                                    Text(
                                      verse.translation,
                                      style: Theme.of(context).textTheme.bodyMedium,
                                      textAlign: TextAlign.center,
                                    ),

                                    const SizedBox(height: AppSizes.spaceMedium),

                                    // Explanation
                                    Container(
                                      padding: const EdgeInsets.all(AppSizes.cardPadding),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                                      ),
                                      child: Text(
                                        verse.explanationForKids,
                                        style: Theme.of(context).textTheme.bodyMedium,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
    );
  }
}

