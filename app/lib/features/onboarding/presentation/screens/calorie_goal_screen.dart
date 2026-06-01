import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/app_card.dart';

class CalorieGoalScreen extends StatelessWidget {
  final String name;
  final int calories;
  final Map<String, int> macros;
  final double bmi;
  final String bmiCategory;
  final String goal;
  final double weightKg;

  const CalorieGoalScreen({
    super.key,
    required this.name,
    required this.calories,
    required this.macros,
    required this.bmi,
    required this.bmiCategory,
    required this.goal,
    required this.weightKg,
  });

  String get _goalLabel {
    switch (goal) {
      case 'lose':
        return 'Weight loss at 0.5 kg/week';
      case 'gain':
        return 'Muscle building (+300 kcal/day)';
      default:
        return 'Maintain current weight';
    }
  }

  String get _bmiLabel {
    switch (bmiCategory) {
      case 'underweight':
        return 'Underweight';
      case 'normal':
        return 'Healthy weight';
      case 'overweight':
        return 'Overweight';
      default:
        return 'Obese';
    }
  }

  Color _bmiColor() {
    switch (bmiCategory) {
      case 'normal':
        return AppColors.success;
      case 'underweight':
        return AppColors.saffron;
      default:
        return AppColors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    final firstName = name.trim().split(' ').first;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    // Header
                    Text(
                      firstName.isNotEmpty ? 'Here\'s your plan,\n$firstName 🎯' : 'Here\'s your plan 🎯',
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                        height: 1.18,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _goalLabel,
                      style: GoogleFonts.poppins(fontSize: 14, color: AppColors.ink2),
                    ),
                    const SizedBox(height: 24),

                    // Calorie card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [AppColors.green, Color(0xFF245741)],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: AppColors.shadowGreen,
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Daily calorie target',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: AppColors.greenOnDark,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.4,
                            ),
                          ),
                          const SizedBox(height: 4),
                          RichText(
                            text: TextSpan(
                              style: GoogleFonts.poppins(
                                fontSize: 68,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -3,
                                color: Colors.white,
                              ),
                              children: [
                                TextSpan(text: '$calories'),
                                TextSpan(
                                  text: ' kcal',
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.greenOnDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Macros
                    AppCard(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Daily macros',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.ink,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              _MacroBlock(
                                label: 'Carbs',
                                grams: macros['carbs_g'] ?? 0,
                                color: AppColors.saffron,
                              ),
                              const SizedBox(width: 10),
                              _MacroBlock(
                                label: 'Protein',
                                grams: macros['protein_g'] ?? 0,
                                color: AppColors.success,
                              ),
                              const SizedBox(width: 10),
                              _MacroBlock(
                                label: 'Fat',
                                grams: macros['fat_g'] ?? 0,
                                color: AppColors.error,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // BMI
                    AppCard(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: _bmiColor().withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(Icons.monitor_weight_outlined, color: _bmiColor(), size: 24),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'BMI: ${bmi.toStringAsFixed(1)}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.ink,
                                  ),
                                ),
                                Text(
                                  '$_bmiLabel · Asian BMI scale',
                                  style: GoogleFonts.poppins(fontSize: 12.5, color: AppColors.ink2),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _bmiColor().withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(99),
                            ),
                            child: Text(
                              _bmiLabel,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: _bmiColor(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Tip
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.saffronSoft,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.saffron.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          const Text('💡', style: TextStyle(fontSize: 20)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Log your meals daily for best results. Most users see progress in 2–3 weeks.',
                              style: GoogleFonts.poppins(fontSize: 12.5, color: AppColors.ink, height: 1.5),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.go('/home'),
                  child: const Text('Start Tracking →'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MacroBlock extends StatelessWidget {
  final String label;
  final int grams;
  final Color color;
  const _MacroBlock({required this.label, required this.grams, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(height: 4),
            Text(
              '${grams}g',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.poppins(fontSize: 11, color: AppColors.ink3, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
