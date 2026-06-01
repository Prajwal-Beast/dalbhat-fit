# DhalBhat Fit — Feature Backlog & Priority

Master list of all features, their priority tier, and which phase they ship in.

**Priority rule:** If a feature does not help the user track food, understand calories, or follow a workout plan, it waits until after launch.

---

## Reconciliation Notes (Conflicts Resolved)

Three features in this plan conflict with our phase decisions. Decisions recorded here.

| Feature | Plan says | Our plan said | Decision | Reason |
|---|---|---|---|---|
| Offline caching | Medium (after launch) | Phase 1 required | **Phase 1** | Nepal's variable internet is not optional friction. Offline mode ships with the MVP or the app fails its core audience. |
| Nepali language UI | Medium (after launch) | Phase 1 toggle | **Phase 1 toggle** | l10n is set up from day 1 in the project. Shipping English-only defeats the core differentiator. Toggle starts off, user can switch in settings. |
| Workout timers | Medium | Phase 1 (active session) | **Phase 1** | The active workout session screen already includes timers. Removing timers from workouts makes the feature unusable. |

---

## HIGH PRIORITY — Phase 1 (MVP)

These must exist in the first version. App is not useful without these.

| Feature | Status | Notes |
|---|---|---|
| User signup and login | — | Email + Google OAuth via Supabase Auth |
| Onboarding with goal, weight, height, activity, workout pref | — | 8-step flow, one question per screen |
| Daily calorie target calculation | — | Mifflin-St Jeor + Asian BMI cutoffs, deterministic |
| Nepali food database | — | 100+ dishes seeded with macros and portion sizes |
| Meal logging (manual search) | — | EN + NE search, portion chips, one-tap recent foods |
| Meal logging (photo-based) | — | Claude Vision API via Supabase Edge Function |
| Daily dashboard | — | Calorie ring, macro summary, log button, workout card |
| Workout recommendation | — | 5 seed plans (home/gym, beginner/intermediate) |
| Workout timers | — | Active session: rep counter, rest timer, set tracker |
| Weight progress tracking | — | Weight log input, trend graph in Progress screen |
| Offline caching | — | drift SQLite + sync_queue — write local first, sync later |
| Nepali language UI toggle | — | l10n configured from day 1, user can switch in Settings |
| AI food correction loop (infrastructure) | — | ai_feedback table + user correction flow in Food Detail |
| AI workout adaptation (basic) | — | Dislike/skip detection → exercise swap, basic rules only |

**What "AI-powered correction loop" means in Phase 1:**
- User can flag wrong food identification (→ `ai_feedback`)
- User can adjust portion after AI logs it (→ `food_logs.user_correction`)
- Corrections are stored and included in future Claude prompt context
- Full adaptive intelligence (database growth pipeline) stays in Phase 3

**What "AI-powered workout adaptation" means in Phase 1:**
- User can mark exercise as disliked → swapped out immediately
- Skip detection: 3 skips → prompt user to swap
- Data collection: `exercise_progressions` table is populated
- Full progressive overload engine (automated suggestions) stays in Phase 3

---

## MEDIUM PRIORITY — Phase 2 / Phase 3

These come after the core loop works well and has been validated with real users.

| Feature | Phase | Notes |
|---|---|---|
| Meal reminders (push notifications) | Phase 2 | FCM + local notifications, user sets time |
| Home and gym mode switching | Phase 2 | Already designed — user_workout_preferences, home_alternative_id on exercises |
| Weekly summaries | Phase 2 | Sunday evening notification + Progress screen view |
| Favorite meals | Phase 2 | Save food_log or meal_template as favorite — one-tap access |
| Favorite workouts | Phase 2 | Mark a workout plan as favorite — pin to home screen |
| Better analytics | Phase 3 | Macro trends, workout volume chart, personal records |
| Custom food creation | Phase 3 | custom_foods pipeline — user submits → review → verified |
| Voice food logging | Phase 3 | Only if Nepali STT accuracy > 70% by then — hold until tested |

---

