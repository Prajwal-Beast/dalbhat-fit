-- ============================================================
-- DhalBhat Fit — Seed Data: Exercise Library + Workout Plans
-- Migration: 003_seed_workouts.sql
-- ============================================================

-- ── Exercises ────────────────────────────────────────────────────────────────

INSERT INTO public.exercises
  (name, category, primary_muscles, equipment, location, difficulty,
   default_sets, default_reps, default_rest_seconds, calories_per_minute,
   instructions, form_notes, is_verified)
VALUES
  -- Bodyweight / Home
  ('Push-ups',         'chest',    ARRAY['chest','triceps','shoulders'], ARRAY[]::TEXT[], 'home', 'beginner',
   3, '10-15', 60, 7.0,
   ARRAY['Start in a high plank position','Lower your chest to the floor','Push back up explosively','Keep your core braced throughout'],
   ARRAY['Elbows at 45° — not flared out','Full range of motion — chest touches floor','Do not let hips sag'], true),

  ('Squats',           'legs',     ARRAY['quads','glutes','hamstrings'], ARRAY[]::TEXT[], 'home', 'beginner',
   3, '12-20', 60, 6.5,
   ARRAY['Stand feet shoulder-width apart','Push hips back and bend knees','Descend until thighs are parallel','Drive through heels to stand'],
   ARRAY['Keep chest up and spine neutral','Knees track over toes','Push hips back first, not knees forward'], true),

  ('Plank',            'core',     ARRAY['core','shoulders'], ARRAY[]::TEXT[], 'home', 'beginner',
   3, '30-60 sec', 45, 4.0,
   ARRAY['Start in a forearm position','Keep body in a straight line from head to heels','Breathe steadily and hold'],
   ARRAY['Do not let hips rise or sag','Squeeze glutes and abs throughout','Look at the floor, not ahead'], true),

  ('Lunges',           'legs',     ARRAY['quads','glutes','hamstrings'], ARRAY[]::TEXT[], 'home', 'beginner',
   3, '10 each leg', 60, 6.0,
   ARRAY['Step one foot forward','Lower back knee toward the floor','Front thigh should be parallel to ground','Push through front heel to return'],
   ARRAY['Keep torso upright','Front knee should not pass toes','Step far enough for 90° angles'], true),

  ('Burpees',          'full_body',ARRAY['full body'], ARRAY[]::TEXT[], 'home', 'intermediate',
   3, '8-12', 90, 10.0,
   ARRAY['Start standing','Drop hands to floor and jump feet back to plank','Do a push-up','Jump feet to hands','Jump up with arms overhead'],
   ARRAY['Move quickly but maintain form','Land softly on each jump','Modify by stepping instead of jumping if needed'], true),

  ('Mountain Climbers','core',     ARRAY['core','hip flexors','shoulders'], ARRAY[]::TEXT[], 'home', 'intermediate',
   3, '20 each side', 45, 9.0,
   ARRAY['Start in a high plank','Drive right knee to chest','Return and drive left knee','Alternate rapidly'],
   ARRAY['Keep hips level','Do not bounce hips up and down','Keep arms straight and shoulders over wrists'], true),

  ('Glute Bridges',    'glutes',   ARRAY['glutes','hamstrings','core'], ARRAY[]::TEXT[], 'home', 'beginner',
   3, '15-20', 45, 4.5,
   ARRAY['Lie on your back, knees bent','Press feet into floor and lift hips up','Squeeze glutes at the top','Lower slowly'],
   ARRAY['Feet flat on the floor, hip-width apart','Do not arch the lower back at the top','Hold for 1-2 seconds at the top'], true),

  ('Tricep Dips (chair)','triceps', ARRAY['triceps','chest','shoulders'], ARRAY['chair']::TEXT[], 'home', 'beginner',
   3, '10-15', 60, 5.5,
   ARRAY['Place hands on edge of chair behind you','Slide hips off the edge','Lower body by bending elbows','Push back up to start'],
   ARRAY['Keep back close to chair','Do not flare elbows outward','Keep core engaged'], true),

  ('Jump Squats',      'legs',     ARRAY['quads','glutes','calves'], ARRAY[]::TEXT[], 'home', 'intermediate',
   3, '10-15', 75, 9.0,
   ARRAY['Perform a regular squat','Explosively jump as you reach the top','Land softly with bent knees','Go immediately into next rep'],
   ARRAY['Land toe-to-heel, not flat-footed','Control the landing — absorb the impact','Avoid on hard surfaces'], true),

  ('Superman Hold',    'back',     ARRAY['lower back','glutes','hamstrings'], ARRAY[]::TEXT[], 'home', 'beginner',
   3, '10-15', 45, 3.5,
   ARRAY['Lie face down, arms extended overhead','Lift arms, chest, and legs off the floor simultaneously','Hold for 2 seconds','Lower with control'],
   ARRAY['Keep neck neutral — do not crane upward','Squeeze glutes as you hold','Both arms and legs should lift equally'], true),

  -- Gym exercises
  ('Barbell Back Squat','legs',    ARRAY['quads','glutes','hamstrings'], ARRAY['barbell','rack'], 'gym', 'intermediate',
   4, '6-10', 90, 8.0,
   ARRAY['Set bar on upper traps','Unrack and step back','Squat to parallel depth','Drive through heels to stand','Re-rack safely'],
   ARRAY['Keep bar path vertical','Brace core before descent','Keep elbows under the bar'], true),

  ('Bench Press',      'chest',    ARRAY['chest','triceps','shoulders'], ARRAY['barbell','bench'], 'gym', 'intermediate',
   4, '6-10', 90, 7.5,
   ARRAY['Lie on bench, feet flat on floor','Grip bar slightly wider than shoulders','Lower bar to lower chest','Press up explosively'],
   ARRAY['Keep shoulder blades retracted','Do not bounce bar off chest','Maintain slight arch in lower back'], true),

  ('Deadlift',         'back',     ARRAY['hamstrings','glutes','lower back','traps'], ARRAY['barbell'], 'gym', 'intermediate',
   3, '5-8', 120, 8.5,
   ARRAY['Stand with bar over mid-foot','Hip-hinge to grip bar','Brace core and leg drive to lift','Hips and bar rise together','Lock out at top'],
   ARRAY['Keep bar close to body throughout','Do not round lower back','Push floor away, do not pull bar up'], true),

  ('Lat Pulldown',     'back',     ARRAY['lats','biceps'], ARRAY['cable machine'], 'gym', 'beginner',
   3, '10-12', 60, 5.0,
   ARRAY['Sit with thighs under pads','Grip bar wider than shoulders','Pull bar to upper chest','Return slowly with control'],
   ARRAY['Lean back slightly — do not lean far back','Squeeze shoulder blades together at bottom','Control the return — 2-3 seconds'], true),

  ('Dumbbell Shoulder Press', 'shoulders', ARRAY['deltoids','triceps'], ARRAY['dumbbells'], 'gym', 'beginner',
   3, '10-12', 60, 6.0,
   ARRAY['Sit or stand with dumbbells at shoulder height','Press overhead until arms are nearly straight','Lower slowly to start'],
   ARRAY['Do not flare elbows forward','Keep core braced — do not arch back','Full range of motion'], true)

