# Handoff: DhalBhat Fit — Brand & Core App Screens

## Overview
**DhalBhat Fit** is a Nepali fitness & nutrition tracking app. It understands Nepali food (dal bhat, momo, chatpate, sel roti, achar, chiya), tracks daily calories against a goal, and recommends workouts for weight loss, muscle gain, or maintenance.

- **Tagline:** "Built for dal bhat and daily fitness"
- **Target users:** Nepali people aged 18–35 in Kathmandu, Pokhara, and major cities.
- **Brand personality:** Local. Energetic. Trustworthy. Modern but grounded in Nepali identity; warm and motivating, never clinical.

This bundle covers the **brand identity** and **8 core app screens** at high fidelity.

---

## About the Design Files
The files in this bundle are **design references created in HTML** — prototypes that show the intended look, layout, and behavior. **They are not production code to copy directly.**

Your task is to **recreate these designs in the target codebase's environment** using its established patterns and component libraries (React Native, Flutter, SwiftUI, Jetpack Compose, etc.). If no codebase exists yet, choose the most appropriate framework for a cross-platform mobile fitness app and implement the designs there. Reproduce the visuals pixel-for-pixel, but build with native/idiomatic components rather than porting the HTML/CSS verbatim.

## Fidelity
**High-fidelity.** Final colors, typography, spacing, radii, and shadows are all specified below and in `app.css`. Recreate the UI pixel-perfectly. Frame target is **iPhone 14 Pro — 393×852 pt**. Build responsively for other phone sizes; an Android (Material) adaptation should keep identical color/type/spacing and swap platform chrome (status bar, back affordance, ripple) — see "Responsive & platform" below.

## Files
- `App Screens.html` — all 8 hi-fi screens in a gallery (the primary visual spec)
- `Components.html` — component library: buttons, chips, inputs, cards, tab bar, tokens
- `Brand Foundation.html` — logo system, color palette, typography specimen, app icons
- `app.css` — **the source of truth for every token and component style.** Mirror these values.
- `assets/` — logo + app icon, ready to drop into the app (see Assets below)
- `screenshots/` — a PNG of each of the 8 screens (`01-splash.png` … `08-onboarding-goal.png`)

## Logo & icon files (in `assets/`)
| File | What it is | Use |
|---|---|---|
| `logo-mark.svg` | Pulse Peak mark, green stroke + saffron dot, transparent | On light backgrounds |
| `logo-mark-white.svg` | Pulse Peak mark, white stroke + saffron dot, transparent | On green/dark backgrounds |
| `logo-mark-512.png` | Raster of the green mark, transparent, 512×512 | Quick raster use |
| `app-icon.svg` | App icon — green rounded square, white mark, saffron dot | Vector source for the launcher icon |
| `app-icon-1024.png` | App Store icon, 1024×1024 | iOS App Store |
| `app-icon-512.png` | Play Store icon, 512×512 | Google Play |

The wordmark ("DhalBhat **Fit**") is set live in Poppins 700 (−0.035em, "Fit" in saffron) — compose it in code next to `logo-mark.svg`; it is not shipped as a baked image so it stays crisp and themeable.

---

## Brand assets

### Logo — "Pulse Peak"
A heartbeat pulse whose tall central spike doubles as a Himalayan summit; a saffron dot marks the peak. Recreate as a vector asset (SVG/PDF). It is one continuous stroke.

**SVG (64×64 viewBox):**
```svg
<svg viewBox="0 0 64 64">
  <path d="M4 42 H16 L21 34 L26 42 L32 8 L38 42 L43 34 L48 42 H60"
        fill="none" stroke="{primary}" stroke-width="5"
        stroke-linecap="round" stroke-linejoin="round"/>
  <circle cx="32" cy="8" r="3.6" fill="{saffron}"/>
</svg>
```
- Stroke color = white on green/dark backgrounds, Deep Forest Green (`#2D6A4F`) on light.
- Dot is always Warm Saffron (`#F4A261`); on the saffron-bg app-icon variant the dot/stroke flip to green/white.
- **App icon:** green background `#2D6A4F`, white pulse + saffron dot, iOS-style rounded square (~23% corner radius). Provide 1024×1024 (App Store) and 512×512 (Play Store).
- Wordmark: "DhalBhat **Fit**" — Poppins 700, letter-spacing −0.035em; "Fit" in saffron. Devanagari sub-lockup: "दालभात फिट".

---

## Design Tokens

