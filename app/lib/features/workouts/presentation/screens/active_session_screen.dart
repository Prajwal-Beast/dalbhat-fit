import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/workout_provider.dart';

class ActiveSessionScreen extends ConsumerWidget {
  const ActiveSessionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    final sessionState = ref.watch(workoutSessionNotifierProvider);

    // Navigate to complete screen when session finishes
    ref.listen(workoutSessionNotifierProvider, (prev, next) {
      if ((next.status == SessionStatus.saved ||
              next.status == SessionStatus.completed) &&
          context.mounted) {
        context.pushReplacement('/workouts/complete');
      }
    });

    // Loading state
    if (sessionState.status == SessionStatus.active &&
        sessionState.exercises.isEmpty) {
      return const Scaffold(
        backgroundColor: AppColors.green,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    // Error state — show message + back button
    if (sessionState.status == SessionStatus.error ||
        (sessionState.exercises.isEmpty &&
            sessionState.status != SessionStatus.active)) {
      return Scaffold(
        backgroundColor: AppColors.green,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.fitness_center,
                      color: Colors.white, size: 64),
                  const SizedBox(height: 20),
                  Text(
                    sessionState.errorMessage ??
                        'No exercises found for this plan.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 28),
                  ElevatedButton(
                    onPressed: () {
                      ref
                          .read(workoutSessionNotifierProvider.notifier)
                          .reset();
                      context.go('/workouts');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.saffron,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Browse workouts',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final ex = sessionState.currentExercise!;
    final notifier = ref.read(workoutSessionNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.green,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ─────────────────────────────────────────────────────
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close,
                        color: Colors.white, size: 22),
                    onPressed: () => _showQuitDialog(context, ref),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          sessionState.plan?.name ?? 'Workout',
                          style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.greenOnDark),
                        ),
                        const SizedBox(height: 3),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(99),
                          child: LinearProgressIndicator(
                            value:
                                (sessionState.currentExerciseIndex + 1) /
                                    sessionState.exercises.length,
                            minHeight: 4,
                            backgroundColor:
                                Colors.white.withValues(alpha: 0.2),
                            valueColor: const AlwaysStoppedAnimation(
                                AppColors.saffron),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),

            // ── Exercise card ────────────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${sessionState.currentExerciseIndex + 1} / ${sessionState.exercises.length}',
                      style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: AppColors.greenOnDark,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 10),

                    // Exercise icon
                    _ExerciseIcon(exercise: ex.exercise),
                    const SizedBox(height: 18),

                    Text(
                      ex.exercise.name,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: -0.5),
                    ),
                    Text(
                      ex.exercise.muscleLabel,
                      style: GoogleFonts.poppins(
                          fontSize: 14, color: AppColors.greenOnDark),
                    ),

                    const SizedBox(height: 32),

                    if (sessionState.resting) ...[
                      _RestTimer(
                        seconds: sessionState.restSecondsLeft,
                        onSkip: notifier.skipRest,
                      ),
                    ] else ...[
                      // Set + reps — use Flexible to prevent overflow
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: _InfoBox(
                                label: 'Set',
                                value:
                                    '${sessionState.currentSet} / ${ex.sets}'),
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                              child: _InfoBox(
                                  label: 'Reps', value: ex.reps)),
                          const SizedBox(width: 12),
                          Flexible(
                            child: _InfoBox(
                                label: 'Rest',
                                value: '${ex.restSeconds}s'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 36),

                      // Form tip if available
                      if (ex.exercise.formNotes.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.tips_and_updates,
                                  color: AppColors.saffron, size: 16),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  ex.exercise.formNotes.first,
                                  style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: AppColors.greenOnDark),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Complete set button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: sessionState.status ==
                                  SessionStatus.saving
                              ? null
                              : notifier.completeSet,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.saffron,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            elevation: 0,
                          ),
                          child: sessionState.status == SessionStatus.saving
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white))
                              : Text(
                                  sessionState.isLastSet &&
                                          sessionState.isLastExercise
                                      ? 'Finish Workout ✓'
                                      : 'Set Complete →',
                                  style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // ── Bottom nav ───────────────────────────────────────────────────
            Container(
              color: Colors.black.withValues(alpha: 0.15),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.skip_previous_rounded,
                        color: Colors.white, size: 28),
                    onPressed: sessionState.currentExerciseIndex > 0
                        ? notifier.prevExercise
                        : null,
                  ),
                  if (!sessionState.isLastExercise)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Next',
                            style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: AppColors.greenOnDark)),
                        Text(
                          sessionState
                              .exercises[
                                  sessionState.currentExerciseIndex + 1]
                              .exercise
                              .name,
                          style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      ],
                    )
                  else
                    Text('Last exercise',
                        style: GoogleFonts.poppins(
                            fontSize: 13, color: AppColors.greenOnDark)),
                  IconButton(
                    icon: const Icon(Icons.skip_next_rounded,
                        color: Colors.white, size: 28),
                    onPressed: !sessionState.isLastExercise
                        ? notifier.nextExercise
                        : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuitDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Quit workout?',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: Text("Your progress won't be saved.",
            style: GoogleFonts.poppins(fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Keep going'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(workoutSessionNotifierProvider.notifier).reset();
              context.go('/home');
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error),
            child: const Text('Quit'),
          ),
        ],
      ),
    );
  }
}

