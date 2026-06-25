import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/calorie_calculator.dart';
import '../providers/onboarding_provider.dart';

// Simple in-memory model to pass between steps
class OnboardingData {
  String name = '';
  int age = 25;
  String gender = 'male'; // male / female / other
  double heightCm = 165;
  bool heightInFeet = false;
  double weightKg = 65;
  bool weightInLbs = false;
  String goal = 'lose'; // lose / gain / maintain
  String activity = 'moderate'; // sedentary / light / moderate / active / very_active
  String workoutPref = 'home'; // gym / home / both
}

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _step = 0;
  final _data = OnboardingData();
  final PageController _pageCtrl = PageController();

  static const _totalSteps = 8;

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.poppins(fontSize: 13.5)),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<void> _next() async {
    // Step 0 is the name — require a non-empty value before continuing.
    if (_step == 0 && _data.name.trim().isEmpty) {
      _showSnack('Please enter your name to continue.');
      return;
    }
    if (_step < _totalSteps - 1) {
      setState(() => _step++);
      _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeInOut,
      );
    } else {
      await _finish();
    }
  }

  void _back() {
    if (_step > 0) {
      setState(() => _step--);
      _pageCtrl.previousPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeInOut,
      );
    } else {
      context.go('/welcome');
    }
  }

  Future<void> _finish() async {
    final bmr = CalorieCalculator.bmr(
      _data.weightKg,
      _data.heightCm,
      _data.age,
      _data.gender,
    );
    final tdee = CalorieCalculator.tdee(bmr, _data.activity);
    final calories = CalorieCalculator.dailyTarget(tdee, _data.goal);
    final macros = CalorieCalculator.macros(calories, _data.goal);
    final bmiVal = CalorieCalculator.bmi(_data.weightKg, _data.heightCm / 100);
    final bmiCat = CalorieCalculator.bmiCategory(_data.weightKg, _data.heightCm / 100);

    // Save profile to Supabase (non-blocking — navigate immediately,
    // save happens in background; calorie-goal screen shows the result)
    ref.read(onboardingNotifierProvider.notifier).saveProfile(
      name: _data.name,
      age: _data.age,
      gender: _data.gender,
      heightCm: _data.heightCm,
      weightKg: _data.weightKg,
      goal: _data.goal,
      activityLevel: _data.activity,
      workoutPref: _data.workoutPref,
      dailyCalories: calories,
      macros: macros,
    );

    if (!mounted) return;
    context.go('/calorie-goal', extra: {
      'name': _data.name,
      'calories': calories,
      'macros': macros,
      'bmi': bmiVal,
      'bmiCategory': bmiCat,
      'goal': _data.goal,
      'weightKg': _data.weightKg,
    });
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(step: _step, total: _totalSteps, onBack: _back),
            Expanded(
              child: PageView(
                controller: _pageCtrl,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _NameStep(data: _data),
                  _AgeStep(data: _data),
                  _GenderStep(data: _data),
                  _HeightStep(data: _data),
                  _WeightStep(data: _data),
                  _GoalStep(data: _data),
                  _ActivityStep(data: _data),
                  _WorkoutPrefStep(data: _data),
                ],
              ),
            ),
            _BottomBar(
              step: _step,
              total: _totalSteps,
              onNext: _next,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Top bar with progress ───────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final int step;
  final int total;
  final VoidCallback onBack;
  const _TopBar({required this.step, required this.total, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 20, 0),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                color: AppColors.ink2,
                onPressed: onBack,
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    value: (step + 1) / total,
                    minHeight: 5,
                    backgroundColor: AppColors.line2,
                    valueColor: const AlwaysStoppedAnimation(AppColors.green),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${step + 1}/$total',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: AppColors.ink3,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Bottom bar with Next button ─────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  final int step;
  final int total;
  final VoidCallback onNext;
  const _BottomBar({required this.step, required this.total, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onNext,
          child: Text(
            step == total - 1 ? 'See my plan →' : 'Continue',
          ),
        ),
      ),
    );
  }
}

// ─── Step container ───────────────────────────────────────────────────────────

