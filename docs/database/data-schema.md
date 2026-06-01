# DhalBhat Fit — Data Schema

Backend: Supabase (PostgreSQL)
Local cache: SQLite via drift (Flutter)

---

## Naming Decisions (Reconciled)

| Our name | User plan name | Final name | Reason |
|---|---|---|---|
| `exercises` | `workouts` | `exercises` | "workouts" is ambiguous — exercises are individual movements, workout_plans are routines |
| `exercise_sets` | `workout_session_items` | `workout_session_items` | User's simpler approach is correct for MVP — per-set tracking is Phase 3 |
| `pending_foods` | `custom_foods` | `custom_foods` | More user-friendly name — same table, richer structure kept |
| `food_logs.calories` | split: `calories_estimated` + `calories_confirmed` | both fields added | Separating AI guess from user-confirmed value enables accuracy tracking |
| `ai_feedback.food_log_id` | `object_type` + `object_id` | generic pattern | Supports feedback on foods, workouts, and recommendations — not just food logs |

---

## Table Definitions

### users
Managed by Supabase Auth. Extended by user_profiles.

```sql
-- Supabase Auth handles this table automatically:
-- id (uuid), email, created_at, last_sign_in_at

-- Additional user metadata stored in auth.users.raw_user_meta_data (JSONB):
-- { "name": "...", "phone": "..." }
-- Phone is optional. Never store password_hash — Supabase Auth handles it.
```

### user_profiles
```sql
CREATE TABLE user_profiles (
  id            UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  name          TEXT,
  age           INTEGER,
  gender        TEXT CHECK (gender IN ('male', 'female', 'other')),
  height_cm     NUMERIC(5,1),
  weight_kg     NUMERIC(5,1),
  goal          TEXT CHECK (goal IN ('lose', 'maintain', 'gain')),
  activity_level TEXT CHECK (activity_level IN ('sedentary','light','moderate','active','very_active')),
  workout_pref  TEXT CHECK (workout_pref IN ('gym', 'home', 'both')),
  daily_calories INTEGER,
  target_weight_kg NUMERIC(5,1),
  food_preference TEXT DEFAULT 'non_vegetarian'
    CHECK (food_preference IN ('non_vegetarian', 'vegetarian', 'vegan')),
  city          TEXT,               -- e.g., 'Kathmandu', 'Pokhara', 'Chitwan'
  created_at    TIMESTAMPTZ DEFAULT NOW(),
  updated_at    TIMESTAMPTZ DEFAULT NOW()
);
```

### user_settings
```sql
CREATE TABLE user_settings (
  user_id       UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  language      TEXT DEFAULT 'en' CHECK (language IN ('en', 'ne')),
  units         TEXT DEFAULT 'metric' CHECK (units IN ('metric', 'imperial')),
  dark_mode     BOOLEAN DEFAULT FALSE,
  notif_enabled BOOLEAN DEFAULT TRUE,
  notif_meal_time   TIME DEFAULT '08:00',
  notif_workout_time TIME DEFAULT '07:00',
  updated_at    TIMESTAMPTZ DEFAULT NOW()
);
```

### foods
Master Nepali food database.

```sql
CREATE TABLE foods (
  id                   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name_en              TEXT NOT NULL,
  name_ne              TEXT,               -- Nepali name in Devanagari
  aliases              TEXT[],             -- alternate names (e.g., 'daal bhat', 'dal bhaat')
  category             TEXT NOT NULL,      -- dal_bhat, rice, dal, curry, meat, momo, newari, grilled, snack, fermented, fruit, drink, dairy, egg, pickle, bread
  calories_per_100g    NUMERIC(6,1),
  protein_g            NUMERIC(5,1),
  carbs_g              NUMERIC(5,1),
  fat_g                NUMERIC(5,1),
  fiber_g              NUMERIC(5,1),
  default_portion_id   UUID,               -- FK to food_portions
  image_url            TEXT,               -- Supabase Storage path: /foods/{id}/photo.jpg
  ai_confidence_base   NUMERIC(3,2),       -- 0.0–1.0: how reliably Claude Vision identifies this dish
  local_variant_notes  TEXT,               -- regional differences, ingredient variations
  is_verified          BOOLEAN DEFAULT FALSE,
  source               TEXT DEFAULT 'official' CHECK (source IN ('official', 'community', 'ai_generated')),
  is_seasonal          BOOLEAN DEFAULT FALSE,
  available_months     INTEGER[],              -- e.g., [5,6,7,8] = May–August
  created_at           TIMESTAMPTZ DEFAULT NOW()
);

-- Food categories:
-- 'dal_bhat', 'rice', 'dal', 'curry', 'meat', 'momo', 'newari', 'grilled',
-- 'snack', 'fermented', 'fruit', 'drink', 'dairy', 'egg', 'pickle', 'bread'
```

