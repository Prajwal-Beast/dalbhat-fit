import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/app_card.dart';
import '../providers/food_provider.dart';
import '../../domain/entities/food.dart';

class FoodDetailScreen extends ConsumerStatefulWidget {
  final String foodId;
  final String? mealType;
  const FoodDetailScreen({super.key, required this.foodId, this.mealType});

  @override
  ConsumerState<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends ConsumerState<FoodDetailScreen> {
  String? _selectedPortionId;
  bool _saved = false;

  String get _mealType => widget.mealType ?? 'lunch';

  @override
  Widget build(BuildContext context) {
    final foodAsync = ref.watch(foodByIdProvider(widget.foodId));
    final logState = ref.watch(foodLogNotifierProvider);
    final isLogging = logState.status == LogStatus.saving;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.flag_outlined, size: 20),
            color: AppColors.ink2,
            tooltip: 'Flag as wrong',
            onPressed: () => _showFlagDialog(context),
          ),
        ],
      ),
      body: foodAsync.when(
        loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.green)),
        error: (err, st) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline,
                  color: AppColors.error, size: 40),
              const SizedBox(height: 12),
              Text('Could not load food.',
                  style: GoogleFonts.poppins(color: AppColors.ink2)),
              TextButton(
                  onPressed: () =>
                      ref.invalidate(foodByIdProvider(widget.foodId)),
                  child: const Text('Retry')),
            ],
          ),
        ),
        data: (food) {
          if (food == null) {
            return Center(
                child: Text('Food not found.',
                    style: GoogleFonts.poppins(color: AppColors.ink2)));
          }

          // Auto-select default portion on first build
          _selectedPortionId ??= food.portions.isNotEmpty
              ? (food.portions.firstWhere((p) => p.isDefault,
                          orElse: () => food.portions.first))
                      .id
              : null;

          final portion = food.portions.isNotEmpty
              ? food.portions
                  .firstWhere((p) => p.id == _selectedPortionId,
                      orElse: () => food.portions.first)
              : null;

          final calories = portion?.calories ?? food.caloriesPer100g;
          final factor =
              portion != null ? portion.weightG / 100.0 : 1.0;

          return Stack(
            children: [
              SingleChildScrollView(
                padding:
                    const EdgeInsets.fromLTRB(20, 0, 20, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero
                    Container(
                      width: double.infinity,
                      height: 160,
                      decoration: BoxDecoration(
                          color: AppColors.greenSoft,
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                          child: Text(
                        _emoji(food.category),
                        style: const TextStyle(fontSize: 64),
                      )),
                    ),
                    const SizedBox(height: 16),

                    // Name
                    Text(food.nameEn,
                        style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink)),
                    if (food.nameNe != null)
                      Text(food.nameNe!,
                          style: GoogleFonts.notoSansDevanagari(
                              fontSize: 14, color: AppColors.ink2)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _CategoryChip(food.category),
                        if (food.isVerified) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 9, vertical: 3),
                            decoration: BoxDecoration(
                                color: AppColors.successSoft,
                                borderRadius:
                                    BorderRadius.circular(99)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.verified_rounded,
                                    size: 12, color: AppColors.success),
                                const SizedBox(width: 4),
                                Text('Verified',
                                    style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.success)),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Portion selector
                    if (food.portions.isNotEmpty) ...[
                      Text('Portion size',
                          style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.ink2)),
                      const SizedBox(height: 10),
                      Row(
                        children: food.portions.map((p) {
                          final selected = p.id == _selectedPortionId;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => setState(
                                  () => _selectedPortionId = p.id),
                              child: AnimatedContainer(
                                duration:
                                    const Duration(milliseconds: 180),
                                margin:
                                    const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12),
                                decoration: BoxDecoration(
                                  color: selected
                                      ? AppColors.green
                                      : AppColors.card,
                                  borderRadius:
                                      BorderRadius.circular(14),
                                  border: Border.all(
                                    color: selected
                                        ? AppColors.green
                                        : AppColors.line2,
                                    width: selected ? 2 : 1.5,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      p.label,
                                      style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: selected
                                              ? Colors.white
                                              : AppColors.ink2),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      '${p.calories.round()} kcal',
                                      style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          color: selected
                                              ? Colors.white
                                                  .withValues(alpha: 0.8)
                                              : AppColors.ink3),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Calories + macros
                    AppCard(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Nutrition',
                              style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.ink2)),
                          const SizedBox(height: 10),
                          RichText(
                            text: TextSpan(
                              style: GoogleFonts.poppins(
                                  fontSize: 38,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.ink,
                                  letterSpacing: -1),
                              children: [
                                TextSpan(
                                    text: '${calories.round()}'),
                                TextSpan(
                                    text: ' kcal',
                                    style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        color: AppColors.ink3,
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Divider(),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              _MacroChip(
                                  label: 'Carbs',
                                  value:
                                      '${(food.carbsG * factor).round()}g',
                                  color: AppColors.saffron),
                              const SizedBox(width: 8),
                              _MacroChip(
                                  label: 'Protein',
                                  value:
                                      '${(food.proteinG * factor).round()}g',
                                  color: AppColors.success),
                              const SizedBox(width: 8),
                              _MacroChip(
                                  label: 'Fat',
                                  value:
                                      '${(food.fatG * factor).round()}g',
                                  color: AppColors.error),
                              const SizedBox(width: 8),
                              _MacroChip(
                                  label: 'Fiber',
                                  value:
                                      '${(food.fiberG * factor).round()}g',
                                  color: AppColors.ink3),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ── Bottom log button ───────────────────────────────────────
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Container(
                    color: AppColors.bg,
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: _saved
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 14),
                            decoration: BoxDecoration(
                                color: AppColors.successSoft,
                                borderRadius:
                                    BorderRadius.circular(14)),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.check_circle,
                                    color: AppColors.success, size: 20),
                                const SizedBox(width: 8),
                                Text('Logged!',
                                    style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.success)),
                              ],
                            ),
                          )
                        : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: isLogging
                                  ? null
                                  : () => _logFood(food, portion),
                              icon: isLogging
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child:
                                          CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white))
                                  : const Icon(Icons.add, size: 20),
                              label: Text(
                                  isLogging
                                      ? 'Saving...'
                                      : 'Add to $_mealType · ${calories.round()} kcal',
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _logFood(Food food, FoodPortion? portion) async {
    if (portion == null) return;
    final success = await ref.read(foodLogNotifierProvider.notifier).logFood(
          food: food,
          portion: portion,
          mealType: _mealType,
        );
    if (!mounted) return;
    if (success) {
      setState(() => _saved = true);
      await Future.delayed(const Duration(milliseconds: 1200));
      if (mounted) context.pop();
    } else {
      final err = ref.read(foodLogNotifierProvider).errorMessage ??
          'Could not log food. Please sign in first.';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(err),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.error,
        margin: const EdgeInsets.all(16),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ));
    }
  }

  void _showFlagDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("What's wrong?",
                style: GoogleFonts.poppins(
                    fontSize: 17, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            ...[
              'Wrong food identified',
              'Calories seem incorrect',
              'Wrong portion size',
              'Other'
            ].map((r) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(r,
                      style: GoogleFonts.poppins(fontSize: 14.5)),
                  leading: const Icon(Icons.radio_button_unchecked,
                      color: AppColors.ink3),
                  onTap: () => Navigator.pop(context),
                )),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  String _emoji(String category) {
    const map = {
      'dal_bhat': '🍛', 'rice': '🍚', 'dal': '🫘', 'curry': '🥘',
      'meat': '🍗', 'momo': '🥟', 'snack': '🍿', 'bread': '🫓',
      'drink': '☕', 'dairy': '🥛', 'fruit': '🍎', 'egg': '🥚',
      'pickle': '🌶', 'newari': '🍽', 'grilled': '🔥',
    };
    return map[category] ?? '🍽';
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  const _CategoryChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
          color: AppColors.greenSoft,
          borderRadius: BorderRadius.circular(99)),
      child: Text(label,
          style: GoogleFonts.poppins(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: AppColors.green)),
    );
  }
}

class _MacroChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _MacroChip(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            color: color.withValues(alpha: 0.09),
            borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Text(value,
                style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink)),
            Text(label,
                style: GoogleFonts.poppins(
                    fontSize: 10.5,
                    color: AppColors.ink3,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
