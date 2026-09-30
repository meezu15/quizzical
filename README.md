# Quizzical — Mobile App Development Lab Final Exam (CSE-3212)

**University of Barishal**  
*Department of Computer Science & Engineering (CSE)*  
*Lab Final Examination – 2026 | 3rd Year, 2nd Semester (2021-22)*  
*Course Code: CSE-3212 | Course Title: Mobile App Development Lab*

---

## 📌 Project Overview
**Quizzical** is a clean, responsive, and accessible trivia quiz application developed in Flutter. The application integrates seamlessly with the **Open Trivia Database (OpenTDB)** REST API, implementing robust session-level caching, state management with **Provider**, local persistence via **SharedPreferences**, animated countdown timers, live scoring, and feedback cards closely adhering to the provided Figma design specifications.

---

## 📱 Application Flow & Screens

### 1. Screen 1 — Welcome (`WelcomeScreen`)
- **Visuals**: Cheerful Figma-inspired illustration featuring playful 3D question marks, avatar, and soft accents.
- **Identity**: App title *"Quizzical"* with personalized candidate name (*"Your_Name"*, editable on tap).
- **CTA**: Primary teal pill button labeled **"GET STARTED"** navigating smoothly to Category Selection.
- **Responsiveness**: Adapts layout across small smartphones and large tablet screens.

### 2. Screen 2 — Category Selection (`CategorySelectionScreen`)
- **API Endpoint**: `GET https://opentdb.com/api_category.php`
- **Session Caching**: Categories are fetched once and cached in-memory for the duration of the user session.
- **Visual Grid**: Responsive 2-to-4 column grid featuring pastel card backgrounds (`#D6E4FF`, `#D4F4DD`, `#FFF0D4`, `#F0D6FF`, `#FFE4DE`, etc.) and contextual iconography for each category.
- **Loading & Error Handling**:
  - Skeleton shimmer placeholder while loading categories.
  - Retry banner displaying actionable errors if network or server fails.
- **Interaction**: Tapping any card captures the `categoryId` & `categoryName` and navigates to Quiz Configuration.

### 3. Screen 3 — Quiz Configuration (`QuizConfigurationScreen`)
- **Top Visual**: Interactive settings/switch illustration.
- **Dynamic Controls**:
  - **Amount**: Interactive slider from 1 to 50 questions (default: 10).
  - **Difficulty**: Dropdown selector (`Any Difficulty`, `Easy`, `Medium`, `Hard`).
  - **Type**: Dropdown selector (`Multiple Choice`, `True / False`, `Any Type`).
- **Persistence**: Remembers and preserves the last chosen configuration via `SharedPreferences`.
- **Fetch & Error Handling**: Initiates question fetch via OpenTDB API with fallback and retry preserving user selections.

### 4. Screen 4 — Interactive Quiz (`QuizScreen`)
- **API Endpoint**: `GET https://opentdb.com/api.php?amount=<n>&category=<id>&difficulty=<level>&type=<multiple|boolean>`
- **Live Progress & Counter**:
  - App bar displays live question counter (e.g. `7/10`) and an accessible **EXIT** button with confirmation dialog.
  - Smooth animated progress bar directly below the app bar.
- **Question Logic & Timer**:
  - HTML entities cleanly unescaped (`&quot;`, `&#039;`, `&amp;`, etc.).
  - 25-second countdown timer per question with warning color transitions (green → orange → red).
  - On timeout: automatically marks question as unanswered, highlights the correct answer, and auto-advances.
- **Options & Instant Feedback**:
  - 4 shuffled options for multiple choice; 2 buttons for boolean (`True` / `False`).
  - Correct answer highlighted in soft green (`#A7D7C5`) with checkmark icon.
  - Incorrect answer highlighted in soft coral (`#FCA5A5`) with cross icon.
- **Next CTA**: Advances to the next question or leads to Results screen on completion.

### 5. Screen 5 — Results (`ResultScreen`)
- **Visuals**: Celebratory confetti horn for passing scores (≥ 60%), or encouraging retry illustration.
- **Prominent Score**: Large percentage badge (e.g., `80%` or `33%`) along with exact tally: *"You scored 7/10!"*.
- **Quick Stats**: Category name, total duration formatted in minutes/seconds, and accuracy percentage.
- **CTA Actions**:
  - **PLAY AGAIN**: Resets quiz state, retains user's preferences, and returns to Category Selection.
  - **Back to Welcome**: Returns to the root screen.