class _StepContainer extends StatelessWidget {
  final String question;
  final String? subtitle;
  final Widget child;
  const _StepContainer({required this.question, this.subtitle, required this.child});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 28),
          Text(
            question,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
              height: 1.2,
              color: AppColors.ink,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 6),
            Text(
              subtitle!,
              style: GoogleFonts.poppins(fontSize: 14, color: AppColors.ink2),
            ),
          ],
          const SizedBox(height: 32),
          child,
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─── Option chip ─────────────────────────────────────────────────────────────

class _OptionChip extends StatelessWidget {
  final String label;
  final String? sub;
  final String? emoji;
  final bool selected;
  final VoidCallback onTap;
  const _OptionChip({
    required this.label,
    this.sub,
    this.emoji,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? AppColors.greenSoft : AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.green : AppColors.line2,
            width: selected ? 2 : 1.5,
          ),
        ),
        child: Row(
          children: [
            if (emoji != null) ...[
              Text(emoji!, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 14),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: selected ? AppColors.green : AppColors.ink,
                    ),
                  ),
                  if (sub != null)
                    Text(
                      sub!,
                      style: GoogleFonts.poppins(fontSize: 12.5, color: AppColors.ink2),
                    ),
                ],
              ),
            ),
            if (selected)
              Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  color: AppColors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, size: 14, color: Colors.white),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Step 1: Name ─────────────────────────────────────────────────────────────

class _NameStep extends StatefulWidget {
  final OnboardingData data;
  const _NameStep({required this.data});

  @override
  State<_NameStep> createState() => _NameStepState();
}

class _NameStepState extends State<_NameStep> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.data.name);
    _ctrl.addListener(() => widget.data.name = _ctrl.text);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _StepContainer(
      question: "What's your name?",
      child: TextFormField(
        controller: _ctrl,
        autofocus: true,
        textCapitalization: TextCapitalization.words,
        style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: 'Your name',
          prefixIcon: const Icon(Icons.person_outline, color: AppColors.ink3, size: 20),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}

// ─── Step 2: Age ──────────────────────────────────────────────────────────────

class _AgeStep extends StatefulWidget {
  final OnboardingData data;
  const _AgeStep({required this.data});

  @override
  State<_AgeStep> createState() => _AgeStepState();
}

class _AgeStepState extends State<_AgeStep> {
  late int _age;

  @override
  void initState() {
    super.initState();
    _age = widget.data.age;
  }

  @override
  Widget build(BuildContext context) {
    return _StepContainer(
      question: 'How old are you?',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _NudgeBtn(
            icon: Icons.remove,
            onTap: () {
              if (_age > 10) setState(() => widget.data.age = --_age);
            },
          ),
          const SizedBox(width: 24),
          Column(
            children: [
              Text(
                '$_age',
                style: GoogleFonts.poppins(
                  fontSize: 64,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -2,
                  color: AppColors.ink,
                ),
              ),
              Text(
                'years old',
                style: GoogleFonts.poppins(fontSize: 14, color: AppColors.ink3),
              ),
            ],
          ),
          const SizedBox(width: 24),
          _NudgeBtn(
            icon: Icons.add,
            onTap: () {
              if (_age < 100) setState(() => widget.data.age = ++_age);
            },
          ),
        ],
      ),
    );
  }
}

class _NudgeBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _NudgeBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.line2, width: 1.5),
        ),
        child: Icon(icon, color: AppColors.green, size: 24),
      ),
    );
  }
}

// ─── Step 3: Gender ───────────────────────────────────────────────────────────

class _GenderStep extends StatefulWidget {
  final OnboardingData data;
  const _GenderStep({required this.data});

  @override
  State<_GenderStep> createState() => _GenderStepState();
}

class _GenderStepState extends State<_GenderStep> {
  late String _gender;

  @override
  void initState() {
    super.initState();
    _gender = widget.data.gender;
  }

  void _select(String v) => setState(() => widget.data.gender = _gender = v);

  @override
  Widget build(BuildContext context) {
    return _StepContainer(
      question: "What's your gender?",
      subtitle: 'Used for accurate calorie calculation',
      child: Column(
        children: [
          _OptionChip(label: 'Male', emoji: '♂️', selected: _gender == 'male', onTap: () => _select('male')),
          _OptionChip(label: 'Female', emoji: '♀️', selected: _gender == 'female', onTap: () => _select('female')),
          _OptionChip(label: 'Other', emoji: '⚧️', selected: _gender == 'other', onTap: () => _select('other')),
        ],
      ),
    );
  }
}