## LOW PRIORITY — Phase 4+

Useful eventually. Not required for MVP or early growth.

| Feature | Phase | Notes |
|---|---|---|
| Social sharing (progress photos) | Phase 4 | Share weight milestone or workout streak |
| Community challenges | Phase 4 | 30-day dal bhat challenge, leaderboards |
| Wearable integration | Phase 4 | Apple Health / Google Fit sync, step counter |
| Premium coaching | Phase 4 | 1-on-1 with Nepali dietitians/trainers |
| Recipe library | Phase 4 | Full recipes with calorie breakdown |
| Restaurant integration | Phase 4 | Tag Nepali restaurants, "DhalBhat Fit approved" menu items |
| Gamification badges | Phase 4 | Streaks, milestones, achievement unlocks |
| Family accounts | Phase 4 | Multiple profiles under one subscription |
| Advanced body scanning | Phase 4 | Body fat %, tape measure tracking, progress photos with AI |

---

## New Features Identified (Not in Earlier Plans)

These were named in this backlog plan but not yet designed. Adding to the queue.

### Favorite Meals

**What it does:** User can star any food_log, meal_template, or custom meal combo as a "favorite." Appears at the top of the meal log screen for instant re-logging.

**Schema addition:**
```sql
CREATE TABLE user_favorites (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  type        TEXT CHECK (type IN ('food', 'meal_template', 'custom_combo')),
  food_id     UUID REFERENCES foods(id),
  template_id UUID REFERENCES meal_templates(id),
  label       TEXT,         -- user-given name (e.g., "My usual lunch")
  created_at  TIMESTAMPTZ DEFAULT NOW()
);
```

**UX:** Star icon on Food Detail screen and meal template cards. Favorites appear as first section in Meal Log Screen above "Recent" and "Suggested."

### Favorite Workouts

**What it does:** User can pin a workout plan as a favorite. Pinned plan shows at top of Workout Browser and generates the home screen workout card.

**Schema addition:** Add `is_pinned BOOLEAN DEFAULT FALSE` to `user_workout_preferences.active_plan_id` (already exists — pinning = setting `active_plan_id`). No new table needed.

### Weekly Summary

**What it does:** Sunday evening, user gets a summary notification + in-app card.

**Content:**
- Average daily calories this week vs target
- Number of workouts completed
- Weight change this week
- Most logged food
- "Best day" (day closest to calorie target)

**Implementation:** Scheduled Supabase Edge Function (runs Sunday 7pm per user timezone). No new table — aggregates from existing `food_logs`, `workout_sessions`, `weight_logs`.

---

## Complete Feature-Phase Map

```
Phase 1 (MVP):
  ✦ Signup + Login
  ✦ Onboarding
  ✦ Calorie target calculation
  ✦ Nepali food database (100+)
  ✦ Meal logging (photo + search + one-tap)
  ✦ Daily dashboard
  ✦ Workout recommendation
  ✦ Active session (with timers)
  ✦ Weight progress tracking
  ✦ Offline mode (drift + sync)
  ✦ Nepali language toggle
  ✦ AI food correction loop (data collection)
  ✦ Basic workout adaptation (dislike/skip)

Phase 2 (Beta + Quick Wins):
  ✦ Meal reminders (push notifications)
  ✦ Home/gym mode switching
  ✦ Weekly summaries
  ✦ Favorite meals + workouts

Phase 3 (Expansion):
  ✦ Full adaptive food intelligence (custom_foods pipeline)
  ✦ Full progressive overload engine
  ✦ Personalized recommendation engine
  ✦ Better analytics (macro trends, volume chart, PRs)
  ✦ Voice logging (if STT is ready)
  ✦ Regional + festival food additions

Phase 4 (Scale):
  ✦ Premium subscription (eSewa, Khalti)
  ✦ Social sharing
  ✦ Community challenges
  ✦ Wearable integration
  ✦ Premium coaching marketplace
  ✦ Recipe library
  ✦ Restaurant integration
  ✦ Gamification
  ✦ Family accounts
```