### food_portions
Multiple portion sizes per food.

```sql
CREATE TABLE food_portions (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  food_id       UUID REFERENCES foods(id) ON DELETE CASCADE,
  label         TEXT NOT NULL,       -- e.g., '1 plate', '1 cup', '1 piece'
  label_ne      TEXT,                -- Nepali portion label
  weight_g      NUMERIC(6,1) NOT NULL,
  calories      NUMERIC(6,1) NOT NULL,
  is_default    BOOLEAN DEFAULT FALSE
);
```

### meal_templates
Pre-built common Nepali meal combos for one-tap logging.

```sql
CREATE TABLE meal_templates (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name_en       TEXT NOT NULL,
  name_ne       TEXT,
  description   TEXT,
  total_calories NUMERIC(6,1),
  total_protein_g NUMERIC(5,1),
  total_carbs_g NUMERIC(5,1),
  total_fat_g   NUMERIC(5,1),
  meal_type     TEXT CHECK (meal_type IN ('breakfast','lunch','dinner','snack')),
  is_public     BOOLEAN DEFAULT TRUE
);

CREATE TABLE meal_template_items (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  template_id   UUID REFERENCES meal_templates(id) ON DELETE CASCADE,
  food_id       UUID REFERENCES foods(id),
  portion_id    UUID REFERENCES food_portions(id),
  quantity      NUMERIC(4,2) DEFAULT 1.0
);
```

### food_logs
User's daily meal entries.

```sql
CREATE TABLE food_logs (
  id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id             UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  food_id             UUID REFERENCES foods(id),
  custom_food_id      UUID REFERENCES custom_foods(id),  -- if food not in main db
  portion_id          UUID REFERENCES food_portions(id),
  quantity            NUMERIC(4,2) DEFAULT 1.0,
  calories_estimated  NUMERIC(6,1),   -- AI-estimated or database value before user review
  calories_confirmed  NUMERIC(6,1),   -- final value after user confirms/edits (use this for totals)
  protein_g           NUMERIC(5,1),
  carbs_g             NUMERIC(5,1),
  fat_g               NUMERIC(5,1),
  meal_type           TEXT CHECK (meal_type IN ('breakfast','lunch','dinner','snack')),
  logged_at           DATE NOT NULL DEFAULT CURRENT_DATE,
  logged_via          TEXT CHECK (logged_via IN ('photo','search','voice','manual','template')),
  ai_confidence       NUMERIC(3,2),   -- 0.0 to 1.0 if came from Claude Vision
  user_correction     TEXT,           -- what user changed, if anything ("changed from large to medium plate")
  created_at          TIMESTAMPTZ DEFAULT NOW()
);
```

**Note:** Always use `calories_confirmed` for daily totals and progress calculations. `calories_estimated` is the AI's initial guess — preserved for accuracy tracking in `ai_feedback`.

### workout_plans
Library of structured plans.

```sql
CREATE TABLE workout_plans (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name          TEXT NOT NULL,
  description   TEXT,
  goal          TEXT CHECK (goal IN ('lose', 'maintain', 'gain')),
  location      TEXT CHECK (location IN ('gym', 'home', 'both')),
  level         TEXT CHECK (level IN ('beginner', 'intermediate', 'advanced')),
  duration_weeks INTEGER,
  days_per_week INTEGER,
  is_active     BOOLEAN DEFAULT TRUE,
  created_at    TIMESTAMPTZ DEFAULT NOW()
);
```

### exercises
Individual exercise library.

