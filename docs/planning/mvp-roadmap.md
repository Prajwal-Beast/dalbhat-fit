# DhalBhat Fit — MVP Roadmap

Four phases from zero to market. Each phase has a clear goal, feature list, and exit criteria.

---

## Phase 1: Foundation
**Goal:** Build the smallest useful version of DhalBhat Fit that a real Nepali user can benefit from daily.
**Timeline:** 8–10 weeks
**Exit criteria:** 20 internal beta users can complete a full day (log meals, check progress, do a workout) without confusion.

---

### Must-Have Features (Phase 1 scope)

| Feature | Status | Notes |
|---|---|---|
| Sign up and login | — | Email + Google OAuth via Supabase Auth |
| Onboarding profile | — | 8-step flow: age, gender, height, weight, goal, activity, workout pref |
| Daily calorie goal calculation | — | Mifflin-St Jeor + Asian BMI cutoffs |
| Nepali food database | — | 100+ dishes seeded (see food-database.md) |
| Meal logging (photo) | — | Claude Vision API via Supabase Edge Function |
| Meal logging (manual search) | — | Nepali + English search, food_portions selection |
| Meal logging (one-tap recent) | — | Last 7 logged foods, suggested by meal time |
| Meal templates | — | Pre-built Nepali meal combos for one-tap logging |
| Daily dashboard | — | Calorie ring, macros, log button, workout card |
| Basic workout recommendations | — | 5 seed plans (home beginner/intermediate, gym beginner/intermediate, weight loss) |
| Active workout session | — | Timer, rep counter, rest timer, exercise detail |
| Progress tracking | — | Weight trend, calorie history, workout calendar |
| Offline mode | — | SQLite local cache via drift, sync queue — critical for Nepal |
| Language toggle | — | English default, Nepali (Devanagari) opt-in |
| Profile + settings | — | Edit goal, units, notification times, language |

> **Note on offline mode:** The user's plan lists offline mode in Phase 3 Expansion, but Nepal's variable internet makes this a Phase 1 requirement — not a nice-to-have. Removing it from MVP creates a broken experience for a significant percentage of users. It stays in Phase 1.

---

### Phase 1 Exclusions (explicitly deferred)

| Feature | Deferred to |
|---|---|
| Voice input (Nepali STT) | Phase 3 — accuracy not reliable yet |
| Smart weekly meal planning | Phase 3 |
| Community / social features | Phase 4 |
| Wearable integration | Phase 4 |
| Advanced AI coaching | Phase 4 |
| Premium subscription + payments | Phase 4 |
| Adaptive database growth (pending_foods pipeline) | Phase 3 |
| Progressive overload engine | Phase 3 |
| Personalized daily nudges | Phase 3 |
| Regional / festival foods | Phase 3 |

---

### Phase 1 Build Plan (Week by Week)

#### Week 1: Setup
- [ ] Finalize app name (DhalBhat vs DalBhat spelling)
- [ ] Finalize logo and app icon
- [ ] Create Apple Developer account ($99/year)
- [ ] Create Google Play Console account ($25 one-time)
- [ ] Create Supabase project + configure all tables from data-schema.md
- [ ] Initialize Flutter project (package name: com.dhalbhatfit.app)
- [ ] Configure: Riverpod, GoRouter, Supabase Flutter, drift
- [ ] Set up l10n (en.arb + ne.arb files, Noto Sans Devanagari)
- [ ] Set up Sentry crash reporting + PostHog analytics
- [ ] Add Poppins + Noto Sans Devanagari fonts
- [ ] Set up Git repository + environment variables (--dart-define)
- [ ] Seed food database (100+ dishes from food-database.md)
- [ ] Seed exercise library (55+ exercises from adaptive-workout.md)
- [ ] Seed 5 workout plans

#### Week 2: Auth + Onboarding
- [ ] Splash screen
- [ ] Welcome screen
- [ ] Sign Up / Sign In (email + Google OAuth)
- [ ] Onboarding flow (8 steps, one question per screen)
- [ ] Calorie goal calculation (Mifflin-St Jeor) + macro split
- [ ] Calorie Goal Summary screen
- [ ] Save user_profiles + user_settings to Supabase
- [ ] Initialize user_workout_preferences on sign-up

