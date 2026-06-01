# DhalBhat Fit — Adaptive Workout Library

The workout system learns from every session. It gets more personal the more the user trains.
This document defines the exercise database, plan generation logic, adaptive rules, and unknown exercise handling.

---

## Workout Recommendation Inputs

Every workout plan is generated from this user context:

| Input | Options | Source |
|---|---|---|
| Goal | lose_fat / build_muscle / maintain | user_profiles.goal |
| Level | beginner / intermediate / advanced | user_profiles.level (derived from onboarding + history) |
| Location | home / gym / both | user_profiles.workout_pref |
| Equipment available | bodyweight / dumbbells / barbell / machines / resistance_bands / pull_up_bar | user_workout_preferences |
| Time available | 20 / 30 / 45 / 60 minutes | user_workout_preferences |
| Injury limitations | none / lower_back / knee / shoulder / wrist | user_workout_preferences |
| Training frequency | 2 / 3 / 4 / 5 days per week | user_workout_preferences |
| Disliked exercises | list of exercise_ids | user_workout_preferences |

---

## Workout Categories

| Category Key | Display Name | Primary Goal |
|---|---|---|
| `weight_loss` | Weight Loss | Calorie burn + fat loss |
| `muscle_gain` | Muscle Gain | Hypertrophy + strength |
| `strength` | Strength | Max force output |
| `endurance` | Endurance | Sustained performance |
| `mobility` | Mobility & Flexibility | Joint health, range of motion |
| `core` | Core Training | Stability, abs, lower back |
| `cardio` | Cardio | Cardiovascular fitness |
| `hiit` | HIIT | High-intensity intervals |
| `full_body` | Full Body | Balanced overall fitness |
| `upper_body` | Upper Body | Chest, back, shoulders, arms |
| `lower_body` | Lower Body | Quads, hamstrings, glutes, calves |
| `recovery` | Active Recovery | Rest day movement, stretching |

---

## Exercise Database

### Exercise Record Fields

| Field | Type | Description |
|---|---|---|
| exercise_id | UUID | Primary key |
| name | TEXT | Exercise name (e.g., "Push-up") |
| name_ne | TEXT | Nepali name if applicable |
| category | TEXT | Workout category key |
| primary_muscles | TEXT[] | Main muscles targeted |
| secondary_muscles | TEXT[] | Supporting muscles |
| equipment | TEXT[] | Required equipment ([] = bodyweight only) |
| location | TEXT | home / gym / both |
| difficulty | TEXT | beginner / intermediate / advanced |
| default_sets | INTEGER | Recommended number of sets |
| default_reps | TEXT | "8-12" or "30 seconds" or "AMRAP" |
| default_rest_seconds | INTEGER | Rest between sets |
| calories_per_minute | NUMERIC | Estimated burn rate |
| form_notes | TEXT[] | Key technique cues |
| video_url | TEXT | Demo video reference |
| gif_url | TEXT | Animated GIF for in-app display |
| home_alternative_id | UUID | Gym exercise → equivalent home version |
| progression_to_id | UUID | Next harder exercise |
| regression_from_id | UUID | Easier exercise (for beginners) |
| injury_avoid | TEXT[] | Injuries where this should be skipped |
| is_verified | BOOLEAN | Reviewed and confirmed |
| ai_confidence_base | NUMERIC | How reliably Claude identifies this movement |

---

## Exercise Seed Library

### Bodyweight / Home Exercises