### Colors (light mode)
| Token | Hex | Use |
|---|---|---|
| Primary — Deep Forest Green | `#2D6A4F` | Brand, headers, primary surfaces, nav active |
| Primary variant | `#40916C` | Gradients, dark-mode primary |
| Accent / CTA — Warm Saffron | `#F4A261` | Primary buttons, highlights, active states |
| Background — Off-white | `#F8F9FA` | App surface |
| Card | `#FFFFFF` | Card surfaces |
| Text — Near-black | `#1A1A2E` | Headlines & body |
| Text 2 | `#5B5F6B` | Secondary text |
| Text 3 | `#9094A0` | Tertiary / placeholder |
| Success — Bright Green | `#52B788` | Calorie ring under target, progress, streaks |
| Error / Alert — Soft Red | `#E76F51` | Over-target, gentle warnings |
| Green soft | `#E7F0EB` | Icon tiles, selected tints |
| Saffron soft | `#FCEEDF` | CTA-adjacent tints |
| Success soft | `#E4F4EC` | Success tints |
| Line | `#ECEEF1` | Hairline dividers |
| Line 2 | `#E1E4E8` | Stronger borders |

### Dark-mode variants (suggested)
Surface `#121A17`; text `#E9ECEF`; primary `#40916C`; saffron `#F6B179`; success `#74C69D`; error `#F08A6E`. Cards lift to ~`#1A241F`.

### Radius
- Cards: **20px** · Buttons & inputs: **14px** · Chips/pills: **999px** · Icon tiles: **13–15px** · Phone screen: 46px inside an 56px bezel.

### Shadows (warm-neutral, soft — never harsh)
- `sh-1` (cards): `0 1px 2px rgba(26,26,46,.04), 0 4px 14px rgba(26,26,46,.05)`
- `sh-2`: `0 2px 6px rgba(26,26,46,.05), 0 14px 34px rgba(26,26,46,.08)`
- `sh-green` (green buttons): `0 10px 26px rgba(45,106,79,.26)`
- `sh-saffron` (CTAs): `0 10px 24px rgba(244,162,97,.38)`

### Typography
- **English:** Poppins — 700/600 headings, 500 subheads/labels, 400 body, 300 light hero sublines.
- **Nepali:** Noto Sans Devanagari — same weights. Used for food names, greetings, and bilingual labels throughout.
- Headings use tight tracking (−0.01 to −0.035em). Captions/eyebrows: 11–12px, 500–600, uppercase, letter-spacing .04–.08em.
- Sentence case everywhere except the wordmark.

### Spacing
8-pt-ish scale. Screen horizontal padding **20px**. Card padding **18px**. Gaps between stacked cards **14px**; section labels 22px above / 12px below.

### Iconography
Lucide-style 1.5–2px stroke icons, rounded caps. Emoji are used **intentionally** in specific spots only (greeting 🌄, feature bullets 🍚📊💪, goal cards 🔥💪❤️, streak 🔥) — do not add emoji to UI chrome.

---

## Screens / Views

> All screens share: iOS status bar (time left "9:41"; signal/wifi/battery right), Dynamic Island, 46px-rounded screen. Background `#F8F9FA` unless noted.

### 1 — Splash
- **Purpose:** Brand moment on launch.
- **Layout:** Full-bleed Deep Forest Green (`#2D6A4F`). Pulse Peak mark centered; wordmark below; tagline pinned near bottom.
- **Animation:** Fade-in shown as two frames — Frame 1: mark at ~40% opacity, scale .86, no text. Frame 2: mark full opacity (~92px), wordmark "DhalBhat Fit" (white, "Fit" saffron) + "दालभात फिट" below, tagline "Built for dal bhat and daily fitness" at bottom. Implement as ~600ms ease-out fade + slight scale-up, then hold ~1s → route to Welcome/Home.

### 2 — Welcome
- **Purpose:** First-run value prop.
- **Layout:** Scrollable. Top hero block (height 188, radius 26) — green gradient `#2D6A4F→#40916C` with a soft saffron radial glow top-right and the white Pulse mark centered. Then headline, then 3 feature rows. Sticky-ish footer with primary button + text link.
- **Components:**
  - Headline: "Fitness built for Nepali life" — Poppins 700, 27px, line-height 1.18. Subline "तपाईंको दैनिक जीवनको लागि बनाइएको" (Devanagari, 14px, text-2).
  - 3 feature rows: 46px green-soft icon tile (emoji) + bold title + text-2 subtitle. Content: 🍚 "Understands your food / Dal bhat, momo, and local meals"; 📊 "Real Nepali portions / Calories tracked the way you eat"; 💪 "Workouts for your goal / Home or gym, beginner to advanced".
  - Primary button (saffron, full-width): "Get Started". Text link below: "I already have an account".

