import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../food/presentation/providers/food_provider.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../../weight/presentation/providers/weight_provider.dart';
import '../../../workouts/presentation/providers/workout_provider.dart';
import '../widgets/calorie_ring.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    final summaryAsync = ref.watch(dailySummaryProvider);
    final firstName = ref.watch(profileNameProvider).split(' ').first;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.green,
          onRefresh: () async {
            ref.invalidate(todayLogsProvider);
            await ref.read(todayLogsProvider.future);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                _GreetingRow(name: firstName),
                const SizedBox(height: 8),

                // ── Calorie ring card ─────────────────────────────────────
                summaryAsync.when(
                  loading: () => AppCard(
                    padding: const EdgeInsets.fromLTRB(18, 22, 18, 18),
                    child: Column(
                      children: [
                        const CalorieRing(consumed: 0, target: 1800),
                        const SizedBox(height: 18),
                        _MacroRow(protein: 0, carbs: 0, fat: 0),
                      ],
                    ),
                  ),
                  error: (err, st) => AppCard(
                    child: Center(
                      child: Text('Could not load today\'s data.',
                          style: GoogleFonts.poppins(
                              fontSize: 13, color: AppColors.ink3)),
                    ),
                  ),
                  data: (summary) => AppCard(
                    padding: const EdgeInsets.fromLTRB(18, 22, 18, 18),
                    child: Column(
                      children: [
                        CalorieRing(
                          consumed: summary.consumed,
                          target: summary.target,
                        ),
                        const SizedBox(height: 18),
                        _MacroRow(
                          protein: summary.proteinG.round(),
                          carbs: summary.carbsG.round(),
                          fat: summary.fatG.round(),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ── Log Meal CTA ──────────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => context.push('/log?type=lunch'),
                    icon: const Icon(Icons.add, size: 20),
                    label: const Text('Log Meal'),
                  ),
                ),

                const SizedBox(height: 22),

                // ── Meals today ───────────────────────────────────────────
                _SectionLabel('Meals today'),
                summaryAsync.when(
                  loading: () => const _MealSlotsShimmer(),
                  error: (err, st) => const SizedBox.shrink(),
                  data: (summary) => AppCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        _MealSlot(
                          emoji: '🍳',
                          label: 'Breakfast',
                          logs: summary.forMeal('breakfast'),
                          onTap: () =>
                              context.push('/log?type=breakfast'),
                        ),
                        const Divider(height: 0, indent: 18, endIndent: 18),
                        _MealSlot(
                          emoji: '🍛',
                          label: 'Lunch',
                          logs: summary.forMeal('lunch'),
                          onTap: () =>
                              context.push('/log?type=lunch'),
                        ),
                        const Divider(height: 0, indent: 18, endIndent: 18),
                        _MealSlot(
                          emoji: '🌙',
                          label: 'Dinner',
                          logs: summary.forMeal('dinner'),
                          onTap: () =>
                              context.push('/log?type=dinner'),
                        ),
                        const Divider(height: 0, indent: 18, endIndent: 18),
                        _MealSlot(
                          emoji: '🍎',
                          label: 'Snacks',
                          logs: summary.forMeal('snack'),
                          onTap: () =>
                              context.push('/log?type=snack'),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                // ── Today's workout card ──────────────────────────────────
                _SectionLabel("Today's workout"),
                _WorkoutCard(),

                const SizedBox(height: 14),

                // ── Water + Weight ────────────────────────────────────────
                Row(
                  children: [
                    Expanded(child: _WaterCard()),
                    const SizedBox(width: 14),
                    const Expanded(child: _WeightCard()),
                  ],
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Greeting ──────────────────────────────────────────────────────────────────

class _GreetingRow extends StatelessWidget {
  final String name;
  const _GreetingRow({required this.name});

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning 🌄';
    if (h < 17) return 'Good afternoon ☀️';
    return 'Good evening 🌙';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_greeting,
                  style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppColors.ink2,
                      fontWeight: FontWeight.w500)),
              Text(name,
                  style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.3,
                      color: AppColors.ink)),
            ],
          ),
        ),
        Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
              color: AppColors.greenSoft, shape: BoxShape.circle),
          child: Center(
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : 'U',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: AppColors.green,
                  fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Macros ────────────────────────────────────────────────────────────────────

class _MacroRow extends StatelessWidget {
  final int protein;
  final int carbs;
  final int fat;
  const _MacroRow(
      {required this.protein, required this.carbs, required this.fat});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _MacroPill(label: 'CARBS', value: '${carbs}g', dot: AppColors.saffron),
        const SizedBox(width: 9),
        _MacroPill(
            label: 'PROTEIN', value: '${protein}g', dot: AppColors.success),
        const SizedBox(width: 9),
        _MacroPill(label: 'FAT', value: '${fat}g', dot: AppColors.error),
      ],
    );
  }
}