```sql
CREATE TABLE exercises (
  id                   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name                 TEXT NOT NULL,
  name_ne              TEXT,
  category             TEXT NOT NULL,      -- workout category key
  primary_muscles      TEXT[],             -- e.g., ['chest', 'triceps']
  secondary_muscles    TEXT[],
  equipment            TEXT[],             -- [] = bodyweight only
  location             TEXT CHECK (location IN ('gym', 'home', 'both')),
  difficulty           TEXT CHECK (difficulty IN ('beginner', 'intermediate', 'advanced')),
  default_sets         INTEGER,
  default_reps         TEXT,               -- '8-12', '30 seconds', 'AMRAP'
  default_rest_seconds INTEGER,
  calories_per_minute  NUMERIC(4,1),
  form_notes           TEXT[],             -- key technique cues
  instructions         TEXT[],             -- step-by-step how-to
  video_url            TEXT,
  gif_url              TEXT,
  home_alternative_id  UUID REFERENCES exercises(id),  -- gym → home swap
  progression_to_id    UUID REFERENCES exercises(id),  -- next harder exercise
  regression_from_id   UUID REFERENCES exercises(id),  -- easier version
  injury_avoid         TEXT[],             -- e.g., ['knee', 'lower_back']
  ai_confidence_base   NUMERIC(3,2),
  is_verified          BOOLEAN DEFAULT FALSE,
  created_at           TIMESTAMPTZ DEFAULT NOW()
);
```

### workout_plan_days
Maps exercises to plans by day.

```sql
CREATE TABLE workout_plan_days (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  plan_id       UUID REFERENCES workout_plans(id) ON DELETE CASCADE,
  day_number    INTEGER NOT NULL,    -- 1, 2, 3...
  day_label     TEXT,                -- e.g., 'Push Day', 'Cardio'
  exercise_id   UUID REFERENCES exercises(id),
  sets          INTEGER,
  reps          TEXT,                -- e.g., '8-12' or '30 seconds'
  rest_seconds  INTEGER,
  order_index   INTEGER              -- display order within day
);
```

### workout_sessions
User's completed workouts.

```sql
CREATE TABLE workout_sessions (
  id                   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id              UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  plan_id              UUID REFERENCES workout_plans(id),
  session_date         DATE DEFAULT CURRENT_DATE,
  started_at           TIMESTAMPTZ,
  completed_at         TIMESTAMPTZ,
  duration_minutes     INTEGER,
  calories_burned      NUMERIC(6,1),
  exercises_completed  INTEGER,
  exercises_skipped    INTEGER DEFAULT 0,
  completion_pct       NUMERIC(4,1),  -- 0-100%: what % of the plan was done
  location             TEXT CHECK (location IN ('gym', 'home')),
  rating               INTEGER CHECK (rating BETWEEN 1 AND 5),  -- user rates session after completing
  notes                TEXT,
  created_at           TIMESTAMPTZ DEFAULT NOW()
);
```

### workout_session_items
Exercises logged within a completed workout session.

```sql
CREATE TABLE workout_session_items (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id        UUID REFERENCES workout_sessions(id) ON DELETE CASCADE,
  exercise_id       UUID REFERENCES exercises(id),
  sets_completed    INTEGER,
  reps              TEXT,                 -- '10-12' or '30 seconds' — as performed
  weight_kg         NUMERIC(5,1),         -- null for bodyweight exercises
  rest_seconds      INTEGER,
  was_skipped       BOOLEAN DEFAULT FALSE,
  notes             TEXT,
  order_index       INTEGER,              -- exercise order within session
  logged_at         TIMESTAMPTZ DEFAULT NOW()
);
```

Phase 3 enhancement: split into per-set tracking (exercise_sets table) for progressive overload precision. MVP uses session-level tracking above.

### exercise_progressions
Tracks each user's performance history per exercise for progressive overload logic.

```sql
CREATE TABLE exercise_progressions (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id           UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  exercise_id       UUID REFERENCES exercises(id),
  current_sets      INTEGER,
  current_reps      TEXT,
  current_weight_kg NUMERIC(5,1),
  consecutive_successes INTEGER DEFAULT 0,  -- sessions hitting full target
  consecutive_failures  INTEGER DEFAULT 0,
  last_session_date DATE,
  progression_suggested BOOLEAN DEFAULT FALSE,
  updated_at        TIMESTAMPTZ DEFAULT NOW()
);
```

### user_workout_preferences
User-specific workout settings and adaptive rules.

