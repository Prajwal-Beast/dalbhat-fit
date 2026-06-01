# DhalBhat Fit — Project Brain

Master reference for all decisions, architecture, and status.
Read this first before touching any file or writing any code.

---

## Quick Status

| | |
|---|---|
| **Phase** | Planning complete — ready to build |
| **App name** | DhalBhat Fit (confirmed spelling) |
| **Tagline** | Built for dal bhat and daily fitness |
| **Stack** | Flutter + Riverpod + Supabase + Claude API |
| **Target** | Nepal — Kathmandu beta first |
| **Primary segment** | Weight loss users |
| **Logo / icon** | Design ready — files to be added to `app/assets/images/` |

---

## Confirmed Decisions

| Decision | Choice |
|---|---|
| App name spelling | **DhalBhat** (not DalBhat) |
| Framework | Flutter (Dart) |
| Architecture | Clean architecture, feature-first folders |
| State management | Riverpod |
| Backend | Supabase (PostgreSQL + Auth + Storage) |
| AI | Claude API via Supabase Edge Function — never direct from app |
| Local DB | drift (SQLite) — offline-first |
| Payments | eSewa + Khalti (Phase 4) |
| Navigation | Bottom tab bar, 5 tabs |
| Primary segment | Weight loss |
| Workout default | Home-first |
| Voice logging | Phase 3 (STT not reliable yet) |
| Offline mode | Phase 1 — required, not optional |
| Monetization | Phase 4 — validate retention first |

---

## Open Questions (2 remaining before code starts)

- [ ] Logo files added to `app/assets/images/` (design ready, user to supply)
- [ ] App icon finalized and exported at required sizes (see brand-identity.md)

---

## Project Folder Structure

```
c:\claude code\dalbhat-fit\
│
├── BRAIN.md                          ← You are here (read first)
│
├── docs\
│   ├── brand\
│   │   └── brand-identity.md         Colors, fonts, logo specs, voice
│   │
│   ├── planning\
│   │   ├── mvp-roadmap.md            4-phase build plan, week-by-week Phase 1
│   │   └── feature-backlog.md        High/Medium/Low priority feature list
│   │
│   ├── ux\
│   │   ├── screens-flow.md           15 screens with full specs
│   │   ├── user-flow.md              12 user journeys mapped to screens
│   │   └── ux-principles.md          UX rules, smart defaults, notification rules
│   │
│   ├── database\
│   │   ├── data-schema.md            Full Supabase PostgreSQL schema (all tables)
│   │   └── food-database.md          90+ Nepali foods with macros and portions
│   │
│   ├── features\
│   │   ├── adaptive-intelligence.md  Living food database system
│   │   ├── adaptive-workout.md       55+ exercises, 5 plans, adaptive rules
│   │   └── recommendation-engine.md  Daily logic, Claude prompts, feedback loop
│   │
│   └── technical\
│       ├── tech-stack.md             Flutter architecture, folder tree, packages
│       └── claude-prompts.md         8 Claude prompt types, output format, safety
│
└── app\                              ← Flutter project goes here
    └── (run: flutter create dalbhat_fit inside this folder)
```

---

## Tech Stack

```
Frontend:        Flutter (Dart)
Architecture:    Clean architecture, feature-first
State:           Riverpod
Backend:         Supabase (PostgreSQL + Auth + Storage + Realtime)
AI:              Claude API via Supabase Edge Function
Local DB:        drift (SQLite) — offline-first, sync queue
Push:            Firebase Cloud Messaging (FCM)
Analytics:       PostHog
Crash reporting: Sentry
Payments:        eSewa + Khalti (Phase 4)
Fonts:           Poppins (EN) + Noto Sans Devanagari (NE)
```

---

## Database Tables (Quick Reference)