class _MacroPill extends StatelessWidget {
  final String label;
  final String value;
  final Color dot;
  const _MacroPill(
      {required this.label, required this.value, required this.dot});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 6),
        decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.line)),
        child: Column(
          children: [
            Container(
                width: 7,
                height: 7,
                decoration:
                    BoxDecoration(color: dot, shape: BoxShape.circle)),
            const SizedBox(height: 2),
            Text(value,
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink)),
            Text(label,
                style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColors.ink3,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.4)),
          ],
        ),
      ),
    );
  }
}

// ── Meal slots ────────────────────────────────────────────────────────────────

class _MealSlot extends StatelessWidget {
  final String emoji;
  final String label;
  final List<dynamic> logs;
  final VoidCallback onTap;
  const _MealSlot(
      {required this.emoji,
      required this.label,
      required this.logs,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final logged = logs.isNotEmpty;
    final totalCal =
        logs.fold<double>(0, (s, l) => s + (l.caloriesConfirmed as double));
    final sub = logged
        ? logs.map((l) => l.foodName as String? ?? 'food').join(', ')
        : 'Not logged';

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                  color: logged
                      ? AppColors.successSoft
                      : AppColors.bg,
                  borderRadius: BorderRadius.circular(13)),
              child: Center(
                  child: Text(emoji,
                      style: const TextStyle(fontSize: 20))),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: GoogleFonts.poppins(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.ink)),
                  Text(
                    sub,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                        fontSize: 12.5, color: AppColors.ink3),
                  ),
                ],
              ),
            ),
            if (logged) ...[
              Text('${totalCal.round()}',
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink2)),
              const SizedBox(width: 10),
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                    color: AppColors.success, shape: BoxShape.circle),
                child: const Icon(Icons.check,
                    color: Colors.white, size: 14),
              ),
            ] else
              Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                    color: AppColors.saffronSoft,
                    shape: BoxShape.circle),
                child: const Icon(Icons.add,
                    color: AppColors.saffron, size: 16),
              ),
          ],
        ),
      ),
    );
  }
}

class _MealSlotsShimmer extends StatelessWidget {
  const _MealSlotsShimmer();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: List.generate(
          4,
          (i) => Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              children: [
                Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                        color: AppColors.line,
                        borderRadius: BorderRadius.circular(13))),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          height: 13,
                          width: 80,
                          color: AppColors.line),
                      const SizedBox(height: 5),
                      Container(
                          height: 11,
                          width: 120,
                          color: AppColors.line2),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Workout card ──────────────────────────────────────────────────────────────

class _WorkoutCard extends ConsumerWidget {
  const _WorkoutCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planAsync = ref.watch(recommendedPlanProvider);

    return planAsync.when(
      loading: () => _WorkoutCardShell(
        title: 'Loading...',
        subtitle: '',
        onStart: null,
      ),
      error: (err, st) => _WorkoutCardShell(
        title: 'Workout',
        subtitle: 'Tap to browse plans',
        onStart: () => context.push('/workouts'),
      ),
      data: (plan) => _WorkoutCardShell(
        title: plan?.name ?? 'Home Full Body',
        subtitle: [
          if ((plan?.durationWeeks ?? 0) > 0)
            '${plan!.durationWeeks} weeks',
          if (plan?.level != null)
            plan!.level![0].toUpperCase() + plan.level!.substring(1),
        ].join(' · '),
        onStart: () async {
          if (plan != null) {
            await ref
                .read(workoutSessionNotifierProvider.notifier)
                .startSession(plan);
          }
          if (context.mounted) context.push('/workouts/session');
        },
      ),
    );
  }
}

