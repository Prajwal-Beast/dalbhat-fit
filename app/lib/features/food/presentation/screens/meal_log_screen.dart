import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/app_card.dart';
import '../providers/food_provider.dart';
import '../../domain/entities/food.dart';
import '../../domain/entities/meal_template.dart';

class MealLogScreen extends ConsumerStatefulWidget {
  final String mealType;
  const MealLogScreen({super.key, required this.mealType});

  @override
  ConsumerState<MealLogScreen> createState() => _MealLogScreenState();
}

class _MealLogScreenState extends ConsumerState<MealLogScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  late String _mealType;

  @override
  void initState() {
    super.initState();
    _mealType = widget.mealType;
    _tabCtrl = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
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
      appBar: AppBar(
        title: const Text('Log Meal'),
        leading: IconButton(
          icon: const Icon(Icons.close, size: 22),
          onPressed: () => context.pop(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: _MealTypeSelector(
            selected: _mealType,
            onSelect: (t) => setState(() => _mealType = t),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: AppColors.bg,
            child: TabBar(
              controller: _tabCtrl,
              labelColor: AppColors.green,
              unselectedLabelColor: AppColors.ink3,
              indicatorColor: AppColors.green,
              labelStyle: GoogleFonts.poppins(
                  fontSize: 13.5, fontWeight: FontWeight.w600),
              unselectedLabelStyle:
                  GoogleFonts.poppins(fontSize: 13.5),
              tabs: const [
                Tab(text: '📷  Photo'),
                Tab(text: '🔍  Search'),
                Tab(text: '🏷  Quick'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabCtrl,
              children: [
                _PhotoTab(mealType: _mealType),
                _SearchTab(mealType: _mealType),
                _QuickTab(mealType: _mealType),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Meal type selector ────────────────────────────────────────────────────────

class _MealTypeSelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelect;
  const _MealTypeSelector(
      {required this.selected, required this.onSelect});

  static const _types = [
    ('breakfast', '🍳', 'Breakfast'),
    ('lunch', '🍛', 'Lunch'),
    ('dinner', '🌙', 'Dinner'),
    ('snack', '🍎', 'Snack'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: _types.map((t) {
          final isSelected = t.$1 == selected;
          return GestureDetector(
            onTap: () => onSelect(t.$1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              margin: const EdgeInsets.only(right: 9),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.green : AppColors.card,
                borderRadius: BorderRadius.circular(99),
                border: Border.all(
                    color: isSelected ? AppColors.green : AppColors.line2),
              ),
              child: Text(
                '${t.$2} ${t.$3}',
                style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.ink2),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Photo tab ─────────────────────────────────────────────────────────────────

class _PhotoTab extends StatelessWidget {
  final String mealType;
  const _PhotoTab({required this.mealType});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {},
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.darkBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: AppColors.green.withValues(alpha: 0.4),
                    width: 2),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                        color: AppColors.greenSoft,
                        shape: BoxShape.circle),
                    child: const Icon(Icons.camera_alt_outlined,
                        color: AppColors.green, size: 28),
                  ),
                  const SizedBox(height: 14),
                  Text('Take a photo of your meal',
                      style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.ink)),
                  const SizedBox(height: 4),
                  Text('AI identifies the food instantly',
                      style: GoogleFonts.poppins(
                          fontSize: 12.5, color: AppColors.ink3)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.photo_library_outlined, size: 18),
              label: const Text('Choose from gallery'),
            ),
          ),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.greenSoft,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                ...[
                  ('📸', 'Take or upload a photo of your meal'),
                  ('🤖', 'AI identifies food and portion automatically'),
                  ('✅', 'Confirm or adjust — then log it'),
                ].map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Text(item.$1,
                              style: const TextStyle(fontSize: 18)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(item.$2,
                                style: GoogleFonts.poppins(
                                    fontSize: 13.5,
                                    color: AppColors.ink)),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Search tab ────────────────────────────────────────────────────────────────

class _SearchTab extends ConsumerStatefulWidget {
  final String mealType;
  const _SearchTab({required this.mealType});

  @override
  ConsumerState<_SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends ConsumerState<_SearchTab> {
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
          child: TextField(
            controller: _ctrl,
            decoration: InputDecoration(
              hintText: 'Search foods... (dal bhat, momo...)',
              prefixIcon: const Icon(Icons.search,
                  color: AppColors.ink3, size: 20),
              suffixIcon: _query.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      color: AppColors.ink3,
                      onPressed: () => _ctrl.clear(),
                    )
                  : null,
            ),
          ),
        ),
        Expanded(
          child: _query.isEmpty
              ? _RecentSection(mealType: widget.mealType)
              : _SearchResults(
                  query: _query, mealType: widget.mealType),
        ),
      ],
    );
  }
}

class _SearchResults extends ConsumerWidget {
  final String query;
  final String mealType;
  const _SearchResults(
      {required this.query, required this.mealType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultsAsync = ref.watch(foodSearchProvider(query));

    return resultsAsync.when(
      loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.green)),
      error: (err, st) => Center(
          child: Text('Could not search. Check your connection.',
              style: GoogleFonts.poppins(
                  fontSize: 13.5, color: AppColors.ink2))),
      data: (foods) => foods.isEmpty
          ? Center(
              child: Text('No results for "$query"',
                  style: GoogleFonts.poppins(
                      fontSize: 14, color: AppColors.ink2)))
          : ListView.separated(
              padding:
                  const EdgeInsets.symmetric(vertical: 8),
              itemCount: foods.length,
              separatorBuilder: (_, i) =>
                  const Divider(height: 0, indent: 68, endIndent: 16),
              itemBuilder: (context, i) =>
                  _FoodRow(food: foods[i], mealType: mealType),
            ),
    );
  }
}

class _RecentSection extends ConsumerWidget {
  final String mealType;
  const _RecentSection({required this.mealType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentAsync = ref.watch(recentFoodsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          recentAsync.when(
            loading: () =>
                const Center(child: CircularProgressIndicator()),
            error: (err, st) => const SizedBox.shrink(),
            data: (foods) {
              if (foods.isEmpty) return const SizedBox.shrink();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Recent',
                      style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.ink2)),
                  const SizedBox(height: 10),
                  ...foods.map((f) =>
                      _FoodRow(food: f, mealType: mealType)),
                  const SizedBox(height: 20),
                ],
              );
            },
          ),
          Text('Quick add',
              style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink2)),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () => context.push('/food/search'),
            icon: const Icon(Icons.search, size: 18),
            label: const Text('Browse all foods'),
            style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48)),
          ),
        ],
      ),
    );
  }
}

