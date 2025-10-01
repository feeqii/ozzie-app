# 📱 OZZIE - Quranic Learning App for Children

## 🎯 Vision
Duolingo-style Quranic learning app combining Islamic authenticity with modern child psychology, AI-powered feedback, and emotional engagement through the Ozzie mascot.

## 👥 Target Audience
Children aged 6-12 years

## 🎨 Brand Colors
- **Cream**: `#FEF3E2` - rgb(254, 243, 226)
- **Gold**: `#FAB12F` - rgb(250, 177, 47) 
- **Orange**: `#FA812F` - rgb(250, 129, 47)
- **Red**: `#DD0303` - rgb(221, 3, 3)

**Design Philosophy**: Warm, encouraging colors that promote learning and engagement

---

## 📋 MVP Scope (6 Months)

### Core Features - MUST HAVE
1. ✅ **Ozzie Mascot Integration** (placeholder initially)
2. ✅ **2 Complete Surahs**: Al-Fatiha (7 verses) + Al-Ikhlas (4 verses)
3. ✅ **6-Step Lesson Structure** (see below)
4. ✅ **Basic AI Recitation Feedback**
5. ✅ **Auditory Comparison** with expert reciters
6. ✅ **Integrated Quizzes & Games**
7. ✅ **Simple Gamification** (badges, streaks, points)
8. ✅ **Basic Parental Dashboard**

### 6-Step Lesson Flow (Per Verse)
1. 📖 **Child-tailored explanation** with visuals
2. 🎧 **Expert recitation listening** (2 speeds: normal & slow)
3. 🎤 **Voice recording with instant AI feedback**
4. ❓ **Quiz Practice** - Comprehension questions
5. ❓ **Quiz Practice** - Word order/meaning games
6. 🎉 **Completion Celebration** with Ozzie

---

## 🏆 Feature Priority Order
1. **Gamification** (badges, streaks, points) - HIGHEST
2. **Progress Tracking & Analytics** 
3. **Parental Dashboard**
4. **Ozzie Mascot Animations** - LOWEST (Phase 2+)

---

## 🛠️ Tech Stack

| Layer | Technology | Phase |
|-------|-----------|-------|
| **Frontend** | Flutter 3.x (cross-platform) | MVP |
| **State Management** | Riverpod | MVP |
| **Animations** | Rive (later) / Flutter built-in (MVP) | MVP → Phase 2 |
| **Navigation** | GoRouter / Navigator 2.0 | MVP |
| **Local Storage** | Hive / SQLite | MVP |
| **Backend** | Firebase / Supabase (TBD later) | Phase 2 |
| **Audio** | audioplayers package | MVP |
| **Recording** | record package | MVP |
| **AI Feedback** | Google Cloud Speech-to-Text / Tarteel AI | MVP |

---

## 📐 Architecture Principles
- ✅ **Clean Architecture** from Day 1
- ✅ **Feature-based folder structure**
- ✅ **Comprehensive documentation & comments**
- ✅ **Explain like teaching a 10-year-old**

---

## 🎨 UX/UI Philosophy

### Emotional Connection
- Ozzie mascot creates personal bond
- Positivity reinforcement (celebration > punishment)

### Child-Centric Interface
- Large touch targets
- Clear navigation
- Minimal cognitive load

### Family Involvement
- Parent engagement tools
- Progress monitoring
- Islamic scholar validation

### Visual Design
- Child-friendly aesthetics
- Culturally sensitive
- Nothing insensitive

### Audio Quality
- High-fidelity Quranic recitations
- Child-appropriate reciters

---

## 🌍 App Narrative Theme: "Cosmic Quest for Wisdom"

### Space Adventure for Ages 6-12
- **Map Level Picker**: Planets represent Surahs (dim/greyed initially)
- **Completion Celebration**: Planets "light up" with 3 stars
- **Verse Levels**: Trail of milestones within each planet
- **Ozzie Guide**: Mascot accompanies journey with pop-up messages

---

## 📱 Development Approach
1. ✅ **Foundation First** - No skipping basics!
2. ✅ **Build → Test → Iterate** continuously
3. ✅ **Hardcode 2 Surahs** initially, design for scalability
4. ✅ **Placeholder assets** until final designs ready
5. ✅ **Documentation** at every step

---

## 🚀 Timeline Overview
- **Phase 1 (Weeks 1-2)**: Foundations - Project setup, design system, navigation
- **Phase 2 (Weeks 3-4)**: Core lesson flow for 1 verse
- **Phase 3 (Weeks 5-6)**: Complete 2 Surahs, AI integration, polish

---

## ✅ Git Repository
- **URL**: https://github.com/feeqii/ozzie-app.git
- **Branching**: Simple - push to main (for now)

---

## 📱 Testing
- **Device**: iPhone (iOS primary testing)
- **Platforms**: iOS + Android (simultaneous development)

---

## ❓ Questions to Clarify Later
- [ ] Tajweed color-coding (pronunciation rules visualization)?
- [ ] Offline-first or online-first data strategy?
- [ ] Detailed progress tracking (verse-by-verse, word mastery, time spent)?
- [ ] Backend choice (Firebase vs Supabase)?