// ── Exercise icon (replaces emojis) ──────────────────────────────────────────

class _ExerciseIcon extends StatelessWidget {
  final dynamic exercise;
  const _ExerciseIcon({required this.exercise});

  IconData get _icon {
    final name = (exercise.name as String).toLowerCase();
    final cat = (exercise.category as String).toLowerCase();
    if (name.contains('push')) return Icons.fitness_center;
    if (name.contains('squat') || name.contains('lunge')) return Icons.accessibility_new;
    if (name.contains('plank') || name.contains('core')) return Icons.horizontal_rule;
    if (name.contains('burpee')) return Icons.bolt;
    if (name.contains('mountain') || name.contains('climber')) return Icons.terrain;
    if (name.contains('bridge') || name.contains('glute')) return Icons.airline_seat_flat;
    if (name.contains('dip')) return Icons.arrow_downward;
    if (name.contains('jump')) return Icons.trending_up;
    if (name.contains('superman')) return Icons.flight;
    if (name.contains('deadlift') || name.contains('barbell')) return Icons.fitness_center;
    if (name.contains('bench') || name.contains('press')) return Icons.fitness_center;
    if (name.contains('pulldown') || name.contains('pull')) return Icons.arrow_downward;
    if (cat.contains('cardio') || cat.contains('hiit')) return Icons.bolt;
    if (cat.contains('chest')) return Icons.fitness_center;
    if (cat.contains('back')) return Icons.fitness_center;
    return Icons.sports_gymnastics;
  }

  Color get _color {
    final cat = (exercise.category as String).toLowerCase();
    if (cat.contains('chest') || cat.contains('push')) return AppColors.saffron;
    if (cat.contains('legs') || cat.contains('glute')) return const Color(0xFF6C63FF);
    if (cat.contains('core')) return AppColors.success;
    if (cat.contains('back')) return AppColors.green;
    if (cat.contains('full') || cat.contains('hiit') || cat.contains('cardio')) return AppColors.error;
    return AppColors.saffron;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.18),
        shape: BoxShape.circle,
        border: Border.all(color: _color.withValues(alpha: 0.4), width: 2),
      ),
      child: Icon(_icon, size: 52, color: _color),
    );
  }
}

// ── Rest timer ────────────────────────────────────────────────────────────────

class _RestTimer extends StatelessWidget {
  final int seconds;
  final VoidCallback onSkip;
  const _RestTimer({required this.seconds, required this.onSkip});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.15),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$seconds',
                  style: GoogleFonts.poppins(
                      fontSize: 44,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -2),
                ),
                Text('rest',
                    style: GoogleFonts.poppins(
                        fontSize: 13, color: AppColors.greenOnDark)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: onSkip,
          child: Text(
            'Skip rest →',
            style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.saffron,
                fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

// ── Info box ──────────────────────────────────────────────────────────────────

class _InfoBox extends StatelessWidget {
  final String label;
  final String value;
  const _InfoBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white),
          ),
          Text(
            label,
            style: GoogleFonts.poppins(
                fontSize: 11,
                color: AppColors.greenOnDark,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
