# DhalBhat Fit — Nepali Food Database

Master food knowledge base. Build to 100+ items before AI integration begins.
Update this file as new foods are researched and verified.

---

## Food Record Structure

Every food item contains these fields:

| Field | Type | Description |
|---|---|---|
| food_id | UUID | Auto-generated primary key |
| name_en | TEXT | English name |
| name_ne | TEXT | Nepali name in Devanagari script |
| aliases | TEXT[] | Alternate spellings and local names |
| category | TEXT | Category key (see category list below) |
| calories_per_100g | NUMERIC | Base calorie value per 100g |
| protein_g | NUMERIC | Protein per 100g |
| carbs_g | NUMERIC | Carbohydrates per 100g |
| fat_g | NUMERIC | Fat per 100g |
| fiber_g | NUMERIC | Dietary fiber per 100g |
| image_ref | TEXT | Path in Supabase Storage: /foods/{food_id}/photo.jpg |
| ai_confidence_base | NUMERIC | How reliably Claude Vision identifies this dish (0.0–1.0) |
| local_variant_notes | TEXT | Regional differences, ingredient variations |
| is_verified | BOOLEAN | Manually cross-checked against a source |

### Portion Record Structure (food_portions table)

Each food has multiple portion entries:

| Field | Description |
|---|---|
| portion_label | e.g., "1 small plate", "1 cup", "1 piece" |
| portion_label_ne | Nepali label |
| weight_g | Weight in grams |
| calories | Total calories for this portion |
| is_default | True for the most common serving size |

---

## Food Categories

| Category Key | Display EN | Display NE |
|---|---|---|
| `dal_bhat` | Dal Bhat Set | दाल भात |
| `rice` | Rice / Bhat | भात |
| `dal` | Lentils / Dal | दाल |
| `curry` | Curry / Tarkari | तरकारी |
| `meat` | Meat Dishes | मासु |
| `momo` | Momo | मम |
| `newari` | Newari Dishes | नेवारी खाना |
| `grilled` | Sekuwa / Grilled | सेकुवा |
| `snack` | Local Snacks / Khaja | खाजा |
| `fermented` | Fermented Foods | किण्वित खाना |
| `fruit` | Fruits | फलफूल |
| `drink` | Drinks | पेय |
| `dairy` | Dairy | दूध / दही |
| `egg` | Eggs | अण्डा |
| `pickle` | Achar / Pickle | अचार |
| `bread` | Bread / Roti | रोटी |

---

## Full Food Database

### Dal Bhat Sets (complete thali meals)

| Name EN | Name NE | Aliases | kcal/100g | P | C | F | Fi | ai_conf | Notes |
|---|---|---|---|---|---|---|---|---|---|
| Dal Bhat Small Plate | साना दाल भात | daal bhat, dal bhat | ~95 | 5.5 | 16 | 1.5 | 1.5 | 0.90 | Varies by dal type and rice amount |
| Dal Bhat Medium Plate | मध्यम दाल भात | standard dal bhat | ~100 | 6 | 18 | 1.8 | 1.8 | 0.90 | Most common serving in Nepal |
| Dal Bhat Large Plate | ठूलो दाल भात | full thali | ~105 | 6.5 | 20 | 2 | 2 | 0.88 | Includes extra rice |

**Portion sizes for Dal Bhat:**

| Portion Label | Weight (g) | Calories |
|---|---|---|
| 1 small plate | ~500g | ~490 |
| 1 medium plate (standard) | ~700g | ~700 |
| 1 large plate | ~900g | ~950 |

*Standard thali composition: 2 cups rice + 1 cup dal + 1 cup tarkari + 2 tbsp achar + optional papad*

---

### Rice / Bhat

| Name EN | Name NE | Aliases | kcal/100g | P | C | F | Fi | ai_conf | Notes |
|---|---|---|---|---|---|---|---|---|---|
| Cooked White Rice | भात | bhat, chaamal | 130 | 2.7 | 28 | 0.3 | 0.4 | 0.85 | Standard Nepali white rice, slightly more starch than basmati |
| Steamed Brown Rice | खैरो चामलको भात | brown rice | 112 | 2.6 | 23 | 0.9 | 1.8 | 0.75 | Less common but available in urban areas |
| Dhindo (buckwheat) | ढिँडो | — | 82 | 1.8 | 16.5 | 0.75 | 1 | 0.92 | Traditional mountain meal, thick porridge |
| Dhindo (millet) | कोदोको ढिँडो | kodo ko dhindo | 75 | 1.5 | 15 | 0.7 | 1.2 | 0.90 | Finger millet, higher fiber |

