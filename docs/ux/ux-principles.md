# DhalBhat Fit — Seamless Experience Principles

Core philosophy: the app should feel like a smart daily assistant, not a complicated tracker.
This document translates UX principles into concrete implementation rules.

---

## The One Rule That Governs Everything

> A user should be able to open the app, log a meal, and close it in under 15 seconds.

Every feature decision should be measured against this goal.

---

## Design Principles (with implementation meaning)

| Principle | What it means in code |
|---|---|
| Minimize typing | Use cameras, taps, sliders, and chips — not text fields — as the primary input |
| Reduce taps | No action should take more than 3 taps from any screen |
| Smart defaults | Use user history to pre-fill portions, meal times, and suggestions |
| App remembers habits | Query food_logs for patterns — surface frequent foods automatically |
| Make corrections easy | Log immediately at default → allow editing after, not before |
| Personalize everything | Every list, suggestion, and default is derived from this user's history |

---

## Home Screen — What It Shows and Why

The home screen is not a dashboard. It is an action surface.

### Above the fold — always visible without scroll

```
┌─────────────────────────────────────────────┐
│  Good morning, [Name] 🌄                    │
│                                             │
│         ┌──────────────┐                   │
│         │   [Ring]     │                   │
│         │  1,240       │                   │
│         │  of 1,800    │                   │
│         └──────────────┘                   │
│                                             │
│  C: 142g   P: 68g   F: 38g                 │
│                                             │
│         ┌──────────────────────┐            │
│         │  + Log Meal          │            │
│         └──────────────────────┘            │
└─────────────────────────────────────────────┘
```

**Rules:**
- Calorie ring is the visual anchor — it communicates success or warning instantly
- Ring color: green when under target, amber within 100 kcal of target, red if over
- Macro summary: three numbers, no labels needed after first few uses
- Log Meal CTA: largest interactive element, impossible to miss
- Greeting changes: "Good morning" / "Afternoon" / "Good evening" by time of day

### Below the fold — scroll to see

```
┌─────────────────────────────────────────────┐
│  Today's Workout                            │
│  ┌────────────────────────────────────────┐ │
│  │  Home Full Body · 30 min · Beginner    │ │
│  │  [Start Workout]                       │ │
│  └────────────────────────────────────────┘ │
│                                             │
│  Meals today                                │
│  Breakfast · 480 kcal   [+]                 │
│  Lunch     · 0 kcal     [+]                 │
│  Dinner    · 0 kcal     [+]                 │
│                                             │
│  Water: ○ ○ ● ○ ○ ○ ○ ○  (3 of 8 glasses)  │
│                                             │
│  Weight: 72.4 kg  ↓ 0.3 this week          │
└─────────────────────────────────────────────┘
```

**Nothing else on the home screen.** No charts. No streaks. No social. No ads above the fold.

---

## Food Logging — Speed Hierarchy

Present logging methods in order of speed, not alphabetically:

### Priority 1: One-tap from suggestions (0 taps to find, 1 tap to log)

The meal log screen opens with:
- **"Suggested for now"** — based on time of day + user history
  - Breakfast time → show user's most common breakfast foods
  - Lunch time → show dal bhat variants (most common Nepali lunch)
  - Dinner time → show user's most common dinner foods
- **"Recent"** — last 7 logged foods (any meal type)
- **"Your meals"** — saved meal templates

