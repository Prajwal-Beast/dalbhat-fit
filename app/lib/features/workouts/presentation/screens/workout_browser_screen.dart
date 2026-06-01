import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/app_card.dart';
import '../providers/workout_provider.dart';
import '../../domain/entities/workout_plan.dart';

class WorkoutBrowserScreen extends ConsumerStatefulWidget {
  const WorkoutBrowserScreen({super.key});

  @override
  ConsumerState<WorkoutBrowserScreen> createState() =>
      _WorkoutBrowserScreenState();
}

class _WorkoutBrowserScreenState extends ConsumerState<WorkoutBrowserScreen> {
  String _goal = 'all';
  String _location = 'all';
  String _level = 'all';

  @override
  Widget build(BuildContext context) {
    final plansAsync = ref.watch(workoutPlansProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('Workouts')),
      body: Column(
        children: [
          // Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Row(
              children: [
                _FilterChips(
                  options: const {
                    'all': 'All',
                    'lose': '🔥 Lose',
                    'gain': '💪 Gain',
                    'maintain': '🌿 Maintain'
                  },
                  selected: _goal,
                  onSelect: (v) => setState(() => _goal = v),
                ),
                const SizedBox(width: 8),
                _FilterChips(
                  options: const {
                    'all': 'All',
                    'home': '🏠 Home',
                    'gym': '🏋️ Gym'
                  },
                  selected: _location,
                  onSelect: (v) => setState(() => _location = v),
                ),
                const SizedBox(width: 8),
                _FilterChips(
                  options: const {
                    'all': 'All',
                    'beginner': 'Beginner',
                    'intermediate': 'Inter.',
                    'advanced': 'Advanced'
                  },
                  selected: _level,
                  onSelect: (v) => setState(() => _level = v),
                ),
              ],
            ),
          ),

          // Plans list
          Expanded(
            child: plansAsync.when(
              loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.green)),
              error: (err, st) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline,
                        color: AppColors.error, size: 40),
                    const SizedBox(height: 12),
                    Text('Could not load workouts.',
                        style: GoogleFonts.poppins(color: AppColors.ink2)),
                    TextButton(
                        onPressed: () => ref.invalidate(workoutPlansProvider),
                        child: const Text('Retry')),
                  ],
                ),
              ),
              data: (plans) {
                final filtered = plans.where((p) {
                  if (_goal != 'all' && p.goal != _goal) { return false; }
                  if (_location != 'all' &&
                      p.location != _location &&
                      p.location != 'both') { return false; }
                  if (_level != 'all' && p.level != _level) { return false; }
                  return true;
                }).toList();

                if (filtered.isEmpty) {
                  return const _EmptyState();
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filtered.length,
                  itemBuilder: (context, i) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _PlanCard(plan: filtered[i]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Filter chips ──────────────────────────────────────────────────────────────

class _FilterChips extends StatelessWidget {
  final Map<String, String> options;
  final String selected;
  final ValueChanged<String> onSelect;
  const _FilterChips(
      {required this.options,
      required this.selected,
      required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: options.entries.map((e) {
        final isSelected = e.key == selected;
        return GestureDetector(
          onTap: () => onSelect(e.key),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            margin: const EdgeInsets.only(right: 7),
            padding:
                const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.green : AppColors.card,
              borderRadius: BorderRadius.circular(99),
              border: Border.all(
                  color: isSelected ? AppColors.green : AppColors.line2),
            ),
            child: Text(
              e.value,
              style: GoogleFonts.poppins(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : AppColors.ink2),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Plan card ─────────────────────────────────────────────────────────────────

class _PlanCard extends ConsumerWidget {
  final WorkoutPlan plan;
  const _PlanCard({required this.plan});

  Color get _levelColor {
    switch (plan.level) {
      case 'beginner':
        return AppColors.success;
      case 'intermediate':
        return AppColors.saffron;
      default:
        return AppColors.error;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () async {
        // Start session with this plan and navigate
        await ref
            .read(workoutSessionNotifierProvider.notifier)
            .startSession(plan);
        if (context.mounted) context.push('/workouts/session');
      },
      child: AppCard(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.greenSoft,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                      child: Text(plan.emoji,
                          style: const TextStyle(fontSize: 24))),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan.name,
                        style: GoogleFonts.poppins(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.ink),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          if (plan.level != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: _levelColor.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(99),
                              ),
                              child: Text(
                                plan.level![0].toUpperCase() +
                                    plan.level!.substring(1),
                                style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: _levelColor),
                              ),
                            ),
                          const SizedBox(width: 6),
                          Text(
                            plan.location == 'home'
                                ? '🏠 Home'
                                : plan.location == 'gym'
                                    ? '🏋️ Gym'
                                    : '🏠/🏋️ Both',
                            style: GoogleFonts.poppins(
                                fontSize: 12, color: AppColors.ink3),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (plan.description != null) ...[
              const SizedBox(height: 14),
              Text(
                plan.description!,
                style: GoogleFonts.poppins(
                    fontSize: 13, color: AppColors.ink2, height: 1.4),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                if (plan.durationWeeks != null)
                  _StatPill('${plan.durationWeeks} weeks'),
                const SizedBox(width: 8),
                if (plan.daysPerWeek != null)
                  _StatPill('${plan.daysPerWeek}x / week'),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: AppColors.green,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    'Start',
                    style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  const _StatPill(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: AppColors.line2),
      ),
      child: Text(label,
          style: GoogleFonts.poppins(
              fontSize: 11.5,
              color: AppColors.ink2,
              fontWeight: FontWeight.w500)),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('💪', style: TextStyle(fontSize: 52)),
          const SizedBox(height: 14),
          Text('No workouts match',
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink)),
          const SizedBox(height: 6),
          Text('Try removing a filter',
              style:
                  GoogleFonts.poppins(fontSize: 13.5, color: AppColors.ink2)),
        ],
      ),
    );
  }
}