**Portion sizes for Rice:**

| Portion Label | Weight (g) | Calories |
|---|---|---|
| 1 small cup | 120g | 156 |
| 1 cup (standard) | 185g | 240 |
| 1 large cup | 240g | 312 |
| 1 serving dhindo | 200g | 165 |

---

### Dal / Lentils

| Name EN | Name NE | kcal/100g | P | C | F | Fi | ai_conf | Notes |
|---|---|---|---|---|---|---|---|---|---|
| Masoor Dal (cooked) | मसुर दाल | 116 | 9 | 20 | 0.4 | 4 | 0.82 | Most common in Nepal, red/orange |
| Mung Dal (cooked) | मुङ दाल | 105 | 7.3 | 19.3 | 0.4 | 1.6 | 0.80 | Yellow, lighter flavor |
| Chana Dal (cooked) | चना दाल | 164 | 10 | 27 | 2.7 | 8 | 0.78 | Split chickpea |
| Rajma (cooked) | राजमा | 127 | 8.7 | 22.8 | 0.5 | 6.4 | 0.75 | Red kidney beans, popular in hills |
| Black Dal (Kalo Dal) | काले दाल | 118 | 8 | 20.4 | 0.6 | 7.3 | 0.72 | Whole black lentil, richer |
| Tarkari Dal (mixed) | मिक्स दाल | 120 | 8.5 | 21 | 0.8 | 4 | 0.70 | Common home-cooked mixed lentil |

**Portion sizes for Dal:**

| Portion Label | Weight (g) | Calories |
|---|---|---|
| 1 small katori (bowl) | 100ml | ~95 |
| 1 serving (standard) | 150ml | ~143 |
| 1 large bowl | 240ml | ~230 |

---

### Curry / Tarkari

| Name EN | Name NE | kcal/100g | P | C | F | Fi | ai_conf | Notes |
|---|---|---|---|---|---|---|---|---|---|
| Mixed Veg Curry | मिक्स तरकारी | 80 | 2.5 | 10 | 3.5 | 3 | 0.75 | Varies greatly by vegetables |
| Aloo Tarkari | आलु तरकारी | 95 | 2 | 14 | 3.5 | 2 | 0.85 | Potato curry, most common |
| Cauliflower Curry | काउली तरकारी | 70 | 2.5 | 8 | 3 | 2.5 | 0.82 | |
| Saag (Spinach/Greens) | साग | 55 | 3.5 | 6 | 2 | 2.5 | 0.80 | Can be mustard greens or spinach |
| Gundruk ko Jhol | गुन्द्रुकको झोल | 28 | 3.2 | 3.8 | 0.4 | 2.8 | 0.88 | Fermented greens soup, staple side |
| Pumpkin Curry | फर्सीको तरकारी | 65 | 1.5 | 12 | 2.5 | 1.5 | 0.78 | |
| Squash/Lauka Curry | लौकाको तरकारी | 50 | 1.2 | 8 | 2 | 1.5 | 0.75 | |

**Portion sizes for Curry:**

| Portion Label | Weight (g) | Calories |
|---|---|---|
| 1 small bowl | 100g | ~75 |
| 1 serving (standard) | 150g | ~113 |
| 1 large bowl | 200g | ~150 |

---

### Meat Dishes

