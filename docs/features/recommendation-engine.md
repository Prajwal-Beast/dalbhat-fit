# DhalBhat Fit — Diet & Workout Recommendation Engine

This is the brain of the app. It combines food intake, workout history, and user goals to generate useful, personalized daily guidance.

---

## Architecture Overview

```
User data inputs
  │
  ├─ Daily logs (food_logs, workout_sessions, weight_logs)
  ├─ User profile (goal, weight, activity level)
  ├─ User preferences (foods they eat, workouts they do)
  └─ Real-time today status (calories consumed, remaining)
        │
        ▼
Recommendation Engine (Supabase Edge Function)
        │
        ├─ Rule-based logic (fast, local, no AI needed)
        └─ Claude API (nuanced suggestions, natural language)
        │
        ▼
Recommendation output
  ├─ Meal suggestion (what to eat next)
  ├─ Workout suggestion (what to do today)
  ├─ Adjustment alert (target change, plan simplification)
  └─ Encouragement / milestone
```

**Rule-based vs Claude API split:**
- Simple threshold checks (over/under calorie, skip patterns) → local rule engine, instant
- Specific meal + food suggestions → Claude API (has context of Nepali foods + user history)
- Workout generation and adjustment → Claude API
- Quick nudges and alerts → local rule engine (no API call needed)

---

## Calorie & Macro Targets

### Daily calorie target computation (Mifflin-St Jeor + goal)

```
BMR (men)   = (10 × weight_kg) + (6.25 × height_cm) − (5 × age) + 5
BMR (women) = (10 × weight_kg) + (6.25 × height_cm) − (5 × age) − 161

TDEE = BMR × activity_multiplier
  Sedentary:   1.2
  Light:       1.375
  Moderate:    1.55
  Active:      1.725
  Very active: 1.9

Daily target:
  Lose weight:    TDEE − 500  (targets ~0.5 kg/week loss)
  Gain muscle:    TDEE + 300  (lean bulk, minimizes fat gain)
  Maintain:       TDEE
```

### Macro split by goal

```
Weight loss:   Carbs 40% / Protein 35% / Fat 25%
Muscle gain:   Carbs 45% / Protein 35% / Fat 20%
Maintenance:   Carbs 50% / Protein 25% / Fat 25%
```

Protein floor: never drop below 1.6g per kg of body weight (critical for muscle retention during fat loss).

---

## Dynamic Target Adjustment

### Weekly weight trend analysis (runs every Sunday evening)

```
weekly_data = weight_logs WHERE user_id = $user AND logged_at >= 14 days ago

current_week_avg = AVG(weight) WHERE logged_at >= 7 days ago
previous_week_avg = AVG(weight) WHERE logged_at BETWEEN 14 and 7 days ago

weekly_change = current_week_avg - previous_week_avg
```

### Weight loss goal — adjustment rules

| Situation | Threshold | Action | Notification |
|---|---|---|---|
| Too slow | weekly_change > −0.1 kg for 2 consecutive weeks | Reduce target by 100 kcal | "Progress is slower than expected. We've adjusted your target slightly." |
| On track | weekly_change between −0.3 and −0.7 kg | No change | Weekly: "You're right on track this week." |
| Too fast | weekly_change < −0.8 kg for 2 consecutive weeks | Increase target by 150 kcal | "You're losing weight very fast. Increasing your target to protect muscle." |
| Plateau | No change for 3 weeks (< ±0.1 kg) | Suggest diet break or recheck activity level | "Your weight hasn't moved in 3 weeks. Let's review your plan." |

### Muscle gain goal — adjustment rules

| Situation | Threshold | Action |
|---|---|---|
| Gaining too fast | weekly_change > 0.5 kg | Reduce surplus by 100 kcal (excess fat gain) |
| On track | weekly_change 0.15 – 0.35 kg | No change |
| Gaining too slow | weekly_change < 0.1 kg for 2 weeks | Increase surplus by 100 kcal |

### Adjustment history

All adjustments saved to `calorie_adjustments` table (see schema section). Users see a graph of target changes over time in Progress screen.

---

## Daily Reactive Logic

Runs 3 times per day: morning, afternoon, evening.

### Morning trigger (7–9am)

```
Inputs: yesterday's logs, this week's trend, today's scheduled workout

Outputs:
  → Show today's calorie target on home screen
  → Generate today's meal plan suggestion (breakfast + lunch + dinner kcal split)
  → Show today's recommended workout
  → If yesterday was over target: "Yesterday was a bit high. Let's have a lighter breakfast."
  → If yesterday was a great day: "Excellent day yesterday. Keep the momentum."
```

