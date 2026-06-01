# DhalBhat Fit — Design Handoff

Source: HTML design files provided by designer.
This is the implementation spec — all values extracted and ready for Flutter.

---

## Logo — "Pulse Peak"

SVG path (64×64 viewBox):
```
M4 42 H16 L21 34 L26 42 L32 8 L38 42 L43 34 L48 42 H60
Circle: cx=32 cy=8 r=3.6 fill=#F4A261
```

Rules:
- Stroke = white on green/dark backgrounds, #2D6A4F on light
- Dot always = #F4A261 (saffron)
- App icon: green bg #2D6A4F, white pulse + saffron dot, ~23% corner radius
- Wordmark: "DhalBhat Fit" — Poppins 700, letter-spacing -0.035em, "Fit" in saffron
- Devanagari sub: "दालभात फिट"

---

## Design Tokens

### Colors
```
Primary (Deep Forest Green):   #2D6A4F
Primary variant:               #40916C
Green soft:                    #E7F0EB
Green on dark:                 #74C69D
Accent/CTA (Warm Saffron):     #F4A261
Saffron soft:                  #FCEEDF
Background (Off-white):        #F8F9FA
Card:                          #FFFFFF
Text (Near-black):             #1A1A2E
Text 2:                        #5B5F6B
Text 3:                        #9094A0
Success (Bright Green):        #52B788
Success soft:                  #E4F4EC
Error (Soft Red):              #E76F51
Error soft:                    #FBE9E3
Line:                          #ECEEF1
Line 2:                        #E1E4E8
```

### Dark Mode
```
Surface:    #121A17
Cards:      #1A241F
Text:       #E9ECEF
Primary:    #40916C
Saffron:    #F6B179
Success:    #74C69D
Error:      #F08A6E
```

### Border Radius
```
Cards:          20px
Buttons/inputs: 14px
Chips/pills:    999px
Icon tiles:     13–15px
```

### Shadows
```
sh-1 (cards):    0 1px 2px rgba(26,26,46,.04), 0 4px 14px rgba(26,26,46,.05)
sh-2:            0 2px 6px rgba(26,26,46,.05), 0 14px 34px rgba(26,26,46,.08)
sh-green:        0 10px 26px rgba(45,106,79,.26)
sh-saffron:      0 10px 24px rgba(244,162,97,.38)
```

### Typography
```
English:  Poppins
  700/600 — headings
  500     — subheads, labels
  400     — body
  300     — light hero sublines
  Tracking: -0.01 to -0.035em on headings

Nepali:   Noto Sans Devanagari (same weights)

Captions/eyebrows: 11–12px, 500–600, UPPERCASE, letter-spacing .04–.08em
```

### Spacing
```
Horizontal screen padding: 20px
Card padding:              18px
Gap between stacked cards: 14px
Section labels:            22px above, 12px below
```

---

## 8 Screens Designed