| Table | Purpose |
|---|---|
| `user_profiles` | Health data: age, gender, height, weight, goal, city |
| `user_settings` | Language, units, dark mode, notification times |
| `user_workout_preferences` | Equipment, injuries, dislikes, active plan |
| `user_favorites` | Starred foods and meal templates |
| `foods` | Verified Nepali food database (90+ items) |
| `food_portions` | Small/medium/large portions per food |
| `meal_templates` | Pre-built Nepali meal combos (14 templates) |
| `food_logs` | Daily meal entries with estimated + confirmed calories |
| `custom_foods` | User-submitted unknown foods (pending → community → verified) |
| `exercises` | Exercise library (55+ with progressions, home alternatives) |
| `workout_plans` | Structured plans (5 seeded: home/gym, beginner/intermediate) |
| `workout_plan_days` | Exercise list per plan day |
| `workout_sessions` | Completed session logs with rating |
| `workout_session_items` | Exercises done per session |
| `exercise_progressions` | Per-user performance history |
| `pending_exercises` | User-requested exercises awaiting review |
| `goals` | Goal history with calorie targets |
| `weight_logs` | Daily weight check-ins |
| `calorie_adjustments` | History of target changes with reason |
| `recommendations` | AI suggestions with follow-through tracking |
| `ai_feedback` | User corrections (polymorphic: food/workout/recommendation) |

---

## Screen List (15 — MVP)

| # | Screen | Tab |
|---|---|---|
| 1 | Splash | — |
| 2 | Welcome | — |
| 3 | Sign Up / Sign In | — |
| 4 | Onboarding (10 steps) | — |
| 5 | Calorie Goal Summary | — |
| 6 | Home Dashboard | Tab 1 |
| 7 | Meal Log Screen | Tab 2 |
| 8 | Food Search Results | Tab 2 |
| 9 | Food Detail | Tab 2 |
| 10 | Workout Browser | Tab 3 |
| 11 | Exercise Detail | Tab 3 |
| 12 | Active Workout Session | Tab 3 |
| 13 | Workout Complete | Tab 3 |
| 14 | Progress Screen | Tab 4 |
| 15 | Profile + Settings | Tab 5 |

---

## MVP Feature List (Phase 1)

- Auth (email + Google OAuth)
- Onboarding (10 steps)
- Calorie calculation (Mifflin-St Jeor, Asian BMI)
- Nepali food database (100+ dishes)
- Meal logging: photo (Claude Vision) + search + one-tap recent
- Meal templates (14 pre-built Nepali combos)
- Daily dashboard (calorie ring, macros, log button, workout card)
- Workout plans (home + gym, beginner + intermediate)
- Active workout session (timer, rep counter, rest timer)
- Weight progress tracking
- Offline mode (drift + sync queue)
- Nepali language toggle (English default)
- AI food correction loop (data collection)
- Basic workout adaptation (dislike/skip handling)

---

## Build Order (Phase 1 — Week by Week)

```
Week 1  → Project setup, Supabase schema, food/exercise seed data
Week 2  → Auth + onboarding + calorie goal screen
Week 3  → Food logging (search + photo + one-tap)
Week 4  → Claude Vision integration + offline mode
Week 5  → Workout module (browser + session + complete)
Week 6  → Progress screen + weight logging
Week 7  → Settings, language toggle, notifications
Week 8  → Polish, dark mode, QA, performance
```

---

## Brand (Quick Reference)

| | |
|---|---|
| Primary color | `#2D6A4F` Deep Forest Green |
| Accent/CTA | `#F4A261` Warm Saffron |
| Background | `#F8F9FA` Off-white |
| Text | `#1A1A2E` Near-black |
| Success | `#52B788` Bright Green |
| English font | Poppins |
| Nepali font | Noto Sans Devanagari |

---

## AI Rules (Non-Negotiable)

- Claude API key: Supabase Edge Function only — never in Flutter app
- Calorie math: always deterministic local formula — Claude identifies, app calculates
- Every Claude call returns: `{ result, confidence, reason, suggested_action }`
- Free tier limit: 20 photo logs/day. Premium: unlimited
- Confidence < 0.40 → show "unknown food" flow, never silently guess
- Calorie target floor: 800 kcal minimum — hard-coded, Claude cannot lower it

---

## UX North Star

> A user should open the app, log a meal, and close it in under 15 seconds.

Home screen answers 4 questions at a glance:
1. What did I eat today?
2. What should I eat next?
3. What should I train today?
4. Am I making progress?

---

## Roadmap Summary

| Phase | Goal | Timeline |
|---|---|---|
| 1 — Foundation | Build MVP | 8–10 weeks |
| 2 — Beta | 500 users, validate | 4–6 weeks post-launch |
| 3 — Expansion | Adaptive AI, full intelligence | Month 4–6 |
| 4 — Scale | Premium, coaching, payments | Month 7+ |