#### Weeks 3–4: Food Logging Core
- [ ] Home Dashboard (calorie ring, macro summary, log meal CTA)
- [ ] Meal Log Screen (photo tab + search tab, meal type selector)
- [ ] Food Search Results (instant search, EN + NE, frequency-ordered)
- [ ] Food Detail Screen (portion chips, calorie update, save)
- [ ] Recent foods list (last 7 logged, meal-time aware)
- [ ] Meal templates one-tap logging (14 pre-built combos)
- [ ] "Log first, edit later" flow (5-second undo chip)
- [ ] Supabase Edge Function for Claude Vision API proxy
- [ ] Claude Vision API integration (photo → JSON food result)
- [ ] food_logs write to Supabase + local SQLite

#### Week 5: Offline Mode
- [ ] drift local database schema (mirrors key Supabase tables)
- [ ] Offline-first write: all food_logs write locally first
- [ ] sync_queue table in SQLite
- [ ] Sync service: push pending logs when connection restored
- [ ] connectivity_plus: detect online/offline state
- [ ] Cache Nepali food database locally on app start (refresh weekly)
- [ ] Test: log meals with airplane mode on — confirm sync after reconnect

#### Week 6: Workout Module
- [ ] Workout Browser (filter by goal / location / level)
- [ ] Exercise Detail Screen (instructions, GIF placeholder, sets/reps/rest)
- [ ] Active Workout Session Screen (timer, rep counter, rest countdown)
- [ ] Workout Complete Screen (summary, calories burned estimate, streak)
- [ ] workout_sessions + exercise_sets write to Supabase + local SQLite
- [ ] Home screen workout card (today's plan + Start button)

#### Week 7: Progress + Settings
- [ ] Progress Screen (weight trend graph, calorie history bars, workout calendar)
- [ ] Weight log input (daily prompt, manual entry)
- [ ] Profile + Settings Screen (all fields from screens-flow.md)
- [ ] Language toggle (English ↔ Nepali) — re-renders UI in Devanagari
- [ ] Units toggle (kg/cm ↔ lbs/ft)
- [ ] Notification setup (flutter_local_notifications)
- [ ] Push notifications: meal reminders, workout reminder, progress summary

#### Week 8: Polish + QA
- [ ] Dark mode palette
- [ ] App icon + launch screen finalized
- [ ] All empty states have CTAs (no blank screens)
- [ ] Loading states for all async operations
- [ ] Error handling: network failure, AI timeout, auth error
- [ ] Performance audit: frame drops, Claude API response time, search speed
- [ ] Accessibility: font size, contrast ratios, tap target sizes
- [ ] Full manual QA: new user flow, returning user flow, offline flow
- [ ] Fix all P0 and P1 bugs

---

## Phase 2: Beta
**Goal:** Test DhalBhat Fit with real Nepali users. Validate core assumptions before broader launch.
**Timeline:** 4–6 weeks post Phase 1
**Target:** 100–500 users in Kathmandu + Pokhara

---

### Beta Validation Focus

| Area | What to measure | Success threshold |
|---|---|---|
| Nepali food accuracy | % of photo logs user accepts without editing | > 65% |
| Logging speed | Seconds from app open to meal logged | < 15 seconds |
| Workout usefulness | % of recommended workouts started | > 40% |
| UI clarity | Support requests / confusion reports | < 5% of users |
| Day 7 retention | Users still active at day 7 | > 30% |
| Day 30 retention | Users still active at day 30 | > 15% |
| Language support | % of users switching to Nepali UI | Track only |
| Crash-free rate | Sessions without a crash | > 99% |

### Beta Distribution
- iOS: TestFlight (invite link sent to beta group)
- Android: Google Play internal testing track
- Recruitment: Nepali fitness groups, gyms in Kathmandu, social media

### Beta Feedback Collection
- In-app: thumbs up/down on recommendations (already in recommendations table)
- In-app: "Flag wrong food" on food logs
- Weekly: short survey (3 questions, in-app prompt)
- Direct: WhatsApp/Telegram group for beta users

### Beta Exit Criteria
- Crash-free rate > 99%
- Photo log accuracy > 60%
- Day 7 retention > 25%
- No P0 bugs
- At least 50 users have logged for 7+ consecutive days

---

## Phase 3: Expansion
**Goal:** Add intelligence, retention tools, and broader content coverage.
**Timeline:** Months 4–6 post-launch
**Trigger:** Phase 2 exit criteria met + 1,000+ active users

---

### Expansion Features

#### Adaptive Food Intelligence
- pending_foods pipeline live (user-submitted unknown foods → admin review → verified)
- Admin review interface (Supabase dashboard initially, proper UI in Phase 4)
- Frequency thresholds automated (5 logs → flag, 20 → priority, 50 → promote)
- Seasonal food surfacing (available_months filtering)
- Regional dishes: Terai, Hills, Mountain cuisine added
- Festival food packs: Tihar, Dashain, Teej special items

#### Adaptive Workout Library
- pending_exercises pipeline live
- Progressive overload engine active (exercise_progressions tracking)
- Dislike/skip detection and automatic plan adjustment
- Injury limitation adaptations
- Exercise GIF/video assets added

#### Personalized Recommendation Engine
- Full recommendation-engine.md logic deployed
- Daily reactive triggers (morning / mid-day / evening)
- Weekly calorie target adjustments based on weight trend
- Meal suggestions drawn from user's food history
- Workout suggestions based on completion patterns
- Feedback loop: was_followed tracking active

#### Offline Mode Enhancements (if not fully complete in Phase 1)
- Full offline workout session (no internet required)
- Background sync optimization

#### Analytics Improvements
- Macro trend over time (30/60/90 day views)
- Workout volume chart (sets × reps over time)
- Personal records (heaviest weight, longest streak)
- BMI trend with Asian cutoffs displayed

#### Voice Logging (if Nepali STT has improved)
- Test Google STT Nepali accuracy at this point
- If > 70% accurate on Nepali food names → ship
- If not → hold for Phase 4

---

## Phase 4: Scale
**Goal:** Build revenue, long-term retention, and market presence in Nepal.
**Timeline:** Month 7+ post-launch
**Trigger:** 5,000+ active users, Phase 3 stable

---

### Scale Features

#### Premium Subscription
- Freemium gate: free tier = 5 AI photo logs/day, basic workout plans
- Premium NPR 299/month / NPR 2,499/year
- eSewa + Khalti integration (Nepal-first payment)
- Stripe as secondary (for diaspora)
- Premium features: unlimited AI logging, full adaptive engine, advanced analytics, no ads

#### Coaching Tools
- Trainer / dietitian onboarding flow
- Client management dashboard
- Trainer can assign meal plans and workout programs to clients
- Progress sharing: client shares data with trainer

#### Local Partnerships
- Nepali gym discount codes (in-app)
- Restaurant partnerships: tagged as "DhalBhat Fit approved" in food search
- Fitness influencer collaboration tools

#### Trainer Dashboards
- Web dashboard (React or Flutter Web)
- View client progress, food logs, workout compliance
- Comment on client logs
- Send personalized workout plans

#### Nutrition Expert Review Panel
- Nutritionists review and verify food database entries
- "Verified by [expert]" badge on food items
- Quarterly review of food accuracy

---

## Success Metrics by Phase

| Metric | Phase 1 Target | Phase 2 Target | Phase 3 Target | Phase 4 Target |
|---|---|---|---|---|
| Active users | 20 (internal) | 500 (beta) | 5,000 | 25,000+ |
| Day 7 retention | N/A | > 25% | > 35% | > 40% |
| Day 30 retention | N/A | > 15% | > 20% | > 25% |
| Photo log accuracy | > 60% | > 65% | > 75% | > 80% |
| Crash-free rate | > 98% | > 99% | > 99.5% | > 99.5% |
| Premium conversion | N/A | N/A | > 3% | > 8% |
| Food database size | 100+ | 150+ | 300+ | 500+ |
| Exercise library | 55+ | 70+ | 100+ | 150+ |

---

## Decision Log (Changes from Original Plan)

| Decision | Reason |
|---|---|
| Offline mode moved to Phase 1 | Nepal's internet reliability requires it — not optional |
| Adaptive database pipeline moved to Phase 3 | Phase 1 focuses on core daily loop first |
| Progressive overload engine moved to Phase 3 | Requires weeks of user data before it's useful |
| Voice logging deferred indefinitely | Nepali STT accuracy not production-ready — will re-evaluate |
| eSewa/Khalti moved to Phase 4 | Subscription features only needed when premium tier is live |
| Payments excluded from Phase 1 MVP | Keep MVP scope lean — monetize after retention is proven |