| Name EN | Name NE | kcal/100g | P | C | F | Fi | ai_conf | Notes |
|---|---|---|---|---|---|---|---|---|---|
| Chicken Curry | कुखुराको मासु | 175 | 18 | 5 | 9 | 0.5 | 0.85 | Bone-in most common, boneless less common |
| Mutton Curry | खसीको मासु | 218 | 19 | 4 | 14 | 0.3 | 0.83 | Goat meat standard in Nepal |
| Fish Curry | माछाको तरकारी | 140 | 20 | 3 | 6 | 0 | 0.78 | Rohu most common |
| Buff Curry (Buffalo) | भैँसीको मासु | 190 | 22 | 3 | 10 | 0 | 0.75 | Popular in Kathmandu |
| Pork Curry | सुँगुरको मासु | 240 | 17 | 2 | 18 | 0 | 0.72 | Less common, regional |
| Chicken Bhutuwa (dry fry) | कुखुराको भुटुवा | 220 | 22 | 4 | 13 | 0.3 | 0.80 | Dry spiced stir-fry |
| Mutton Bhutuwa | खसीको भुटुवा | 260 | 22 | 3 | 17 | 0.2 | 0.78 | |

**Portion sizes for Meat:**

| Portion Label | Weight (g) | Calories |
|---|---|---|
| 1 small serving | 100g | ~175–218 |
| 1 standard serving | 150g | ~263–327 |
| 1 large serving | 200g | ~350–436 |

---

### Momo

| Name EN | Name NE | kcal/100g | P | C | F | Fi | ai_conf | Notes |
|---|---|---|---|---|---|---|---|---|---|
| Chicken Momo (steamed) | भापे कुखुराको मम | 155 | 10 | 18 | 4.5 | 1 | 0.92 | Most popular variety |
| Mutton Momo (steamed) | भापे खसीको मम | 175 | 11 | 17 | 7 | 1 | 0.90 | |
| Buff Momo (steamed) | भापे भैँसीको मम | 160 | 11 | 17 | 5.5 | 1 | 0.88 | Common in Kathmandu |
| Veg Momo (steamed) | भापे तरकारीको मम | 120 | 5 | 20 | 2.5 | 2 | 0.87 | Cabbage, tofu, paneer filling |
| Chicken Momo (fried) | तलेको कुखुराको मम | 220 | 10 | 18 | 11 | 1 | 0.88 | Significantly higher fat |
| Mutton Momo (fried) | तलेको खसीको मम | 245 | 11 | 17 | 14 | 1 | 0.85 | |
| Jhol Momo | झोल मम | 170 | 10 | 20 | 5.5 | 1.5 | 0.85 | In tomato-sesame soup, popular recently |
| C-Momo (spicy crispy) | सी-मम | 280 | 10 | 25 | 15 | 1.5 | 0.80 | Deep fried, tossed in sauce |
| Momo Chutney (tomato-sesame) | मम अचार | 45 | 1.5 | 8 | 1.2 | 2 | 0.90 | Standard dip |

**Portion sizes for Momo:**

| Portion Label | Pieces | Weight (g) | Calories |
|---|---|---|---|
| 1 piece | 1 | 20g | ~31–44 |
| Half plate | 5 | 100g | ~155–245 |
| 1 plate (standard) | 10 | 200g | ~310–490 |

---

### Newari Dishes

| Name EN | Name NE | kcal/100g | P | C | F | Fi | ai_conf | Notes |
|---|---|---|---|---|---|---|---|---|---|
| Chhoila (buff) | भैँसीको छोइला | 230 | 23 | 4 | 14 | 0.5 | 0.80 | Grilled buffalo, spiced with mustard oil |
| Chhoila (chicken) | कुखुराको छोइला | 200 | 22 | 4 | 11 | 0.5 | 0.78 | |
| Kwati (mixed beans soup) | क्वाटी | 118 | 8 | 20 | 1.5 | 6 | 0.75 | Nine-bean mix, festival food |
| Bara (lentil pancake) | बारा | 185 | 9 | 22 | 7 | 3 | 0.82 | Black lentil pancake, Newari |
| Yomari | योमरी | 280 | 5 | 48 | 8 | 1.5 | 0.88 | Rice flour dumpling, sweet chaku/sesame filling |
| Sikarni | सिकर्नी | 180 | 5 | 25 | 7 | 0.5 | 0.80 | Sweetened strained yogurt with spices |
| Samay Baji (Khaja set) | समय बाजी | ~130 | 7 | 18 | 4 | 2 | 0.72 | per 100g avg — full plate: ~500–650 kcal |
| Bhatmas Sadeko | भटमासको सदेको | 375 | 28 | 30 | 16 | 9 | 0.85 | Spiced roasted soybeans, common bar snack |
| Aloo Sadeko | आलुको सदेको | 110 | 2.5 | 18 | 3.5 | 2 | 0.82 | Spiced potato, lemon, chili |

