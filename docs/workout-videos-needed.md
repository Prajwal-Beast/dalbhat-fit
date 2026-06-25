# Workout Videos Needed — DhalBhat Fit

Each video should be:
- **Format**: MP4 (landscape or square)
- **Length**: 15–30 seconds (looping demo, no intro/outro)
- **Style**: Clean, clear view of the full body, no talking needed
- **Resolution**: 720p minimum

Upload each to Supabase Storage → bucket: `exercise-videos`
Then update the `video_url` column in the `exercises` table.

---

## 🏠 Home / Bodyweight Exercises

| # | Exercise | What to show in video |
|---|---|---|
| 1 | **Push-ups** | Side angle — full down to up, elbows at 45° |
| 2 | **Squats** | Side angle — hip crease below knees, chest up |
| 3 | **Plank** | Side angle — straight line head to heels, forearms down |
| 4 | **Lunges** | Front/side — step forward, 90° both knees, upright torso |
| 5 | **Burpees** | Side angle — full sequence: stand → squat → plank → push-up → jump |
| 6 | **Mountain Climbers** | Side angle — plank position, alternating knee drives fast |
| 7 | **Glute Bridges** | Side angle — lying down, hips drive up, squeeze at top |
| 8 | **Tricep Dips (chair)** | Side angle — chair behind, lower and push back up |
| 9 | **Jump Squats** | Side angle — squat then explosive jump, soft landing |
| 10 | **Superman Hold** | Side angle — face down, lift arms + chest + legs together |

---

## 🏋️ Gym Exercises

| # | Exercise | What to show in video |
|---|---|---|
| 11 | **Barbell Back Squat** | Side angle — bar on upper traps, squat to parallel depth |
| 12 | **Bench Press** | Side angle — bar to lower chest, press up explosively |
| 13 | **Deadlift** | Side angle — hip hinge, bar drags up shins, lock out at top |
| 14 | **Lat Pulldown** | Front angle — wide grip, bar to upper chest, elbows drive down |
| 15 | **Dumbbell Shoulder Press** | Front angle — dumbbells at shoulder height, press overhead |

---

## How to add videos to the app

Once you have the videos:

### 1. Upload to Supabase Storage
- Supabase Dashboard → Storage → Create bucket `exercise-videos` (public)
- Upload each video with filename matching exercise name e.g. `push-ups.mp4`

### 2. Update the database
Run this SQL for each exercise (replace values):
```sql
UPDATE public.exercises
SET video_url = 'https://hmjqotxfdmirbomfhrgu.supabase.co/storage/v1/object/public/exercise-videos/push-ups.mp4'
WHERE name = 'Push-ups';
```

### 3. The app will auto-play them
The `video_url` field is already in the `exercises` table schema.
I'll add a video player widget to `ActiveSessionScreen` once videos are ready.

---

## Free video sources (if you don't have your own)

- **Pexels.com** → search exercise name → free download, commercial use OK
- **Coverr.co** → free fitness video clips
- **Your own phone** → record yourself doing each exercise (most authentic!)