| Name | Primary Muscles | Difficulty | Sets | Reps | Rest | kcal/min |
|---|---|---|---|---|---|---|
| Push-up | Chest, Triceps, Shoulders | beginner | 3 | 10-15 | 60s | 8 |
| Wide Push-up | Chest (outer) | beginner | 3 | 10-15 | 60s | 8 |
| Close-grip Push-up | Triceps | intermediate | 3 | 10-12 | 60s | 8 |
| Knee Push-up | Chest, Triceps | beginner | 3 | 12-15 | 45s | 6 |
| Bodyweight Squat | Quads, Glutes, Hamstrings | beginner | 3 | 15-20 | 60s | 6 |
| Jump Squat | Quads, Glutes, Calves | intermediate | 3 | 12-15 | 90s | 12 |
| Forward Lunge | Quads, Glutes | beginner | 3 | 10 each | 60s | 7 |
| Reverse Lunge | Quads, Glutes, Hamstrings | beginner | 3 | 10 each | 60s | 7 |
| Glute Bridge | Glutes, Hamstrings | beginner | 3 | 15-20 | 45s | 5 |
| Single-leg Glute Bridge | Glutes, Hamstrings | intermediate | 3 | 10-12 each | 60s | 5 |
| Plank | Core, Shoulders | beginner | 3 | 30-60s | 45s | 5 |
| Side Plank | Obliques, Core | beginner | 3 | 20-30s each | 45s | 5 |
| Mountain Climber | Core, Cardio | intermediate | 3 | 30-45s | 60s | 14 |
| Burpee | Full body, Cardio | intermediate | 3 | 8-12 | 90s | 15 |
| High Knees | Cardio, Quads | beginner | 3 | 30-45s | 60s | 12 |
| Jumping Jacks | Cardio, Full body | beginner | 3 | 30-45s | 45s | 10 |
| Tricep Dip (chair) | Triceps, Shoulders | beginner | 3 | 10-12 | 60s | 7 |
| Step-up (chair/stair) | Quads, Glutes | beginner | 3 | 10-12 each | 60s | 8 |
| Dead Bug | Core, Stability | beginner | 3 | 8-10 each | 45s | 4 |
| Bird Dog | Core, Back stability | beginner | 3 | 8-10 each | 45s | 4 |
| Superman | Lower back, Glutes | beginner | 3 | 10-15 | 45s | 4 |
| Crunches | Abs | beginner | 3 | 15-20 | 45s | 5 |
| Bicycle Crunch | Abs, Obliques | beginner | 3 | 15-20 | 45s | 6 |
| Leg Raise | Lower abs | intermediate | 3 | 12-15 | 60s | 5 |
| Pull-up | Back, Biceps | intermediate | 3 | 5-10 | 90s | 9 |
| Negative Pull-up | Back, Biceps | beginner | 3 | 5-8 | 90s | 7 |
| Pike Push-up | Shoulders | intermediate | 3 | 8-12 | 60s | 8 |
| Jump Rope (skipping) | Cardio, Calves | beginner | 3 | 60-90s | 60s | 13 |
| Walking | Cardio | beginner | 1 | 20-30 min | — | 5 |
| Running | Cardio | beginner | 1 | 15-30 min | — | 12 |

### Gym Exercises

| Name | Primary Muscles | Equipment | Difficulty | Sets | Reps | Rest | kcal/min |
|---|---|---|---|---|---|---|---|
| Barbell Back Squat | Quads, Glutes, Hamstrings | Barbell, Rack | intermediate | 4 | 6-10 | 120s | 8 |
| Goblet Squat | Quads, Glutes | Dumbbell | beginner | 3 | 10-12 | 90s | 7 |
| Romanian Deadlift | Hamstrings, Glutes, Back | Barbell/Dumbbells | intermediate | 3 | 8-12 | 90s | 8 |
| Conventional Deadlift | Full posterior chain | Barbell | advanced | 4 | 4-6 | 180s | 9 |
| Leg Press | Quads, Glutes | Machine | beginner | 4 | 10-15 | 90s | 7 |
| Leg Curl | Hamstrings | Machine | beginner | 3 | 10-15 | 60s | 5 |
| Leg Extension | Quads | Machine | beginner | 3 | 10-15 | 60s | 5 |
| Barbell Bench Press | Chest, Triceps, Shoulders | Barbell, Bench | intermediate | 4 | 6-10 | 120s | 8 |
| Dumbbell Bench Press | Chest, Triceps | Dumbbells, Bench | beginner | 3 | 8-12 | 90s | 7 |
| Incline Dumbbell Press | Upper chest, Shoulders | Dumbbells, Bench | intermediate | 3 | 8-12 | 90s | 7 |
| Cable Fly | Chest | Cable machine | intermediate | 3 | 12-15 | 60s | 6 |
| Barbell Overhead Press | Shoulders, Triceps | Barbell | intermediate | 4 | 6-10 | 120s | 8 |
| Dumbbell Shoulder Press | Shoulders | Dumbbells | beginner | 3 | 10-12 | 90s | 7 |
| Lateral Raise | Side deltoids | Dumbbells | beginner | 3 | 12-15 | 60s | 5 |
| Lat Pulldown | Back, Biceps | Cable machine | beginner | 3 | 10-12 | 90s | 7 |
| Seated Cable Row | Back, Biceps | Cable machine | beginner | 3 | 10-12 | 90s | 7 |
| Dumbbell Row | Back, Biceps | Dumbbell, Bench | beginner | 3 | 10-12 each | 60s | 7 |
| Barbell Row | Back, Biceps | Barbell | intermediate | 4 | 8-12 | 90s | 8 |
| Dumbbell Bicep Curl | Biceps | Dumbbells | beginner | 3 | 10-12 | 60s | 5 |
| Hammer Curl | Biceps, Brachialis | Dumbbells | beginner | 3 | 10-12 | 60s | 5 |
| Tricep Pushdown | Triceps | Cable machine | beginner | 3 | 10-15 | 60s | 5 |
| Skull Crusher | Triceps | Barbell/Dumbbells | intermediate | 3 | 10-12 | 60s | 5 |
| Calf Raise (machine) | Calves | Machine | beginner | 4 | 15-20 | 45s | 4 |
| Cable Crunch | Abs | Cable machine | beginner | 3 | 15-20 | 45s | 5 |
| Treadmill | Cardio | Treadmill | beginner | 1 | 20-40 min | — | 10 |
| Elliptical | Cardio, Full body | Elliptical | beginner | 1 | 20-30 min | — | 9 |
| Stationary Bike | Cardio, Legs | Bike | beginner | 1 | 20-30 min | — | 8 |