---

### Sekuwa / Grilled

| Name EN | Name NE | kcal/100g | P | C | F | Fi | ai_conf | Notes |
|---|---|---|---|---|---|---|---|---|---|
| Chicken Sekuwa | कुखुराको सेकुवा | 195 | 25 | 2 | 10 | 0 | 0.85 | Grilled, marinated, no batter |
| Mutton Sekuwa | खसीको सेकुवा | 235 | 24 | 2 | 15 | 0 | 0.83 | |
| Buff Sekuwa | भैँसीको सेकुवा | 215 | 26 | 2 | 12 | 0 | 0.80 | Common street food in Kathmandu |
| Fish Sekuwa | माछाको सेकुवा | 165 | 23 | 1.5 | 8 | 0 | 0.78 | |
| Pork Sekuwa | सुँगुरको सेकुवा | 280 | 20 | 1.5 | 22 | 0 | 0.72 | |

**Portion sizes for Sekuwa:**

| Portion Label | Weight (g) | Calories |
|---|---|---|
| 1 small skewer | 80g | ~155–220 |
| 1 standard serving | 150g | ~290–350 |
| 1 large serving | 250g | ~490–590 |

---

### Fermented Foods

| Name EN | Name NE | kcal/100g | P | C | F | Fi | ai_conf | Notes |
|---|---|---|---|---|---|---|---|---|---|
| Gundruk | गुन्द्रुक | 35 | 4 | 5 | 0.5 | 3.5 | 0.85 | Dried fermented leafy greens |
| Sinki | सिन्की | 25 | 3 | 3.5 | 0.3 | 3 | 0.78 | Fermented radish/turnip root, more sour |
| Gundruk Soup | गुन्द्रुकको झोल | 28 | 3.2 | 3.8 | 0.4 | 2.8 | 0.88 | Cooked as side soup |
| Sinki Soup | सिन्कीको झोल | 22 | 2.5 | 3.2 | 0.3 | 2.5 | 0.80 | Very sour, regional staple |
| Kinema | किनेमा | 190 | 18 | 18 | 6 | 6 | 0.65 | Fermented soybean, pungent smell |
| Tama (fermented bamboo) | तामा | 30 | 2.5 | 5 | 0.4 | 2 | 0.75 | Bamboo shoot pickle/curry |

---

### Snacks / Khaja

| Name EN | Name NE | kcal/100g | P | C | F | Fi | ai_conf | Notes |
|---|---|---|---|---|---|---|---|---|---|
| Sel Roti | सेल रोटी | 350 | 5 | 55 | 12 | 1.5 | 0.90 | Deep-fried rice flour ring, festival item |
| Chatpate | चटपटे | 220 | 5 | 38 | 6 | 3 | 0.88 | Puffed rice mix with spices and lemon |
| Chura (beaten rice) | चिउरा | 350 | 7.5 | 76 | 1.5 | 1 | 0.85 | Flattened rice, very common snack |
| Chiura with Dahi | दही चिउरा | 190 | 7 | 32 | 4.5 | 0.8 | 0.87 | Classic Nepali breakfast |
| Pakoda | पकौडा | 270 | 7 | 30 | 14 | 3 | 0.82 | Vegetable fritters |
| Samosa | समोसा | 290 | 5 | 35 | 15 | 3 | 0.85 | Potato-filled fried pastry |
| Pani Puri | पानी पुरी | 175 | 4 | 28 | 6 | 2 | 0.80 | Hollow fried crisp with spiced water |
| Noodle Soup / Wai Wai | वाइ वाइ | 380 | 9 | 52 | 16 | 2 | 0.87 | Instant noodle, very common |
| Thukpa | थुक्पा | 120 | 8 | 18 | 3 | 1.5 | 0.82 | Tibetan noodle soup, popular in hills |
| Piro Aloo | पिरो आलु | 100 | 2 | 16 | 3.5 | 2 | 0.80 | Spicy potato, popular street snack |

