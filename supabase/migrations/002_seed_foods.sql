-- ============================================================
-- DhalBhat Fit — Seed Data: Nepali Food Database (50 foods)
-- Migration: 002_seed_foods.sql
-- ============================================================

-- NOTE: Run 001_initial_schema.sql first.

INSERT INTO public.foods
  (name_en, name_ne, category, calories_per_100g, protein_g, carbs_g, fat_g, fiber_g, is_verified, source)
VALUES
  -- Dal Bhat category
  ('Dal Bhat (full thali)',        'दाल भात थाली',       'dal_bhat',  130, 5.2, 23.0, 2.8, 2.1,  true, 'official'),
  ('Plain Rice (boiled)',          'भात',                 'rice',      130, 2.7, 28.2, 0.3, 0.4,  true, 'official'),
  ('Masoor Dal (cooked)',          'मसुरको दाल',         'dal',        93, 7.6, 14.5, 0.4, 3.5,  true, 'official'),
  ('Tarkari (mixed veg curry)',    'तरकारी',              'curry',      65, 2.0, 10.0, 2.0, 2.5,  true, 'official'),

  -- Meat & Fish
  ('Chicken Curry',                'कुखुराको मासु',       'meat',      165, 17.5, 3.5, 9.0, 0.4,  true, 'official'),
  ('Mutton Curry',                 'खसीको मासु',          'meat',      195, 16.0, 2.5, 13.5, 0.2, true, 'official'),
  ('Fish Curry (rohu)',            'माछाको झोल',          'meat',      110, 18.0, 3.0, 3.5, 0.0,  true, 'official'),
  ('Egg (boiled, 1 piece)',        'उमालेको अण्डा',       'egg',       155, 13.0, 1.1, 11.0, 0.0, true, 'official'),
  ('Fried Egg',                   'भुटेको अण्डा',        'egg',       196, 13.6, 0.4, 15.0, 0.0, true, 'official'),

  -- Momo & street food
  ('Momo (steamed, pork, 8 pcs)', 'मःमः (भाप)',          'momo',       40, 2.8, 5.2, 1.1, 0.3,  true, 'official'),
  ('Momo (fried, 8 pcs)',         'कोठेमःमः',            'momo',       55, 2.5, 5.5, 2.2, 0.3,  true, 'official'),
  ('Momo (veg, steamed)',         'भेज मःमः',            'momo',       35, 1.8, 5.8, 0.6, 0.8,  true, 'official'),
  ('Samosa (1 piece)',            'समोसा',               'snack',     150, 3.0, 19.0, 7.0, 1.5,  true, 'official'),
  ('Chatpate',                    'चटपटे',               'snack',     190, 4.5, 32.0, 5.5, 3.0,  true, 'official'),
  ('Sel Roti (1 piece)',          'सेल रोटी',            'snack',     180, 2.5, 29.0, 6.5, 0.5,  true, 'official'),
  ('Pakoda (veg, 4 pcs)',         'पकौडा',               'snack',     168, 4.0, 18.0, 9.0, 1.5,  true, 'official'),

  -- Breads
  ('Roti (1 piece)',              'रोटी',                'bread',     120, 3.5, 21.5, 2.5, 1.8,  true, 'official'),
  ('Puri (1 piece)',              'पुरी',                'bread',     135, 2.8, 17.0, 6.5, 0.8,  true, 'official'),
  ('Paratha (1 piece)',           'पराठा',               'bread',     185, 4.0, 24.0, 8.5, 1.5,  true, 'official'),
  ('Chapati (1 piece)',           'चपाती',               'bread',     104, 3.0, 20.0, 1.5, 2.0,  true, 'official'),

  -- Dairy & drinks
  ('Chiya (milk tea, 1 cup)',     'चिया',                'drink',      85, 2.5, 12.5, 3.0, 0.0,  true, 'official'),
  ('Masala Chiya',                'मसाला चिया',          'drink',      95, 2.5, 14.0, 3.5, 0.0,  true, 'official'),
  ('Lassi (sweet, 1 glass)',      'लस्सी',               'drink',     160, 5.5, 25.0, 5.0, 0.0,  true, 'official'),
  ('Dahi / Yogurt',               'दही',                 'dairy',      61, 3.5,  4.7, 3.3, 0.0,  true, 'official'),
  ('Paneer',                      'पनीर',                'dairy',     265, 18.3, 1.2, 21.0, 0.0, true, 'official'),
  ('Buffalo Milk (1 cup)',        'भैंसीको दूध',         'dairy',     110, 4.0, 10.5, 6.5, 0.0,  true, 'official'),

  -- Fruits
  ('Banana',                      'केरा',                'fruit',      89, 1.1, 23.0, 0.3, 2.6,  true, 'official'),
  ('Mango (1 medium)',            'आँप',                 'fruit',      60, 0.8, 15.0, 0.4, 1.6,  true, 'official'),
  ('Apple',                       'स्याउ',               'fruit',      52, 0.3, 14.0, 0.2, 2.4,  true, 'official'),
  ('Orange',                      'सुन्तला',             'fruit',      47, 0.9, 12.0, 0.1, 2.4,  true, 'official'),
  ('Papaya',                      'मेवा',                'fruit',      43, 0.5, 11.0, 0.3, 1.7,  true, 'official'),
  ('Guava',                       'अम्बा',               'fruit',      68, 2.6, 14.3, 1.0, 5.4,  true, 'official'),

  -- Vegetables
  ('Aloo Tarkari (potato curry)', 'आलुको तरकारी',       'curry',     140, 2.5, 24.0, 4.5, 2.0,  true, 'official'),
  ('Saag (spinach, cooked)',      'साग',                 'curry',      70, 4.0,  6.5, 2.5, 2.5,  true, 'official'),
  ('Cauliflower Curry',           'काउलीको तरकारी',     'curry',      90, 2.8, 12.0, 3.5, 2.8,  true, 'official'),
  ('Bitter Gourd (karela)',       'करेलाको तरकारी',     'curry',      60, 2.0,  8.5, 2.0, 3.5,  true, 'official'),

  -- Newari specialties
  ('Bara (plain)',                'बरा',                 'newari',    195, 7.0, 24.0, 8.5, 2.0,  true, 'official'),
  ('Chatamari',                   'चतांमरी',             'newari',    145, 5.5, 20.0, 5.5, 1.0,  true, 'official'),
  ('Kwati (sprouted bean soup)',  'क्वाँटी',             'dal',        95, 7.5, 14.0, 1.5, 3.5,  true, 'official'),

  -- Snacks & pickles
  ('Chiura (beaten rice)',        'चिउरा',               'snack',     350, 6.5, 77.0, 1.5, 1.5,  true, 'official'),
  ('Achar (tomato pickle)',       'अचार',                'pickle',     55, 1.5,  8.0, 2.0, 1.5,  true, 'official'),
  ('Wai Wai noodles (1 pack)',    'वाईवाई',              'snack',     428, 10.0, 58.0, 17.5, 2.0, true, 'official'),

  -- Grilled / tandoor
  ('Chicken Sekuwa',              'चिकन सेकुवा',         'grilled',   185, 28.5, 2.0, 7.0, 0.0,  true, 'official'),
  ('Buff (buffalo) Sekuwa',       'बफ सेकुवा',           'grilled',   210, 30.0, 1.5, 9.5, 0.0,  true, 'official'),

  -- Common staples
  ('Khichdi',                     'खिचडी',               'rice',      140, 5.5, 24.0, 3.0, 2.5,  true, 'official'),
  ('Thukpa (noodle soup)',        'थुक्पा',               'dal',        95, 4.5, 15.5, 1.5, 1.5,  true, 'official'),
  ('Dhido',                       'ढिडो',                'rice',      175, 4.0, 38.5, 1.0, 2.0,  true, 'official'),
  ('Gundruk (fermented veg)',     'गुन्द्रुक',            'fermented',  35, 3.5,  4.0, 0.8, 4.5,  true, 'official'),
  ('Buckwheat (phapar ko dhido)', 'फापरको ढिडो',          'rice',      155, 4.8, 32.0, 1.5, 2.8,  true, 'official'),
  ('Corn (roasted makai)',        'मकै',                 'snack',     365, 9.5, 73.0, 5.0, 7.0,  true, 'official')