class _FoodRow extends ConsumerWidget {
  final Food food;
  final String mealType;
  const _FoodRow({required this.food, required this.mealType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            color: AppColors.greenSoft,
            borderRadius: BorderRadius.circular(12)),
        child: Center(
            child: Text(_emoji(food.category),
                style: const TextStyle(fontSize: 20))),
      ),
      title: Text(food.nameEn,
          style: GoogleFonts.poppins(
              fontSize: 14, fontWeight: FontWeight.w600)),
      subtitle: Text('${food.caloriesPer100g.round()} kcal / 100g',
          style: GoogleFonts.poppins(
              fontSize: 12, color: AppColors.ink3)),
      trailing: IconButton(
        icon: const Icon(Icons.add_circle_outline,
            color: AppColors.green, size: 26),
        onPressed: () =>
            context.push('/food/detail/${food.id}?mealType=$mealType'),
      ),
      onTap: () =>
          context.push('/food/detail/${food.id}?mealType=$mealType'),
    );
  }

  String _emoji(String category) {
    const map = {
      'dal_bhat': '🍛', 'rice': '🍚', 'dal': '🫘', 'curry': '🥘',
      'meat': '🍗', 'momo': '🥟', 'snack': '🍿', 'bread': '🫓',
      'drink': '☕', 'dairy': '🥛', 'fruit': '🍎', 'egg': '🥚',
    };
    return map[category] ?? '🍽';
  }
}

// ── Quick tab (meal templates) ────────────────────────────────────────────────

class _QuickTab extends ConsumerWidget {
  final String mealType;
  const _QuickTab({required this.mealType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templatesAsync = ref.watch(mealTemplatesProvider);
    final logState = ref.watch(foodLogNotifierProvider);
    final isLogging = logState.status == LogStatus.saving;

    return templatesAsync.when(
      loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.green)),
      error: (err, st) => Center(
          child: Text('Could not load templates.',
              style: GoogleFonts.poppins(
                  fontSize: 13.5, color: AppColors.ink2))),
      data: (templates) => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: templates.length,
        itemBuilder: (context, i) {
          final t = templates[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: AppCard(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  const Text('🍽', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t.nameEn,
                            style: GoogleFonts.poppins(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600)),
                        if (t.description != null)
                          Text(t.description!,
                              style: GoogleFonts.poppins(
                                  fontSize: 11.5,
                                  color: AppColors.ink3),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                        Text(
                            '${t.totalCalories.round()} kcal · P:${t.totalProteinG.round()}g C:${t.totalCarbsG.round()}g F:${t.totalFatG.round()}g',
                            style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: AppColors.ink3)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: isLogging
                        ? null
                        : () => _logTemplate(context, ref, t),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                          color: AppColors.greenSoft,
                          borderRadius: BorderRadius.circular(99)),
                      child: Text('Add',
                          style: GoogleFonts.poppins(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.green)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _logTemplate(
      BuildContext context, WidgetRef ref, MealTemplate template) async {
    final success = await ref
        .read(foodLogNotifierProvider.notifier)
        .logTemplate(template: template, mealType: mealType);

    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${template.nameEn} logged!',
              style: GoogleFonts.poppins(fontSize: 13.5)),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.success,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
        ),
      );
      context.pop();
    }
  }
}