```sql
CREATE TABLE user_workout_preferences (
  user_id                 UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  equipment_available     TEXT[],             -- ['dumbbells', 'barbell', 'machines', 'pull_up_bar', 'resistance_bands']
  session_duration_mins   INTEGER DEFAULT 45,
  training_days_per_week  INTEGER DEFAULT 3,
  injury_limitations      TEXT[],             -- ['knee', 'lower_back', 'shoulder', 'wrist']
  disliked_exercises      UUID[],             -- exercise_ids to exclude from plans
  preferred_categories    TEXT[],             -- workout category keys user likes
  active_plan_id          UUID REFERENCES workout_plans(id),
  updated_at              TIMESTAMPTZ DEFAULT NOW()
);
```

### pending_exercises
User-requested or AI-suggested exercises not yet in the verified library.

```sql
CREATE TABLE pending_exercises (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  submitted_by      UUID REFERENCES auth.users(id),
  name              TEXT NOT NULL,
  category          TEXT,
  primary_muscles   TEXT[],
  equipment         TEXT[],
  location          TEXT,
  difficulty        TEXT,
  ai_closest_match  TEXT,           -- exercise Claude suggested as closest
  ai_confidence     NUMERIC(3,2),
  log_count         INTEGER DEFAULT 1,
  unique_user_count INTEGER DEFAULT 1,
  status            TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected', 'merged')),
  merged_into_id    UUID REFERENCES exercises(id),
  created_at        TIMESTAMPTZ DEFAULT NOW()
);
```

### goals
User goal history (supports goal changes over time).

```sql
CREATE TABLE goals (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  goal_type     TEXT CHECK (goal_type IN ('lose', 'maintain', 'gain')),
  start_weight_kg NUMERIC(5,1),
  target_weight_kg NUMERIC(5,1),
  daily_calorie_target INTEGER,
  started_at    DATE DEFAULT CURRENT_DATE,
  ended_at      DATE,
  is_active     BOOLEAN DEFAULT TRUE
);
```

### weight_logs
Daily weight check-ins.

```sql
CREATE TABLE weight_logs (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  weight_kg     NUMERIC(5,1) NOT NULL,
  logged_at     DATE NOT NULL DEFAULT CURRENT_DATE,
  notes         TEXT,
  created_at    TIMESTAMPTZ DEFAULT NOW()
);
```

### recommendations
AI-generated daily suggestions.

```sql
CREATE TABLE recommendations (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id           UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  type              TEXT CHECK (type IN ('meal','workout','tip','adjustment')),
  meal_type         TEXT CHECK (meal_type IN ('breakfast','lunch','dinner','snack')),
  content           TEXT NOT NULL,
  context           JSONB,                -- snapshot of user state when generated
  related_food_id   UUID REFERENCES foods(id),
  related_plan_id   UUID REFERENCES workout_plans(id),
  generated_at      TIMESTAMPTZ DEFAULT NOW(),
  was_useful        BOOLEAN,              -- thumbs up/down
  was_followed      BOOLEAN,             -- did user actually log this food/workout?
  feedback_reason   TEXT                 -- why thumbs down: wrong_food, not_hungry, etc.
);
```

### custom_foods
User-submitted or AI-guessed foods not yet in the verified database.
Formerly referenced as `pending_foods` in adaptive-intelligence.md — same table, renamed for clarity.
See `docs/adaptive-intelligence.md` for full lifecycle flow.

```sql
CREATE TABLE custom_foods (
  id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  submitted_by        UUID REFERENCES auth.users(id),
  name_en             TEXT NOT NULL,        -- user's typed food name
  name_ne             TEXT,
  category            TEXT,
  ingredients_guess   TEXT[],               -- Claude's detected ingredient clues
  ai_closest_match    TEXT,                 -- closest verified food Claude suggested
  ai_confidence       NUMERIC(3,2),
  estimated_calories_per_100g NUMERIC(6,1), -- AI-estimated
  estimated_protein_g NUMERIC(5,1),
  estimated_carbs_g   NUMERIC(5,1),
  estimated_fat_g     NUMERIC(5,1),
  suggested_calories  NUMERIC(6,1),         -- calories for the default portion (user-facing display)
  image_url           TEXT,                 -- Supabase Storage path
  log_count           INTEGER DEFAULT 1,    -- times this custom food has been logged
  unique_user_count   INTEGER DEFAULT 1,    -- distinct users who logged it
  average_calories    NUMERIC(6,1),         -- running average across all logs
  status              TEXT DEFAULT 'pending'
    CHECK (status IN ('pending', 'community', 'rejected', 'merged')),
  merged_into_food_id UUID REFERENCES foods(id),  -- if promoted to verified
  reviewed_at         TIMESTAMPTZ,
  created_at          TIMESTAMPTZ DEFAULT NOW()
);
```

