# DhalBhat Fit — Technical Stack & Architecture

---

## Stack Overview

```
Layer               Technology                      Purpose
──────────────────────────────────────────────────────────────────────
Mobile app          Flutter (Dart)                  iOS + Android from one codebase
State management    Riverpod                        Reactive state, testable, no boilerplate
Local database      drift (SQLite)                  Offline cache + sync queue
Backend             Supabase                        PostgreSQL + Auth + Storage + Realtime
AI layer            Claude API via Supabase Edge Fn Vision (food photo) + recommendations
Payments            eSewa SDK + Khalti SDK           Nepal-first (Phase 4)
Analytics           PostHog                         Event tracking, funnels, retention
Crash reporting     Sentry                          Production error monitoring
Push notifications  Firebase Cloud Messaging (FCM)  Cross-platform push delivery
Fonts               Poppins + Noto Sans Devanagari  English + Nepali UI
Localization        Flutter intl + l10n              Language switching (en / ne)
```

---

## Architecture Style: Clean Architecture (Feature-First)

The app follows clean architecture with a feature-first folder organization.

**Why feature-first over layer-first:**
- Each feature (food, workout, auth) is fully self-contained
- You can work on one feature without touching other features
- Scales better as the app grows
- Easier to add a new feature without restructuring

**Three layers inside every feature:**

```
Presentation Layer  → Screens, Widgets, Riverpod Providers
                       Displays UI, captures user actions
                       Knows nothing about data sources

Domain Layer        → Entities, Use Cases, Repository Interfaces
                       Contains pure business logic
                       No Flutter, no Supabase, no drift — only Dart

Data Layer          → Repository Implementations, Data Sources, Models
                       Talks to Supabase (remote) and drift (local)
                       Translates external data into domain entities
```

---

## Project Folder Structure