ON CONFLICT DO NOTHING;

-- ── Add default portions for the most-used foods ──────────────────────────────

-- Dal Bhat Thali
INSERT INTO public.food_portions (food_id, label, label_ne, weight_g, calories, is_default)
SELECT id, 'Small thali',  'सानो थाली', 400, 520, false FROM public.foods WHERE name_en = 'Dal Bhat (full thali)'
UNION ALL
SELECT id, 'Medium thali', 'मध्यम थाली', 550, 715, true  FROM public.foods WHERE name_en = 'Dal Bhat (full thali)'
UNION ALL
SELECT id, 'Large thali',  'ठूलो थाली', 700, 910, false FROM public.foods WHERE name_en = 'Dal Bhat (full thali)'
ON CONFLICT DO NOTHING;

-- Momo (per 8 pieces = ~240g)
INSERT INTO public.food_portions (food_id, label, label_ne, weight_g, calories, is_default)
SELECT id, '4 pieces',  '४ वटा', 120, 48,  false FROM public.foods WHERE name_en = 'Momo (steamed, pork, 8 pcs)'
UNION ALL
SELECT id, '8 pieces',  '८ वटा', 240, 96,  true  FROM public.foods WHERE name_en = 'Momo (steamed, pork, 8 pcs)'
UNION ALL
SELECT id, '12 pieces', '१२ वटा', 360, 144, false FROM public.foods WHERE name_en = 'Momo (steamed, pork, 8 pcs)'
ON CONFLICT DO NOTHING;

