# 🚀 OZZIE APP - Development Action Plan

## 📅 Phase 1: Foundations (Weeks 1-2)

### Week 1: Project Setup & Design System

#### Task 1.1: Flutter Environment Setup ⚙️
**What we'll do**: Install Flutter and set up your development environment

**Steps**:
1. Install Flutter SDK (latest stable 3.x)
2. Install Android Studio + Xcode (for iOS)
3. Set up VS Code with Flutter extensions
4. Test with `flutter doctor` command
5. Create new Flutter project
6. Connect to GitHub repository

**You'll learn**: How Flutter projects are structured, what files do what

**Time**: 2-3 hours

---

#### Task 1.2: Git Repository Integration 🔄
**What we'll do**: Connect our code to GitHub

**Steps**:
1. Initialize git in project
2. Add `.gitignore` for Flutter
3. Connect to `https://github.com/feeqii/ozzie-app.git`
4. Create initial commit
5. Set up basic branching (main branch)

**You'll learn**: Version control basics

**Time**: 30 minutes

---

#### Task 1.3: Design System Foundation 🎨
**What we'll do**: Create the "look and feel" rules for our app

**Steps**:
1. Create `lib/core/constants/app_colors.dart`
   - Define your 4 brand colors (#FEF3E2, #FAB12F, #FA812F, #DD0303)
   - Add semantic color names (background, primary, accent, etc.)

2. Create `lib/core/constants/app_text_styles.dart`
   - Set up Arabic font (Amiri)
   - Set up English font (Poppins/Quicksand for kids)
   - Define text sizes (heading, body, caption)

3. Create `lib/core/theme/app_theme.dart`
   - Combine colors + text styles
   - Create Flutter ThemeData

4. Create `lib/core/constants/app_sizes.dart`
   - Padding values
   - Border radius
   - Icon sizes

**What you'll learn**: How to keep design consistent, what "constants" mean

**Files created**: 4 files
**Time**: 2-3 hours

---

#### Task 1.4: Reusable Widgets 🧩
**What we'll do**: Create building blocks we'll use everywhere

**Widgets to create**:
1. `OzzieButton` - Colorful, kid-friendly button
2. `OzzieCard` - Rounded card for content
3. `OzzieAppBar` - Top navigation bar
4. `OzzieLoadingSpinner` - Loading animation
5. `OzziePlaceholder` - For Ozzie mascot (simple circle with "Ozzie" text for now)

**What you'll learn**: What widgets are, how to make reusable components

**Files created**: 5 widget files in `lib/core/widgets/`
**Time**: 3-4 hours

---

### Week 2: Navigation & Data Structure

#### Task 2.1: App Navigation Setup 🗺️
**What we'll do**: Create the "roads" between different screens

**Steps**:
1. Add `go_router` package
2. Create placeholder screens:
   - `HomeScreen` - Main menu
   - `SurahMapScreen` - Planet/Surah selector
   - `LessonFlowScreen` - The 6-step lesson
   - `ProfileScreen` - User progress
3. Set up routes in `lib/core/router/app_router.dart`
4. Test navigation between screens

**What you'll learn**: How apps move between screens, routing concepts

**Screens created**: 4 basic screens
**Time**: 3-4 hours

---

#### Task 2.2: Data Models 📊
**What we'll do**: Create the "shape" of our Quran data

**Models to create**:
1. `Surah` - Represents a chapter
   ```dart
   class Surah {
     int number;
     String nameArabic;
     String nameEnglish;
     int totalVerses;
     List<Verse> verses;
   }
   ```

2. `Verse` - Represents a single verse
   ```dart
   class Verse {
     int verseNumber;
     String arabicText;
     String transliteration;
     String translation;
     String explanationForKids;
     String audioUrl;
     List<Word> words;
   }
   ```

3. `Word` - Individual word in verse
   ```dart
   class Word {
     String arabic;
     String transliteration;
     String meaning;
   }
   ```

4. `UserProgress` - Track user's learning
   ```dart
   class UserProgress {
     String userId;
     Map<int, SurahProgress> surahProgress;
     int totalBadges;
     int currentStreak;
   }
   ```

**What you'll learn**: How to structure data, what "models" are, Dart classes

**Files created**: 4 model files in `lib/features/lesson/data/models/`
**Time**: 2-3 hours

---

#### Task 2.3: Create Quran Content (JSON) 📖
**What we'll do**: Create the actual Surah content in organized files

**Steps**:
1. Create `assets/data/` folder
2. Fetch Al-Fatiha data from Al-Quran Cloud API
3. Format into our JSON structure
4. Create `surah_001_al_fatiha.json`
5. Repeat for Al-Ikhlas (`surah_112_al_ikhlas.json`)
6. Write child-friendly explanations for each verse (we'll help with this!)

**What you'll learn**: JSON format, how to structure content data

**Files created**: 2 JSON files
**Time**: 4-5 hours (including writing explanations)

---

#### Task 2.4: Data Service 🔌
**What we'll do**: Create code that reads our JSON files

**Steps**:
1. Create `lib/services/quran_data_service.dart`
2. Write function to load JSON from assets
3. Convert JSON to Surah objects
4. Test loading both Surahs

**What you'll learn**: How to read files, async programming, services

**Files created**: 1 service file
**Time**: 2-3 hours

---

## 📅 Phase 2: Core Lesson Flow (Weeks 3-4)

### Week 3: Lesson Steps 1-3

#### Task 3.1: Lesson Flow Architecture 🏗️
**What we'll do**: Create the structure for the 6-step lesson

**Steps**:
1. Create `LessonFlowController` (Riverpod provider)
   - Track current step (1-6)
   - Track current verse
   - Handle step progression
2. Create `LessonFlowScreen` with stepper UI
3. Show progress (Step 1 of 6, etc.)

**What you'll learn**: State management with Riverpod, controllers

**Files created**: 2 files (controller + screen)
**Time**: 3-4 hours

---

#### Task 3.2: Step 1 - Explanation Screen 📖
**What we'll do**: Show verse explanation with visuals

**Components**:
1. Display Arabic text (large, beautiful)
2. Show transliteration
3. Show English translation
4. Show kid-friendly explanation
5. Audio narration button (we'll record or use TTS)
6. Simple illustrations (placeholder images for now)
7. "Next" button to continue

**What you'll learn**: Text rendering, audio playback, layouts

**Time**: 4-5 hours

---

#### Task 3.3: Step 2 - Expert Recitation 🎧
**What we'll do**: Play expert reciter audio with controls

**Components**:
1. Display Arabic text (highlighted as it plays - if time allows)
2. Audio player with:
   - Play/Pause button
   - Speed control (Normal/Slow)
   - Replay button
3. Show transliteration below
4. "I'm ready to practice" button

**What you'll learn**: Audio playback, audio controls, timing

**Packages**: `audioplayers`
**Time**: 4-5 hours

---

#### Task 3.4: Step 3 - Voice Recording 🎤
**What we'll do**: Let kids record themselves reciting

**Components**:
1. Big "Press to Record" button
2. Recording indicator (animated red circle)
3. Playback of their recording
4. "Re-record" option
5. "Submit for feedback" button
6. Save audio file locally

**What you'll learn**: Audio recording, permissions, file storage

**Packages**: `record`, `permission_handler`
**Time**: 5-6 hours

---

### Week 4: Lesson Steps 4-6 + Integration

#### Task 4.1: Step 4 - Comprehension Quiz ❓
**What we'll do**: Create interactive quiz about verse meaning

**Components**:
1. Question display
2. Multiple choice answers (4 options)
3. Tap to select answer
4. Immediate feedback (correct/incorrect)
5. Explanation if wrong
6. "Next question" button
7. Score tracking

**Quiz types**:
- What does this verse mean?
- Which word means "X"?
- What is this verse teaching us?

**What you'll learn**: Interactive UI, conditionals, quiz logic

**Time**: 4-5 hours

---

#### Task 4.2: Step 5 - Word Order Quiz 🎮
**What we'll do**: Drag-and-drop word ordering game

**Components**:
1. Scrambled Arabic words at bottom
2. Empty slots at top
3. Drag words into correct order
4. Check button
5. Visual feedback (green checkmark / red X)
6. Hint button (show one word in correct position)

**What you'll learn**: Drag-and-drop, game mechanics, animations

**Time**: 5-6 hours

---

#### Task 4.3: Step 6 - Celebration Screen 🎉
**What we'll do**: Reward completion with fun celebration

**Components**:
1. Confetti animation
2. "Great job!" message from Ozzie (placeholder image)
3. Show what they learned (verse summary)
4. Stars earned (1-3 based on quiz performance)
5. Badge if earned (first time, perfect score, etc.)
6. "Continue" button to next verse or back to map

**What you'll learn**: Animations, rewards systems

**Packages**: `confetti`, `lottie` (for simple animations)
**Time**: 3-4 hours

---

#### Task 4.4: AI Feedback Integration (Basic) 🤖
**What we'll do**: Add basic pronunciation feedback

**Steps**:
1. Set up Google Cloud Speech-to-Text
   - Create Google Cloud project
   - Enable Speech-to-Text API
   - Get API key
2. Integrate with `speech_to_text` package
3. Send recorded audio to Google API
4. Get transcription back
5. Compare with expected Arabic text
6. Show basic feedback:
   - ✅ Great! (90%+ match)
   - 😊 Good job! (70-89% match)
   - 💪 Keep practicing! (<70% match)

**What you'll learn**: API integration, cloud services, comparison logic

**Time**: 6-8 hours (includes setup)

---

## 📅 Phase 3: Polish & Gamification (Weeks 5-6)

### Week 5: Progress & Gamification

#### Task 5.1: Local Storage with Hive 💾
**What we'll do**: Save user progress on device

**Steps**:
1. Set up Hive database
2. Create progress models
3. Save after each lesson:
   - Verse completion
   - Stars earned
   - Quiz scores
   - Streak days
4. Load progress on app start

**What you'll learn**: Local databases, persistence

**Time**: 3-4 hours

---

#### Task 5.2: Home Screen Dashboard 🏠
**What we'll do**: Show progress and motivate learning

**Components**:
1. Ozzie greeting (placeholder)
2. Daily streak counter (🔥 7 Days)
3. Progress bars for each Surah
4. Recent badges showcase
5. "Continue Learning" button
6. "Start New Journey" button

**What you'll learn**: Dashboard layouts, progress visualization

**Time**: 4-5 hours

---

#### Task 5.3: Surah Map Screen 🪐
**What we'll do**: Create the "cosmic quest" planet selector

**Components**:
1. Space background
2. Two planets (Al-Fatiha, Al-Ikhlas)
3. Planet states:
   - Locked (greyed out)
   - In Progress (glowing)
   - Completed (3 stars around it)
4. Tap planet to see verse trail
5. Tap verse to start lesson

**What you'll learn**: Custom painting, visual states, game-like UI

**Time**: 6-7 hours

---

#### Task 5.4: Badge System 🏆
**What we'll do**: Create achievement badges

**Badges**:
1. First Verse (complete any verse)
2. First Surah (complete Al-Fatiha)
3. Perfect Recitation (100% AI score)
4. 7-Day Streak
5. Early Bird (study in morning)
6. Night Owl (study at night)
7. Speed Learner (complete in under 5 minutes)

**Components**:
1. Badge icons (simple SVGs)
2. Badge unlock logic
3. Badge collection screen
4. Badge notifications

**What you'll learn**: Achievement systems, notifications

**Time**: 5-6 hours

---

### Week 6: Complete Second Surah & Polish

#### Task 6.1: Complete Al-Ikhlas Content ✅
**What we'll do**: Add all 4 verses of Al-Ikhlas

**Steps**:
1. Ensure JSON data is complete
2. Test all 6 lesson steps for each verse
3. Write quiz questions for all verses
4. Test full Surah completion flow

**Time**: 4-5 hours

---

#### Task 6.2: Polish & Refinement ✨
**What we'll do**: Make everything smooth and beautiful

**Tasks**:
1. Add loading states everywhere
2. Add error handling (no internet, etc.)
3. Smooth transitions between screens
4. Add sound effects (button clicks, success sounds)
5. Improve animations
6. Test on real iPhone
7. Fix any bugs

**Time**: 6-8 hours

---

#### Task 6.3: Basic Parental Dashboard 👨‍👩‍👧
**What we'll do**: Show parents their child's progress

**Components**:
1. PIN lock to access
2. Progress overview:
   - Surahs completed
   - Verses mastered
   - Total time studied
   - Current streak
3. Detailed statistics per Surah
4. Badges earned
5. Recitation scores over time (simple graph)

**What you'll learn**: Data visualization, authentication

**Time**: 5-6 hours

---

#### Task 6.4: Final Testing & Documentation 📝
**What we'll do**: Make sure everything works perfectly

**Steps**:
1. Test entire app flow start to finish
2. Test on both iOS and Android
3. Write user manual (how to use the app)
4. Write developer documentation (how code works)
5. Create demo video
6. Fix final bugs

**Time**: 4-5 hours

---

## 📊 Summary Timeline

| Phase | Duration | Key Deliverables |
|-------|----------|------------------|
| **Phase 1** | Weeks 1-2 | Setup, Design System, Navigation, Data Models |
| **Phase 2** | Weeks 3-4 | 6-Step Lesson Flow, AI Feedback (basic) |
| **Phase 3** | Weeks 5-6 | Gamification, 2 Complete Surahs, Dashboard |

**Total**: 6 weeks to MVP 🚀

---

## 🎯 Success Criteria

At the end of 6 weeks, we'll have:
- ✅ Fully functional app on iOS + Android
- ✅ 2 complete Surahs (Al-Fatiha + Al-Ikhlas)
- ✅ All 6 lesson steps working
- ✅ Basic AI pronunciation feedback
- ✅ Gamification (badges, streaks, progress)
- ✅ Parental dashboard
- ✅ Beautiful, child-friendly UI
- ✅ Clean, documented code
- ✅ Ready to demo to client!

---

## 📚 Learning Resources for You

As we build, I'll share:
1. **Flutter Basics**: Widgets, State, Navigation
2. **Dart Language**: Variables, Functions, Classes, Async
3. **Riverpod**: State management patterns
4. **Clean Architecture**: Why we organize code this way
5. **Best Practices**: Comments, naming, structure

Every code file will have:
- 📝 Comments explaining WHAT and WHY
- 🎯 Simple explanations (like teaching a 10-year-old)
- 🔗 Links to docs when you want to learn more

---

## 🚀 Ready to Start?

Once you approve this plan, we'll:
1. ✅ Start with **Task 1.1** (Flutter setup)
2. ✅ Work through tasks **one by one**
3. ✅ Test after each task
4. ✅ Commit to GitHub regularly
5. ✅ Keep documentation updated

**Let me know if you approve, or if you want to adjust anything!** 🎉

