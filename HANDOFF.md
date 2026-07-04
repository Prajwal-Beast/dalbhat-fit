# DhalBhat Fit — Session Handoff & Living Context

> **Purpose:** This file is the single source of truth for continuing work across
> sessions. When a new session starts, READ THIS FIRST. Keep appending to it —
> never delete history, add new dated entries at the bottom of the Log section.

_Last updated: 2026-06-26_

---

## 1. What the app is

**DhalBhat Fit** — Nepal-first diet & fitness mobile app. Tracks Nepali foods
(dal bhat, momo, sel roti, etc.), guided home/gym workouts, weight & progress.
Free. Built for Nepal.

- **Owner:** Prajwal (prajwalbeast22@gmail.com), GitHub user `prajwal-beast`
- **Package name (permanent):** `com.dhalbhatfit.dalbhat_fit`
- **Repo:** public on GitHub, GitHub Pages live
- **Privacy policy (live):** https://prajwal-beast.github.io/dalbhat-fit/privacy-policy.html

## 2. Tech stack

- **Flutter** (clean architecture, feature-first: `data/ domain/ presentation/`)
- **Riverpod** state management (Provider, FutureProvider(.family), StateNotifierProvider)
- **GoRouter** routing — ShellRoute with 5-tab bottom nav + auth redirect guard
- **Supabase** backend — PostgreSQL + Auth + Storage + RLS
- **Drift (SQLite)** offline-first local DB (`core/database/app_database.dart`)
- Asian BMI cutoffs (23.0 = overweight); Mifflin-St Jeor BMR/TDEE

### Project paths
- App root: `C:\claude code\dalbhat-fit\app`
- Source: `app/lib`
- Release APK: `app/build/app/outputs/flutter-apk/app-release.apk`
- Release AAB: `app/build/app/outputs/bundle/release/app-release.aab`
- Build command (MUST include credentials):
  `flutter build apk --release --dart-define-from-file=.env.local`
  (AAB: `flutter build appbundle --release --dart-define-from-file=.env.local`)
- ADB on this machine: `$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe`
- Phone: Samsung Galaxy S22, device id `EIQWTOFQJV8DYPSS`

## 3. SECURITY RULES (never violate)

1. **Claude/Anthropic API key NEVER in the Flutter app** — only in a Supabase
   Edge Function's env vars. `env.dart` only reads `--dart-define` values.
2. **Never commit:** `.env.local`, `*.jks` keystores, `key.properties`. They are
   in `.gitignore` and confirmed untracked.
3. Keystore: `android/dalbhat-fit-release.jks`, `android/key.properties`
   (storeFile is just `dalbhat-fit-release.jks`, NOT `app/...`).

## 4. Google Play Store status

- Developer account: **verified** ($25 paid, one-time, unlimited apps).
- App created in Play Console. Internal + Closed testing tracks.
- AAB uploaded. Store listing filled (name, short/full description, screenshots,
  icon, feature graphic). Privacy policy URL set. Data safety + all 9
  declarations completed.
- **Sent for review** (first review takes 1–3 days).
- **Closed testing requirement:** need **12 testers opted-in for 14 days** before
  applying for Production. THIS IS THE MAIN BOTTLENECK — user must recruit testers.
- Versioning for updates: `pubspec.yaml` `version: 1.0.0+1` (bump build number
  each upload). Updates can be automated later via Google Play Developer API, but
  first publish must be manual.

### Store assets (on user's Desktop)
- Icon 512×512: `C:\Users\TUF\Desktop\dhalbhat_fit_icon_512.png`
- Feature graphic 1024×500: `C:\Users\TUF\Desktop\dhalbhat_fit_feature_graphic_1024x500.png`
- Screenshots: `C:\Users\TUF\Desktop\PlayStore_Screenshots\01..06_*.jpg`
- Drive folder: "DHALBHAT FIT SCREENSHOT" (id `1qICclcbDZjamWrkqwd7IADJ0FdDomEfW`)

