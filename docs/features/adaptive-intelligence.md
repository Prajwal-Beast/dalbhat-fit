# DhalBhat Fit — Adaptive Food Intelligence

The food database is not static. It grows with every user interaction.
This document defines how the system learns, handles unknowns, and promotes new foods into the verified database.

---

## Core Principle

Every food interaction is a data point. Unknown foods are not errors — they are opportunities to expand the database. The system should never dead-end on an unrecognized food.

---

## Food Knowledge States

Every food item in the system exists in one of four states:

| State | Description | Source | Visible to users |
|---|---|---|---|
| `verified` | Fully reviewed, macros confirmed | Admin / manual research | Yes, full confidence |
| `community` | Logged by 10+ unique users, macros estimated | User submissions reviewed | Yes, with "community" tag |
| `pending` | Submitted by 1–9 users, unreviewed | User submission | Yes, with "unverified" tag |
| `rejected` | Submitted but removed (duplicate, incorrect, or spam) | Admin | No |

---

## Full Unknown Food Flow

### Step 1: User uploads photo

```
Claude Vision API analyzes image
        │
        ├─ Confidence ≥ 0.65 → Match found
        │       └─ Show identified food + portion → user confirms → log normally
        │
        └─ Confidence < 0.65 → No confident match
                └─ → Step 2
```

### Step 2: Partial match attempt

```
Claude returns:
  - Closest known food (e.g., "looks like a chatpate variant")
  - Visible ingredient clues (e.g., puffed rice, spices, citrus)
  - Estimated calories based on ingredient analysis
  - Confidence score
  - Question for user: "What is this dish called?"
```

### Step 3: User names the food

**Option A — User provides name:**
```
User types: "Piro Bhatmas Chatpate"
        │
        ├─ Check: does this name exist in foods or pending_foods?
        │       ├─ Yes, pending → link this log to that pending_food, +1 to log_count
        │       └─ No match → create new pending_food entry
        │
        └─ Show estimated calories → user confirms or edits → log saved
```

**Option B — User skips naming:**
```
Log saved as "Unknown food" with AI ingredient estimate
No pending_food entry created (can't grow database without a name)
```

### Step 4: Pending food logged and tracked

```
pending_foods table:
  - stores name, estimated macros, who submitted it, how many times logged
  - log_count increments every time a user logs this food
  - average_calories updated as more users log it

Thresholds:
  log_count ≥ 5  → flag for admin review
  log_count ≥ 20 → priority review queue (multiple users agree on this food)
  log_count ≥ 50 → strong candidate for verified promotion
```

### Step 5: Admin review

```
Admin reviews pending_foods queue (can be done from Supabase dashboard initially)
        │
        ├─ Approve → verify macros manually → move to foods table as verified
        ├─ Merge → it is a duplicate of existing food → link logs to correct food_id
        └─ Reject → mark as rejected, notify users who submitted it
```

### Step 6: Database grows

Newly verified food is available to all users. Future photo recognition of this dish improves because:
- The food now has a `foods` entry with name, aliases, and macros
- Claude's prompt context includes the expanded food knowledge base
- `ai_confidence_base` starts low (0.50) and is calibrated as more users confirm it

---

## Claude API Prompts for Unknown Foods

### Unknown food photo prompt
```
System:
You are a nutrition assistant for DhalBhat Fit, a Nepali fitness app.
The user has uploaded a food photo that does not match your known Nepali food database.

Your known database includes: [inject food list]

Analyze the image and:
1. Identify the closest match from the known database if one exists.
2. List visible ingredients or preparation style clues.
3. Estimate total calories and macros based on what is visible.
4. Assign a confidence score.
5. Suggest a question to ask the user to help identify the food.

Return JSON only:
{
  "recognized": false,
  "closest_known_food": "string or null",
  "closest_food_id": "uuid or null",
  "confidence": 0.0,
  "ingredient_clues": ["string"],
  "estimated_calories": 0,
  "estimated_protein_g": 0,
  "estimated_carbs_g": 0,
  "estimated_fat_g": 0,
  "ask_user": "What is this dish called? (optional — only if helpful)",
  "reasoning": "brief explanation"
}
```

### Name-based macro estimation prompt
```
System:
You are a nutrition assistant. A Nepali user has named a food that is not in the database.
Food name: [user input]
Visible clues from image: [ingredient clues]

Estimate the nutritional content per 100g for this food.
Base your estimate on similar known Nepali or South Asian foods.

Return JSON:
{
  "food_name_normalized": "string",
  "estimated_category": "string",
  "calories_per_100g": 0,
  "protein_g": 0,
  "carbs_g": 0,
  "fat_g": 0,
  "fiber_g": 0,
  "confidence": 0.0,
  "based_on": "string — what known food this estimate is based on",
  "notes": "any relevant local variant context"
}
```

---

## Database Growth Stages