### 3 — Home Dashboard *(most important)*
- **Purpose:** Answer 4 questions instantly — what I ate / what to eat next / what to train / am I progressing. Scrollable; bottom tab bar fixed.
- **Layout (top→bottom):**
  1. **Greeting row:** "Good morning 🌄" (13px text-2) + "Prajnaa" (22px, 600) on left; 44px circular avatar (green-soft, initial "P") right.
  2. **Calorie ring card** (white, radius 20): centered ring (196px). Ring = SVG, r=92, stroke-width 17, track `#EAF1ED`, progress gradient `#52B788→#2D6A4F`, `stroke-linecap:round`, `transform:rotate(-90)`, `stroke-dasharray="398 580"` (= 1240/1800 ≈ 69%). **Over target → progress stroke becomes `#E76F51`.** Center text: "1,240" (34px 700) / "of 1,800 kcal" (12.5px text-3) / "560 kcal left" pill (success-soft bg, success text). Below ring: macro row — 3 equal pills, colored dot + value + label: Carbs 142g (saffron dot), Protein 68g (success dot), Fat 38g (error dot).
  3. **Primary button** (saffron, full-width): "+ Log Meal".
  4. **"Meals today"** section label → card with 3 meal rows (42px rounded emoji tile + name/sub + kcal + trailing control). Breakfast 480 ✓ (green check); Lunch "दाल भात · not logged" 0 [+ saffron add]; Dinner "Not logged" 0 [+]. Logged rows show a success check; unlogged show a saffron "+" button.
  5. **"Today's workout"** → green gradient card (`#2D6A4F→#245741`, saffron glow): eyebrow "Recommended", "Home Full Body", meta "30 min · Beginner · 6 exercises", saffron "▶ Start Workout" button.
  6. **Two half-width cards:** Water ("3 / 8", row of droplet cells — filled = green-soft + green droplet, empty = outline droplet) and Weight ("72.4 kg" 26px, "↓ 0.3" success, "this week").
- **Bottom tab bar:** see component spec. Home active.

### 4 — Meal Log
- **Purpose:** Capture a meal via photo (default), search, or voice.
- **Layout:** App bar (back icon-button + eyebrow "Log meal" / title "Lunch"). Segmented control **Photo | Search | Voice** (Photo active). Large camera viewfinder (flex-fills; dark `#15201B`, radius 22) with 4 corner brackets, a centered circular plate hint, and hint text "Point at your plate — we'll identify the food". Saffron full-width "📷 Take Photo". Text link "Upload from Gallery". "Recent" label → quick-tap chips: "दाल भात · Dal Bhat", "मोमो · Momo", "चिया · Chiya".

### 5 — Food Detail *(after AI identifies food)*
- **Purpose:** Confirm/adjust the identified food and save it.
- **Layout:** App bar (back) with an "✨ AI estimated" chip (yellow, `#FBF1D9`/`#B07A14`) right. Header row: 118px rounded food image (placeholder) + title block: "Dal Bhat (Medium Plate)" (21px 600) and "मध्यम दाल भात" (Devanagari, green, 15px). Centered calorie card: "700 kcal" (46px 700, green) + macro row (Protein 22g, Carbs 118g, Fat 12g). "Portion size" → 3 chips Small 520 / **Medium 700 (active, green)** / Large 910 — **selecting a portion updates the calorie number and macros live.** Footer: saffron "Save to Log" full-width; below, two outline buttons "Edit portion" and "Flag as wrong" (latter in error red).

### 6 — Active Workout
- **Purpose:** Drive a live training set.
- **Layout:** App bar — close (×) icon-button left, a progress bar in the center with "Exercise 3 of 6" beneath (bar at 50%), and a minus/skip icon right. Demo area (height 212, radius 22, green-soft gradient) with a "▶ demo" badge and the animated figure (in production: looping exercise GIF/video). Exercise title "Bodyweight Squat" (25px 600) centered + "Quads · Glutes" green chip. Two stat cards: **SET** "2 of 3"; **REPS · tap to add** big "12" (64px 700, green, tappable to increment) on a green-soft card. Rest-timer state (when resting): replace the reps card with a countdown ring in success green. Saffron full-width "Next Exercise →".