## 5. PENDING / TODO (priority order)

1. **User is testing the latest APK on their phone** (installed 2026-06-10 with
   all bug fixes below). Awaiting feedback on login / meals / workouts / dashboard.
2. **Verify workout plans have exercises seeded** in Supabase — code is correct,
   but if a plan has 0 exercises it can't be started. Migration 004 seeded all 5
   plans; confirm live.
3. **Google OAuth fix (USER ACTION):** In Supabase Dashboard → Authentication →
   URL Configuration, change Site URL from `http://localhost:3000` to
   `https://prajwal-beast.github.io/dalbhat-fit`. Otherwise Google sign-in
   redirects to localhost.
4. **Enable Leaked Password Protection (USER ACTION):** Supabase → Authentication
   → Policies → toggle on. (Only remaining security advisor warning.)
5. **Recruit 12 closed-test testers** (family/friends/classmates) — 14-day clock.
6. **Workout videos:** 15 exercises listed in `docs/workout-videos-needed.md`.
   Once uploaded to Supabase Storage bucket `exercise-videos` and `video_url`
   set on `exercises` rows, add a video player widget to `ActiveSessionScreen`.
7. ✅ **Committed** — the full bug-fix batch + this session's work are now on
   branch `fixes/settings-units-meal-delete` (2 commits, off `master`). Still
   need to **push to GitHub** and open/merge a PR (or fast-forward `master`).
8. **Before next Play Store upload:** bump `pubspec.yaml` version, build AAB.

## 6. Architecture cheat-sheet (key files)

- Auth: `features/auth/` — `currentUserProvider` is REACTIVE (watches
  `authStateProvider`). `launchGoogleSignIn()` is fire-and-forget; routing via
  `ref.listen(authStateProvider)` in auth_screen.
- Router: `core/router/app_router.dart` — has `redirect` + `GoRouterRefreshStream`
  guarding the protected prefixes (`/home /log /food /workouts /progress /settings`).
- Food offline-first: write to Drift first (instant) → background push to Supabase
  using the SAME client UUID (`id: localId`) so local+remote dedupe by id.
  `todayLogsProvider` merges both sources.
- Workouts: `workout_provider.dart` — `WorkoutSessionNotifier` with rest Timer
  (guarded by `mounted`), double-save guard in `completeSet`.
- Profile: `profile_provider.dart` — calorie target read as `num?.toInt()`.

## 7. SESSION LOG (append-only — newest at bottom)

### 2026-06-10 — Multi-agent bug audit + fixes (session continued from compaction)
Ran 3 parallel agents (QA, Security, Senior Dev). Fixed all critical/high bugs.
`flutter analyze lib` = **No issues found**. Built APK (62.7MB) and installed on
the S22. User is testing.

**Bugs fixed:**
1. CRITICAL — `currentUserProvider` was non-reactive → user appeared logged-out
   everywhere after login. Root cause of "not signed in", meals failing, workouts
   not saving. Now derives from `authStateProvider`.
   (`features/auth/presentation/providers/auth_provider.dart`)
2. CRITICAL — Food logs double-counted: local Drift row UUID wasn't sent to
   Supabase, so remote got a new id and merge never deduped. Now the client UUID
   is passed through (`logFood/logTemplate` gained `id` param; remote uses
   `upsert` with `'id': ?id`). Also fixes delete-then-reappear.
   (food_provider.dart, supabase_food_log_datasource.dart, repo + interface)
3. CRITICAL — Dashboard crash: `l.caloriesConfirmed as double` on dynamic list.
   Typed `_MealSlot.logs` as `List<FoodLog>`, removed casts.
   (`features/dashboard/presentation/screens/home_screen.dart`)
4. HIGH — Workout "green screen": Start pushed an empty session when no plan
   ready. Now if `plan == null` → go to `/workouts` browse instead.
