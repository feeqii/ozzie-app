# 👨‍💻 Developer Preferences & Workflow Guide

> **This document captures how I like to work, communicate, and learn. Please read this before starting any development work!**

---

## 🗣️ **Communication Style**

### Explain Like I'm 10
- **Break down complex concepts** into simple, everyday language
- Use **analogies and examples** when explaining technical terms
- Don't assume I know technical jargon - explain it first
- Example: Instead of "We'll implement dependency injection", say "We'll make it easy to swap out different parts of the app, like changing batteries in a toy"

### Ask Clarifying Questions
- **Always ask clarifying questions** when something is unclear
- Better to ask too many questions than make wrong assumptions
- If you don't know something, **say you don't know** - don't guess
- Help me understand the "why" behind technical decisions

### Stay Organized
- Break problems into **smaller, manageable tasks**
- Use clear headings, bullet points, and structure
- Keep explanations focused on one topic at a time
- Use visual indicators (✅ ❌ 🔄 💡 🎯) to make things scannable

---

## 💻 **Development Approach**

### Foundations First
- **Never skip the foundations** - get them perfect before moving forward
- Build the design system, architecture, and core utilities first
- Don't rush to the "fun" features - the foundation matters most
- Quote: *"Listen, don't skip out on the foundations, lets get the foundations perfect and then we'll start building out the lesson"*

### Clean Code from Day One
- **Clean architecture and documentation from day one** - this is very important!
- Write well-organized, maintainable code
- Include comments and explanations in the code
- Follow best practices and design patterns
- Think long-term, not quick hacks

### Test as We Go
- **Constantly test** after each implementation
- I have my iPhone 17 available for real device testing
- Use iPhone 14 Pro Max simulator for quick iterations
- Verify everything works before moving to the next step
- Fix errors immediately - don't accumulate technical debt

### Review Before Changing
- **Always review the entire codebase** before making changes
- Ensure you're not creating duplicate files or functionality
- Don't overcomplicate things unnecessarily
- Understand existing patterns before adding new code

---

## 🎓 **Learning Preferences**

### I'm Learning Flutter & Rive
- I'm **new to Flutter and Rive** - be patient and explain thoroughly
- This is a learning opportunity for me, not just a client project
- Include **learning resources** alongside development when helpful
- Pair program with lots of **comments and explanations in the code**

### Show Me How Things Work
- Explain what you're doing as we build
- Show me **why** you chose a particular approach
- Help me understand Flutter/Dart concepts (I don't know what "Dart syntax" means initially)
- Make this an educational experience, not just code generation

### Visual Learning
- Screenshots and examples help a lot
- Show me what the app looks like after changes
- Use code examples to illustrate concepts
- Diagrams are great when explaining architecture

---

## 🚀 **Project Philosophy**

### Quality Over Speed
- **No deadlines or rush** - I'd rather do it right than do it fast
- Take time to research and make informed decisions
- Document everything well for future reference
- Build something we're proud of

### Iterative & Incremental
- Build bit by bit, testing as we go
- Complete one feature fully before moving to the next
- Celebrate small wins along the way
- Keep the momentum positive and encouraging

### Research-Driven Decisions
- Research options before choosing tech (APIs, libraries, patterns)
- Document findings in `RESEARCH_FINDINGS.md`
- Discuss pros/cons of different approaches
- Make informed choices, not arbitrary ones

---

## ✅ **What Works Well for Me**

### Documentation
- I love having **comprehensive documentation files**:
  - `PROJECT_BRIEF.md` - Vision and goals
  - `RESEARCH_FINDINGS.md` - Technical research and decisions
  - `ACTION_PLAN.md` - Development roadmap and milestones
  - `DEVELOPER_PREFERENCES.md` - This file!
- Keep docs updated as the project evolves
- Use markdown for clear formatting

### Q&A Before Coding
- I prefer to **discuss and plan before writing code**
- Walk through requirements together
- Ask me questions to clarify scope and priorities
- Make sure we're aligned before implementation

### Confirmation Before Big Changes
- **Ask for confirmation** before editing integral functionality
- Provide a brief explanation of why the change is needed
- Let me review and approve architectural decisions
- Keep me in the loop on important choices

---

## 🎯 **Current Project Context**

### Target Audience
- **Kids aged 6-12** learning Quranic wisdom
- Think Duolingo but for the Quran
- Make it engaging, fun, and educational

### Priorities (in order)
1. **Gamification** (badges, streaks, points)
2. **Progress tracking/analytics**
3. **Parental dashboard**
4. **Ozzie mascot animations** (lower priority for now)

### MVP Scope
- 2 complete Surahs (short ones: Al-Fatiha, Al-Ikhlas)
- All 6 lesson steps (explanation → recitation → recording → quiz → quiz → celebration)
- Both iOS and Android
- Build pure functionality first, animations later

### Tech Stack Preferences
- **Flutter** (latest stable version)
- **Riverpod** for state management (recommended by previous agent)
- **GoRouter** for navigation
- **Google Fonts** (Poppins for English, Amiri for Arabic)
- **Firebase** (or alternatives - we'll worry about backend later)
- **Google Cloud Speech-to-Text** for AI feedback

---

## 🎨 **Design Philosophy**

### Brand Colors
- Warm, cosmic theme (Cream, Gold, Orange, Red)
- Space-inspired elements (stars, planets)
- See `lib/core/constants/app_colors.dart` for exact colors

### Fonts
- **English**: Poppins (via Google Fonts)
- **Arabic**: Amiri (via Google Fonts)
- See `lib/core/constants/app_text_styles.dart`

### UX Principles
- **Kid-friendly** and playful
- **Clear visual hierarchy**
- **Smooth animations** (when we add them)
- **Immediate feedback** for all actions
- **Celebratory** - make learning feel like winning

---

## 📝 **Development Workflow**

### Git Practices
- Commit frequently with **descriptive messages**
- Use conventional commits (feat:, fix:, docs:, etc.)
- Push to GitHub regularly
- Repository: https://github.com/feeqii/ozzie-app.git

### File Organization
- Follow **clean architecture** structure:
  - `lib/core/` - Design system, constants, widgets
  - `lib/features/` - Feature modules
  - `lib/services/` - Data services
  - `assets/` - Images, audio, data, animations
- Keep related files together
- Use clear, descriptive file names

### Error Handling
- **Debug together** when issues arise
- Help me understand what went wrong
- Show me how to read error messages
- Fix root causes, not symptoms

---

## 💡 **Conversation Flow That Works**

1. **Start with context** - Review relevant files and project state
2. **Ask clarifying questions** - Make sure we're aligned
3. **Explain the approach** - What you'll build and why
4. **Show the code** - With comments and explanations
5. **Test together** - Verify it works
6. **Celebrate wins** - Acknowledge progress! 🎉
7. **Plan next steps** - What's coming next

---

## 🚫 **Things to Avoid**

- ❌ Don't skip foundations or rush to features
- ❌ Don't use technical jargon without explaining
- ❌ Don't make assumptions - ask questions instead
- ❌ Don't create duplicate files or overcomplicate things
- ❌ Don't commit changes without my knowledge
- ❌ Don't worry about deadlines or timelines

---

## 🌟 **Final Notes**

> **"This conversation flow really worked for me, so I wanna keep the same energy"**

- Keep the energy **positive and encouraging**
- Make this a **collaborative** experience
- Help me **learn and grow** as a developer
- Build something we're both **proud of**
- Have fun with it! 🚀

---

**Last Updated**: October 1, 2025  
**Project**: Ozzie - Quranic Learning App for Kids  
**Status**: Foundation Complete, Ready for Lesson Flow Implementation

