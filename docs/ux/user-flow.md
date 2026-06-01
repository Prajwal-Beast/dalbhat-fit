# DhalBhat Fit — User Flow

Complete walkthrough of every user journey in the app.
Each flow maps to specific screens (see screens-flow.md) and data operations.

---

## The Return Loop (Home Screen North Star)

Every time the user opens the app, it must immediately answer four questions:

```
1. What did I eat today?          → Calorie ring + meal slots on dashboard
2. What should I eat next?        → Meal suggestion card (time-of-day aware)
3. What should I train today?     → Today's workout card
4. Am I making progress?          → Weight delta + streak indicator
```

If the home screen fails to answer these four questions at a glance, the design needs revision.

---

## Flow 1: App Open

**Screens:** Splash → (route to auth or home)

```
App launches
    │
    ├─ First time → Splash → Welcome
    └─ Returning user → Splash → Home Dashboard (auto sign-in)

Splash screen shows:
  - DhalBhat Fit logo (centered)
  - Tagline: "Built for dal bhat and daily fitness"
  - Fade-in animation (max 1.5 seconds)
  - No user interaction needed

Routing logic:
  - IF no auth token → Welcome screen
  - IF auth token valid → Home Dashboard
  - IF auth token expired → Sign In screen
```

---

## Flow 2: Welcome

**Screens:** Welcome

```
User sees:
  - "Fitness built for Nepali life"
  - 3 feature bullets:
      → Understands Nepali food (dal bhat, momo, chatpate)
      → Tracks calories and macros accurately
      → Recommends workouts for weight loss or muscle gain

Primary CTA: Get Started → Sign Up screen
Secondary CTA: Sign In → Sign In screen (returning users)
```

---

## Flow 3: Authentication

**Screens:** Sign Up / Sign In

```
Sign Up:
  - Email + password
  - OR: Continue with Google
  - After auth: → Onboarding Step 1

Sign In:
  - Email + password
  - OR: Continue with Google
  - Forgot password: sends reset email
  - After auth: → Home Dashboard (skip onboarding if profile exists)
```

---

## Flow 4: Onboarding

**Screens:** Onboarding (10 steps, one per screen) → Calorie Setup

Each step: full screen, progress bar at top, Back + Continue buttons.

```
Step 1: Name
  Input: text field
  Store: user_profiles.name

Step 2: Age
  Input: number scroll picker
  Store: user_profiles.age

Step 3: Gender
  Input: 3 option cards (Male / Female / Other)
  Store: user_profiles.gender

Step 4: Height
  Input: number + unit toggle (cm / ft+in)
  Store: user_profiles.height_cm

Step 5: Current weight
  Input: number + unit toggle (kg / lbs)
  Store: user_profiles.weight_kg

Step 6: Goal
  Input: 3 option cards with icons
      → Lose weight (scale icon)
      → Build muscle (dumbbell icon)
      → Stay healthy (heart icon)
  Store: user_profiles.goal

Step 7: Activity level
  Input: 5 option cards
      → Mostly sitting (office job, no exercise)
      → Light movement (walk sometimes)
      → Moderately active (workout 3x/week)
      → Very active (workout 5x/week)
      → Athlete level
  Store: user_profiles.activity_level

Step 8: Workout preference
  Input: 3 option cards
      → Home (bodyweight, no equipment)
      → Gym (weights and machines)
      → Both (I switch)
  Store: user_profiles.workout_pref

Step 9: Food preference
  Input: 3 option cards
      → Non-vegetarian (I eat everything)
      → Vegetarian (no meat or fish)
      → Vegan (no animal products)
  Store: user_profiles.food_preference

Step 10: Language
  Input: 2 option cards
      → English
      → नेपाली (Nepali)
  Store: user_settings.language
  Effect: immediately re-renders UI in chosen language
```

---

## Flow 5: Calorie Setup

**Screens:** Calorie Goal Summary

```
After onboarding completes:

App calculates (locally, no API call):
  BMR = Mifflin-St Jeor formula
  TDEE = BMR × activity_multiplier
  Daily target:
      Lose weight: TDEE − 500
      Gain muscle: TDEE + 300
      Maintain:    TDEE

  Macro split based on goal:
      Lose:    40% carbs / 35% protein / 25% fat
      Gain:    45% carbs / 35% protein / 20% fat
      Maintain: 50% carbs / 25% protein / 25% fat

Screen shows:
  - "Your daily calorie target"  (large number, prominent)
  - Goal type: "Weight Loss · 0.5 kg/week pace"
  - Macro split: Carbs [Xg] · Protein [Xg] · Fat [Xg]
  - BMI category (Asian cutoffs) with range indicator
  - Estimated weeks to reach target weight

Save to:
  user_profiles.daily_calories
  goals (new row: goal_type, start_weight_kg, target_weight_kg, daily_calorie_target)

CTA: Start Tracking → Home Dashboard
```

---

## Flow 6: Home Dashboard (Daily Loop)