5. HIGH — Meal log opened on dead "Photo" tab (both buttons no-ops). Default tab
   set to Search (`initialIndex: 1`); photo buttons show "coming soon" snackbar;
   tab relabeled "Photo (soon)". (`meal_log_screen.dart`)
6. HIGH — Dead "Add custom food" button replaced with a helper hint.
   (`food_search_screen.dart`)
7. HIGH — No auth gating. Added `redirect` + `GoRouterRefreshStream` to router.
8. HIGH — Workout double-save / rest Timer leak. Added re-entrancy guard in
   `completeSet`, `mounted` guard in the timer, bounds-safe `currentExercise`.
9. `profileCalorieTargetProvider` unsafe `as int?` → `(num?)?.toInt()`.
10. `_logTemplate` now surfaces failure with an error snackbar.

**Security audit result:** PASS. No secrets in code; keystore/.env untracked; RLS
enabled on all user tables (`auth.uid() = user_id`). Fixed: revoked public EXECUTE
on `public.rls_auto_enable()` SECURITY DEFINER function (migration
`revoke_execute_rls_auto_enable`). Remaining advisor warning: Leaked Password
Protection disabled (user must toggle in dashboard).

**Install note:** had to `adb uninstall` first — old build was signed with a
different key (signature mismatch). Reinstall wipes local data → good for testing
the login fix.

### 2026-06-10 (later) — Auth/onboarding flow fixed
User reported the whole sign-up/login flow was broken: "Get Started" never asked
for email/password; "I already have an account" showed "Create Account"; Google
login 404; after onboarding it bounced back to "Get Started".

**Root causes + fixes (all in code, `flutter analyze` clean):**
1. `welcome_screen.dart:81` — "Get Started" went straight to `/onboarding`,
   skipping account creation entirely → no user → onboarding's profile save
   fails → auth guard bounces /home back to /welcome (the loop). FIX: "Get
   Started" now → `/auth?mode=signup`. The auth screen already routes to
   /onboarding after successful sign-up (auth_screen.dart:68).
2. `welcome_screen.dart:88` — "I already have an account" passed mode via
   `extra: {'mode':'signin'}`, but the router reads `queryParameters['mode']`
   (app_router.dart:26) → always defaulted to signup → wrong screen title. FIX:
   now `/auth?mode=signin`.
3. `auth_screen.dart` `_submit` — after sign-up, if email confirmation is on
   there's no active session; pushing to onboarding would fail. FIX: check
   `auth.currentSession`; if null, show "confirm your email" + switch to sign-in.

Rebuilt APK (62.7MB). Phone disconnected before reinstall — pending reinstall.

**DB checks done:** no trigger on auth.users; only 1 user exists
(prajwalbeast22@gmail.com, confirmed). No failed signups in auth logs.

**USER DASHBOARD ACTIONS still needed (I cannot do these via tools):**
- Google 404 / OAuth: Supabase → Authentication → URL Configuration → set Site
  URL to `https://prajwal-beast.github.io/dalbhat-fit` (currently localhost).
- For frictionless beta sign-up: Supabase → Authentication → Providers → Email →
  consider turning OFF "Confirm email" so sign-up creates a session immediately
  and flows straight into onboarding. (If left ON, users must confirm via email
  before signing in.)

### 2026-06-10 (later 2) — Code-review findings: critical sync fix + batch
A detailed review surfaced a chain bug causing ~94% of food logs to never reach
the server. Fixed that + several high/medium issues. **`flutter analyze` pending
verification at time of writing.**

**IMPORTANT INFRA DISCOVERY:** The Supabase MCP in this environment is connected
to the WRONG project — `rpeqnasynmotozsegijh` (a brand/marketing analytics
project with tables brands/campaigns/snapshots/scorecards), NOT DhalBhat Fit
(`hmjqotxfdmirbomfhrgu`, per the storage URL in docs/workout-videos-needed.md).
Consequences: the earlier live `get_advisors` check and the
`revoke_execute_rls_auto_enable` migration went to the WRONG project (harmless
there). I could NOT verify the "47/50 foods lack portions" claim or seed
portions live. To do live DB work on DhalBhat, reconnect the MCP to
`hmjqotxfdmirbomfhrgu` OR run SQL in that project's dashboard.