```
dalbhat_fit/
├── lib/
│   ├── main.dart                    # Entry point
│   ├── app.dart                     # Root widget, theme, router setup
│   │
│   ├── core/                        # Shared across all features
│   │   ├── constants/
│   │   │   ├── colors.dart          # Brand color palette
│   │   │   ├── text_styles.dart     # Poppins + Noto typography
│   │   │   └── dimensions.dart      # Spacing, radius, icon sizes
│   │   ├── theme/
│   │   │   ├── app_theme.dart       # Light ThemeData
│   │   │   └── dark_theme.dart      # Dark ThemeData
│   │   ├── router/
│   │   │   └── app_router.dart      # GoRouter: all route definitions
│   │   ├── localization/
│   │   │   ├── app_en.arb           # English strings
│   │   │   └── app_ne.arb           # Nepali strings (Devanagari)
│   │   ├── utils/
│   │   │   ├── calorie_calculator.dart   # Deterministic BMR/TDEE math
│   │   │   ├── bmi_calculator.dart       # Asian BMI cutoffs
│   │   │   ├── macro_calculator.dart     # Macro splits by goal
│   │   │   └── formatters.dart           # Date, number, unit formatters
│   │   └── env.dart                 # Build-time env vars (--dart-define)
│   │
│   ├── features/
│   │   │
│   │   ├── auth/                    # Sign up, sign in, password reset
│   │   │   ├── data/
│   │   │   │   ├── repositories/auth_repository_impl.dart
│   │   │   │   └── datasources/supabase_auth_datasource.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/user.dart
│   │   │   │   ├── repositories/auth_repository.dart  (interface)
│   │   │   │   └── usecases/sign_in_usecase.dart
│   │   │   └── presentation/
│   │   │       ├── screens/sign_in_screen.dart
│   │   │       ├── screens/sign_up_screen.dart
│   │   │       └── providers/auth_provider.dart
│   │   │
│   │   ├── onboarding/              # 8-step setup flow
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   │   └── usecases/compute_calorie_goal_usecase.dart
│   │   │   └── presentation/
│   │   │       ├── screens/onboarding_screen.dart
│   │   │       ├── screens/calorie_goal_screen.dart
│   │   │       └── providers/onboarding_provider.dart
│   │   │
│   │   ├── dashboard/               # Home screen
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   │   └── usecases/get_today_summary_usecase.dart
│   │   │   └── presentation/
│   │   │       ├── screens/home_screen.dart
│   │   │       ├── widgets/calorie_ring.dart
│   │   │       ├── widgets/macro_summary.dart
│   │   │       ├── widgets/meal_slots_row.dart
│   │   │       ├── widgets/workout_card.dart
│   │   │       └── providers/dashboard_provider.dart
│   │   │
│   │   ├── food/                    # Logging, search, detail, templates
│   │   │   ├── data/
│   │   │   │   ├── repositories/food_repository_impl.dart
│   │   │   │   ├── datasources/
│   │   │   │   │   ├── supabase_food_datasource.dart  (remote)
│   │   │   │   │   └── local_food_datasource.dart     (drift)
│   │   │   │   └── models/food_model.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/food.dart
│   │   │   │   ├── entities/food_log.dart
│   │   │   │   ├── repositories/food_repository.dart  (interface)
│   │   │   │   └── usecases/
│   │   │   │       ├── log_meal_usecase.dart
│   │   │   │       ├── search_foods_usecase.dart
│   │   │   │       └── get_recent_foods_usecase.dart
│   │   │   └── presentation/
│   │   │       ├── screens/meal_log_screen.dart
│   │   │       ├── screens/food_search_screen.dart
│   │   │       ├── screens/food_detail_screen.dart
│   │   │       ├── widgets/food_card.dart
│   │   │       ├── widgets/portion_chips.dart         # Small/Medium/Large
│   │   │       ├── widgets/portion_slider.dart
│   │   │       ├── widgets/undo_chip.dart             # 5-second undo
│   │   │       └── providers/food_provider.dart
│   │   │
│   │   ├── ai/                      # Claude Vision + recommendations
│   │   │   ├── data/
│   │   │   │   ├── repositories/ai_repository_impl.dart
│   │   │   │   └── datasources/claude_api_datasource.dart  (Edge Function)
│   │   │   ├── domain/
│   │   │   │   ├── entities/food_recognition_result.dart
│   │   │   │   ├── entities/recommendation.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── recognize_food_photo_usecase.dart
│   │   │   │       └── get_meal_recommendation_usecase.dart
│   │   │   └── presentation/
│   │   │       ├── widgets/ai_result_card.dart        # Shows identified food
│   │   │       ├── widgets/confidence_chip.dart       # High/medium/low
│   │   │       └── providers/ai_provider.dart
│   │   │
│   │   ├── workouts/                # Browser, session, complete
│   │   │   ├── data/
│   │   │   │   ├── repositories/workout_repository_impl.dart
│   │   │   │   └── datasources/
│   │   │   │       ├── supabase_workout_datasource.dart
│   │   │   │       └── local_workout_datasource.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/workout_plan.dart
│   │   │   │   ├── entities/exercise.dart
│   │   │   │   ├── entities/workout_session.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── get_today_workout_usecase.dart
│   │   │   │       ├── start_session_usecase.dart
│   │   │   │       └── complete_session_usecase.dart
│   │   │   └── presentation/
│   │   │       ├── screens/workout_browser_screen.dart
│   │   │       ├── screens/exercise_detail_screen.dart
│   │   │       ├── screens/active_session_screen.dart
│   │   │       ├── screens/workout_complete_screen.dart
│   │   │       ├── widgets/exercise_card.dart
│   │   │       ├── widgets/rest_timer.dart
│   │   │       ├── widgets/rep_counter.dart
│   │   │       └── providers/workout_provider.dart
│   │   │
│   │   ├── progress/                # Weight, calorie history, streaks
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   │   └── usecases/
│   │   │   │       ├── get_weight_trend_usecase.dart
│   │   │   │       └── get_calorie_history_usecase.dart
│   │   │   └── presentation/
│   │   │       ├── screens/progress_screen.dart
│   │   │       ├── widgets/weight_graph.dart
│   │   │       ├── widgets/calorie_bar_chart.dart
│   │   │       ├── widgets/workout_heatmap.dart
│   │   │       └── providers/progress_provider.dart
│   │   │
│   │   └── settings/                # Profile, language, notifications
│   │       ├── data/
│   │       ├── domain/
│   │       └── presentation/
│   │           ├── screens/profile_screen.dart
│   │           ├── screens/settings_screen.dart
│   │           └── providers/settings_provider.dart
│   │
│   └── shared/                      # Reusable widgets + services
│       ├── widgets/
│       │   ├── primary_button.dart
│       │   ├── loading_indicator.dart
│       │   ├── error_view.dart
│       │   └── empty_state.dart
│       └── services/
│           ├── notification_service.dart    # FCM + local notifications
│           ├── sync_service.dart            # Offline → Supabase sync
│           └── analytics_service.dart       # PostHog event wrapper
│
├── assets/
│   ├── images/                      # Logos, illustrations
│   ├── fonts/                       # Poppins, Noto Sans Devanagari
│   └── animations/                  # Lottie files (workout complete, etc.)
│
├── l10n/
│   ├── app_en.arb
│   └── app_ne.arb
│
└── test/
    ├── unit/                        # Use case + calculator tests
    └── widget/                      # Widget tests per feature
```