**Screens:** Home Dashboard [Tab 1]

```
Every time user opens the app after onboarding:

Above the fold (always visible):
  - Greeting: "Good morning, [Name]" (time-aware)
  - Calorie ring:
      Center: calories consumed today
      Ring fill: consumed / daily_target
      Color: green (<90% of target) / amber (90-110%) / red (>110%)
  - Macro summary: C [Xg] · P [Xg] · F [Xg]
  - [+ Log Meal] button (largest CTA on screen)

Below the fold (scroll):
  - Today's meals:
      Breakfast · [X] kcal  [+]
      Lunch     · [X] kcal  [+]
      Dinner    · [X] kcal  [+]
      Snack     · [X] kcal  [+]
  - Today's workout card:
      Plan name · Duration · Level
      [Start Workout] button
  - Water tracker: ○ ○ ● ○ ○ ○ ○ ○ (tap to add glass)
  - Streak indicator: "🔥 5 days logged in a row"
  - Weight this week: "72.4 kg · ↓ 0.3 kg this week"

Data sources:
  - food_logs WHERE logged_at = today → calorie total, macros
  - workout_plans (user's active plan) → today's plan day
  - weight_logs (last 7 days) → trend
  - food_logs (consecutive days with ≥1 log) → streak count
```

---

## Flow 7: Meal Logging

**Screens:** Meal Log Screen → Food Search → Food Detail → (back to Home)

```
User taps [+ Log Meal] or [+] next to a meal slot:

Meal Log Screen opens with meal type pre-selected (time-aware):
  Before 10am → Breakfast
  10am-3pm   → Lunch
  3pm-7pm    → Snack
  After 7pm  → Dinner

Three input tabs:

── TAB 1: PHOTO (opens by default) ──
  Camera opens
  User takes photo or uploads from gallery
      │
      ▼
  Image sent to Supabase Edge Function
  Claude Vision identifies dish
      │
      ├─ Confidence ≥ 0.65:
      │     → Food Detail opens pre-filled
      │     → User sees: dish name, portion chips, calories
      │     → User confirms or adjusts → logged
      │
      └─ Confidence < 0.65:
            → "I'm not sure what this is"
            → Show closest match + ask: "What is this called?"
            → User types name → custom_foods flow
            → Estimate from ingredients → user confirms → logged

── TAB 2: SEARCH ──
  Search bar (EN + NE text)
  Results appear after 1 character
  Sections:
    "Suggested for now" (time + history based)
    "Recent" (last 7 logged foods)
    "Your favorites" (starred items)
    "All foods" (search results)
  One tap on [+] → instantly logged at default portion
  (5-second undo chip appears)

── TAB 3: VOICE (Phase 3) ──
  Microphone opens
  User says: "ek plate dal bhat khaya"
  Claude parses → maps to food_id + portion
  → Food Detail opens pre-filled

On Food Detail screen:
  - Food name (EN + NE)
  - Estimated calories (large)
  - Portion chips: [Small] [Medium ✓] [Large]
  - Calorie updates live as user switches portions
  - Macro breakdown: P · C · F
  - AI confidence chip (if came from photo)
  - [Save to log] CTA
  - [Quick Add] — logs immediately, skips this screen next time

After logging:
  → Undo chip (5 seconds)
  → Home dashboard calorie ring updates
  → food_logs entry created (local SQLite first, then Supabase)
```

---

## Flow 8: Workout

**Screens:** Workout Browser → Exercise Detail → Active Session → Workout Complete

```
User taps Today's Workout card on home screen OR Workout tab [Tab 3]:

── WORKOUT BROWSER ──
  Filters: Goal / Location / Level
  Cards show: plan name, days/week, duration, level tag
  User selects a plan → sees day-by-day exercise list

── EXERCISE DETAIL ──
  Tap any exercise to see:
    - Name + target muscles
    - Animated GIF or video
    - Step-by-step instructions
    - Sets / Reps / Rest recommendation
    - Beginner modification (if applicable)
  Back → Workout Browser

── ACTIVE SESSION ──
  When user taps [Start Workout]:
    - Full screen mode
    - Session start time recorded (workout_sessions.started_at)
    - Exercise list in order

  For each exercise:
    - Name + muscle group tag
    - Animation
    - Set X of Y counter
    - Rep counter (tap to count)
    - [Start Rest] → rest timer countdown
    - [Next Exercise] after rest
    - [Skip] to skip this exercise (recorded in workout_session_items.was_skipped)

  Controls:
    - Pause session
    - Swap exercise (tap → picks home alternative if user is home)
    - End session early

  Data written per exercise:
    workout_session_items: exercise_id, sets_completed, reps, weight_kg, was_skipped

── WORKOUT COMPLETE ──
  After last exercise:
    - Celebration animation
    - Summary: X exercises, Y minutes, Z kcal burned (estimate)
    - Streak: "4 workouts this week!"
    - [Log a meal] / [Back to home] CTAs

  Data saved:
    workout_sessions: completed_at, duration_minutes, calories_burned, completion_pct
```