**Fixes applied (all code, no DB needed):**
1. 🔴 CRITICAL food-log data loss: synthesized portion ids like
   `<uuid>_default` were sent to the `uuid` column `food_logs.portion_id`,
   throwing "invalid input syntax for type uuid", swallowed silently, retried
   forever → ~94% of logs never synced, vanished on reinstall. FIX: new
   `core/utils/uuid_util.dart` `isUuid()`; send `portion_id: null` when not a
   real UUID — in `supabase_food_log_datasource.dart` (logFood) and
   `sync_service.dart` (`_syncFoodLogs`). Optional longer-term: seed real
   `food_portions` for the 47 foods (needs correct DB connection).
2. 🟡 Dev-mode crash: `app_router.dart` touched `Supabase.instance` at build
   time, but Supabase only inits when env vars present → `flutter run` with no
   creds crashed. FIX: guarded `refreshListenable`/`redirect` behind
   `Env.isConfigured`.
3. 🟠 Settings Privacy Policy + Help were no-ops (bad for Play review). FIX:
   Privacy opens the live policy URL; Help opens a mailto. (url_launcher)
4. 🟡 Forgot-password silent failure: wrapped in try/catch with feedback snack.
5. 🟡 Onboarding allowed empty name: step 0 now blocks Continue if name blank.
6. 🟡 Workout streak reset on same-day second session: normalize to date-only,
   skip same-day duplicates (workout_complete_screen.dart).
7. 🟡 Water card label "/8" but 4 droplets: each droplet = 2 glasses, label now
   "${_filled*2} / 8 glasses".
8. 🟢 Sign-in navigation race: signIn now routes onboarding-aware (not always
   /home).