---

## Data Flow (Every User Action)

```
1. User taps [+ Log Meal] on home screen
        │
        ▼
2. UI (MealLogScreen) dispatches event → Riverpod provider
        │
        ▼
3. Provider calls use case: LogMealUseCase.execute(food, portion, mealType)
        │
        ▼
4. Use case calls repository interface: FoodRepository.logMeal(foodLog)
        │
        ▼
5. Repository implementation:
        │
        ├─ Writes to local SQLite (drift) immediately → user sees instant update
        ├─ Adds entry to sync_queue
        └─ (if online) pushes to Supabase in background
        │
        ▼
6. Use case returns updated daily totals
        │
        ▼
7. Provider updates state (calorie total, macros)
        │
        ▼
8. UI rebuilds: calorie ring updates, undo chip appears for 5 seconds
```

**Key principle:** Local write always happens first. UI never waits for network.

---

## Service Definitions

| Service | Location | Responsibility |
|---|---|---|
| `CalorieService` | `core/utils/calorie_calculator.dart` | Deterministic BMR, TDEE, macro calculations — never uses AI |
| `FoodLoggingService` | `features/food/domain/usecases/` | Orchestrates photo → AI → food_log pipeline |
| `AiService` | `features/ai/data/datasources/` | Calls Supabase Edge Function → Claude API, handles caching + fallback |
| `WorkoutRecommendationService` | `features/workouts/domain/usecases/` | Selects today's plan day, applies adaptive rules |
| `SyncService` | `shared/services/sync_service.dart` | Monitors connectivity, pushes sync_queue entries to Supabase |
| `NotificationService` | `shared/services/notification_service.dart` | Schedules FCM + local notifications, applies frequency rules |
| `ProgressService` | `features/progress/domain/usecases/` | Weight trend computation, milestone detection, calorie adjustment logic |
| `AnalyticsService` | `shared/services/analytics_service.dart` | PostHog event wrapper — standardizes event names and properties |

---

## Claude API Integration

### Security: API key never in the Flutter app

```
Flutter app
    │  (Supabase anon key only — user-scoped)
    ▼
Supabase Edge Function  ← validates auth token, rate limits
    │  (Claude API key stored in Edge Function env vars)
    ▼
Claude API (Anthropic)
    │
    ▼
Structured JSON response
    │
    ▼
Flutter app displays result
```

### AI Safety Rules

| Rule | Implementation |
|---|---|
| **Validate before sending** | Check image is non-null, non-empty, valid format before calling Edge Function |
| **Use structured prompts** | All prompts return typed JSON — no free-text parsing in the app |
| **Cache repeated requests** | Same image hash = return cached result, skip API call |
| **Fallback when AI unavailable** | Photo tab fails gracefully → show search tab with message "Try searching manually" |
| **Calorie math is deterministic** | Claude identifies the food — the app calculates calories from the foods table. Never trust AI-generated calorie numbers for math operations |
| **Confidence threshold enforcement** | Results below 0.40 confidence shown with explicit "unverified" label, not silently used |
| **Rate limiting** | Edge Function: max 20 photo requests/day (free tier), unlimited (premium) |
| **No PII in prompts** | Claude prompts include food history context, never name, email, or identifiable info |

### Caching Strategy

```dart
// features/ai/data/datasources/claude_api_datasource.dart

// 1. Hash the image bytes
final imageHash = sha256.convert(imageBytes).toString();

// 2. Check local cache (valid for 24 hours)
final cached = await _localCache.get(imageHash);
if (cached != null) return cached;

// 3. Call Edge Function
final result = await _edgeFunction.call('identify-food', {
  'image': base64.encode(imageBytes),
  'user_food_context': userFoodContext,
});

// 4. Cache result
await _localCache.set(imageHash, result, ttl: Duration(hours: 24));
return result;
```

---

## Calorie Calculation Logic (Deterministic — No AI)

### Mifflin-St Jeor BMR