| Stage | Foods count | What's included | Timeline |
|---|---|---|---|
| Seed | 100 | Core Nepali foods, verified macros | Before launch |
| Phase 1 | 150–200 | Regional dishes, festival foods manually added | Month 1–3 |
| Phase 2 | 300+ | Community-promoted foods (pending → community) | Month 3–6 |
| Phase 3 | 500+ | Restaurant items, packaged foods, fusion dishes | Month 6–12 |
| Long-term | 1000+ | Continuously growing Nepali food intelligence | Ongoing |

### Priority items for Phase 1 additions (post-launch research)
- Tihar special: sel roti, anarsha, barfi
- Dashain special: goat meat dishes, saag varieties
- Teej fasting foods: fruits, boiled potato
- School/college canteen staples
- Common dhaba/restaurant plate options
- Newari festival foods: Ihi, Kwati, Yomari Punhi dishes
- Hill and mountain regional foods: Gundruk setpu, local millet dishes
- Terai foods: Tharu cuisine, maize dishes

---

## Handling Seasonal Foods

Seasonal foods have an `available_months` field so the app can:
- Surface them in recommendations during their season
- Not suggest out-of-season items
- Flag them as seasonal in the UI

```sql
-- Added to foods table
available_months  INTEGER[],  -- e.g., [3,4,5] for March-May (mango season)
is_seasonal       BOOLEAN DEFAULT FALSE
```

Examples:
| Food | Season | Months |
|---|---|---|
| Mango | Summer | May–August |
| Litchi | Summer | May–June |
| Watermelon | Summer | April–August |
| Sel Roti | Festival | October–November (Tihar) |
| Yomari | Festival | December (Yomari Punhi) |
| Kwati | Festival | August (Janai Purnima) |

---

## User-Facing Experience for Unknown Foods

### What the user sees (unknown food flow)

```
┌─────────────────────────────────────┐
│  🤔 I'm not sure what this is       │
│                                     │
│  It looks like a chatpate variant   │
│  Estimated: ~180 kcal               │
│                                     │
│  What is this dish called?          │
│  ┌─────────────────────────────┐    │
│  │ Type food name...           │    │
│  └─────────────────────────────┘    │
│                                     │
│  [Skip naming]  [Save estimate]     │
└─────────────────────────────────────┘
```

After naming:
```
┌─────────────────────────────────────┐
│  ✓ "Piro Bhatmas Chatpate" saved    │
│                                     │
│  Estimated: 195 kcal                │
│  P: 8g  C: 22g  F: 9g              │
│                                     │
│  ⚠ Unverified food                 │
│  Calories are AI-estimated          │
│                                     │
│  [Edit calories]  [Log this meal]   │
└─────────────────────────────────────┘
```

### Confidence labels shown to users

| ai_confidence | User-facing label | Color |
|---|---|---|
| ≥ 0.85 | — (no label, high confidence) | — |
| 0.65–0.84 | "Estimated" | Yellow chip |
| 0.40–0.64 | "AI guess — please verify" | Orange chip |
| < 0.40 | "Unverified food" | Red chip |

---

## Feedback Loop Architecture

```
User logs food (photo or text)
        │
        ▼
Claude identifies → logged with ai_confidence
        │
        ├─ User accepts → no action needed
        │
        ├─ User edits portion → update food_log.quantity, log to ai_feedback
        │
        ├─ User changes dish name → log to ai_feedback (ai_identified vs user_corrected)
        │                         → if correction is frequent → update food alias list
        │
        └─ User flags "wrong food" → log to ai_feedback
                                   → if flagged 5+ times → lower ai_confidence_base
                                   → if flagged 10+ times → review food entry
```

### How corrections improve future accuracy

1. `ai_feedback` records accumulate: what Claude guessed vs what the user said
2. High-frequency corrections update the `aliases` array on the foods entry (so Claude recognizes it by more names)
3. Repeated portion corrections adjust the `default_portion_id` for that food
4. Per-user corrections are included in the user's personalized Claude prompt context:
   ```
   "This user typically logs dal bhat as 1 large plate (900g), not medium.
    When this user photographs dal bhat, default to large plate estimate."
   ```

---

## Admin Review Interface (MVP: Supabase Dashboard)

For MVP, admin review happens directly in the Supabase table editor. Build a proper admin dashboard in v2.

Pending foods review checklist:
- [ ] Is this a real food? (not a duplicate, spam, or test entry)
- [ ] Is the name correct? (check aliases, normalize spelling)
- [ ] Are the macros reasonable? (cross-check against USDA or similar source)
- [ ] Should it be merged with an existing food? (e.g., "piro chatpate" → alias of "chatpate")
- [ ] Assign correct category
- [ ] Set `ai_confidence_base` (start at 0.50 for newly promoted foods)
- [ ] Mark `is_verified = true`

---

## Metrics to Track

| Metric | Why |
|---|---|
| Unknown food rate | % of photo logs that return confidence < 0.65 |
| User naming rate | % of unknown foods that users name (vs skip) |
| Pending food log count | Foods getting enough logs to warrant review |
| Correction rate | % of AI results users edit or flag |
| Database growth rate | New verified foods added per month |
| Per-food confidence trend | Is a food getting more or less accurate over time |