---

## 🏗️ Architecture & State Management

```
quizzical/
├── lib/
│   ├── main.dart                      # App entry point with MultiProvider & Theme
│   ├── constants/
│   │   ├── app_colors.dart            # Figma-aligned teal, pastel, and feedback palettes
│   │   └── app_theme.dart             # Material 3 typography and custom pill button styles
│   ├── models/
│   │   ├── category_model.dart        # Trivia category model with clean display names & icons
│   │   ├── question_model.dart        # OpenTDB question with HTML unescaping & shuffled answers
│   │   ├── quiz_config.dart           # Configuration parameters and JSON serialization
│   │   └── quiz_result.dart           # Result metrics, formatted time, and score evaluations
│   ├── services/
│   │   ├── api_service.dart           # OpenTDB client with session caching & response code handlers
│   │   └── storage_service.dart       # SharedPreferences persistence layer
│   ├── providers/
│   │   └── quiz_provider.dart         # ChangeNotifier managing state, timers, scoring & navigation
│   ├── screens/
│   │   ├── welcome_screen.dart        # Screen 1: Welcome & Name customization
│   │   ├── category_selection_screen.dart # Screen 2: Responsive pastel category grid
│   │   ├── quiz_configuration_screen.dart # Screen 3: Sliders and dropdown filters
│   │   ├── quiz_screen.dart           # Screen 4: Live quiz gameplay with timer & instant feedback
│   │   └── result_screen.dart         # Screen 5: Score report, statistics, and replay
│   └── widgets/
│       ├── app_illustrations.dart     # Custom vector illustrations matching Figma designs
│       ├── custom_button.dart         # Pill-shaped CTA button with loading states
│       ├── category_card.dart         # Pastel category card widget
│       ├── option_card.dart           # Quiz answer tile with check/cross animations
│       ├── loading_shimmer.dart       # Skeleton shimmer widgets for loading states
│       └── retry_banner.dart          # Error banner with retry trigger
├── test/
│   └── quizzical_test.dart            # Unit tests for models, unescaping, and scoring logic
├── android/                           # Android platform files (with INTERNET permission)
├── web/                               # Flutter Web runner files (PWA manifest & HTML)
├── pubspec.yaml                       # Dependencies configuration
└── README.md                          # Examination documentation & instructions
```

---

## 🚀 How to Run the Project

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (v3.10.0 or higher)
- Android Studio / VS Code with Flutter extension
- Connected Android Device, Emulator, Chrome, or Windows Desktop

### Steps
1. Open terminal inside the project directory:
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run tests to verify logic:
   ```bash
   flutter test
   ```
4. Run the application:
   ```bash
   flutter run
   ```
   *(Or target Chrome directly using `flutter run -d chrome`)*

---

## 🎯 Acceptance Criteria Verification Checklist

| Requirement | Implementation Detail | Status |
|-------------|-----------------------|:------:|
| **≥ 4 Screens** | Welcome, Category Selection, Configuration, Quiz, Results (5 screens) | ✅ Implemented |
| **State Management** | Provider pattern with `QuizProvider` managing all reactive states | ✅ Implemented |
| **OpenTDB Integration** | Category & Questions endpoints fully integrated with timeout handling | ✅ Implemented |
| **Session Caching** | Categories cached in `ApiService` during active session | ✅ Implemented |
| **Loading Skeletons** | Animated shimmer skeleton cards on Category Selection | ✅ Implemented |
| **Retry Banner** | Actionable banner shown on network / OpenTDB rate-limit errors | ✅ Implemented |
| **Config Persistence** | `SharedPreferences` persists last selected config across replays | ✅ Implemented |
| **Question Timer** | 25s timer with warning colors; auto-advances on timeout | ✅ Implemented |
| **Figma Fidelity** | Matched color palette, rounded buttons, custom illustrations & cards | ✅ Implemented |
| **HTML Entity Unescaping** | Robust unescaping of HTML entities in questions & answers | ✅ Implemented |