Each card has:
- Food name
- Portion (user's most recently logged portion for that food)
- Calories
- [+] button → instantly logs at default portion

Tapping [+] logs immediately. No confirmation screen. Undo available for 5 seconds.

### Priority 2: Photo (1 tap to open camera, instant AI result)

Camera opens by default when user taps Log Meal.
Result appears in under 5 seconds.
Show result → user taps Confirm or adjusts portion.

### Priority 3: Search (type to find)

- Results appear after 1 character typed
- Nepali and English search both work
- Results ordered: exact match first, then by user's logging frequency
- Each result: one tap to open Food Detail, one tap to log

### Priority 4: Voice (Phase 2)

Not in MVP. Add when Nepali STT accuracy is acceptable.

---

## Portion Adjustment — No Number Typing

Never show a "enter grams" text field as the primary input. Always show:

### Quick portion chips (primary)

```
[ Small ]  [ Medium ✓ ]  [ Large ]
```

- Chips correspond to the food's food_portions entries
- Default chip is pre-selected based on user's last logged portion for this food
- One tap to change

### Portion multiplier slider (secondary, shown if user taps "Custom")

```
0.5x ────●────────── 2x
         Currently: 1x  (240 kcal)
```

- Calorie number updates live as slider moves
- Snap points at 0.5, 0.75, 1.0, 1.25, 1.5, 2.0
- Only show this if user explicitly wants custom — not by default

### Gram input (tertiary, show only if user taps "Enter grams")

Hidden behind one more tap. Most users will never need it.

---

## Log First, Edit Later

**Old way (wrong):** User taps food → chooses portion → reviews → confirms → logged.
**DhalBhat Fit way:** User taps [+] → instantly logged at default portion → undo chip appears.

```
Food logged ✓ · 240 kcal          [Undo] [Edit]
                                    ←  5 seconds  →
```

After 5 seconds: undo disappears, food is committed.
"Edit" always accessible from the meal list on home screen or daily summary.

This removes the "feels like a chore" from logging. Log now, adjust if needed.

---

## Smart Defaults System

Every default is derived from user history. Never use generic defaults after the first week.

| Default | How it's computed |
|---|---|
| Portion size for a food | User's most recently logged portion for that food_id |
| Breakfast suggestion | Top 3 foods logged at breakfast time in last 30 days |
| Lunch suggestion | Top 3 foods logged at lunch time in last 30 days |
| Dinner suggestion | Top 3 foods logged at dinner time in last 30 days |
| Workout duration | User's last 3 completed session durations (average) |
| Workout intensity | Based on completion_pct from last 5 sessions |
| Meal template default | Most-used template in last 14 days |

### Smart default data queries

All computed at session start or cached daily:

```sql
-- User's top breakfast foods (last 30 days)
SELECT food_id, COUNT(*) as frequency, MAX(portion_id) as last_portion
FROM food_logs
WHERE user_id = $1
  AND meal_type = 'breakfast'
  AND logged_at >= NOW() - INTERVAL '30 days'
GROUP BY food_id
ORDER BY frequency DESC
LIMIT 5;

-- User's most recent portion for a specific food
SELECT portion_id FROM food_logs
WHERE user_id = $1 AND food_id = $2
ORDER BY created_at DESC
LIMIT 1;
```

These queries run once, cached in local SQLite, refreshed daily.

---

## Suggestion Engine Rules

### Meal suggestions

```
Time of day → meal slot → query user's history for that slot
  + Apply goal filter:
      Weight loss → prefer lower-calorie variants of common foods
                    (if user usually logs large dal bhat → suggest medium)
      Muscle gain → prefer high-protein options from user's history
  + Apply remaining calorie filter:
      Only suggest meals that fit within remaining daily calories
  + Surface as: "Have this for lunch?" card on home screen
```

### Workout suggestions

```
Time of day + day of week → check if user usually trains this day
  + Equipment availability (gym vs home preference)
  + Remaining energy (if < 400 kcal logged all day → suggest shorter session)
  + User's typical session duration
  + Surface as: today's workout card on home screen
```

### Busy day detection

```
IF user logs meals but hasn't opened workout section by 8pm:
  → swap today's workout suggestion to "15 min quick session" or "active rest"
  → notification: "Short on time? Here's a 15-minute option."
```

---

## Notification Rules

### What to send

| Notification | Trigger | Message style |
|---|---|---|
| Meal reminder | User's set meal time (or 8am / 1pm / 7pm default) | "Time to log lunch?" |
| Workout reminder | User's set workout time | "Your workout is waiting." |
| Under-calorie nudge | User is 300+ kcal under target at 8pm | "You're 300 kcal under today. Have a snack?" |
| Over-calorie nudge | User is 200+ kcal over target | "Slightly over today — lighter dinner?" |
| Progress milestone | User hits 7-day streak, 5kg lost, etc. | "7 days consistent! You're building a habit." |
| Weekly summary | Sunday evening | "This week: X kcal avg, Y workouts. [View]" |

### What NOT to send

- Daily "don't forget to log!" if user has already logged that day
- Workout reminder if user already completed a workout today
- Any notification between 10pm and 7am
- More than 3 notifications in one day
- Generic motivational quotes (no value, high annoyance)

### Notification copy rules

- Maximum 1 sentence
- Use the user's name only on milestone notifications
- Never use guilt language ("You failed", "You missed", "You slacked")
- Always include an action or data point — never vague encouragement

```
Good: "You're 300 kcal under today. Have a snack?"
Bad:  "Don't forget to take care of yourself!"

Good: "7 days logged in a row. Consistency is everything."
Bad:  "Great job! Keep it up! 🎉🎉🎉"
```

---

## Friction Inventory (Things to Eliminate)

These are specific friction points that must be designed out:

| Friction Point | Solution |
|---|---|
| Typing food name every time | Recent foods + suggestion chips on log screen |
| Estimating grams manually | Portion chips (Small/Medium/Large) + visual reference |
| Forgetting what you ate | Morning prompt: "What did you have for breakfast?" with quick suggestions |
| Not knowing which workout to do | App decides — shows one recommendation, not a list |
| Feeling judged for eating too much | Calorie ring stays green until 110% of target — no red alert for small overages |
| Having to scroll to find Log button | Log Meal CTA is always the dominant action on the home screen |
| Losing a log if internet drops | All logs write locally first — never lose data |
| Form is too long during onboarding | Max 8 questions, one per screen, skip optional ones |

---

## Daily Use Narrative (5-step flow)

This is the ideal daily journey. Design every screen to support this flow.

```
1. Open app (morning)
   → See calorie ring, macro summary, workout card
   → One action available: "Log Meal"

2. After breakfast
   → Tap Log Meal
   → Breakfast suggestions appear (based on history)
   → Tap "[+] Dal bhat · 1 medium plate"
   → Logged in 2 taps, 4 seconds

3. Workout time
   → Home screen shows today's plan
   → Tap "Start Workout"
   → Follow exercises with timers
   → Done → see workout summary

4. After lunch and dinner
   → Same 2-tap log flow
   → Ring shows green or amber status

5. Evening check-in
   → Open app, see daily summary
   → Ring shows today's total
   → Weight log prompt (optional)
   → Close app
```

Total interactions per day: approximately 8–12 taps.

---

## Personalization Timeline

How personalization improves over time:

| Day | What the app knows | What gets personalized |
|---|---|---|
| Day 1 | Goal + activity level | Calorie target, workout plan |
| Day 7 | 7 days of meals | Breakfast suggestions, frequent foods list |
| Day 14 | Workout completion patterns | Workout duration, difficulty adjustments |
| Day 30 | Full meal and workout pattern | Meal timing suggestions, progressive overload starts |
| Day 90 | Strong behavioral model | Near-instant logging (app anticipates what you'll log) |

---

## Empty State Rules

Every empty state must have an action. Never show a blank screen with just "No data yet."

| Screen | Empty state | CTA |
|---|---|---|
| Home (no meals logged) | "You haven't logged yet today" | "Log Breakfast" |
| Progress (no weight logged) | "Add your first weight to start tracking" | "Add Weight" |
| Progress (no workouts done) | "Complete a workout to see your history" | "Start Workout" |
| Food search (no results) | "Not found. Add a custom food?" | "Add Food" |
| Workout browser (no matches) | "No plans match your filters" | "Reset Filters" |
