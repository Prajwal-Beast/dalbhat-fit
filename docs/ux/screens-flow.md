# DhalBhat Fit — Screens & User Flow

---

## Navigation Architecture

**Model:** Bottom Tab Bar (5 tabs)

```
Tab 1: Home        (dashboard icon)
Tab 2: Log         (plus/food icon)
Tab 3: Workout     (dumbbell icon)
Tab 4: Progress    (chart icon)
Tab 5: Profile     (person icon)
```

Pre-auth screens (Splash → Welcome → Auth → Onboarding) live outside the tab structure.

---

## User Flow — First Time

```
Splash
  └─ Welcome
       └─ Sign Up
            └─ Onboarding (multi-step)
                 └─ Calorie Goal Summary
                      └─ Home Dashboard [Tab 1]
```

## User Flow — Returning User

```
Splash
  └─ Sign In
       └─ Home Dashboard [Tab 1]
```

## User Flow — Guest (skip auth)

```
Splash
  └─ Welcome
       └─ Skip (local-only mode)
            └─ Onboarding
                 └─ Home Dashboard [Tab 1] (data stored locally)
```

---

## Screen Specs

### 1. Splash Screen
- App logo centered
- Short fade-in animation (max 1.5 seconds)
- Tagline: "Built for dal bhat and daily fitness"
- No user action required — auto-advances

### 2. Welcome Screen
- Headline: "Fitness built for Nepali life"
- 3 short feature bullets with icons:
  - Track your dal bhat and local meals
  - Get workouts matched to your goal
  - Built for Nepal, priced for Nepal
- Primary CTA: Get Started
- Secondary CTA: Sign In (already have account)

### 3. Sign Up / Sign In Screen
- Email + password sign up
- Google Sign In (OAuth)
- Facebook Sign In (OAuth)
- Toggle between Sign Up and Sign In
- Forgot password link
- No phone OTP in MVP (add in v2)

### 4. Onboarding (multi-step, 8 steps)
Each step is one question, full screen, progress indicator at top.

| Step | Question | Input type |
|---|---|---|
| 1 | What's your name? | Text field |
| 2 | How old are you? | Number picker |
| 3 | What's your gender? | Option select (Male / Female / Other) |
| 4 | How tall are you? | Number input (cm or ft/in toggle) |
| 5 | How much do you weigh? | Number input (kg or lbs toggle) |
| 6 | What's your main goal? | Option select (Lose weight / Build muscle / Stay healthy) |
| 7 | How active are you? | Option select (Sedentary / Light / Moderate / Active / Very active) |
| 8 | Do you prefer gym or home workouts? | Option select (Gym / Home / Both) |

Language preference: offered at end of onboarding or in Settings — do not interrupt flow.

### 5. Calorie Goal Summary Screen
Shown once after onboarding completes.

Display:
- Daily calorie target (large number, prominent)
- Goal type (e.g., "Weight Loss at 0.5 kg/week pace")
- Macro split: Carbs / Protein / Fat (grams + percentages)
- BMI indicator (using Asian BMI cutoffs)
- Estimated weeks to goal weight

CTA: Start Tracking

### 6. Home Dashboard [Tab 1]
**Above the fold (always visible without scroll):**
- Greeting: "Good morning, [Name]"
- Calorie ring: consumed vs target (circular progress)
- Quick macro summary: C [g] · P [g] · F [g]
- Log Meal button (prominent CTA)

**Below the fold (scrollable):**
- Water intake tracker (tap to add glasses)
- Today's workout card (goal-matched suggestion + Start button)
- Weight trend mini-graph (last 7 days)
- "Meals today" summary (breakfast/lunch/dinner chips)

### 7. Meal Log Screen [Tab 2]
Three input methods presented as tabs or cards:

**Photo tab (primary):**
- Camera open by default
- Upload from gallery option
- After capture: AI processes → auto-fills Food Detail screen

**Search tab:**
- Search bar (English + Nepali text)
- Recent foods list
- Frequent foods list
- Meal template shortcuts (e.g., "Standard Dal Bhat Thali" → one tap log)

**Manual tab:**
- Browse by category (Dal Bhat / Meat / Snacks / Fruits / Drinks / Other)
- Each item shows name + calories per portion

Meal slot selector at top: Breakfast / Lunch / Dinner / Snack

### 8. Food Search Results Screen
- Search bar remains active at top
- Results list: food name + kcal per 100g + category tag
- Tap to open Food Detail
- No result found → "Add custom food" option

### 9. Food Detail Screen
Display:
- Food name (English + Nepali alias)
- Calorie estimate (large)
- Macro breakdown: Protein / Carbs / Fat / Fiber (grams)
- Portion size selector (Small / Medium / Large / Custom weight)
- Serving description (e.g., "1 plate = 700 kcal")
- Photo (if available)
- AI confidence indicator (if came from photo scan)

Actions:
- Save to log (primary CTA)
- Edit portion (adjust grams/quantity)
- Quick Add (one-tap for repeat meals, skips this screen next time)
- Flag as wrong (sends to ai_feedback table)

### 10. Workout Browser [Tab 3]
Top filters:
- Goal: Lose / Gain / Maintain
- Location: Gym / Home
- Level: Beginner / Intermediate / Advanced

Workout plan cards:
- Plan name
- Duration (e.g., "4 weeks")
- Days per week
- Difficulty tag
- Short description

Tap → opens plan detail with full exercise list.

### 11. Exercise Detail Screen
- Exercise name
- Muscle group tags
- Video or animated GIF demonstration
- Step-by-step instructions (3-5 steps)
- Sets / Reps / Rest recommendation
- Beginner modification (if applicable)
- Add to custom plan option (v2)

### 12. Active Workout Session Screen
Full-screen workout mode.

Display:
- Current exercise name + muscle group
- Animation / video
- Rep counter (tap to count or manual entry)
- Set progress (e.g., Set 2 of 4)
- Rest timer (countdown between sets)
- Next exercise preview
- Pause / Stop session

Navigation:
- Skip exercise
- Previous / Next exercise
- End session early

### 13. Workout Complete Screen
- Celebration animation (confetti or checkmark)
- Summary: exercises completed, total time, estimated calories burned
- Streak indicator (e.g., "3 days in a row!")
- CTA: Log next meal / Back to home

### 14. Progress Screen [Tab 4]
Sections:
- **Weight trend:** line graph (7 days / 30 days / 90 days toggle)
- **Calorie history:** bar chart (daily intake vs target, last 7 days)
- **Workout consistency:** calendar heatmap (workout days marked)
- **Goal progress:** progress bar to target weight

All data sourced from `weight_logs`, `food_logs`, `workout_sessions`.

### 15. Profile + Settings [Tab 5]
**Profile section:**
- Avatar / name / goal summary
- Edit profile (re-opens onboarding fields)
- Change goal

**Settings section:**
- Language: English / Nepali
- Units: kg + cm / lbs + ft
- Notifications: on/off + time preferences
- Dark mode toggle
- Privacy settings
- Subscription status + Upgrade CTA
- Sign out
- Delete account

---

## Key UX Principles for Development

1. **Log Meal CTA always visible** — most-used action, never buried
2. **Home dashboard above-fold is complete without scrolling** — calorie ring + macros + log button
3. **Photo → result in under 5 seconds** — Claude Vision API call must feel instant
4. **Meal templates = one-tap logging** — for common meals like dal bhat, reduce daily friction
5. **Offline always works** — food logging, workout session, and progress reading must work without internet
6. **No dead ends** — every empty state has a CTA (first log, first workout, first weight entry)
