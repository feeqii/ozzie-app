# 🏗️ OZZIE APP - Architecture Documentation

**Purpose**: Help future developers (and AI agents) understand how this app is built  
**Audience**: Developers new to the codebase  
**Last Updated**: October 2, 2025

---

## 📚 TABLE OF CONTENTS

1. [Overview](#overview)
2. [Project Structure](#project-structure)
3. [Data Architecture](#data-architecture)
4. [State Management](#state-management)
5. [Navigation Flow](#navigation-flow)
6. [Lesson Flow Architecture](#lesson-flow-architecture)
7. [Progress Tracking](#progress-tracking)
8. [Adding New Content](#adding-new-content)
9. [Best Practices](#best-practices)

---

## 🎯 OVERVIEW

### **What is Ozzie?**
Ozzie is a Duolingo-style educational app that teaches kids (ages 6-12) Quranic verses through:
- Interactive lessons
- Audio recitation
- Voice recording
- Fun quizzes
- Gamification (badges, streaks, progress)

### **Tech Stack**
- **Framework**: Flutter (Dart)
- **State Management**: Riverpod
- **Navigation**: GoRouter
- **Local Storage**: Hive (for progress)
- **Fonts**: Google Fonts (Poppins for English, Amiri for Arabic)
- **Audio**: `audioplayers` package

### **Clean Architecture Principles**
We follow clean architecture to keep code:
- **Organized** - Easy to find things
- **Scalable** - Easy to add new Surahs
- **Maintainable** - Easy to fix bugs
- **Testable** - Easy to verify it works

---

## 📂 PROJECT STRUCTURE

```
lib/
├── core/                           # Shared/reusable code
│   ├── constants/                  # App-wide constants
│   │   ├── app_colors.dart        # Brand colors (#FEF3E2, #FAB12F, etc.)
│   │   ├── app_sizes.dart         # Padding, spacing, sizes
│   │   └── app_text_styles.dart   # Typography (Poppins, Amiri)
│   ├── theme/
│   │   └── app_theme.dart         # Flutter theme configuration
│   ├── widgets/                    # Reusable UI components
│   │   ├── ozzie_button.dart
│   │   ├── ozzie_card.dart
│   │   ├── ozzie_app_bar.dart
│   │   └── ozzie_placeholder.dart # Ozzie mascot placeholder
│   └── router/
│       └── app_router.dart        # GoRouter configuration
│
├── features/                       # Feature modules
│   ├── home/                      # Home screen & Surah Map
│   │   └── ui/
│   │       └── screens/
│   │           ├── home_screen.dart
│   │           └── surah_map_screen.dart
│   │
│   ├── lesson/                    # The main lesson system
│   │   ├── data/                  # Data layer
│   │   │   └── models/
│   │   │       ├── surah_model.dart      # Surah data structure
│   │   │       ├── verse_model.dart      # Verse data structure
│   │   │       ├── word_model.dart       # Word data structure
│   │   │       ├── quiz_model.dart       # Quiz data structure
│   │   │       └── user_progress_model.dart # Progress tracking
│   │   │
│   │   ├── logic/                 # Business logic (controllers)
│   │   │   ├── lesson_flow_state.dart       # Lesson state
│   │   │   ├── lesson_flow_controller.dart  # Lesson controller
│   │   │   └── progress_controller.dart     # Progress management
│   │   │
│   │   └── ui/                    # User interface
│   │       └── screens/
│   │           ├── verse_trail_screen.dart      # Verse selection
│   │           ├── lesson_flow_screen.dart      # Main lesson wrapper
│   │           └── steps/                        # Individual lesson steps
│   │               ├── explanation_step_screen.dart    # Step 1
│   │               ├── recitation_step_screen.dart     # Step 2
│   │               ├── recording_step_screen.dart      # Step 3
│   │               ├── quiz1_step_screen.dart          # Step 4
│   │               ├── quiz2_step_screen.dart          # Step 5
│   │               └── celebration_step_screen.dart    # Step 6
│   │
│   └── progress/                  # Progress & analytics (future)
│
├── services/                      # Data services
│   ├── quran_data_service.dart   # Loads Quran data from JSON
│   └── progress_service.dart     # Hive operations for progress
│
└── main.dart                      # App entry point

assets/
├── data/                          # Quran content (JSON files)
│   ├── surah_001_al_fatiha.json
│   └── surah_112_al_ikhlas.json  # (Future)
├── images/                        # Images, icons
├── audio/                         # Local audio files (if needed)
└── animations/                    # Rive/Lottie animations
```

---

## 📊 DATA ARCHITECTURE

### **Hierarchy**
```
Quran (114 Surahs)
  └── Surah (e.g., Al-Fatiha)
        └── Verse (e.g., Verse 1)
              └── Word (e.g., "بِسْمِ")
```

### **Data Models**

#### **1. Surah Model** (`surah_model.dart`)
```dart
class Surah {
  final int number;              // 1-114
  final String nameArabic;       // "الفاتحة"
  final String nameEnglish;      // "Al-Fatiha"
  final String nameMeaning;      // "The Opening"
  final int totalVerses;         // 7
  final RevelationType revelationType; // Meccan/Medinan
  final List<Verse> verses;      // All verses in this Surah
  final String? description;     // Kid-friendly description
  final List<String>? themes;    // Main themes
}
```

#### **2. Verse Model** (`verse_model.dart`)
```dart
class Verse {
  final int verseNumber;         // 1, 2, 3...
  final String arabicText;       // "بِسْمِ اللَّهِ..."
  final String transliteration;  // "Bismillah ir-Rahman..."
  final String translation;      // English translation
  final String explanationForKids; // Kid-friendly explanation
  final String audioUrl;         // URL to audio file
  final List<Word> words;        // Individual words
  final Quiz? quiz1;             // Word order quiz (optional)
  final Quiz? quiz2;             // Comprehension quiz (optional)
}
```

#### **3. Word Model** (`word_model.dart`)
```dart
class Word {
  final String arabic;           // "بِسْمِ"
  final String transliteration;  // "Bismi"
  final String meaning;          // "In the name"
  final int position;            // 0, 1, 2... (order in verse)
}
```

#### **4. Quiz Model** (`quiz_model.dart`)
```dart
class Quiz {
  final String question;              // "What does Bismillah mean?"
  final List<String> options;         // 4 answer choices
  final int correctAnswerIndex;       // 0-3
  final String explanation;           // Why this is correct
  final String? hint;                 // Optional hint
}
```

### **JSON Structure**

**File**: `assets/data/surah_001_al_fatiha.json`

```json
{
  "number": 1,
  "nameArabic": "الفاتحة",
  "nameEnglish": "Al-Fatiha",
  "nameMeaning": "The Opening",
  "totalVerses": 7,
  "revelationType": "Meccan",
  "description": "Al-Fatiha is the first chapter...",
  "themes": ["Praise to Allah", "Seeking Guidance"],
  "verses": [
    {
      "verseNumber": 1,
      "arabicText": "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ",
      "transliteration": "Bismillah ir-Rahman ir-Raheem",
      "translation": "In the name of Allah...",
      "explanationForKids": "This verse means...",
      "audioUrl": "https://everyayah.com/data/Alafasy_128kbps/001001.mp3",
      "words": [
        {
          "arabic": "بِسْمِ",
          "transliteration": "Bismi",
          "meaning": "In the name",
          "position": 0
        }
      ],
      "quiz1": {
        "instruction": "Put the words in the correct order",
        "hint": "Listen to the recitation!"
      },
      "quiz2": {
        "question": "What does 'Bismillah' mean?",
        "options": [
          "In the name of Allah",
          "Praise be to Allah",
          "There is no god but Allah",
          "Allah is the Greatest"
        ],
        "correctAnswerIndex": 0,
        "explanation": "Bismillah means 'In the name of Allah'..."
      }
    }
  ]
}
```

### **Data Loading**

**QuranDataService** (`services/quran_data_service.dart`):
- Loads JSON from assets
- Parses into Dart objects
- Caches Surahs (don't reload)
- Provides methods to get Surah/Verse

```dart
// Example usage:
final service = QuranDataService();
final fatiha = await service.loadSurah(1);
final verse1 = await service.getVerse(surahNumber: 1, verseNumber: 1);
```

---

## 🧠 STATE MANAGEMENT

We use **Riverpod** for state management (think of it as a smart way to share data across screens).

### **Why Riverpod?**
- **Reactive**: UI updates automatically when data changes
- **Testable**: Easy to test in isolation
- **Type-safe**: Catches errors at compile time
- **Scalable**: Works well for large apps

### **Key Concepts**

#### **1. Providers**
Providers "provide" data to widgets.

```dart
// Example: Provide QuranDataService to the app
final quranDataServiceProvider = Provider((ref) => QuranDataService());
```

#### **2. StateNotifier**
Manages mutable state (state that changes over time).

```dart
// Example: LessonFlowController manages lesson state
class LessonFlowController extends StateNotifier<LessonFlowState> {
  void nextStep() {
    // Update state to next step
    state = state.copyWith(currentStep: state.currentStep.next);
  }
}
```

#### **3. ConsumerWidget**
Widgets that "consume" (use) providers.

```dart
class MyScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // "Watch" a provider (rebuilds when it changes)
    final lessonState = ref.watch(lessonFlowControllerProvider);
    
    return Text('Current step: ${lessonState.currentStep}');
  }
}
```

### **Lesson Flow State**

The lesson state tracks:
- Which Surah and verse we're learning
- What step we're on (1-6)
- Quiz answers
- Recording status
- Stars earned

```dart
class LessonFlowState {
  final int surahNumber;         // e.g., 1
  final int verseNumber;         // e.g., 1
  final LessonStep currentStep;  // e.g., LessonStep.explanation
  final Verse? verse;            // The loaded verse data
  final bool isLoading;
  final String? error;
  
  // Quiz state
  final bool? quiz1Correct;
  final bool? quiz2Correct;
  
  // Recording state
  final bool hasRecorded;
  final int? aiScore;
  
  // Completion
  final int starsEarned;         // 1-3
  final bool isCompleted;
}
```

---

## 🗺️ NAVIGATION FLOW

We use **GoRouter** for navigation.

### **Route Structure**
```
/                          → HomeScreen
/surah-map                 → SurahMapScreen
/surah/:surahNumber/trail  → VerseTrailScreen (NEW!)
/lesson/:surahNumber/:verseNumber → LessonFlowScreen
```

### **User Flow**
```
1. Home Screen
   ↓ [Start New Journey]
   
2. Surah Map (Planet selection)
   ↓ [Tap Al-Fatiha planet]
   
3. Verse Trail (Verse selection)
   ↓ [Tap Verse 1]
   
4. Lesson Flow (6 steps)
   Step 1: Explanation
   Step 2: Recitation
   Step 3: Recording
   Step 4: Quiz 1 (Word Order)
   Step 5: Quiz 2 (Comprehension)
   Step 6: Celebration
   ↓ [Complete]
   
5. Back to Verse Trail
   ↓ [All verses done?]
   
6. Surah Completion Celebration
   ↓
   
7. Back to Surah Map (planet shows COMPLETED)
```

### **Navigation Examples**

```dart
// Navigate to verse trail
context.push('/surah/1/trail');

// Navigate to specific lesson
context.push('/lesson/1/2');  // Surah 1, Verse 2

// Go back
context.pop();
```

---

## 🎓 LESSON FLOW ARCHITECTURE

### **6-Step Learning Journey**

Each verse goes through 6 steps:

| Step | Name | Purpose | File |
|------|------|---------|------|
| 1 | Explanation | Understand the meaning | `explanation_step_screen.dart` |
| 2 | Recitation | Listen to expert | `recitation_step_screen.dart` |
| 3 | Recording | Practice yourself | `recording_step_screen.dart` |
| 4 | Quiz 1 | Word order game | `quiz1_step_screen.dart` |
| 5 | Quiz 2 | Comprehension test | `quiz2_step_screen.dart` |
| 6 | Celebration | Celebrate success | `celebration_step_screen.dart` |

### **Step Details**

#### **Step 1: Explanation**
- Displays Arabic text
- Shows transliteration
- Shows English translation
- Shows kid-friendly explanation
- Optional audio narration

#### **Step 2: Recitation**
- Plays expert recitation from URL
- Audio controls (play/pause, seek, speed)
- Shows Arabic text + transliteration
- Can replay multiple times

#### **Step 3: Recording**
- Records user's voice
- Plays back recording
- Simulated AI feedback (80-95% score)
- TODO: Real AI with Google Speech-to-Text

#### **Step 4: Quiz 1 - Word Order**
- Scrambles words from verse
- User taps words to build correct order
- Checks answer
- Hint button (shows transliteration)
- Must get correct to proceed

#### **Step 5: Quiz 2 - Comprehension**
- Multiple choice question
- 4 answer options
- Immediate feedback
- Explanation shown
- Must get correct to proceed

#### **Step 6: Celebration**
- Shows stars earned (1-3)
- Confetti animation
- Ozzie celebrates
- Summary of what was learned
- "Next" button to continue

### **Star Calculation**
```
1 star  = Completed the verse
2 stars = Completed + both quizzes correct
3 stars = Perfect (quizzes + AI score ≥ 90%)
```

### **Lesson Flow Controller**

Manages the entire lesson:

```dart
class LessonFlowController extends StateNotifier<LessonFlowState> {
  // Load verse data
  Future<void> loadVerse();
  
  // Navigation
  void nextStep();
  void previousStep();
  
  // Quiz 1
  void submitQuiz1Answer(List<String> answers);
  
  // Quiz 2
  void submitQuiz2Answer(String answer);
  
  // Recording
  void submitRecording(String path, int aiScore);
  
  // Completion
  void completeVerse();
}
```

---

## 💾 PROGRESS TRACKING

### **What We Track**

**Per Verse**:
- Is completed?
- Stars earned (1-3)
- Completion date

**Per Surah**:
- Which verses are completed
- Total stars earned
- Is Surah completed?

**Global** (Future):
- Total verses completed
- Current streak (days)
- Badges earned

### **Storage: Hive**

Hive is a fast, local NoSQL database for Flutter.

**Why Hive?**
- Fast (faster than SQLite)
- Easy to use
- Works offline
- Type-safe

### **Progress Models**

```dart
// UserProgress (top-level)
class UserProgress {
  final String userId;
  final Map<int, SurahProgress> surahProgress;
  final int currentStreak;
  final List<String> badgesEarned;
}

// SurahProgress
class SurahProgress {
  final int surahNumber;
  final List<int> versesCompleted;    // [1, 2, 3]
  final Map<int, int> verseStars;     // {1: 3, 2: 2}
  final bool isCompleted;
}
```

### **Progress Service**

```dart
class ProgressService {
  // Save verse completion
  Future<void> saveVerseProgress({
    required int surahNumber,
    required int verseNumber,
    required int stars,
  });
  
  // Load user progress
  Future<UserProgress> loadProgress();
  
  // Check if verse is completed
  bool isVerseCompleted(int surahNumber, int verseNumber);
  
  // Get stars for verse
  int getVerseStars(int surahNumber, int verseNumber);
}
```

---

## ➕ ADDING NEW CONTENT

### **How to Add a New Surah**

1. **Create JSON file**
   - File: `assets/data/surah_XXX_name.json`
   - Copy structure from `surah_001_al_fatiha.json`
   - Fill in Surah data, verses, quizzes

2. **Update pubspec.yaml**
   ```yaml
   assets:
     - assets/data/surah_XXX_name.json
   ```

3. **Update QuranDataService**
   ```dart
   String _getSurahFileName(int surahNumber) {
     switch (surahNumber) {
       case 1: return 'al_fatiha';
       case XXX: return 'your_surah_name';  // ADD THIS
     }
   }
   ```

4. **Add to Surah Map**
   - Add planet visual in `surah_map_screen.dart`
   - Set unlock logic

5. **Test**
   - Load Surah data
   - Test all verses
   - Verify quizzes work

### **How to Add Quiz Questions**

1. **Read verse content** in JSON file
2. **Create quiz2 object**:
   ```json
   "quiz2": {
     "question": "What does X mean?",
     "options": ["A", "B", "C", "D"],
     "correctAnswerIndex": 0,
     "explanation": "X means..."
   }
   ```

3. **Guidelines**:
   - Age-appropriate (6-12 years)
   - Test comprehension, not memorization
   - 4 options, 1 correct
   - Provide clear, educational explanation
   - Make it engaging!

---

## ✅ BEST PRACTICES

### **Code Organization**
- ✅ Keep files small and focused (< 500 lines)
- ✅ One widget per file (usually)
- ✅ Group related files in folders
- ✅ Use clear, descriptive names

### **Naming Conventions**
- **Files**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Variables**: `camelCase`
- **Constants**: `SCREAMING_SNAKE_CASE`
- **Private**: `_privateVariable`

### **Comments**
- ✅ Explain **WHY**, not **WHAT**
- ✅ Add comments for complex logic
- ✅ Use doc comments for public APIs
- ✅ Keep comments up-to-date

### **State Management**
- ✅ Use Riverpod providers
- ✅ Keep state immutable (use `copyWith`)
- ✅ Don't mutate state directly
- ✅ Use `ConsumerWidget` to watch providers

### **Error Handling**
- ✅ Use try-catch for async operations
- ✅ Show user-friendly error messages
- ✅ Log errors for debugging
- ✅ Provide fallback UI

### **Testing**
- ✅ Test after each major change
- ✅ Test edge cases (empty data, errors)
- ✅ Test on real devices (not just simulator)
- ✅ Test navigation flows

### **Performance**
- ✅ Use `const` constructors when possible
- ✅ Cache loaded data (don't reload unnecessarily)
- ✅ Lazy-load large lists
- ✅ Optimize images

---

## 🔧 TROUBLESHOOTING

### **Common Issues**

**Issue**: Verse data not loading  
**Solution**: Check JSON syntax, verify file path in `pubspec.yaml`

**Issue**: Navigation not working  
**Solution**: Check route parameters, verify GoRouter config

**Issue**: State not updating  
**Solution**: Make sure you're using `copyWith`, not mutating state directly

**Issue**: Audio not playing  
**Solution**: Check internet connection, verify audio URL, check permissions

**Issue**: Progress not saving  
**Solution**: Verify Hive initialization in `main.dart`, check `ProgressService`

---

## 📖 LEARNING RESOURCES

### **Flutter**
- [Flutter Docs](https://docs.flutter.dev/)
- [Flutter Widget Catalog](https://docs.flutter.dev/ui/widgets)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)

### **Riverpod**
- [Riverpod Docs](https://riverpod.dev/)
- [Riverpod Quick Start](https://riverpod.dev/docs/getting_started)

### **GoRouter**
- [GoRouter Package](https://pub.dev/packages/go_router)
- [GoRouter Tutorial](https://docs.flutter.dev/ui/navigation)

### **Hive**
- [Hive Docs](https://docs.hivedb.dev/)
- [Hive Quick Start](https://pub.dev/packages/hive)

---

## 🎉 CONCLUSION

This architecture is designed to be:
- **Scalable**: Easy to add 114 Surahs
- **Maintainable**: Clear structure, good documentation
- **Educational**: Comments explain complex concepts
- **Professional**: Follows Flutter best practices

If you have questions, refer to:
1. This document (ARCHITECTURE.md)
2. Code comments
3. ACTION_PLAN.md (overall project plan)
4. DEVELOPER_PREFERENCES.md (workflow preferences)

**Happy coding!** 🚀

---

**Last Updated**: October 2, 2025  
**Maintainers**: Ozzie Development Team  
**Questions?**: Check documentation first, then ask!