### 7 — Progress
- **Purpose:** Show trend, streak, weekly intake, goal. Scrollable; tab bar fixed (Progress active).
- **Layout — 4 cards:**
  1. **Weight trend:** title + 7d/30d/90d segmented toggle. SVG area line chart, line `#2D6A4F` (3px round), soft green area fill (`#52B788` 22%→0), end dot. Footer: Start 75.1 / Now 72.4 (green) / Target 68.0.
  2. **Streak:** "🔥 5 days in a row" + 7-cell heatmap (intensity levels: l1 `#CDE9D8`, l2 `#8FD3AC`, l3 `#52B788`, empty `#E1E4E8`) with M–S labels.
  3. **This week's calories:** 7 vertical bars; on-target = success green, over-target = error red. Caption "vs 1,800 target".
  4. **Goal progress:** green progress bar + three-stop track "85 Start → 82 Now (green) → 75 Target" (kg).

### 8 — Onboarding — Goal Selection
- **Purpose:** Capture the user's primary goal (step 6 of 10).
- **Layout:** App bar — back + progress bar (60%) + "6 / 10". Question "What's your main goal?" (26px 700) + "तपाईंको मुख्य लक्ष्य के हो?" (Devanagari, text-2). Three large option cards (radius 18, 2px border): 50px green-soft emoji tile + title + subtitle + trailing radio/check. **Selected card:** green border + sh-green + saffron filled checkmark. Content: 🔥 Lose Weight / "Burn fat, feel lighter" (selected); 💪 Build Muscle / "Gain strength and size"; ❤️ Stay Healthy / "Maintain and feel great". Saffron full-width "Continue" pinned bottom.

---

## Interactions & Behavior
- **Navigation:** 5-tab bottom bar (Home / Log / Workout / Progress / Profile); active tab uses Primary green icon+label, inactive uses text-3. "+ Log Meal" and the Log tab both open the Meal Log flow → Food Detail → back to Home with the new entry reflected in the ring and meals list.
- **Calorie ring:** animate the progress arc from 0 to current on mount (~600–800ms ease-out). Color is success green under target, switches to error red once consumed > target.
- **Portion chips (Food Detail):** changing portion recomputes kcal + macros immediately (no page change).
- **Reps counter (Workout):** tap increments; long-press or a secondary control to decrement; advancing sets/exercises updates the top progress bar; rest timer counts down between sets.
- **Segmented controls & chips:** single-select; active state moves the white "thumb" (segmented) or fills green (chips).
- **Buttons:** press = slight settle (translateY 0, shadow flattens), no scale-down. Transitions ~150–240ms ease-out. Hover (web/tablet): lift translateY(-1px).
- **Toggles:** standard iOS-style switch; on = green, off = line-2.

## State Management
- `user` (name, goal, target kcal, weights history)
- `today` { consumedKcal, macros{c,p,f}, meals[{slot, name, nameNe, kcal, logged}], water{filled,total}, workout{name, duration, level, exercises[]} }
- `logFlow` { mode: photo|search|voice, candidate food {name, nameNe, portion, kcalByPortion, macros}, source: ai|manual }
- `workoutSession` { exerciseIndex, totalExercises, setIndex, totalSets, reps, resting, restRemaining }
- `progress` { range: 7|30|90, weightSeries[], streakDays[], weeklyKcal[], goal{start, now, target} }
- `onboarding` { step, totalSteps, goal }
- Data fetching: food recognition (photo → AI estimate), food search, workout library, and metric history. AI-estimated foods carry an `aiEstimated` flag (drives the yellow chip).

## Responsive & platform
- Design canvas is iPhone 14 Pro (393×852). Scale type/spacing proportionally for larger/smaller phones; keep min tap target **44×44**.
- **Android (Material):** identical palette, type (Poppins + Noto Sans Devanagari), radii, and spacing. Swap iOS status bar for the Android one, back-chevron for the platform back affordance, add ripple on press, and use a Material bottom navigation bar with the same 5 destinations and color logic.

## Assets
- **Fonts:** Poppins + Noto Sans Devanagari (Google Fonts). Bundle them in-app.
- **Icons:** Lucide (or Material Symbols) at 1.5–2px stroke. The few inline SVGs in the HTML (home, clipboard, dumbbell/activity, trending-up, user, camera, search, droplet, play, chevrons, check, plus) map 1:1 to Lucide names.
- **Logo & app icon:** ready-made files in `assets/` (see "Logo & icon files" table above) — `logo-mark.svg` / `logo-mark-white.svg` for in-app use, `app-icon-1024.png` / `app-icon-512.png` for the stores. The Pulse Peak SVG geometry is documented under "Brand assets".
- **Screen references:** `screenshots/01-splash.png` … `08-onboarding-goal.png` show each finished screen.
- **Food/exercise media:** the HTML uses CSS placeholders for the food photo and exercise demo — wire these to real photo capture and exercise GIF/video in production.
- **No stock photography.** Illustrations only if minimal and flat.
