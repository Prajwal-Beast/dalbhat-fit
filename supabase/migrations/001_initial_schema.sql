-- ============================================================
-- DhalBhat Fit — Initial Schema
-- Migration: 001_initial_schema.sql
-- Apply in Supabase: SQL Editor → paste this entire file → Run
-- ============================================================

-- ── user_profiles ─────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS public.user_profiles (
  id                UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  name              TEXT,
  age               INTEGER,
  gender            TEXT CHECK (gender IN ('male', 'female', 'other')),
  height_cm         NUMERIC(5,1),
  weight_kg         NUMERIC(5,1),
  goal              TEXT CHECK (goal IN ('lose', 'maintain', 'gain')),
  activity_level    TEXT CHECK (activity_level IN ('sedentary','light','moderate','active','very_active')),
  workout_pref      TEXT CHECK (workout_pref IN ('gym', 'home', 'both')),
  daily_calories    INTEGER,
  target_weight_kg  NUMERIC(5,1),
  food_preference   TEXT DEFAULT 'non_vegetarian'
    CHECK (food_preference IN ('non_vegetarian', 'vegetarian', 'vegan')),
  city              TEXT,
  created_at        TIMESTAMPTZ DEFAULT NOW(),
  updated_at        TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "user_profiles: own rows only"
  ON public.user_profiles FOR ALL
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- ── user_settings ─────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS public.user_settings (
  user_id             UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  language            TEXT DEFAULT 'en' CHECK (language IN ('en', 'ne')),
  units               TEXT DEFAULT 'metric' CHECK (units IN ('metric', 'imperial')),
  dark_mode           BOOLEAN DEFAULT FALSE,
  notif_enabled       BOOLEAN DEFAULT TRUE,
  notif_meal_time     TIME DEFAULT '08:00',
  notif_workout_time  TIME DEFAULT '07:00',
  updated_at          TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.user_settings ENABLE ROW LEVEL SECURITY;
CREATE POLICY "user_settings: own rows only"
  ON public.user_settings FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- ── user_workout_preferences ──────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS public.user_workout_preferences (
  user_id                UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  equipment_available    TEXT[] DEFAULT '{}',
  session_duration_mins  INTEGER DEFAULT 45,
  training_days_per_week INTEGER DEFAULT 3,
  injury_limitations     TEXT[] DEFAULT '{}',
  disliked_exercises     UUID[] DEFAULT '{}',
  preferred_categories   TEXT[] DEFAULT '{}',
  active_plan_id         UUID,
  updated_at             TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.user_workout_preferences ENABLE ROW LEVEL SECURITY;
CREATE POLICY "user_workout_preferences: own rows only"
  ON public.user_workout_preferences FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- ── goals ─────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS public.goals (
  id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id               UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  goal_type             TEXT CHECK (goal_type IN ('lose', 'maintain', 'gain')),
  start_weight_kg       NUMERIC(5,1),
  target_weight_kg      NUMERIC(5,1),
  daily_calorie_target  INTEGER,
  started_at            DATE DEFAULT CURRENT_DATE,
  ended_at              DATE,
  is_active             BOOLEAN DEFAULT TRUE
);

ALTER TABLE public.goals ENABLE ROW LEVEL SECURITY;
CREATE POLICY "goals: own rows only"
  ON public.goals FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- ── foods (public read) ───────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS public.foods (
  id                   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name_en              TEXT NOT NULL,
  name_ne              TEXT,
  aliases              TEXT[] DEFAULT '{}',
  category             TEXT NOT NULL,
  calories_per_100g    NUMERIC(6,1),
  protein_g            NUMERIC(5,1),
  carbs_g              NUMERIC(5,1),
  fat_g                NUMERIC(5,1),
  fiber_g              NUMERIC(5,1),
  default_portion_id   UUID,
  image_url            TEXT,
  ai_confidence_base   NUMERIC(3,2) DEFAULT 0.70,
  local_variant_notes  TEXT,
  is_verified          BOOLEAN DEFAULT FALSE,
  source               TEXT DEFAULT 'official'
    CHECK (source IN ('official', 'community', 'ai_generated')),
  is_seasonal          BOOLEAN DEFAULT FALSE,
  available_months     INTEGER[] DEFAULT '{}',
  created_at           TIMESTAMPTZ DEFAULT NOW()
);

-- Foods are public: everyone can read, only admins write (via service role)
ALTER TABLE public.foods ENABLE ROW LEVEL SECURITY;
CREATE POLICY "foods: public read"
  ON public.foods FOR SELECT
  USING (true);

-- ── food_portions ─────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS public.food_portions (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  food_id     UUID REFERENCES public.foods(id) ON DELETE CASCADE,
  label       TEXT NOT NULL,
  label_ne    TEXT,
  weight_g    NUMERIC(6,1) NOT NULL,
  calories    NUMERIC(6,1) NOT NULL,
  is_default  BOOLEAN DEFAULT FALSE
);

ALTER TABLE public.food_portions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "food_portions: public read"
  ON public.food_portions FOR SELECT
  USING (true);

-- ── meal_templates ────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS public.meal_templates (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name_en          TEXT NOT NULL,
  name_ne          TEXT,
  description      TEXT,
  total_calories   NUMERIC(6,1),
  total_protein_g  NUMERIC(5,1),
  total_carbs_g    NUMERIC(5,1),
  total_fat_g      NUMERIC(5,1),
  meal_type        TEXT CHECK (meal_type IN ('breakfast','lunch','dinner','snack')),
  is_public        BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS public.meal_template_items (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  template_id  UUID REFERENCES public.meal_templates(id) ON DELETE CASCADE,
  food_id      UUID REFERENCES public.foods(id),
  portion_id   UUID REFERENCES public.food_portions(id),
  quantity     NUMERIC(4,2) DEFAULT 1.0
);

ALTER TABLE public.meal_templates ENABLE ROW LEVEL SECURITY;
CREATE POLICY "meal_templates: public read"
  ON public.meal_templates FOR SELECT
  USING (is_public = true);

ALTER TABLE public.meal_template_items ENABLE ROW LEVEL SECURITY;
CREATE POLICY "meal_template_items: public read"
  ON public.meal_template_items FOR SELECT
  USING (true);

-- ── food_logs ─────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS public.food_logs (
  id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id             UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  food_id             UUID REFERENCES public.foods(id),
  custom_food_id      UUID,
  portion_id          UUID REFERENCES public.food_portions(id),
  quantity            NUMERIC(4,2) DEFAULT 1.0,
  calories_estimated  NUMERIC(6,1),
  calories_confirmed  NUMERIC(6,1),
  protein_g           NUMERIC(5,1),
  carbs_g             NUMERIC(5,1),
  fat_g               NUMERIC(5,1),
  meal_type           TEXT CHECK (meal_type IN ('breakfast','lunch','dinner','snack')),
  logged_at           DATE NOT NULL DEFAULT CURRENT_DATE,
  logged_via          TEXT CHECK (logged_via IN ('photo','search','voice','manual','template')),
  ai_confidence       NUMERIC(3,2),
  user_correction     TEXT,
  created_at          TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.food_logs ENABLE ROW LEVEL SECURITY;
CREATE POLICY "food_logs: own rows only"
  ON public.food_logs FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE INDEX IF NOT EXISTS idx_food_logs_user_date ON public.food_logs(user_id, logged_at);
CREATE INDEX IF NOT EXISTS idx_food_logs_food_id ON public.food_logs(food_id);

-- ── weight_logs ───────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS public.weight_logs (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  weight_kg   NUMERIC(5,1) NOT NULL,
  logged_at   DATE NOT NULL DEFAULT CURRENT_DATE,
  notes       TEXT,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.weight_logs ENABLE ROW LEVEL SECURITY;
CREATE POLICY "weight_logs: own rows only"
  ON public.weight_logs FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE INDEX IF NOT EXISTS idx_weight_logs_user_date ON public.weight_logs(user_id, logged_at);

-- ── exercises (public read) ───────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS public.exercises (
  id                   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name                 TEXT NOT NULL,
  name_ne              TEXT,
  category             TEXT NOT NULL,
  primary_muscles      TEXT[] DEFAULT '{}',
  secondary_muscles    TEXT[] DEFAULT '{}',
  equipment            TEXT[] DEFAULT '{}',
  location             TEXT CHECK (location IN ('gym', 'home', 'both')),
  difficulty           TEXT CHECK (difficulty IN ('beginner', 'intermediate', 'advanced')),
  default_sets         INTEGER,
  default_reps         TEXT,
  default_rest_seconds INTEGER,
  calories_per_minute  NUMERIC(4,1),
  form_notes           TEXT[] DEFAULT '{}',
  instructions         TEXT[] DEFAULT '{}',
  video_url            TEXT,
  gif_url              TEXT,
  home_alternative_id  UUID REFERENCES public.exercises(id),
  progression_to_id    UUID REFERENCES public.exercises(id),
  regression_from_id   UUID REFERENCES public.exercises(id),
  injury_avoid         TEXT[] DEFAULT '{}',
  ai_confidence_base   NUMERIC(3,2) DEFAULT 0.80,
  is_verified          BOOLEAN DEFAULT FALSE,
  created_at           TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.exercises ENABLE ROW LEVEL SECURITY;
CREATE POLICY "exercises: public read"
  ON public.exercises FOR SELECT
  USING (true);

-- ── workout_plans (public read) ───────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS public.workout_plans (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name            TEXT NOT NULL,
  description     TEXT,
  goal            TEXT CHECK (goal IN ('lose', 'maintain', 'gain')),
  location        TEXT CHECK (location IN ('gym', 'home', 'both')),
  level           TEXT CHECK (level IN ('beginner', 'intermediate', 'advanced')),
  duration_weeks  INTEGER,
  days_per_week   INTEGER,
  is_active       BOOLEAN DEFAULT TRUE,
  created_at      TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.workout_plans ENABLE ROW LEVEL SECURITY;
CREATE POLICY "workout_plans: public read"
  ON public.workout_plans FOR SELECT
  USING (is_active = true);

-- ── workout_plan_days ─────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS public.workout_plan_days (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  plan_id       UUID REFERENCES public.workout_plans(id) ON DELETE CASCADE,
  day_number    INTEGER NOT NULL,
  day_label     TEXT,
  exercise_id   UUID REFERENCES public.exercises(id),
  sets          INTEGER,
  reps          TEXT,
  rest_seconds  INTEGER,
  order_index   INTEGER
);

ALTER TABLE public.workout_plan_days ENABLE ROW LEVEL SECURITY;
CREATE POLICY "workout_plan_days: public read"
  ON public.workout_plan_days FOR SELECT
  USING (true);

-- ── workout_sessions ─────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS public.workout_sessions (
  id                   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id              UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  plan_id              UUID REFERENCES public.workout_plans(id),
  session_date         DATE DEFAULT CURRENT_DATE,
  started_at           TIMESTAMPTZ,
  completed_at         TIMESTAMPTZ,
  duration_minutes     INTEGER,
  calories_burned      NUMERIC(6,1),
  exercises_completed  INTEGER,
  exercises_skipped    INTEGER DEFAULT 0,
  completion_pct       NUMERIC(4,1),
  location             TEXT CHECK (location IN ('gym', 'home')),
  rating               INTEGER CHECK (rating BETWEEN 1 AND 5),
  notes                TEXT,
  created_at           TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.workout_sessions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "workout_sessions: own rows only"
  ON public.workout_sessions FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE INDEX IF NOT EXISTS idx_workout_sessions_user ON public.workout_sessions(user_id, created_at);

-- ── workout_session_items ─────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS public.workout_session_items (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id        UUID REFERENCES public.workout_sessions(id) ON DELETE CASCADE,
  exercise_id       UUID REFERENCES public.exercises(id),
  sets_completed    INTEGER,
  reps              TEXT,
  weight_kg         NUMERIC(5,1),
  rest_seconds      INTEGER,
  was_skipped       BOOLEAN DEFAULT FALSE,
  notes             TEXT,
  order_index       INTEGER,
  logged_at         TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.workout_session_items ENABLE ROW LEVEL SECURITY;
CREATE POLICY "workout_session_items: own rows only"
  ON public.workout_session_items FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM public.workout_sessions ws
      WHERE ws.id = session_id AND ws.user_id = auth.uid()
    )
  );

CREATE INDEX IF NOT EXISTS idx_workout_session_items_session ON public.workout_session_items(session_id);

-- ── ai_feedback ───────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS public.ai_feedback (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  object_type     TEXT CHECK (object_type IN ('food_log','workout_session','recommendation','custom_food')),
  object_id       UUID NOT NULL,
  feedback_type   TEXT CHECK (feedback_type IN (
                    'wrong_food','wrong_portion','wrong_calories',
                    'bad_recommendation','irrelevant_workout','other')),
  ai_identified   TEXT,
  user_corrected  TEXT,
  ai_value        NUMERIC(6,1),
  user_value      NUMERIC(6,1),
  feedback_text   TEXT,
  created_at      TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.ai_feedback ENABLE ROW LEVEL SECURITY;
CREATE POLICY "ai_feedback: own rows only"
  ON public.ai_feedback FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE INDEX IF NOT EXISTS idx_ai_feedback_object ON public.ai_feedback(object_type, object_id);

-- ── custom_foods ─────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS public.custom_foods (
  id                          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  submitted_by                UUID REFERENCES auth.users(id),
  name_en                     TEXT NOT NULL,
  name_ne                     TEXT,
  category                    TEXT,
  ingredients_guess           TEXT[] DEFAULT '{}',
  ai_closest_match            TEXT,
  ai_confidence               NUMERIC(3,2),
  estimated_calories_per_100g NUMERIC(6,1),
  estimated_protein_g         NUMERIC(5,1),
  estimated_carbs_g           NUMERIC(5,1),
  estimated_fat_g             NUMERIC(5,1),
  suggested_calories          NUMERIC(6,1),
  image_url                   TEXT,
  log_count                   INTEGER DEFAULT 1,
  unique_user_count           INTEGER DEFAULT 1,
  average_calories            NUMERIC(6,1),
  status                      TEXT DEFAULT 'pending'
    CHECK (status IN ('pending','community','rejected','merged')),
  merged_into_food_id         UUID REFERENCES public.foods(id),
  reviewed_at                 TIMESTAMPTZ,
  created_at                  TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.custom_foods ENABLE ROW LEVEL SECURITY;
CREATE POLICY "custom_foods: own + community read"
  ON public.custom_foods FOR SELECT
  USING (submitted_by = auth.uid() OR status = 'community');
CREATE POLICY "custom_foods: own insert"
  ON public.custom_foods FOR INSERT
  WITH CHECK (submitted_by = auth.uid());

-- ── calorie_adjustments ──────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS public.calorie_adjustments (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id          UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  previous_target  INTEGER NOT NULL,
  new_target       INTEGER NOT NULL,
  reason           TEXT CHECK (reason IN ('too_slow','too_fast','plateau','goal_change','manual')),
  weekly_change_kg NUMERIC(4,2),
  applied_at       TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.calorie_adjustments ENABLE ROW LEVEL SECURITY;
CREATE POLICY "calorie_adjustments: own rows only"
  ON public.calorie_adjustments FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- ── user_favorites ────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS public.user_favorites (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id      UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  type         TEXT CHECK (type IN ('food','meal_template')),
  food_id      UUID REFERENCES public.foods(id),
  template_id  UUID REFERENCES public.meal_templates(id),
  label        TEXT,
  created_at   TIMESTAMPTZ DEFAULT NOW(),
  CONSTRAINT only_one_target CHECK (
    (food_id IS NOT NULL AND template_id IS NULL) OR
    (food_id IS NULL AND template_id IS NOT NULL)
  )
);

ALTER TABLE public.user_favorites ENABLE ROW LEVEL SECURITY;
CREATE POLICY "user_favorites: own rows only"
  ON public.user_favorites FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- ── Remaining indexes ─────────────────────────────────────────────────────────

CREATE INDEX IF NOT EXISTS idx_foods_category ON public.foods(category);
CREATE INDEX IF NOT EXISTS idx_foods_name_search
  ON public.foods USING gin(to_tsvector('simple', name_en || ' ' || COALESCE(name_ne, '')));
CREATE INDEX IF NOT EXISTS idx_custom_foods_status ON public.custom_foods(status);
CREATE INDEX IF NOT EXISTS idx_custom_foods_log_count ON public.custom_foods(log_count DESC);

-- ── Updated-at trigger (reusable) ────────────────────────────────────────────

CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_user_profiles_updated_at
  BEFORE UPDATE ON public.user_profiles
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER trg_user_settings_updated_at
  BEFORE UPDATE ON public.user_settings
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER trg_user_workout_preferences_updated_at
  BEFORE UPDATE ON public.user_workout_preferences
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