class _WorkoutCardShell extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onStart;
  const _WorkoutCardShell(
      {required this.title,
      required this.subtitle,
      required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.green, Color(0xFF245741)]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.shadowGreen,
      ),
      padding: const EdgeInsets.all(18),
      child: Stack(
        children: [
          Positioned(
            right: -40,
            bottom: -50,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppColors.saffron.withValues(alpha: 0.32),
                  Colors.transparent
                ]),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('RECOMMENDED',
                  style: GoogleFonts.poppins(
                      fontSize: 11,
                      letterSpacing: 0.8,
                      fontWeight: FontWeight.w600,
                      color: AppColors.greenOnDark)),
              const SizedBox(height: 5),
              Text(title,
                  style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
              if (subtitle.isNotEmpty)
                Text(subtitle,
                    style: GoogleFonts.poppins(
                        fontSize: 12.5,
                        color:
                            Colors.white.withValues(alpha: 0.72))),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onStart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.saffron,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.play_arrow, size: 16),
                  label: Text('Start Workout',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.5)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Water & Weight ────────────────────────────────────────────────────────────

class _WaterCard extends StatefulWidget {
  @override
  State<_WaterCard> createState() => _WaterCardState();
}

class _WaterCardState extends State<_WaterCard> {
  int _filled = 0;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Water',
                  style: GoogleFonts.poppins(
                      fontSize: 15, fontWeight: FontWeight.w600)),
              Text('$_filled / 8',
                  style: GoogleFonts.poppins(
                      fontSize: 12, color: AppColors.ink3)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(4, (i) {
              final isFilled = i < _filled;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() {
                    _filled = (_filled == i + 1) ? i : i + 1;
                  }),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Container(
                      height: 32,
                      decoration: BoxDecoration(
                        color: isFilled
                            ? AppColors.greenSoft
                            : AppColors.bg,
                        borderRadius: BorderRadius.circular(11),
                        border: isFilled
                            ? null
                            : Border.all(color: AppColors.line2),
                      ),
                      child: Center(
                          child: Icon(Icons.water_drop,
                              size: 16,
                              color: isFilled
                                  ? AppColors.green
                                  : AppColors.line2)),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _WeightCard extends ConsumerWidget {
  const _WeightCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(weightLogsProvider);

    return logsAsync.when(
      loading: () => AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Weight',
                style: GoogleFonts.poppins(
                    fontSize: 15, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Text('—', style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.ink)),
            Text('loading...', style: GoogleFonts.poppins(fontSize: 11.5, color: AppColors.ink3)),
          ],
        ),
      ),
      error: (err, st) => AppCard(
        child: Text('Weight', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600)),
      ),
      data: (logs) {
        final latest = logs.isNotEmpty ? logs.first : null;
        final prev = logs.length > 1 ? logs[1] : null;
        final delta = (latest != null && prev != null)
            ? latest.weightKg - prev.weightKg
            : null;
        final deltaStr = delta == null
            ? null
            : '${delta >= 0 ? "↑" : "↓"} ${delta.abs().toStringAsFixed(1)}';
        final deltaColor = delta == null
            ? AppColors.ink3
            : delta < 0
                ? AppColors.success
                : AppColors.error;

        return GestureDetector(
          onTap: () => _showWeightSheet(context, ref),
          child: AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Weight',
                        style: GoogleFonts.poppins(
                            fontSize: 15, fontWeight: FontWeight.w600)),
                    if (deltaStr != null)
                      Text(deltaStr,
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: deltaColor)),
                  ],
                ),
                const SizedBox(height: 6),
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                        color: AppColors.ink),
                    children: [
                      TextSpan(
                          text: latest != null
                              ? latest.weightKg.toStringAsFixed(1)
                              : '—'),
                      TextSpan(
                          text: ' kg',
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: AppColors.ink3,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                Text(
                  latest != null ? 'tap to update' : 'tap to log weight',
                  style: GoogleFonts.poppins(
                      fontSize: 11.5, color: AppColors.ink3),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showWeightSheet(BuildContext context, WidgetRef ref) {
    final ctrl = TextEditingController();
    final logs = ref.read(weightLogsProvider).valueOrNull;
    final latest = logs?.isNotEmpty == true ? logs!.first : null;
    if (latest != null) {
      ctrl.text = latest.weightKg.toStringAsFixed(1);
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => _WeightLogSheet(ctrl: ctrl, ref: ref),
    );
  }
}

class _WeightLogSheet extends ConsumerStatefulWidget {
  final TextEditingController ctrl;
  final WidgetRef ref;
  const _WeightLogSheet({required this.ctrl, required this.ref});

  @override
  ConsumerState<_WeightLogSheet> createState() => _WeightLogSheetState();
}

class _WeightLogSheetState extends ConsumerState<_WeightLogSheet> {
  bool _saving = false;
  bool _saved = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Today's weight",
              style: GoogleFonts.poppins(
                  fontSize: 17, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          TextFormField(
            controller: widget.ctrl,
            autofocus: true,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              hintText: '72.4',
              suffixText: 'kg',
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: _saved
                ? Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                        color: AppColors.successSoft,
                        borderRadius: BorderRadius.circular(14)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle,
                            color: AppColors.success, size: 20),
                        const SizedBox(width: 8),
                        Text('Saved!',
                            style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.success)),
                      ],
                    ),
                  )
                : ElevatedButton(
                    onPressed: _saving ? null : _save,
                    child: _saving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : const Text('Save'),
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    final val = double.tryParse(widget.ctrl.text.trim());
    if (val == null || val <= 0) return;
    setState(() => _saving = true);
    final ok = await ref
        .read(weightLogNotifierProvider.notifier)
        .logWeight(val);
    if (!mounted) return;
    if (ok) {
      setState(() {
        _saving = false;
        _saved = true;
      });
      await Future.delayed(const Duration(milliseconds: 900));
      if (mounted) Navigator.pop(context);
    } else {
      setState(() => _saving = false);
    }
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(text,
          style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.ink2,
              letterSpacing: 0.2)),
    );
  }
}