---

## Flow 9: Progress

**Screens:** Progress Screen [Tab 4]

```
Shows user's historical data across 4 sections:

── WEIGHT TREND ──
  Line graph: daily weight over time
  Toggle: 7 days / 30 days / 90 days
  Source: weight_logs
  Shows: current weight, start weight, delta from goal start

── STREAKS ──
  Food logging streak: consecutive days with ≥1 food log
  Workout streak: consecutive days with ≥1 workout session
  Shown as number + fire emoji equivalent + mini calendar
  Source: computed from food_logs + workout_sessions

── WEEKLY CALORIES ──
  Bar chart: daily calories vs target (7 days)
  Color: green bars = at/under target, red bars = over target
  Source: food_logs grouped by logged_at

── WORKOUT CONSISTENCY ──
  Calendar heatmap (last 30 days)
  Green dot = workout logged, grey = no workout
  Source: workout_sessions grouped by session_date

── GOAL PROGRESS ──
  Progress bar: start weight → current weight → target weight
  Estimated weeks remaining at current pace
  Source: weight_logs trend + goals table

── WEIGHT LOG ──
  [+ Add today's weight] button
  Opens: numeric input + optional note
  Saves to: weight_logs
```

---

## Flow 10: AI Feedback Loop

**How the app learns (invisible to user, always running)**

```
FOOD LEARNING:

After every food photo log:
  → User accepts AI result → no feedback entry
  → User changes portion → ai_feedback (wrong_portion)
  → User changes food name → ai_feedback (wrong_food)
  → User taps "Flag as wrong" → ai_feedback (wrong_food or wrong_calories)

  Feedback is included in future Claude prompts as user context:
    "This user's dal bhat is usually a large plate, not medium."

After custom food submission:
  → Logged with estimated calories
  → custom_foods.log_count increments each time
  → At 20 logs → admin review queue

WORKOUT LEARNING:

After session:
  → completion_pct recorded
  → Skipped exercises → user_workout_preferences.disliked_exercises (if pattern)

Skip pattern (3× same exercise):
  → App prompts: "Keep skipping [exercise]. Swap it?"
  → Yes → adds to disliked_exercises, replaces in plan

Rating collected (1–5 stars) after workout:
  → Low rating + skip pattern → simplify plan
  → High rating + completion → suggest progression

RECOMMENDATION LEARNING:

After each meal or workout recommendation:
  → Thumbs up/down → recommendations.was_useful
  → User logs suggested food within 2h → recommendations.was_followed = true
  → User starts suggested workout → recommendations.was_followed = true

Over 30 days:
  → App learns which suggestion formats the user responds to
  → Adjusts future Claude prompts with this context
```

---

## Flow 11: Settings & Profile

**Screens:** Profile + Settings [Tab 5]

```
Profile section:
  - Name, goal, current weight (display only)
  - [Edit Profile] → re-opens onboarding fields (pre-filled)
  - [Change Goal] → Goal selector + recalculates calorie target

Settings section:
  - Language toggle: English ↔ नेपाली
  - Units: kg + cm ↔ lbs + ft
  - Notification times: meal reminder, workout reminder
  - Dark mode toggle
  - Privacy settings
  - Subscription status (free / premium)
  - Sign out
  - Delete account (with confirmation)
```

---

## Flow 12: Return Visit (Daily Retention Loop)

**The most important flow — happens every day**

```
Morning (6-10am):
  Open app → Home Dashboard
  Ring shows 0 kcal logged
  Breakfast suggestion visible ("Have dal bhat?")
  Today's workout card ready

After breakfast:
  Tap [+ Log Meal] → Breakfast pre-selected
  Photo or one-tap from recent → logged in < 15 seconds
  Ring updates

Mid-day:
  Lunch suggestion appears based on remaining calories
  Log lunch → 2 taps

Evening:
  Workout reminder notification
  Complete workout → Workout Complete screen
  Log dinner → Ring shows full day

Night:
  Optional: Log weight
  Progress screen shows today's summary
  Tomorrow's workout ready on dashboard

Sunday evening:
  Weekly summary notification
  Opens to Progress screen: "This week: X kcal avg, Y workouts"
```

---

## Empty States (Every Flow Has a CTA)

| Screen | Empty condition | Message | CTA |
|---|---|---|---|
| Home (no meals today) | No food_logs for today | "You haven't logged yet today" | "Log Breakfast" |
| Home (no workout) | No active plan | "No workout set up yet" | "Browse Plans" |
| Progress (no weight) | No weight_logs | "Add your first weight to start tracking" | "Add Weight" |
| Progress (no workouts) | No workout_sessions | "Complete a workout to see history" | "Start Workout" |
| Food search (no results) | Search returns 0 | "Not found — add it as a custom food?" | "Add Custom Food" |
| Workout browser (no match) | Filters return 0 | "No plans match your filters" | "Reset Filters" |