### Screen 1 — Splash
- Full-bleed green (#2D6A4F) background
- Frame 1: Logo at 40% opacity, scale 0.86
- Frame 2: Logo full + "DhalBhat Fit" (white, Fit=saffron) + "दालभात फिट" (Devanagari, greenOnDark)
- Tagline pinned bottom: "Built for dal bhat and daily fitness" (white 78% opacity, 300 weight)
- Animation: 600ms ease-out fade+scale → hold 1s → route

### Screen 2 — Welcome
- Green gradient hero block (h=188, radius=26) with logo centered + saffron glow
- Headline: "Fitness built for Nepali life" (27px 700)
- Nepali sub: "तपाईंको दैनिक जीवनको लागि बनाइएको" (Devanagari, 14px, text-2)
- 3 feature rows: emoji tile (46px, green-soft bg) + title + subtitle
  - 🍚 "Understands your food" / "Dal bhat, momo, and local meals"
  - 📊 "Real Nepali portions" / "Calories tracked the way you eat"
  - 💪 "Workouts for your goal" / "Home or gym, beginner to advanced"
- Primary button (saffron, full-width): "Get Started"
- Text link: "I already have an account"

### Screen 3 — Home Dashboard
- Greeting: "Good morning 🌄" (13px text-2) + "Prajnaa" (22px 600) + 44px avatar
- Calorie ring card (white, radius 20, 196px):
  - SVG ring: r=92, stroke-width=17, track=#EAF1ED, fill gradient #52B788→#2D6A4F
  - stroke-dasharray="398 580" (69% fill example)
  - Center: "1,240" (34px 700) / "of 1,800 kcal" / "560 kcal left" pill (success-soft)
  - Over target → ring becomes #E76F51
  - Macro row: 3 pills (Carbs saffron-dot, Protein success-dot, Fat error-dot)
- Saffron full-width "+ Log Meal" button
- Meals today card: 3 rows (emoji tile + name + kcal + check/add)
- Today's workout card: green gradient + glow, "Home Full Body" + meta + saffron Start button
- Two half-cards: Water (8 drop cells) + Weight (26px number + delta)
- Bottom tab bar: Home(active) / Log / Workout / Progress / Profile

### Screen 4 — Meal Log
- App bar: back + "Log meal" eyebrow + "Lunch" title
- Segmented: Photo (active) | Search | Voice
- Camera viewfinder (dark #15201B, radius 22): 4 corner brackets + plate hint
- Saffron "Take Photo" button
- "Upload from Gallery" text link
- Recent chips: "दाल भात · Dal Bhat" / "मोमो · Momo" / "चिया · Chiya"

### Screen 5 — Food Detail (after AI identifies)
- App bar + "✨ AI estimated" yellow chip
- Food image (118px, radius 24) + "Dal Bhat (Medium Plate)" / "मध्यम दाल भात" (green)
- Calorie card: "700 kcal" (46px 700, green) + macro row
- Portion chips: Small 520 / Medium 700 (active, green) / Large 910
- Selecting portion updates calories live
- "Save to Log" (saffron) + "Edit portion" + "Flag as wrong" (error color)

### Screen 6 — Active Workout Session
- App bar: X close + progress bar (50%) + "Exercise 3 of 6" + skip icon
- Demo area (h=212, green-soft gradient): play badge + exercise figure animation
- "Bodyweight Squat" (25px 600) + "Quads · Glutes" green chip
- Two stat cards: SET "2 of 3" + REPS "12" (64px 700, green, tap to increment)
- Rest timer (when active): countdown ring in success green
- Saffron "Next Exercise →"

### Screen 7 — Progress
- Weight trend: line chart (3px green line, soft green fill, end dot) + 7d/30d/90d toggle
- Streak: "🔥 5 days in a row" + 7-cell heatmap (l1=#CDE9D8, l2=#8FD3AC, l3=#52B788)
- Weekly calories: 7 bars (green=on target, red=over target)
- Goal progress: green bar + "85 Start → 82 Now (green) → 75 Target"

### Screen 8 — Onboarding Goal (step 6/10)
- Back + progress bar (60%) + "6 / 10"
- "What's your main goal?" (26px 700) + Nepali sub
- 3 option cards (radius 18, 2px border, 50px emoji tile):
  - 🔥 Lose Weight / "Burn fat, feel lighter" (selected: green border + saffron check)
  - 💪 Build Muscle / "Gain strength and size"
  - ❤️ Stay Healthy / "Maintain and feel great"
- Saffron "Continue" pinned bottom

---

## Calorie Ring Implementation

```dart
// SVG stroke-dasharray formula
// circumference = 2 * pi * r = 2 * 3.14159 * 92 = 578.05
// filled = (consumed / target) * circumference
// Example: (1240/1800) * 578 = 398 (stroke-dasharray="398 580")
```

## Bottom Tab Bar
5 tabs: Home / Log / Workout / Progress / Profile
Active: green icon + green label
Inactive: text-3 color (#9094A0)
Height: 86px, bg white 94% opacity + blur, 1px top border
