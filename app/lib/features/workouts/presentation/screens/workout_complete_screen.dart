import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/workout_provider.dart';

class WorkoutCompleteScreen extends ConsumerWidget {
  const WorkoutCompleteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionState = ref.watch(workoutSessionNotifierProvider);
    final saved = sessionState.savedSession;

    final exerciseCount =
        saved?.exercisesCompleted ?? sessionState.exercises.length;
    final durationMin =
        saved?.durationMinutes ?? sessionState.elapsedMinutes;
    final calories =
        saved?.caloriesBurned ?? sessionState.estimatedCalories;

    // Streak from recent sessions
    final sessionsAsync = ref.watch(recentSessionsProvider);
    final streak = sessionsAsync.whenOrNull(data: (sessions) {
          // Count consecutive days with a session
          if (sessions.isEmpty) return 1;
          int count = 1;
          // Normalize to date-only so multiple sessions in one day don't reset
          // the streak.
          DateTime dayOf(DateTime d) => DateTime(d.year, d.month, d.day);
          DateTime prev = dayOf(sessions.first.sessionDate);
          for (var i = 1; i < sessions.length; i++) {
            final day = dayOf(sessions[i].sessionDate);
            final diff = prev.difference(day).inDays;
            if (diff == 0) {
              // Same day — skip duplicate, don't break the streak.
              continue;
            } else if (diff == 1) {
              count++;
              prev = day;
            } else {
              break;
            }
          }
          return count;
        }) ??
        1;

    return Scaffold(
      backgroundColor: AppColors.green,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    const Text('🎉', style: TextStyle(fontSize: 80)),
                    const SizedBox(height: 20),
                    Text(
                      'Workout\nComplete!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -1,
                          height: 1.1,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$streak ${streak == 1 ? 'day' : 'days'} in a row 🔥',
                      style: GoogleFonts.poppins(
                          fontSize: 15, color: AppColors.greenOnDark),
                    ),
                    const SizedBox(height: 36),

                    // Stats row
                    Row(
                      children: [
                        _StatCard(
                            label: 'Exercises',
                            value: '$exerciseCount',
                            emoji: '💪'),
                        const SizedBox(width: 12),
                        _StatCard(
                            label: 'Time',
                            value: durationMin > 0
                                ? '$durationMin min'
                                : '—',
                            emoji: '⏱'),
                        const SizedBox(width: 12),
                        _StatCard(
                            label: 'Calories',
                            value: '~$calories',
                            emoji: '🔥'),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Exercise list
                    if (sessionState.exercises.isNotEmpty) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Exercises completed',
                                style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.greenOnDark)),
                            const SizedBox(height: 10),
                            ...sessionState.exercises.map((pe) => Padding(
                                  padding:
                                      const EdgeInsets.only(bottom: 6),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.check_circle,
                                          color: AppColors.saffron,
                                          size: 16),
                                      const SizedBox(width: 8),
                                      Text(
                                        '${pe.exercise.name} · ${pe.sets}×${pe.reps}',
                                        style: GoogleFonts.poppins(
                                            fontSize: 13.5,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],

                    if (sessionState.errorMessage != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12)),
                        child: Text(
                          sessionState.errorMessage!,
                          style: GoogleFonts.poppins(
                              fontSize: 12.5, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // ── Bottom actions ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ref
                            .read(workoutSessionNotifierProvider.notifier)
                            .reset();
                        context.go('/log?type=lunch');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.saffron,
                        foregroundColor: Colors.white,
                        padding:
                            const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      child: Text('Log your next meal →',
                          style: GoogleFonts.poppins(
                              fontSize: 15, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      ref
                          .read(workoutSessionNotifierProvider.notifier)
                          .reset();
                      context.go('/home');
                    },
                    child: Text('Back to home',
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: AppColors.greenOnDark,
                            fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String emoji;
  const _StatCard(
      {required this.label, required this.value, required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 6),
            Text(value,
                style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white)),
            Text(label,
                style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColors.greenOnDark,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
