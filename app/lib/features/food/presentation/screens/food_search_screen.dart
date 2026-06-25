import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/food_provider.dart';
import '../../domain/entities/food.dart';

class FoodSearchScreen extends ConsumerStatefulWidget {
  const FoodSearchScreen({super.key});

  @override
  ConsumerState<FoodSearchScreen> createState() => _FoodSearchScreenState();
}

class _FoodSearchScreenState extends ConsumerState<FoodSearchScreen> {
  final _ctrl = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _ctrl.addListener(() => setState(() => _query = _ctrl.text));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  static const _categoryEmoji = {
    'dal_bhat': '🍛', 'rice': '🍚', 'dal': '🫘', 'curry': '🥘',
    'meat': '🍗', 'momo': '🥟', 'snack': '🥐', 'bread': '🫓',
    'drink': '☕', 'dairy': '🥛', 'fruit': '🍎', 'egg': '🥚',
    'pickle': '🌶️', 'newari': '🍽️', 'grilled': '🍖', 'fermented': '🫙',
    'sweet': '🍯', 'soup': '🍲', 'salad': '🥗', 'nuts': '🥜',
  };

  String _emoji(String category) =>
      _categoryEmoji[category] ?? '🍽';

  @override
  Widget build(BuildContext context) {
    final resultsAsync = ref.watch(foodSearchProvider(_query));

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          controller: _ctrl,
          autofocus: true,
          style: GoogleFonts.poppins(fontSize: 15),
          decoration: InputDecoration(
            hintText: 'Search foods... (dal bhat, momo...)',
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            hintStyle:
                GoogleFonts.poppins(color: AppColors.ink3, fontSize: 15),
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (_query.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.close, size: 20),
              onPressed: () => _ctrl.clear(),
            ),
        ],
      ),
      body: resultsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.green),
        ),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off_outlined,
                  color: AppColors.ink3, size: 40),
              const SizedBox(height: 10),
              Text('Could not load foods.',
                  style: GoogleFonts.poppins(
                      fontSize: 14, color: AppColors.ink2)),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.invalidate(foodSearchProvider(_query)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (foods) => foods.isEmpty
            ? _EmptyState(query: _query)
            : ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: foods.length,
                separatorBuilder: (_, i) =>
                    const Divider(height: 0, indent: 70, endIndent: 16),
                itemBuilder: (context, i) {
                  final food = foods[i];
                  return _FoodTile(
                    food: food,
                    emoji: _emoji(food.category),
                    onTap: () => context.push('/food/detail/${food.id}'),
                  );
                },
              ),
      ),
    );
  }
}

class _FoodTile extends StatelessWidget {
  final Food food;
  final String emoji;
  final VoidCallback onTap;
  const _FoodTile(
      {required this.food, required this.emoji, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
            color: AppColors.greenSoft,
            borderRadius: BorderRadius.circular(14)),
        child: Center(
            child: Text(emoji, style: const TextStyle(fontSize: 22))),
      ),
      title: Text(food.nameEn,
          style: GoogleFonts.poppins(
              fontSize: 14.5,
              fontWeight: FontWeight.w600,
              color: AppColors.ink)),
      subtitle: Row(
        children: [
          Text('${food.caloriesPer100g.round()} kcal / 100g',
              style: GoogleFonts.poppins(
                  fontSize: 12.5, color: AppColors.ink3)),
          const SizedBox(width: 8),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
                color: AppColors.greenSoft,
                borderRadius: BorderRadius.circular(99)),
            child: Text(food.category,
                style: GoogleFonts.poppins(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                    color: AppColors.green)),
          ),
          if (food.isVerified) ...[
            const SizedBox(width: 6),
            const Icon(Icons.verified_rounded,
                size: 13, color: AppColors.green),
          ],
        ],
      ),
      trailing:
          const Icon(Icons.chevron_right, color: AppColors.ink3, size: 20),
      onTap: onTap,
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String query;
  const _EmptyState({required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🔍', style: TextStyle(fontSize: 52)),
          const SizedBox(height: 14),
          Text(
            query.isEmpty ? 'Start typing to search' : 'No results for "$query"',
            style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.ink),
          ),
          const SizedBox(height: 6),
          Text(
            query.isEmpty
                ? 'Search dal bhat, momo, chiya and more'
                : 'Try a different name or spelling',
            style: GoogleFonts.poppins(
                fontSize: 13.5, color: AppColors.ink2),
          ),
          if (query.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text(
              "Can't find it? Try a shorter or English name.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 12.5, color: AppColors.ink3),
            ),
          ],
        ],
      ),
    );
  }
}