---

## Workout Plan Templates (Seed Plans)

### Plan 1: Home Beginner Full Body
- **Goal:** Weight loss / Maintenance
- **Days/week:** 3 (Mon / Wed / Fri)
- **Duration:** ~30 minutes
- **Equipment:** Bodyweight only

| Day | Exercises |
|---|---|
| Day 1 | Push-up × 3, Bodyweight Squat × 3, Plank × 3, High Knees × 3 |
| Day 2 | Lunge × 3, Glute Bridge × 3, Mountain Climber × 3, Jumping Jacks × 3 |
| Day 3 | Push-up × 3, Step-up × 3, Dead Bug × 3, Burpee × 2 |
| Rest days | Walking (active recovery) |

### Plan 2: Home Intermediate Full Body
- **Goal:** Weight loss + Muscle tone
- **Days/week:** 4 (Mon / Tue / Thu / Fri)
- **Duration:** ~40 minutes

| Day | Focus |
|---|---|
| Day 1 | Push-up variants + Core |
| Day 2 | Lower body + Cardio |
| Day 3 | Upper body + HIIT |
| Day 4 | Full body circuit |

### Plan 3: Gym Beginner Full Body
- **Goal:** Muscle gain
- **Days/week:** 3
- **Duration:** ~45 minutes
- **Equipment:** Dumbbells + Machines

| Day | Exercises |
|---|---|
| Day 1 | Goblet Squat, Leg Press, Dumbbell Row, Dumbbell Press, Lat Pulldown, Plank |
| Day 2 | Romanian Deadlift, Leg Curl, Dumbbell Shoulder Press, Dumbbell Curl, Tricep Pushdown |
| Day 3 | Full body repeat with weight progression |

### Plan 4: Gym Intermediate Upper/Lower Split
- **Goal:** Muscle gain
- **Days/week:** 4 (Upper / Lower / Rest / Upper / Lower)
- **Duration:** ~55 minutes

### Plan 5: Weight Loss Cardio + Strength
- **Goal:** Fat loss
- **Days/week:** 5
- **Duration:** 30–45 minutes
- **Format:** 3 strength days + 2 cardio days + active recovery

---

## Adaptive Learning Rules

### Progressive Overload Triggers

```
After every completed workout session:

IF user completed all sets at target reps for 2 consecutive sessions:
  → suggest_progression(exercise_id, user_id)
  → Progression options:
      +2 reps (if rep range)
      +5% weight (if weighted)
      -10s rest time
      advance to progression_to_id exercise

IF user failed to complete target reps for 2 consecutive sessions:
  → suggest_regression(exercise_id, user_id)
  → Regression options:
      -2 reps
      -10% weight
      +15s rest time
      switch to regression_from_id exercise
```

### Exercise Dislike Handling

```
User marks exercise as disliked:
  → add to user_workout_preferences.disliked_exercises[]
  → immediately remove from active plan
  → replace with: exercise with same primary_muscles + similar difficulty
  → never suggest this exercise again unless user resets preferences
```

### Skip Pattern Detection

