import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/settings/settings_provider.dart';
import '../../../../core/utils/units.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../food/presentation/providers/food_provider.dart';
import '../../../weight/presentation/providers/weight_provider.dart';
import '../../../profile/presentation/providers/profile_provider.dart';

class ProgressScreen extends ConsumerStatefulWidget {
  const ProgressScreen({super.key});

  @override
  ConsumerState<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends ConsumerState<ProgressScreen> {
  String _weightRange = '7d';

  @override
  Widget build(BuildContext context) {
    final weightLogsAsync = ref.watch(weightLogsProvider);
    final calorieHistoryAsync = ref.watch(calorieHistoryProvider);
    final calorieTarget = ref.watch(dailyCalorieTargetProvider);
    final useLbs = ref.watch(appSettingsProvider).useLbs;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('Progress')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Summary row ───────────────────────────────────────────────
            weightLogsAsync.when(
              loading: () => const SizedBox(height: 80),
              error: (err, st) => const SizedBox.shrink(),
              data: (logs) {
                // Compute week delta
                final now = DateTime.now();
                final weekAgo = now.subtract(const Duration(days: 7));
                final weekLogs = logs
                    .where((l) => l.loggedAt.isAfter(weekAgo))
                    .toList();
                final latest = logs.isNotEmpty ? logs.first : null;
                final weekStart =
                    weekLogs.isNotEmpty ? weekLogs.last : null;
                final weekDelta = (latest != null && weekStart != null)
                    ? latest.weightKg - weekStart.weightKg
                    : null;
                final weekStr = weekDelta == null
                    ? '—'
                    : '${weekDelta >= 0 ? "+" : ""}${kgToDisplay(weekDelta, useLbs).toStringAsFixed(1)} ${weightUnit(useLbs)}';
                final weekColor = weekDelta == null
                    ? AppColors.ink3
                    : weekDelta < 0
                        ? AppColors.success
                        : AppColors.error;

                return Row(
                  children: [
                    _SummaryCard(
                        label: 'This week',
                        value: weekStr,
                        sub: 'weight change',
                        color: weekColor),
                    const SizedBox(width: 12),
                    _SummaryCard(
                        label: 'Current',
                        value: latest != null
                            ? formatWeight(latest.weightKg, useLbs)
                            : '—',
                        sub: 'body weight',
                        color: AppColors.green),
                    const SizedBox(width: 12),
                    calorieHistoryAsync.when(
                      loading: () => const Expanded(child: SizedBox()),
                      error: (err, st) => const Expanded(child: SizedBox()),
                      data: (history) {
                        final avg = history.isEmpty
                            ? 0
                            : history.fold<int>(
                                    0,
                                    (s, d) =>
                                        s + (d['calories'] as int)) ~/
                                history.length;
                        return _SummaryCard(
                            label: 'Avg calories',
                            value: '$avg',
                            sub: 'kcal / day',
                            color: AppColors.saffron);
                      },
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 20),

            // ── Weight trend ──────────────────────────────────────────────
            AppCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Weight trend',
                          style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600)),
                      _RangeSelector(
                        selected: _weightRange,
                        options: const ['7d', '30d', '90d'],
                        onSelect: (v) =>
                            setState(() => _weightRange = v),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  weightLogsAsync.when(
                    loading: () => const SizedBox(
                        height: 100,
                        child: Center(
                            child: CircularProgressIndicator(
                                color: AppColors.green))),
                    error: (err, st) => const SizedBox(height: 60),
                    data: (logs) {
                      final days = _weightRange == '7d'
                          ? 7
                          : _weightRange == '30d'
                              ? 30
                              : 90;
                      final cutoff = DateTime.now()
                          .subtract(Duration(days: days));
                      final filtered = logs
                          .where((l) => l.loggedAt.isAfter(cutoff))
                          .toList()
                        ..sort((a, b) =>
                            a.loggedAt.compareTo(b.loggedAt));

                      if (filtered.isEmpty) {
                        return SizedBox(
                          height: 100,
                          child: Center(
                            child: Text('No weight data yet.',
                                style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: AppColors.ink3)),
                          ),
                        );
                      }

                      final weights =
                          filtered.map((l) => l.weightKg).toList();
                      final minW = weights.reduce(
                              (a, b) => a < b ? a : b) -
                          0.5;
                      final maxW = weights.reduce(
                              (a, b) => a > b ? a : b) +
                          0.5;
                      final start = filtered.first;
                      final end = filtered.last;
                      final delta = end.weightKg - start.weightKg;

                      return Column(
                        children: [
                          _WeightGraph(
                              weights: weights, minW: minW, maxW: maxW),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  formatWeight(start.weightKg, useLbs),
                                  style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: AppColors.ink3)),
                              Row(
                                children: [
                                  Icon(
                                    delta <= 0
                                        ? Icons.arrow_downward
                                        : Icons.arrow_upward,
                                    size: 14,
                                    color: delta <= 0
                                        ? AppColors.success
                                        : AppColors.error,
                                  ),
                                  Text(
                                    '${kgToDisplay(delta.abs(), useLbs).toStringAsFixed(1)} ${weightUnit(useLbs)}',
                                    style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: delta <= 0
                                            ? AppColors.success
                                            : AppColors.error,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              Text(
                                  formatWeight(end.weightKg, useLbs),
                                  style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: AppColors.ink3)),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ── Calorie history ───────────────────────────────────────────
            AppCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Calorie history',
                      style: GoogleFonts.poppins(
                          fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 14),
                  calorieHistoryAsync.when(
                    loading: () => const SizedBox(
                        height: 120,
                        child: Center(
                            child: CircularProgressIndicator(
                                color: AppColors.green))),
                    error: (err, st) => const SizedBox.shrink(),
                    data: (history) {
                      if (history.isEmpty) {
                        return SizedBox(
                          height: 100,
                          child: Center(
                            child: Text('Log some meals to see history.',
                                style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: AppColors.ink3)),
                          ),
                        );
                      }
                      return _CalorieBarChart(
                          history: history, target: calorieTarget);
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                              color: AppColors.green,
                              borderRadius: BorderRadius.circular(3))),
                      const SizedBox(width: 5),
                      Text('Consumed',
                          style: GoogleFonts.poppins(
                              fontSize: 11.5, color: AppColors.ink2)),
                      const SizedBox(width: 14),
                      Container(width: 10, height: 2, color: AppColors.line2),
                      const SizedBox(width: 5),
                      Text('Target ($calorieTarget kcal)',
                          style: GoogleFonts.poppins(
                              fontSize: 11.5, color: AppColors.ink2)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ── Goal progress ─────────────────────────────────────────────
            _GoalProgressCard(),

            const SizedBox(height: 14),

            // ── Log weight button ─────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showWeightSheet(context),
                icon: const Icon(Icons.monitor_weight_outlined, size: 18),
                label: const Text("Log today's weight"),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showWeightSheet(BuildContext context) {
    final useLbs = ref.read(appSettingsProvider).useLbs;
    final logs = ref.read(weightLogsProvider).valueOrNull;
    final latest = logs?.isNotEmpty == true ? logs!.first : null;
    final ctrl = TextEditingController(
        text: latest != null
            ? kgToDisplay(latest.weightKg, useLbs).toStringAsFixed(1)
            : '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _WeightLogSheet(ctrl: ctrl),
    );
  }
}

// ── Weight log bottom sheet ───────────────────────────────────────────────────

class _WeightLogSheet extends ConsumerStatefulWidget {
  final TextEditingController ctrl;
  const _WeightLogSheet({required this.ctrl});

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
            decoration: InputDecoration(
              hintText: '72.4',
              suffixText: weightUnit(ref.watch(appSettingsProvider).useLbs),
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
                                strokeWidth: 2,
                                color: Colors.white))
                        : const Text('Save'),
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    final entered = double.tryParse(widget.ctrl.text.trim());
    if (entered == null || entered <= 0) return;
    // Input is in the user's display unit — convert back to kg for storage.
    final useLbs = ref.read(appSettingsProvider).useLbs;
    final val = displayToKg(entered, useLbs);
    setState(() => _saving = true);
    final ok =
        await ref.read(weightLogNotifierProvider.notifier).logWeight(val);
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

// ── Goal progress ─────────────────────────────────────────────────────────────

class _GoalProgressCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(weightLogsProvider);
    final goalAsync = ref.watch(activeGoalProvider);
    final useLbs = ref.watch(appSettingsProvider).useLbs;

    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Goal progress',
              style: GoogleFonts.poppins(
                  fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 14),
          logsAsync.when(
            loading: () => const SizedBox(height: 50),
            error: (err, st) => const SizedBox.shrink(),
            data: (logs) {
              final goalRow = goalAsync.valueOrNull;
              if (logs.isEmpty || goalRow == null) {
                return Text('Log your weight to track goal progress.',
                    style: GoogleFonts.poppins(
                        fontSize: 13, color: AppColors.ink3));
              }

              final current = logs.first.weightKg;
              final goalType = goalRow['goal_type'] as String? ?? 'maintain';
              // start_weight_kg is captured once at onboarding and never
              // overwritten, so progress actually moves as the user loses/gains.
              final start =
                  (goalRow['start_weight_kg'] as num?)?.toDouble() ?? current;
              // Use the stored target if set, else a sensible heuristic.
              final targetWeight =
                  (goalRow['target_weight_kg'] as num?)?.toDouble() ??
                      (goalType == 'lose'
                          ? start - 5.0
                          : goalType == 'gain'
                              ? start + 5.0
                              : start);
              final progress = (goalType == 'maintain' || targetWeight == start)
                  ? 1.0
                  : ((current - start) / (targetWeight - start))
                      .clamp(0.0, 1.0);
              final toGo =
                  kgToDisplay((targetWeight - current).abs(), useLbs)
                      .toStringAsFixed(1);
              final goalLabel = goalType == 'lose'
                  ? 'lose weight'
                  : goalType == 'gain'
                      ? 'gain muscle'
                      : 'maintain weight';

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${formatWeight(current, useLbs)} now',
                          style: GoogleFonts.poppins(
                              fontSize: 13, color: AppColors.ink2)),
                      Text('${formatWeight(targetWeight, useLbs)} target',
                          style: GoogleFonts.poppins(
                              fontSize: 13, color: AppColors.ink2)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 12,
                      backgroundColor: AppColors.line2,
                      valueColor: const AlwaysStoppedAnimation(
                          AppColors.success),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    goalType == 'maintain'
                        ? 'Maintaining weight — great work!'
                        : '$toGo ${weightUnit(useLbs)} to $goalLabel',
                    style: GoogleFonts.poppins(
                        fontSize: 12.5, color: AppColors.ink3),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

// ── Summary card ──────────────────────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final String sub;
  final Color color;
  const _SummaryCard(
      {required this.label,
      required this.value,
      required this.sub,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AppCard(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColors.ink3,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            Text(value,
                style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: color,
                    letterSpacing: -0.3)),
            Text(sub,
                style: GoogleFonts.poppins(
                    fontSize: 11, color: AppColors.ink3)),
          ],
        ),
      ),
    );
  }
}

// ── Range selector ────────────────────────────────────────────────────────────

class _RangeSelector extends StatelessWidget {
  final String selected;
  final List<String> options;
  final ValueChanged<String> onSelect;
  const _RangeSelector(
      {required this.selected,
      required this.options,
      required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.line2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: options.map((o) {
          final isSelected = o == selected;
          return GestureDetector(
            onTap: () => onSelect(o),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.green : Colors.transparent,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Text(o,
                  style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color:
                          isSelected ? Colors.white : AppColors.ink3)),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Weight line graph ─────────────────────────────────────────────────────────

class _WeightGraph extends StatelessWidget {
  final List<double> weights;
  final double minW;
  final double maxW;
  const _WeightGraph(
      {required this.weights, required this.minW, required this.maxW});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: CustomPaint(
        size: const Size(double.infinity, 100),
        painter: _WeightLinePainter(weights: weights, minW: minW, maxW: maxW),
      ),
    );
  }
}

class _WeightLinePainter extends CustomPainter {
  final List<double> weights;
  final double minW;
  final double maxW;
  _WeightLinePainter(
      {required this.weights, required this.minW, required this.maxW});

  @override
  void paint(Canvas canvas, Size size) {
    if (weights.length < 2) {
      // Single point — draw a dot
      final paint = Paint()
        ..color = AppColors.green
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(size.width / 2, size.height / 2), 5, paint);
      return;
    }

    final linePaint = Paint()
      ..color = AppColors.green
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = AppColors.green
      ..style = PaintingStyle.fill;

    final n = weights.length;
    final step = size.width / (n - 1);
    final points = <Offset>[];
    for (var i = 0; i < n; i++) {
      final x = i * step;
      final y = (maxW == minW)
          ? size.height / 2
          : size.height -
              ((weights[i] - minW) / (maxW - minW)) * size.height;
      points.add(Offset(x, y));
    }

    final path = Path()..moveTo(points[0].dx, points[0].dy);
    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, linePaint);
    for (final p in points) {
      canvas.drawCircle(p, 4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(_WeightLinePainter old) =>
      old.weights != weights || old.minW != minW || old.maxW != maxW;
}

// ── Calorie bar chart ─────────────────────────────────────────────────────────

class _CalorieBarChart extends StatelessWidget {
  final List<Map<String, dynamic>> history;
  final int target;
  const _CalorieBarChart(
      {required this.history, required this.target});

  @override
  Widget build(BuildContext context) {
    final maxCal = history
        .map((d) => d['calories'] as int)
        .fold<int>(target, (a, b) => a > b ? a : b)
        .toDouble();

    return SizedBox(
      height: 120,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: history.map((d) {
          final cal = d['calories'] as int;
          final date = d['date'] as String;
          final dayLabel = _dayLabel(date);
          final isOver = cal > target;
          final barH = (cal / maxCal) * 100;

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: barH,
                    decoration: BoxDecoration(
                      color: isOver
                          ? AppColors.error.withValues(alpha: 0.7)
                          : AppColors.green.withValues(alpha: 0.8),
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(5)),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(dayLabel,
                      style: GoogleFonts.poppins(
                          fontSize: 10.5,
                          color: AppColors.ink3,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _dayLabel(String date) {
    final dt = DateTime.tryParse(date);
    if (dt == null) return '';
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[dt.weekday - 1];
  }
}