**STILL OUTSTANDING from the review (not yet done — pick up here):**
- 🟠 Delete/edit a logged meal: `FoodLogNotifier.deleteLog` exists but is wired
  to no screen; also has a resurrect bug (no tombstone if remote delete fails
  offline). Needs UI (swipe-to-delete on today's logs) + tombstone handling.
- 🟠 Settings toggles are decorative (Nepali lang, lbs/ft, Dark mode, meal/
  workout reminders) — not persisted to `user_settings`; Dark mode doesn't
  change theme (app uses ThemeMode.system).
- 🟠 Goal progress bar always ~0%: `progress_screen.dart` uses
  `profile['weight_kg']` as start, but weight logging overwrites that with
  current weight. Real start is in `goals.start_weight_kg` (unused). Card also
  invents a target (start −10/+5) while Settings reads `target_weight_kg`.
- 🟡 Weight offline-sync is dead code: `SyncService._syncWeightLogs` reads
  `getUnsyncedWeightLogs` but nothing calls `insertLocalWeightLog` — weight
  saves are remote-only, fail offline. Wire weight through local DB or delete.
- 🟡 "Flag as wrong" on food detail records nothing.
- 🟢 Food search has no real debounce (network per keystroke).
- 🟢 Water intake resets on navigation (state not persisted).
- 🟢 Pull-to-refresh on Home only refreshes food logs, not weight/workout.

### 2026-06-13 — Root-caused "can't add food"; fixed email confirmation
User: "cannot add any food items into my log." Drove the app on the Android
emulator + tested the backend directly.

**ROOT CAUSE (proven): Supabase email confirmation was ON.** Signup returned a
user with `confirmation_sent_at` and NO session → user never actually logged in
→ food logging requires a userId → fails. Verified via direct curl to
`hmjqotxfdmirbomfhrgu.supabase.co/auth/v1/signup`:
- before: `HAS_SESSION: False`, `confirmation_sent_at` set
- after user turned OFF "Confirm email": `HAS_SESSION: True` ✅
Also found: Supabase rejects `@example.com` emails (`email_address_invalid`);
gmail works.

**Verified working on emulator:** "Get Started" → Create Account screen (name +
email + password) — the welcome→auth fix is confirmed via screenshot.

**Code fixes this session (analyze clean):**
- Auth error messages improved: invalid-email now says "Please enter a valid
  email address"; added `_fallbackMessage()` so non-AuthApiException errors
  surface a useful message instead of always "Check your connection".
  (supabase_auth_datasource.dart)
- (earlier this session) auth_screen handles no-session-after-signup case.

**USER ACTIONS COMPLETED:** disabled email confirmation ✅; set Site URL for
Google OAuth ✅.

**Could NOT get a clean end-to-end emulator pass:** the AVD is catastrophically
slow — 19s frame times, "Skipped 1108 frames", "Lost connection to device", and
finally an ANR ("dalbhat_fit isn't responding"). The emulator times out the
network call → false "Something went wrong". NOT a code bug (same backend+key
works via curl). **Definitive verification must be on the real Samsung S22.**

Latest release APK (all fixes) at `app/build/.../app-release.apk` and copied to
`C:\Users\TUF\Desktop\DhalBhatFit-latest.apk`. Install on the phone and test:
sign up with a REAL email (not example.com) → should go straight to onboarding →
log a meal via Search tab → should appear and persist.

### 2026-06-26 — Cleared the "STILL OUTSTANDING" review list + live DB verify
This session's MCP reached the CORRECT project (`hmjqotxfdmirbomfhrgu`) via the
Supabase connector, so the 2026-06-10 claims were finally verified live:
- 🔴 `portion_id` bug PROVEN: `'<uuid>_default'::uuid` throws in Postgres, and
  `food_logs` had 0 rows. The `isUuid()` guard (already in the working tree) is
  the correct fix and is in place in `supabase_food_log_datasource.dart` +
  `sync_service.dart`.
- Foods=50, food_portions=9 across only 3 foods → 47 foods rely on the
  synthesized `_default` portion (hence null portion_id on log). Templates=8,
  exercises=15. All 5 workout plans have day-1 exercises seeded (3–5 each) — the
  old "green screen" risk is gone.

**Fixed the three 🟠 outstanding items + more (analyze clean; release APK 62.7MB
builds):**
1. Settings persistence + real units — new `core/settings/settings_provider.dart`
   (SharedPreferences-backed, opened in `main.dart`, injected like the DB) and
   `core/utils/units.dart` (kg↔lb). lbs/kg now actually converts on Home,
   Progress, Settings, and both weight-entry sheets. Weight is always STORED in
   kg; only display/input convert.
2. Delete-a-meal — long-press a logged meal slot on Home → `_MealItemsSheet`
   lists each FoodLog with delete (`FoodLogNotifier.deleteLog`). Tightened
   deleteLog ordering (local+remote, then invalidate once).
3. Goal progress — new `activeGoalProvider` / `ProfileDatasource.getActiveGoal`;
   `_GoalProgressCard` now uses the immutable `goals.start_weight_kg`, so the bar
   actually moves.
4. "Flag as wrong" now acknowledges with a snackbar (was a no-op).

**Dark mode — DEFERRED by user decision.** Screens hard-code the light
`AppColors` palette (57+ refs across 12 files); a real dark mode needs a full
palette→theme migration. `themeMode` is now forced `ThemeMode.light` (so the OS
dark setting can't half-apply and break readability); the Dark mode toggle is
labeled "Coming soon" but still persists. Nepali language is likewise persisted +
"coming soon". Do the dark-palette migration as a dedicated, device-tested pass.

**Still minor/open:** weight offline-sync path still dead code; no search
debounce; offline delete can resurrect a synced row (no tombstone). Supabase
advisors: Leaked Password Protection still OFF; `public.set_updated_at` mutable
search_path; a `beast-media` public bucket exists in this project that looks
unrelated to DhalBhat Fit — worth confirming it's intended.

### 2026-06-26 (later) — Committed everything to a branch
The entire uncommitted working tree (29 modified + 5 new files) is now recorded
in git. Created branch `fixes/settings-units-meal-delete` off `master` and split
into two commits (secrets verified untracked — `.env.local`, `*.jks`,
`key.properties` are git-ignored and were NOT staged):
- `bedab49` — *Fix critical portion_id bug and harden auth/workout/food flows*
  (the prior-session bug-fix batch incl. the `isUuid()` guard, auth/router/
  workout/food fixes, release signing, deps).
- `f89401a` — *Add persisted settings, real kg/lb units, delete-meal, goal
  progress* (this session's `core/settings` + `core/utils/units` + Home/Progress/
  Settings/Profile wiring; dark mode persisted but "coming soon").

Working tree is now clean except this HANDOFF.md update. **Next:** `git push -u
origin fixes/settings-units-meal-delete` and merge to `master` (then bump version
+ build AAB for the next Play upload).

### 2026-07-04 — 🔴 ROOT CAUSE OF EVERYTHING: missing INTERNET permission
Self-driven QA session (emulator + real phone via adb). Findings & fixes, all
committed to master and pushed:

1. **`4d39e1d` — Release builds NEVER had network access.** AndroidManifest.xml
   lacked `<uses-permission android:name="android.permission.INTERNET"/>`.
   Debug builds inject it (hot reload), release builds don't. Proven via
   `aapt dump permissions` (no INTERNET in APK) and Supabase API logs (zero
   requests ever received from any release build). This retroactively explains:
   "cannot add food", empty food_logs, all "Check your connection" errors, the
   2026-06-13 emulator failures (misblamed on slow AVD), and why the Play
   closed-testing AAB is dead on arrival. **FIX VERIFIED LIVE**: signup from
   the real phone created auth user `dhalbhatqa20260626@gmail.com` (confirmed,
   session active) — the app's first successful network call in a release build.
2. **Food data accuracy (DB migration `fix_per100g_semantics_and_seed_portions`):**
   ~12 foods had PER-PIECE kcal stored in the per-100g column. Worst: momo —
   8 steamed pork momos computed as 96 kcal (real ≈ 420; was ~4× under). Fixed
   per-100g values + macros (momo 175/230/130, chapati 297, roti 300, puri 400,
   paratha 320, samosa 260, sel roti 330, pakoda 280, chiya 42.5, lassi 110),
   renamed foods to drop misleading "(1 piece)/(8 pcs)" suffixes, seeded real
   piece portions (chapati/roti/puri/paratha/samosa/sel roti/momo/egg/wai wai/
   lassi/buffalo milk/banana/apple), fixed 3 meal templates (Momo Snack 105→440).
3. **`2082a08` — Fonts bundled** (assets/google_fonts/, OFL licenses registered,
   `GoogleFonts.config.allowRuntimeFetching = false`). Previously every fresh
   install downloaded Poppins from fonts.gstatic.com at runtime.
4. **`7d12099` — version 1.0.1+2**; new AAB built (61.8MB) at
   `app/build/app/outputs/bundle/release/app-release.aab` — **UPLOAD THIS to
   Play Console**; the 1.0.0+1 AAB there cannot work.
5. Supabase project was found **INACTIVE (auto-paused, free tier)** — restored.
   ⚠️ It WILL pause again after ~7 days without traffic; plan: upgrade or keep-
   alive ping. Also applied `set_search_path_on_set_updated_at` (advisor fix).
6. Verified: Google OAuth provider live (302 → Google, correct callback);
   deep-link scheme matches manifest; calorie math (Mifflin-St Jeor + Asian
   BMI) correct; all 5 workout plans fully seeded with sane programming.

**In progress / next:** on-device E2E (onboarding → food logging → workout →
progress → settings) with QA account `dhalbhatqa20260626@gmail.com` /
`TestPass123!` — blocked repeatedly by flaky USB on the phone; switch adb to
WiFi (`adb tcpip 5555`) as soon as it reconnects. Then: final flaw report,
upload new AAB, confirm Redirect URLs allowlist contains
`com.dhalbhatfit.dalbhat_fit://login-callback/`, enable Leaked Password
Protection.

### 2026-07-04 (later) — Full snapshot handoff written
Complete session snapshot (goal, evidence, git/release state, backend changes,
device quirks + failed workarounds, QA account, expected E2E test values, resume
steps) captured in **`handoffs/HANDOFF-2026-07-04-1150.md`** — read that file to
resume. Key blockers at time of writing: phone disconnected (E2E steps 3–9
pending), new 1.0.1+2 AAB awaiting Play upload. The session-handoff skill itself
was upgraded with a completeness checklist
(`C:\Users\TUF\.claude\skills\session-handoff\SKILL.md`).

### 2026-07-04 (final) — FULL ON-DEVICE E2E PASSED · release verdict
Completed the entire E2E suite on the real phone (adb over WiFi 192.168.18.57:5555
survived the flaky USB). Build tested: v1.0.1+2 (INTERNET + bundled fonts).

**E2E results (all verified against live Supabase):**
- Sign-up ✓ · Sign-out ✓ (confirm dialog) · Sign-in ✓ → lands on Home with data
  re-synced (onboarding-aware routing works)
- Onboarding ✓ — profile saved (Pr7, 24y M, 177cm, 75.5kg, moderate, lose);
  app target **2207 kcal** = independent Mifflin-St Jeor calc EXACTLY
- Food logging ✓ — momo detail shows corrected **8 pcs = 420 kcal** (was 96!);
  dashboard total 220+420=640, "1,567 left" exact; macros scale with portion
  (91/30/22g); DB row has portion_id (old data-loss bug dead); template log
  (Chiura+Dahi 220) matches template values; state survives force-stop
- Delete-meal ✓ — long-press sheet → trash → totals revert, remote row deleted
- Workout ✓ — HIIT session completed: 100%, 5/5 exercises, saved to
  workout_sessions; rest timer + skip-rest work
- Weight/Progress ✓ — 74.8 kg logged → trend point plots; goal bar =
  (75.5−74.8)/(75.5−70.5) ≈ 14% with "4.3 kg to lose" (activeGoalProvider fix
  works); weight row in weight_logs
- Settings ✓ — lbs toggle converts instantly (166.4 lb = 75.5kg exact),
  **persists across force-stop/relaunch**; dark mode "coming soon" label ok

**Remaining minor flaws (non-blocking, next sprint):**
1. Settings "Current weight" shows stale profile cache until app restart after
   logging weight (invalidate profile provider in weight-save flow)
2. Version footer hardcoded "v1.0.0" — use package_info or bump the string
3. workout started_at/completed_at store device-local time as UTC; created_at
   is true UTC (mixed semantics; fine same-timezone)
4. workout_session_items unused (0 rows) — per-set detail not persisted
5. Known deferred: weight offline-sync dead code, offline-delete tombstone,
   search debounce, dark-mode palette migration, photo logging, workout videos,
   Hypertrophy day-2 has only 2 exercises
6. Google login: server config verified (302→Google, correct client+callback);
   full round-trip needs ONE interactive tap-test by the user (and confirm
   Redirect URLs allowlist contains com.dhalbhatfit.dalbhat_fit://login-callback/)

**VERDICT: SHIP to closed testing NOW** — upload the 1.0.1+2 AAB
(`app/build/app/outputs/bundle/release/app-release.aab`). Production-ready after:
12 testers × 14 days, one interactive Google-login check, Leaked Password
Protection toggle, and a decision on Supabase free-tier auto-pause (upgrade or
keep-alive ping — otherwise the backend sleeps after ~7 idle days and the app
appears broken).

<!-- Add the next session's entry below this line -->