```
IF same exercise skipped 3 times in a row:
  → auto-flag as likely disliked
  → prompt user: "You keep skipping [exercise]. Want to swap it?"
  → yes → treat as dislike
  → no → keep in plan, stop asking

IF user misses entire workout 3 times in a row:
  → reduce plan intensity for next session
  → send encouraging notification
  → suggest shorter 20-minute session as reentry
```

### Injury Adaptation

```
User reports injury (lower_back / knee / shoulder / wrist):
  → filter out all exercises where injury_avoid[] includes that injury
  → offer: "Here's a modified plan while you recover"
  → flag in user_workout_preferences.injury_limitations[]
  → review every 2 weeks: "How's your [injury]? Still bothering you?"
```

### Equipment Availability Shifts

```
User marks "no gym today" (or location = home):
  → for each gym exercise in today's plan:
      → find home_alternative_id
      → if no alternative: find exercise with same primary_muscles + equipment = []
  → generate modified home version of today's plan automatically
```

### Workout Frequency Adjustment

```
IF user trains 5+ days/week consistently for 4 weeks:
  → suggest upgrading to more advanced split
  → prompt: "You've been very consistent! Ready for a harder program?"

IF user trains < 2 days/week for 2+ weeks:
  → reduce plan to 2–3 days
  → simplify workouts
  → send check-in notification
```

---

## Workout Plan Generation Logic

Claude API generates or adjusts plans. The prompt structure:

```
System:
You are a fitness coach for DhalBhat Fit, a Nepali fitness app.
User profile:
  - Goal: [lose_fat / build_muscle / maintain]
  - Level: [beginner / intermediate / advanced]
  - Location: [home / gym / both]
  - Equipment: [list]
  - Days per week: [2–5]
  - Time per session: [20–60 min]
  - Injuries: [list or none]
  - Disliked exercises: [list or none]

Available exercise database: [inject exercise list matching equipment + location]

Generate a [X]-day weekly workout plan.
For each day, list: exercises, sets, reps, rest time.
Include a rest/recovery day recommendation.
Return structured JSON.
```

### Daily workout adjustment prompt

```
System:
User just completed: [yesterday's workout summary]
Performance notes: [completed sets, missed sets, weights used]
Goal: [user goal]

Suggest today's workout. Adjust difficulty based on yesterday's performance.
Return: exercise list with sets/reps/rest.
```

---

## Unknown Exercise Handling

If a user asks for or mentions an exercise not in the database:

### Step 1: Closest match search
```
User types: "I want to do a Bulgarian split squat"
        │
        ├─ Check exercises table for name match or alias match
        ├─ Not found → Claude identifies closest movement
        │       → "This is similar to Reverse Lunge (same muscles: quads, glutes)"
        │       → Show closest match + offer to proceed with it
        │
        └─ Claude also provides:
              Primary muscles: quads, glutes, hamstrings
              Equipment needed: bench or raised surface
              Difficulty: intermediate
              Estimated kcal/min: 7
```

### Step 2: Log and queue
```
If user wants to log this specific exercise (not the closest match):
  → Create entry in pending_exercises
  → Log workout session with pending_exercise reference
  → Increment log_count on pending_exercises
```

### Step 3: Promotion
```
Same thresholds as food:
  log_count ≥ 5  → flag for review
  log_count ≥ 15 → priority review
  log_count ≥ 30 → add to verified exercises
```

---

## Recovery Day Logic

```
After 2 consecutive training days:
  → Suggest recovery day: walking + stretching + mobility
  → Show specific recovery exercises: Superman, Bird Dog, Hip flexor stretch

After intense session (HIIT or heavy weights):
  → Next day: suggest mobility / lower intensity
  → "Your muscles need 24-48h to recover. Here's a light day."

After 5+ rest days with no workout:
  → Gentle reentry plan (50% normal volume)
  → "Welcome back! Let's ease in with a shorter session."
```

---

## Metrics to Track

| Metric | Why |
|---|---|
| Workout completion rate | % of sessions fully completed vs partially done |
| Exercise skip rate per exercise | Identifies unpopular exercises to remove |
| Average session duration | Are users doing full sessions? |
| Progression events | How often users are advancing |
| Injury flags | How common are injury limitations |
| Home vs gym split | How many users use home vs gym |
| Unknown exercise requests | What's missing from the library |
| Day 7 / Day 30 workout retention | Are users still active after 1 week / 1 month |