**Portion sizes for Common Snacks:**

| Food | Portion | Weight (g) | Calories |
|---|---|---|---|
| Sel Roti | 1 piece | 80g | 280 |
| Chatpate | 1 serving | 100g | 220 |
| Chura | 1 cup | 70g | 245 |
| Samosa | 1 piece | 80g | 232 |
| Thukpa | 1 bowl | 350g | 420 |
| Wai Wai | 1 packet | 75g | 285 |

---

### Achar / Pickle

| Name EN | Name NE | kcal/100g | P | C | F | Fi | ai_conf | Notes |
|---|---|---|---|---|---|---|---|---|---|
| Tomato Achar | गोलभेडाको अचार | 50 | 1.5 | 9 | 1.5 | 2 | 0.88 | Most common, served with momo and dal bhat |
| Radish Achar | मूलाको अचार | 45 | 1.2 | 8 | 1.2 | 2.5 | 0.85 | |
| Mango Achar | आँपको अचार | 120 | 1 | 20 | 4.5 | 2 | 0.82 | Sweet-sour-spicy |
| Sesame Achar | तिलको अचार | 180 | 5 | 10 | 14 | 3 | 0.80 | Creamy, high fat from sesame |
| Lapsi Achar | लप्सीको अचार | 130 | 0.8 | 28 | 2 | 2 | 0.82 | Hog plum pickle, very popular in Nepal |
| Timur Achar | टिमुरको अचार | 40 | 1 | 7 | 1 | 2 | 0.75 | Sichuan pepper-based |
| Gundruk Achar | गुन्द्रुकको अचार | 30 | 3 | 4 | 0.4 | 3 | 0.80 | |

**Portion sizes for Achar:**

| Portion Label | Weight (g) | Calories |
|---|---|---|
| 1 tsp | 5g | ~3–9 |
| 1 tbsp | 15g | ~7–27 |
| 2 tbsp (standard side) | 30g | ~14–54 |

---

### Eggs

| Name EN | Name NE | kcal/100g | P | C | F | Fi | ai_conf | Notes |
|---|---|---|---|---|---|---|---|---|---|
| Boiled Egg | उसिनेको अण्डा | 155 | 13 | 1.1 | 11 | 0 | 0.95 | |
| Fried Egg | तलेको अण्डा | 196 | 14 | 0.4 | 15 | 0 | 0.92 | |
| Scrambled Egg | फेँटेको अण्डा | 175 | 13 | 1.6 | 13 | 0 | 0.88 | With milk or plain |
| Egg Curry | अण्डाको तरकारी | 170 | 12 | 5 | 11 | 0.5 | 0.85 | 2 eggs in gravy |
| Omelette | अमलेट | 185 | 14 | 2 | 14 | 0 | 0.90 | Plain or with vegetables |

**Portion sizes for Eggs:**

| Portion Label | Weight (g) | Calories |
|---|---|---|
| 1 small egg | 43g | ~67 |
| 1 medium egg | 50g | ~78 |
| 1 large egg | 60g | ~93 |
| 2 eggs (egg curry) | 150g | ~255 |

---

### Fruits

| Name EN | Name NE | kcal/100g | P | C | F | Fi | ai_conf | Notes |
|---|---|---|---|---|---|---|---|---|---|
| Banana | केरा | 89 | 1.1 | 23 | 0.3 | 2.6 | 0.95 | Most common, small Nepali variety slightly sweeter |
| Apple | स्याउ | 52 | 0.3 | 14 | 0.2 | 2.4 | 0.93 | |
| Orange | सुन्तला | 47 | 0.9 | 12 | 0.1 | 2.4 | 0.90 | |
| Papaya | मेवा | 43 | 0.5 | 11 | 0.3 | 1.7 | 0.88 | |
| Watermelon | तरबुजा | 30 | 0.6 | 7.6 | 0.2 | 0.4 | 0.87 | |
| Guava | अम्बा | 68 | 2.6 | 14 | 1 | 5.4 | 0.85 | |
| Mango | आँप | 60 | 0.8 | 15 | 0.4 | 1.6 | 0.88 | Seasonal, summer |
| Pear | नाश्पाती | 57 | 0.4 | 15 | 0.1 | 3.1 | 0.85 | |
| Litchi | लीची | 66 | 0.8 | 17 | 0.4 | 1.3 | 0.82 | Seasonal, very popular |
| Pomegranate | दाडिम | 83 | 1.7 | 19 | 1.2 | 4 | 0.80 | |
| Plum | आलुबखडा | 46 | 0.7 | 11.4 | 0.3 | 1.4 | 0.80 | Seasonal |