// ─── Step 4: Height ───────────────────────────────────────────────────────────

class _HeightStep extends StatefulWidget {
  final OnboardingData data;
  const _HeightStep({required this.data});

  @override
  State<_HeightStep> createState() => _HeightStepState();
}

class _HeightStepState extends State<_HeightStep> {
  late double _cm;
  late bool _inFeet;

  @override
  void initState() {
    super.initState();
    _cm = widget.data.heightCm;
    _inFeet = widget.data.heightInFeet;
  }

  double get _feet => _cm / 30.48;
  int get _ft => _feet.floor();
  int get _in => ((_feet - _ft) * 12).round();

  String get _display => _inFeet ? "$_ft' $_in\"" : '${_cm.round()} cm';

  @override
  Widget build(BuildContext context) {
    return _StepContainer(
      question: 'How tall are you?',
      child: Column(
        children: [
          _UnitToggle(
            leftLabel: 'cm',
            rightLabel: 'ft / in',
            useRight: _inFeet,
            onToggle: () => setState(() {
              _inFeet = !_inFeet;
              widget.data.heightInFeet = _inFeet;
            }),
          ),
          const SizedBox(height: 28),
          Text(
            _display,
            style: GoogleFonts.poppins(
              fontSize: 52,
              fontWeight: FontWeight.w700,
              letterSpacing: -2,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 24),
          Slider(
            value: _cm,
            min: 100,
            max: 230,
            divisions: 130,
            activeColor: AppColors.green,
            inactiveColor: AppColors.greenSoft,
            onChanged: (v) => setState(() {
              _cm = v;
              widget.data.heightCm = v;
            }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('100 cm', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.ink3)),
              Text('230 cm', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.ink3)),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Step 5: Weight ───────────────────────────────────────────────────────────

class _WeightStep extends StatefulWidget {
  final OnboardingData data;
  const _WeightStep({required this.data});

  @override
  State<_WeightStep> createState() => _WeightStepState();
}

class _WeightStepState extends State<_WeightStep> {
  late double _kg;
  late bool _inLbs;

  @override
  void initState() {
    super.initState();
    _kg = widget.data.weightKg;
    _inLbs = widget.data.weightInLbs;
  }

  double get _displayVal => _inLbs ? _kg * 2.20462 : _kg;
  String get _displayUnit => _inLbs ? 'lbs' : 'kg';

  @override
  Widget build(BuildContext context) {
    return _StepContainer(
      question: 'How much do you weigh?',
      child: Column(
        children: [
          _UnitToggle(
            leftLabel: 'kg',
            rightLabel: 'lbs',
            useRight: _inLbs,
            onToggle: () => setState(() {
              _inLbs = !_inLbs;
              widget.data.weightInLbs = _inLbs;
            }),
          ),
          const SizedBox(height: 28),
          RichText(
            text: TextSpan(
              style: GoogleFonts.poppins(
                fontSize: 52,
                fontWeight: FontWeight.w700,
                letterSpacing: -2,
                color: AppColors.ink,
              ),
              children: [
                TextSpan(text: _displayVal.toStringAsFixed(1)),
                TextSpan(
                  text: ' $_displayUnit',
                  style: GoogleFonts.poppins(fontSize: 22, color: AppColors.ink3, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Slider(
            value: _kg,
            min: 30,
            max: 200,
            divisions: 340,
            activeColor: AppColors.saffron,
            inactiveColor: AppColors.saffronSoft,
            onChanged: (v) => setState(() {
              _kg = v;
              widget.data.weightKg = v;
            }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('30 kg', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.ink3)),
              Text('200 kg', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.ink3)),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Step 6: Goal ─────────────────────────────────────────────────────────────

class _GoalStep extends StatefulWidget {
  final OnboardingData data;
  const _GoalStep({required this.data});

  @override
  State<_GoalStep> createState() => _GoalStepState();
}

class _GoalStepState extends State<_GoalStep> {
  late String _goal;

  @override
  void initState() {
    super.initState();
    _goal = widget.data.goal;
  }

  void _select(String v) => setState(() => widget.data.goal = _goal = v);

  @override
  Widget build(BuildContext context) {
    return _StepContainer(
      question: "What's your main goal?",
      child: Column(
        children: [
          _OptionChip(
            label: 'Lose weight',
            sub: 'Burn fat, improve fitness',
            emoji: '🔥',
            selected: _goal == 'lose',
            onTap: () => _select('lose'),
          ),
          _OptionChip(
            label: 'Build muscle',
            sub: 'Gain strength and mass',
            emoji: '💪',
            selected: _goal == 'gain',
            onTap: () => _select('gain'),
          ),
          _OptionChip(
            label: 'Stay healthy',
            sub: 'Maintain weight and energy',
            emoji: '🌿',
            selected: _goal == 'maintain',
            onTap: () => _select('maintain'),
          ),
        ],
      ),
    );
  }
}

// ─── Step 7: Activity ─────────────────────────────────────────────────────────

class _ActivityStep extends StatefulWidget {
  final OnboardingData data;
  const _ActivityStep({required this.data});

  @override
  State<_ActivityStep> createState() => _ActivityStepState();
}

class _ActivityStepState extends State<_ActivityStep> {
  late String _activity;

  @override
  void initState() {
    super.initState();
    _activity = widget.data.activity;
  }

  void _select(String v) => setState(() => widget.data.activity = _activity = v);

  @override
  Widget build(BuildContext context) {
    return _StepContainer(
      question: 'How active are you?',
      subtitle: 'Outside of planned exercise',
      child: Column(
        children: [
          _OptionChip(label: 'Sedentary', sub: 'Desk job, mostly sitting', emoji: '🪑', selected: _activity == 'sedentary', onTap: () => _select('sedentary')),
          _OptionChip(label: 'Lightly active', sub: '1–3 days of light activity', emoji: '🚶', selected: _activity == 'light', onTap: () => _select('light')),
          _OptionChip(label: 'Moderately active', sub: '3–5 days per week', emoji: '🏃', selected: _activity == 'moderate', onTap: () => _select('moderate')),
          _OptionChip(label: 'Very active', sub: '6–7 days hard training', emoji: '⚡', selected: _activity == 'active', onTap: () => _select('active')),
          _OptionChip(label: 'Athlete', sub: 'Training twice a day', emoji: '🏆', selected: _activity == 'very_active', onTap: () => _select('very_active')),
        ],
      ),
    );
  }
}

// ─── Step 8: Workout preference ───────────────────────────────────────────────

class _WorkoutPrefStep extends StatefulWidget {
  final OnboardingData data;
  const _WorkoutPrefStep({required this.data});

  @override
  State<_WorkoutPrefStep> createState() => _WorkoutPrefStepState();
}

class _WorkoutPrefStepState extends State<_WorkoutPrefStep> {
  late String _pref;

  @override
  void initState() {
    super.initState();
    _pref = widget.data.workoutPref;
  }

  void _select(String v) => setState(() => widget.data.workoutPref = _pref = v);

  @override
  Widget build(BuildContext context) {
    return _StepContainer(
      question: 'Where do you prefer to work out?',
      child: Column(
        children: [
          _OptionChip(
            label: 'At home',
            sub: 'No equipment needed',
            emoji: '🏠',
            selected: _pref == 'home',
            onTap: () => _select('home'),
          ),
          _OptionChip(
            label: 'At the gym',
            sub: 'Full equipment access',
            emoji: '🏋️',
            selected: _pref == 'gym',
            onTap: () => _select('gym'),
          ),
          _OptionChip(
            label: 'Both',
            sub: "Mix depending on the day",
            emoji: '🔄',
            selected: _pref == 'both',
            onTap: () => _select('both'),
          ),
        ],
      ),
    );
  }
}

// ─── Shared: Unit toggle ──────────────────────────────────────────────────────

class _UnitToggle extends StatelessWidget {
  final String leftLabel;
  final String rightLabel;
  final bool useRight;
  final VoidCallback onToggle;
  const _UnitToggle({
    required this.leftLabel,
    required this.rightLabel,
    required this.useRight,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onToggle,
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.line2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ToggleTab(label: leftLabel, active: !useRight),
              _ToggleTab(label: rightLabel, active: useRight),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToggleTab extends StatelessWidget {
  final String label;
  final bool active;
  const _ToggleTab({required this.label, required this.active});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: active ? AppColors.green : Colors.transparent,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
          color: active ? Colors.white : AppColors.ink3,
        ),
      ),
    );
  }
}