### Mid-day trigger (12–2pm)

```
Inputs: breakfast logged (or not), remaining daily calories, goal

IF breakfast not logged:
  → Do not nag. Show log prompt on home screen only.

IF breakfast logged:
  → remaining = daily_target - breakfast_calories
  → Suggest lunch options that fit remaining calories
  → Account for dinner (reserve 35% of remaining for dinner)
  → Lunch suggestion budget = remaining × 0.55
  → Show: "You have [X] kcal for lunch. Here are some ideas."
```

### Evening trigger (7–9pm)

```
Inputs: all meals logged today, workout completed (yes/no), remaining calories

IF over target by > 200 kcal:
  → "You're a bit over today. A 20-minute walk burns about 100 kcal."
  → Suggest lighter dinner if not yet logged

IF under target by > 300 kcal AND goal = muscle_gain:
  → "You're 300 kcal under today. Add a protein-rich snack."
  → Suggest: boiled eggs, dahi, peanuts, milk

IF under target by > 300 kcal AND goal = weight_loss:
  → "Great job staying under today! Make sure you're eating enough to feel energized."
  → No suggestion to eat more unless consistently under by large margin

IF workout not completed today:
  → "Didn't get to workout today? That's fine. Rest is part of the plan."
  → No guilt. Just acknowledge.
```

---

## Goal-Specific Recommendation Rules

### Weight Loss

**Food rules:**
```
Priority 1: Portion control for rice and dal bhat
  → Default suggestion: medium plate (not large)
  → If user usually logs large plate: suggest dropping to medium
  → Show calorie difference: "Switching to medium saves 200 kcal"

Priority 2: More protein per meal
  → Add: boiled egg, chicken curry, fish, dahi, dal
  → Replace: fried momo → steamed momo (saves 130 kcal per plate)
  → Replace: sel roti → roti (saves 140 kcal)

Priority 3: More vegetables and fiber
  → Suggest saag, gundruk, mixed tarkari as additions
  → Fiber slows digestion, reduces hunger — mention this

Priority 4: Reduce cooking oil
  → Fried items: suggest baked, steamed, or boiled alternatives
```

**Workout rules:**
```
5 days/week default plan:
  Day 1: Strength (full body)
  Day 2: Cardio (30 min running / cycling / jump rope)
  Day 3: Strength (upper/lower split)
  Day 4: Active recovery (walking, stretching)
  Day 5: HIIT circuit (20-30 min)
  Day 6-7: Rest

Adjust for home users:
  → Replace gym cardio with: jump rope, running, mountain climbers, burpees
  → All strength days use bodyweight or resistance bands
```

### Muscle Gain

**Food rules:**
```
Priority 1: Calorie surplus from quality sources
  → Increase rice portion (1 large cup instead of 1 medium)
  → Add extra dal serving (more protein + carbs)
  → Add 2 eggs to at least one meal daily

Priority 2: Protein at every meal
  → Breakfast: eggs + milk / dahi
  → Lunch: chicken/fish curry + dal + rice
  → Dinner: mutton/chicken/fish + dal + rice
  → Snacks: bhatmas, peanuts, dahi

Priority 3: Don't add junk calories
  → Avoid: fried snacks, instant noodles as calorie source
  → Surplus should come from whole foods
  → Track protein: target 1.6–2g per kg body weight

Nepali muscle gain meal example:
  Breakfast: 3 boiled eggs + 1 cup milk + 2 rotis = ~480 kcal / 30g protein
  Lunch: 3 cups rice + chicken curry + dal = ~950 kcal / 45g protein
  Dinner: 2 cups rice + mutton curry + dal = ~850 kcal / 40g protein
  Total: ~2,280 kcal / ~115g protein (good for 70kg user)
```

**Workout rules:**
```
4 days/week strength split:
  Day 1 (Mon): Push — Chest, Shoulders, Triceps
  Day 2 (Tue): Pull — Back, Biceps
  Day 3 (Thu): Legs — Quads, Hamstrings, Glutes, Calves
  Day 4 (Fri): Full body compound / weak points

Progressive overload: increase weight or reps every 2 sessions
Rest days: 2 full rest days, 1 active recovery day
Cardio: minimal (1-2 sessions/week, low intensity, preserve calories)
```

### Maintenance