**Portion sizes for Fruits:**

| Food | Portion | Weight (g) | Calories |
|---|---|---|---|
| Banana | 1 medium | 120g | 107 |
| Apple | 1 medium | 180g | 94 |
| Orange | 1 medium | 130g | 61 |
| Watermelon | 1 slice | 300g | 90 |
| Mango | 1 cup diced | 165g | 99 |
| Guava | 1 medium | 100g | 68 |

---

### Drinks / Beverages

| Name EN | Name NE | kcal/100g | P | C | F | Fi | ai_conf | Notes |
|---|---|---|---|---|---|---|---|---|---|
| Chiya (milk tea, sweetened) | मिठो चिया | 40 | 1.5 | 6 | 1.5 | 0 | 0.90 | Standard Nepali tea, 1 tsp sugar + milk |
| Chiya (black, no sugar) | कालो चिया | 2 | 0.1 | 0.5 | 0 | 0 | 0.85 | |
| Chiya (2 tsp sugar) | मिठो चिया (दुई चम्चा) | 50 | 1.5 | 8 | 1.5 | 0 | 0.88 | Common variant |
| Lassi (sweet) | लस्सी | 75 | 3.5 | 10 | 2.5 | 0 | 0.85 | |
| Lassi (salted) | नमकिन लस्सी | 55 | 3.5 | 6 | 2.5 | 0 | 0.82 | |
| Tongba | टोङ्बा | 45 | 1 | 8 | 0.5 | 0 | 0.70 | Millet beer, Himalayan traditional |
| Chang | छ्याङ | 35 | 0.8 | 6 | 0.2 | 0 | 0.68 | Fermented grain beer, traditional |
| Water | पानी | 0 | 0 | 0 | 0 | 0 | 1.00 | Always free tier |

**Portion sizes for Drinks:**

| Food | Portion | Volume (ml) | Calories |
|---|---|---|---|
| Chiya | 1 small glass | 150ml | 60 |
| Chiya | 1 standard cup | 250ml | 100 |
| Lassi | 1 glass | 250ml | 188 |
| Water | 1 glass | 250ml | 0 |

---

### Dairy

| Name EN | Name NE | kcal/100g | P | C | F | Fi | ai_conf | Notes |
|---|---|---|---|---|---|---|---|---|---|
| Dahi (plain yogurt) | दही | 61 | 3.5 | 4.7 | 3.3 | 0 | 0.88 | Thicker than commercial yogurt |
| Full cream milk | पूरा दूध | 61 | 3.2 | 4.8 | 3.3 | 0 | 0.85 | |
| Paneer | पनीर | 265 | 18 | 3.5 | 20 | 0 | 0.82 | Homemade paneer common in Nepal |
| Ghee | घिउ | 900 | 0 | 0 | 100 | 0 | 0.75 | Always used in small quantities |
| Butter | मक्खन | 717 | 0.9 | 0.1 | 81 | 0 | 0.75 | |

---

### Bread

| Name EN | Name NE | kcal/100g | P | C | F | Fi | ai_conf | Notes |
|---|---|---|---|---|---|---|---|---|---|
| Roti (chapati) | रोटी | 297 | 9 | 52 | 7 | 5 | 0.88 | Whole wheat, thin |
| Puri | पुरी | 360 | 7 | 45 | 17 | 3 | 0.87 | Deep fried wheat |
| Paratha | पराठा | 340 | 7 | 44 | 16 | 3 | 0.85 | Layered, pan-fried |
| Makai Roti | मकैको रोटी | 220 | 5 | 40 | 5 | 3.5 | 0.80 | Cornmeal flatbread |