ON CONFLICT DO NOTHING;

-- ── Workout Plans ─────────────────────────────────────────────────────────────

INSERT INTO public.workout_plans
  (name, description, goal, location, level, duration_weeks, days_per_week)
VALUES
  ('Home Full Body - Beginner',
   'No equipment needed. Three days a week of full body work to build a base. Ideal for weight loss beginners.',
   'lose', 'home', 'beginner', 4, 3),

  ('Home Full Body - Intermediate',
   'Four days, higher volume, more intensity. For those who have been training for 2+ months at home.',
   'lose', 'home', 'intermediate', 6, 4),

  ('Gym Strength - Beginner',
   'Classic 3-day full body gym routine. Builds strength and muscle on the core compound lifts.',
   'gain', 'gym', 'beginner', 6, 3),

  ('Gym Hypertrophy - Intermediate',
   'Push/Pull/Legs split for intermediate lifters. Higher volume for muscle growth.',
   'gain', 'gym', 'intermediate', 8, 4),

  ('Weight Loss HIIT',
   'High intensity home workouts designed to maximize calorie burn. Minimal rest, maximum effort.',
   'lose', 'home', 'beginner', 6, 4)
ON CONFLICT DO NOTHING;

-- ── Plan Days — Home Full Body Beginner (plan 1, 3 days) ─────────────────────

-- We use a CTE to look up plan/exercise IDs safely
WITH plan AS (SELECT id FROM public.workout_plans WHERE name = 'Home Full Body - Beginner' LIMIT 1),
     ex AS (
       SELECT name, id FROM public.exercises
       WHERE name IN ('Push-ups','Squats','Plank','Lunges','Glute Bridges','Mountain Climbers',
                      'Burpees','Tricep Dips (chair)','Jump Squats','Superman Hold')
     )
INSERT INTO public.workout_plan_days
  (plan_id, day_number, day_label, exercise_id, sets, reps, rest_seconds, order_index)
SELECT
  plan.id,
  v.day_number,
  v.day_label,
  ex.id,
  v.sets,
  v.reps,
  v.rest_seconds,
  v.order_index
FROM plan, (VALUES
  -- Day 1 — Full Body A
  (1, 'Full Body A', 'Push-ups',       3, '10-12', 60, 1),
  (1, 'Full Body A', 'Squats',         3, '15',    60, 2),
  (1, 'Full Body A', 'Plank',          3, '30 sec',45, 3),
  (1, 'Full Body A', 'Lunges',         3, '10 each',60,4),
  (1, 'Full Body A', 'Glute Bridges',  3, '15',    45, 5),

  -- Day 2 — Full Body B
  (2, 'Full Body B', 'Burpees',        3, '8',     90, 1),
  (2, 'Full Body B', 'Squats',         3, '15',    60, 2),
  (2, 'Full Body B', 'Tricep Dips (chair)', 3, '12', 60, 3),
  (2, 'Full Body B', 'Mountain Climbers',3, '20 each',45,4),
  (2, 'Full Body B', 'Superman Hold',  3, '12',    45, 5),

  -- Day 3 — Full Body C (cardio focus)
  (3, 'Cardio Blast', 'Jump Squats',   3, '12',    75, 1),
  (3, 'Cardio Blast', 'Burpees',       3, '10',    90, 2),
  (3, 'Cardio Blast', 'Mountain Climbers',3,'20 each',45,3),
  (3, 'Cardio Blast', 'Plank',         3, '45 sec',45, 4),
  (3, 'Cardio Blast', 'Push-ups',      3, '12',    60, 5)
) AS v(day_number, day_label, exercise_name, sets, reps, rest_seconds, order_index)
JOIN ex ON ex.name = v.exercise_name
ON CONFLICT DO NOTHING;