**Food rules:**
```
→ Match TDEE daily (no significant deficit or surplus)
→ Balanced thali: rice + dal + tarkari + protein + achar
→ No food group restrictions unless personal preference
→ Focus on: consistency, variety, adequate water
→ Suggest variety: different dal types, seasonal vegetables, different protein sources each week
```

**Workout rules:**
```
3 days/week, full body or any split the user enjoys
Duration: 30-45 min
Intensity: moderate — not pushing for PRs, not coasting either
1-2 cardio sessions per week for cardiovascular health
Focus: enjoyment + consistency over optimization
```

---

## Workout Recommendation Rules

### Daily workout selection algorithm

```
Step 1: Check what day it is in the user's active plan
  → plan_day = (days since plan start) mod plan.days_per_week

Step 2: Check recent performance
  → last_session.completion_pct < 70% → reduce intensity
  → last 3 sessions all 100% complete → suggest progression

Step 3: Check available time (from notification context or user_workout_preferences)
  → < 20 min available: suggest 15-min quick circuit
  → 20-30 min: standard session, reduce sets by 1
  → 30+ min: full session as planned

Step 4: Check location (home vs gym)
  → home → filter to bodyweight or home equipment exercises
  → gym → full plan as designed

Step 5: Output today's session
  → exercise list, sets, reps, rest
  → estimated duration
  → estimated calories burned
  → motivation note (specific to user's recent performance)
```

### Workout simplification triggers

```
IF skip_count_this_week >= 3:
  → reduce days_per_week by 1 (min: 2)
  → reduce session duration by 10 min
  → switch to beginner variant of current plan
  → notify: "Let's simplify your plan a bit. Consistency beats intensity."

IF completion_pct < 60% for 3 consecutive sessions:
  → reduce volume by 20% (fewer sets, not fewer exercises)
  → check: is it the difficulty, time, or specific exercises?
  → suggest: "Which part of the workout is hardest to complete? [tap to tell us]"
```

### Workout progression triggers

```
IF all sessions completed for 2 consecutive weeks:
  → suggest next plan level (beginner → intermediate)
  → notify: "You've been incredibly consistent. Ready for a harder plan?"

IF individual exercise completed at target reps for 2 consecutive sessions:
  → suggest progressive overload for that exercise
  → show in exercise detail: "Try adding 1-2 reps next session"
```

---

## Claude API Prompts for Recommendations

### Daily meal suggestion prompt

```
System:
You are a Nepali nutrition coach for DhalBhat Fit.
Recommend meals for [meal_type] based on the user's situation.

User profile:
  Goal: [lose/gain/maintain]
  Daily calorie target: [X] kcal
  Calories consumed today: [Y] kcal
  Remaining for [meal_type]: [Z] kcal
  Macro remaining: Protein [g], Carbs [g], Fat [g]

User's common [meal_type] foods (from history):
  [food_name, typical_portion, calories] × top 5

Available Nepali foods in database: [inject filtered list]

Food preference: [vegetarian / non-vegetarian]

Rules:
  - Suggest 3 meal options
  - Prefer foods from user's history when possible
  - Stay within [Z] kcal budget
  - Prioritize protein for this goal
  - Use realistic Nepali portion sizes
  - If weight loss: suggest medium portions, lean protein, vegetables
  - If muscle gain: suggest higher calories, extra protein source

Return JSON:
[
  {
    "food_name": "",
    "food_id": "",
    "portion_label": "",
    "calories": 0,
    "protein_g": 0,
    "reason": "one sentence why this fits the user's goal"
  }
]
```

### Workout suggestion prompt

```
System:
You are a Nepali fitness coach for DhalBhat Fit.
Suggest today's workout.

User profile:
  Goal: [lose/gain/maintain]
  Level: [beginner/intermediate/advanced]
  Location: [gym/home]
  Equipment: [list]
  Time available: [X] minutes

Recent performance:
  Last session: [date, completion_pct, exercises]
  This week: [sessions completed / sessions planned]
  Streak: [X consecutive days]

Plan context:
  Active plan: [plan_name]
  Today's plan day: [day_label, exercises]

Adjustment flags:
  [if completion_pct low] → reduce volume
  [if all sessions complete] → maintain or suggest progression

Return JSON:
{
  "session_title": "",
  "exercises": [
    {
      "exercise_id": "",
      "exercise_name": "",
      "sets": 0,
      "reps": "",
      "rest_seconds": 0
    }
  ],
  "duration_estimate_mins": 0,
  "intensity": "low/moderate/high",
  "motivation_note": "one sentence, personal to user's recent pattern"
}
```