---

## Pre-built Meal Templates (one-tap logging)

| Template Name | Meal Type | kcal | Components |
|---|---|---|---|
| Standard Dal Bhat Thali | Lunch/Dinner | 700 | 2 cups rice + 1 cup masoor dal + 1 serving aloo tarkari + 2 tbsp tomato achar |
| Light Dal Bhat Thali | Lunch/Dinner | 490 | 1.5 cups rice + 1 cup dal + achar |
| Heavy Dal Bhat Thali | Lunch/Dinner | 950 | 3 cups rice + extra dal + tarkari + achar |
| Egg Dal Bhat | Lunch/Dinner | 780 | Standard thali + 2 boiled eggs |
| Chicken Dal Bhat | Lunch/Dinner | 960 | Standard thali + 1 serving chicken curry |
| Steamed Chicken Momo (10 pcs) | Lunch/Snack | 310 | 10 pcs + tomato achar |
| Fried Chicken Momo (10 pcs) | Snack | 440 | 10 pcs + achar |
| Chiya + Roti Breakfast | Breakfast | 220 | 2 rotis + 1 cup chiya |
| Dahi Chiura | Breakfast/Snack | 330 | 1 cup chiura + 1 cup dahi |
| Chiura + Egg | Breakfast | 410 | 1 cup chiura + 2 boiled eggs |
| Fruit Bowl | Breakfast/Snack | 200 | 1 banana + 1 apple + 1 orange |
| Muscle Gain Thali | Lunch/Dinner | 950 | Large rice + extra dal + chicken curry + 2 eggs |
| Samay Baji (Newari Khaja Set) | Lunch | 560 | Chiura + chhoila + bhatmas + aloo sadeko + achar |
| Thukpa Bowl | Lunch/Dinner | 420 | 1 bowl thukpa |

---

## AI Matching Rules

When user submits a food photo:

```
Step 1: Identify food
  → Claude Vision analyzes image
  → Returns top 3 candidate dishes with confidence scores
  → Uses Nepali food knowledge base for context

Step 2: Estimate plate/portion size
  → Analyze plate diameter relative to food volume
  → Small / medium / large plate classification
  → Estimate weight in grams

Step 3: Match to database
  → Map identified dish to food_id in foods table
  → Select closest portion_id from food_portions
  → Calculate calories based on portion

Step 4: Return to user
  → Show: dish name (EN + NE) + estimated calories + macros
  → Show: confidence level (high/medium/low)
  → Show: portion size used

Step 5: User review
  → User confirms or adjusts portion size
  → User can flag wrong dish identification

Step 6: Save
  → Log to food_logs with ai_confidence score
  → If user corrected → save to ai_feedback table
  → Over time: user corrections improve prompt context
```

### Confidence Score Guidance

| Score | Label | UI Treatment |
|---|---|---|
| 0.85–1.00 | High confidence | Auto-fill, small "verify" chip |
| 0.65–0.84 | Medium confidence | Show result + "Does this look right?" |
| below 0.65 | Low confidence | Show result + ask user to confirm dish name |

---

## Data Sources

| Source | Use |
|---|---|
| USDA FoodData Central | Base macro values for standard ingredients |
| Nepal-specific food composition studies | Adjustments for local cooking methods and varieties |
| Manual local entry | Dishes not in any database (Gundruk, Sinki, Sel Roti, etc.) |
| Real user meal logs (post-launch) | Portion size calibration and variant discovery |
| Curated Nepali food image dataset | AI confidence training and recognition improvement |

---

## Backlog (add before launch)

- [ ] Sekuwa with sides (common order includes chiura and achar)
- [ ] Thukpa regional variants (Tibetan vs Nepali style)
- [ ] Common packaged snacks with barcode data (Wai Wai, Mayos chips, etc.)
- [ ] Seasonal fruits: peach, plum, persimmon, loquat
- [ ] Restaurant chain items (Pizza Hut Nepal, KFC Nepal, local chains)
- [ ] Festival foods: Sel roti combo, Tihar snacks, Teej fasting foods
- [ ] School canteen common meals
- [ ] Khana set from dhaba (roadside restaurant standard plate)