-- Chiya (1 cup = 200ml)
INSERT INTO public.food_portions (food_id, label, label_ne, weight_g, calories, is_default)
SELECT id, '1 cup (small)',  'सानो कप',  150, 64,  false FROM public.foods WHERE name_en = 'Chiya (milk tea, 1 cup)'
UNION ALL
SELECT id, '1 cup (medium)', 'मध्यम कप', 200, 85,  true  FROM public.foods WHERE name_en = 'Chiya (milk tea, 1 cup)'
UNION ALL
SELECT id, '1 glass (large)','ठूलो गिलास', 300, 128, false FROM public.foods WHERE name_en = 'Chiya (milk tea, 1 cup)'
ON CONFLICT DO NOTHING;

-- ── Meal Templates ────────────────────────────────────────────────────────────

INSERT INTO public.meal_templates
  (name_en, name_ne, description, total_calories, total_protein_g, total_carbs_g, total_fat_g, meal_type)
VALUES
  ('Standard Dal Bhat Thali', 'दाल भात थाली', 'Dal, rice, tarkari, achar — the classic Nepali meal', 715, 24, 96, 14, 'lunch'),
  ('Chiya + Roti Breakfast',  'चिया र रोटी',  'Two rotis with milk tea', 290, 9, 55, 7, 'breakfast'),
  ('Momo Snack (8 pcs)',      '८ वटा मःमः',   'Steamed momo with achar', 105, 8, 14, 2, 'snack'),
  ('Chiura + Dahi',           'चिउरा दही',    'Beaten rice with yogurt', 220, 8, 48, 4, 'breakfast'),
  ('Egg + Roti Breakfast',    'अण्डा रोटी',   'Two boiled eggs with one roti', 430, 30, 23, 24, 'breakfast'),
  ('Dal Bhat + Chicken',      'दाल भात कुखुरा', 'Full thali with chicken curry side', 880, 42, 100, 23, 'dinner'),
  ('Sel Roti + Dahi',         'सेल रोटी दही', 'Two sel roti pieces with yogurt', 421, 10, 63, 15, 'snack'),
  ('Khichdi Bowl',            'खिचडी',        'Light rice and lentil porridge', 280, 11, 48, 6, 'dinner')
ON CONFLICT DO NOTHING;