### Goal adjustment alert prompt

```
System:
You are a compassionate Nepali fitness advisor.
The user's weight trend suggests their plan needs adjustment.

Situation: [too slow / too fast / plateau]
Current target: [X] kcal
New target: [Y] kcal
User's goal: [lose/gain/maintain]
Weeks tracking: [N]

Write a short (2 sentence max) notification message that:
  - Explains what changed and why
  - Uses encouraging language, not guilt
  - Feels personal, not robotic
  - Is in [English / Nepali] depending on user's language setting

Return: { "message": "..." }
```

---

## Feedback Loop

### After each recommendation is shown

```
UI: Show recommendation card with thumbs up / thumbs down
    ↓
User taps thumbs down:
  → Ask: "Why wasn't this helpful?"
    Options: Wrong food | Not hungry | Already ate | Too much effort | Other
  → Save to recommendations.feedback_reason
  → Reduce frequency of this recommendation type

User taps thumbs up:
  → Save recommendations.was_useful = true
  → Increase frequency of this recommendation type
```

### Tracking whether recommendation was followed

```
Meal recommendation:
  → 2 hours after suggestion: check if food_logs has that food_id logged
  → IF logged: recommendations.was_followed = true
  → IF not: recommendations.was_followed = false (not failure — just not followed)
  → Aggregate: if was_followed < 30% over 2 weeks → adjust suggestion strategy

Workout recommendation:
  → Check if workout_sessions has a session for today
  → IF session exists: was_followed = true
  → Track which recommended workouts are consistently skipped
```

### Learning from feedback over time

```
After 30 days:
  Compute per-user: which food suggestions are followed vs ignored
  Adjust meal suggestion prompt context:
    → "This user tends to follow [food_type] suggestions"
    → "This user rarely logs [food_type] when suggested — exclude"

  Compute: which workout formats user completes (gym vs home, long vs short)
  Adjust workout suggestion:
    → Prefer formats with high historical completion_pct
```

---

## Vegetarian / Non-Vegetarian Filter

Applied at recommendation generation time:

```
IF food_preference = 'vegetarian':
  → Exclude: chicken, mutton, fish, buff, pork
  → Include: eggs (if lacto-ovo), dairy, dal, paneer, tofu, bhatmas
  → For protein: emphasize dal, eggs, paneer, dahi, bhatmas

IF food_preference = 'non_vegetarian':
  → All foods eligible
  → Protein suggestions: chicken, fish, eggs, mutton — in order of calorie efficiency

IF food_preference = 'vegan' (future):
  → Exclude dairy, eggs, meat
  → Protein: dal, bhatmas, tofu, beans
```

---

## Schema Additions for Recommendation Engine

```sql
-- Track calorie target adjustments over time
CREATE TABLE calorie_adjustments (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  previous_target INTEGER NOT NULL,
  new_target      INTEGER NOT NULL,
  reason          TEXT,           -- 'too_slow', 'too_fast', 'plateau', 'goal_change'
  weekly_change_kg NUMERIC(4,2),  -- what triggered the adjustment
  applied_at      TIMESTAMPTZ DEFAULT NOW()
);

-- Extend recommendations table
ALTER TABLE recommendations ADD COLUMN was_followed    BOOLEAN;
ALTER TABLE recommendations ADD COLUMN feedback_reason TEXT;
ALTER TABLE recommendations ADD COLUMN related_food_id UUID REFERENCES foods(id);
ALTER TABLE recommendations ADD COLUMN related_plan_id UUID REFERENCES workout_plans(id);

-- Add food preference to user_profiles
ALTER TABLE user_profiles ADD COLUMN food_preference TEXT
  DEFAULT 'non_vegetarian'
  CHECK (food_preference IN ('non_vegetarian', 'vegetarian', 'vegan'));
```

---

## Recommendation Quality Rules

These prevent the engine from giving useless or annoying advice:

| Rule | Why |
|---|---|
| Never recommend the same meal 3 days in a row | Variety prevents boredom |
| Never recommend a food the user has flagged as disliked | Obvious but must be enforced |
| Never generate a calorie adjustment within 1 week of the last adjustment | Too frequent changes are confusing |
| Do not recommend workout if user logged sick / injury today | Read context before suggesting exercise |
| Limit meal suggestions to foods in the database + user's custom logs | No hallucinated foods |
| Always show remaining macros after each recommendation | Users make better decisions with context |
| Do not show "you're over target" if over by < 50 kcal | Micro-overages are not meaningful |