### user_favorites
User-pinned foods and meal templates for instant re-logging. Phase 2 feature.

```sql
CREATE TABLE user_favorites (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  type        TEXT CHECK (type IN ('food', 'meal_template')),
  food_id     UUID REFERENCES foods(id),
  template_id UUID REFERENCES meal_templates(id),
  label       TEXT,           -- optional user-given name: "My usual lunch"
  created_at  TIMESTAMPTZ DEFAULT NOW(),
  CONSTRAINT only_one_target CHECK (
    (food_id IS NOT NULL AND template_id IS NULL) OR
    (food_id IS NULL AND template_id IS NOT NULL)
  )
);
```

### calorie_adjustments
History of when and why the user's daily calorie target was changed.

```sql
CREATE TABLE calorie_adjustments (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id           UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  previous_target   INTEGER NOT NULL,
  new_target        INTEGER NOT NULL,
  reason            TEXT CHECK (reason IN ('too_slow','too_fast','plateau','goal_change','manual')),
  weekly_change_kg  NUMERIC(4,2),
  applied_at        TIMESTAMPTZ DEFAULT NOW()
);
```

### ai_feedback
User corrections and signals that help the AI improve over time.
Uses a generic polymorphic pattern so it can capture feedback on foods, workouts, and recommendations.

```sql
CREATE TABLE ai_feedback (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  object_type     TEXT CHECK (object_type IN ('food_log', 'workout_session', 'recommendation', 'custom_food')),
  object_id       UUID NOT NULL,             -- ID in the referenced table
  feedback_type   TEXT CHECK (feedback_type IN (
                    'wrong_food',
                    'wrong_portion',
                    'wrong_calories',
                    'bad_recommendation',
                    'irrelevant_workout',
                    'other'
                  )),
  ai_identified   TEXT,                      -- what AI guessed
  user_corrected  TEXT,                      -- what user said it actually was
  ai_value        NUMERIC(6,1),              -- AI's numeric estimate (calories, etc.)
  user_value      NUMERIC(6,1),              -- user's corrected numeric value
  feedback_text   TEXT,                      -- optional free-text explanation
  created_at      TIMESTAMPTZ DEFAULT NOW()
);
```

---

## Indexes (Performance)

```sql
-- Most frequent queries
CREATE INDEX idx_food_logs_user_date ON food_logs(user_id, logged_at);
CREATE INDEX idx_weight_logs_user_date ON weight_logs(user_id, logged_at);
CREATE INDEX idx_workout_sessions_user ON workout_sessions(user_id, created_at);
CREATE INDEX idx_foods_category ON foods(category);
CREATE INDEX idx_foods_name_search ON foods USING gin(to_tsvector('simple', name_en || ' ' || COALESCE(name_ne, '')));
CREATE INDEX idx_custom_foods_status ON custom_foods(status);
CREATE INDEX idx_custom_foods_log_count ON custom_foods(log_count DESC);
CREATE INDEX idx_food_logs_food_id ON food_logs(food_id);
CREATE INDEX idx_food_logs_custom_food_id ON food_logs(custom_food_id);
CREATE INDEX idx_workout_session_items_session ON workout_session_items(session_id);
CREATE INDEX idx_ai_feedback_object ON ai_feedback(object_type, object_id);
```

---

## Row Level Security (RLS)

All user-specific tables must have RLS enabled:

```sql
-- Pattern for all user tables
ALTER TABLE food_logs ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can only access own data"
  ON food_logs FOR ALL
  USING (auth.uid() = user_id);

-- Apply same pattern to:
-- user_profiles, user_settings, goals, weight_logs,
-- workout_sessions, workout_session_items, recommendations,
-- ai_feedback, custom_foods, calorie_adjustments
```

---

## Local SQLite Tables (drift — offline cache)

Mirrors the critical Supabase tables for offline functionality:

- `local_foods` — cached food database (sync on app start)
- `local_food_logs` — pending logs (sync when online)
- `local_weight_logs` — pending weight entries
- `local_workout_sessions` — pending workout completions
- `sync_queue` — tracks unsynced records (id, table_name, operation, payload, created_at)

Sync strategy: write locally first → sync to Supabase when connection available → resolve conflicts by timestamp (last write wins for user data).