```dart
// core/utils/calorie_calculator.dart

double calculateBMR(double weightKg, double heightCm, int age, String gender) {
  final base = (10 * weightKg) + (6.25 * heightCm) - (5 * age);
  return gender == 'male' ? base + 5 : base - 161;
}

double calculateTDEE(double bmr, String activityLevel) {
  const multipliers = {
    'sedentary':    1.2,
    'light':        1.375,
    'moderate':     1.55,
    'active':       1.725,
    'very_active':  1.9,
  };
  return bmr * (multipliers[activityLevel] ?? 1.2);
}

int calculateDailyTarget(double tdee, String goal) {
  switch (goal) {
    case 'lose':     return (tdee - 500).round();
    case 'gain':     return (tdee + 300).round();
    default:         return tdee.round();
  }
}
```

### Asian BMI Cutoffs

```dart
String getBMICategory(double weightKg, double heightM) {
  final bmi = weightKg / (heightM * heightM);
  if (bmi < 18.5)  return 'underweight';
  if (bmi < 23.0)  return 'normal';
  if (bmi < 27.5)  return 'overweight';
  return 'obese';
}
```

### Macro Splits

```dart
Map<String, int> getMacroTargets(int dailyCalories, String goal) {
  final splits = {
    'lose':     {'carbs': 0.40, 'protein': 0.35, 'fat': 0.25},
    'gain':     {'carbs': 0.45, 'protein': 0.35, 'fat': 0.20},
    'maintain': {'carbs': 0.50, 'protein': 0.25, 'fat': 0.25},
  }[goal]!;

  return {
    'carbs_g':   ((dailyCalories * splits['carbs']!) / 4).round(),
    'protein_g': ((dailyCalories * splits['protein']!) / 4).round(),
    'fat_g':     ((dailyCalories * splits['fat']!) / 9).round(),
  };
}
```

---

## Offline Sync Architecture

```
User action (offline)
    │
    ▼
Write to drift (local SQLite) — instant, no network needed
Add record to sync_queue { table, operation, payload, created_at }
    │
    ▼ (connectivity_plus detects online)
SyncService.runSync()
    │
    ├─ Read all unsynced entries from sync_queue
    ├─ POST each to Supabase
    ├─ Supabase RLS validates (user can only write own data)
    └─ On success: mark sync_queue entry as synced, delete after 7 days
    │
    ▼
Supabase persists → available on all devices
```

Conflict resolution: `created_at` timestamp wins. Local writes are trusted.

---

## Environment Configuration

```dart
// lib/core/env.dart
class Env {
  static const supabaseUrl     = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  static const postHogKey      = String.fromEnvironment('POSTHOG_KEY');
  static const sentryDsn       = String.fromEnvironment('SENTRY_DSN');
  // Claude API key: Supabase Edge Function env only — never in app
}
```

Build command:
```
flutter build appbundle --release \
  --dart-define=SUPABASE_URL=https://xxx.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=xxx \
  --dart-define=POSTHOG_KEY=xxx \
  --dart-define=SENTRY_DSN=xxx
```

---

## Build & Deployment

### Android
- Min SDK: 21 (Android 5.0) — covers ~99% of Nepal Android devices
- Target SDK: 34 (Android 14)
- Build: `flutter build appbundle --release`
- Signing: keystore stored outside repo, referenced via `key.properties`
- Upload: Google Play Console → Internal track → Beta → Production

### iOS
- Deployment target: iOS 13.0+
- Requires: Apple Developer account ($99/year)
- Build: `flutter build ipa --release`
- Upload: Transporter or Xcode Organizer → App Store Connect
- Review: Apple health app guidelines (no medical claims)

### CI/CD (Phase 3)
- GitHub Actions → on push to `main`: run tests → build → upload to Firebase App Distribution (beta testers)
- Production release: manual trigger after QA sign-off

---

## Key Flutter Packages

| Package | Purpose |
|---|---|
| `flutter_riverpod` | State management |
| `go_router` | Navigation and deep linking |
| `supabase_flutter` | Supabase client (auth, db, storage) |
| `drift` | Local SQLite ORM with type safety |
| `image_picker` | Camera + photo gallery access |
| `cached_network_image` | Image caching with loading states |
| `fl_chart` | Progress charts (line, bar, pie) |
| `flutter_localizations` | Flutter built-in l10n |
| `intl` | Date, number, and unit formatting |
| `connectivity_plus` | Online/offline detection |
| `flutter_local_notifications` | Local scheduled notifications |
| `firebase_messaging` | FCM push notification delivery |
| `sentry_flutter` | Crash and error reporting |
| `posthog_flutter` | Analytics events |
| `crypto` | SHA-256 image hashing for AI cache |
| `shared_preferences` | Simple key-value (auth token cache, settings) |
| `lottie` | Animated illustrations (workout complete, onboarding) |
