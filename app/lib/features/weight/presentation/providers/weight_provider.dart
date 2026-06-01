import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/supabase_weight_datasource.dart';
import '../../domain/entities/weight_log.dart';

// ── Infrastructure ────────────────────────────────────────────────────────────

final weightDatasourceProvider = Provider<SupabaseWeightDatasource>((ref) {
  return SupabaseWeightDatasource(ref.watch(supabaseClientProvider));
});

// ── Weight log list ───────────────────────────────────────────────────────────

/// All weight logs for the current user (up to 90 entries), newest first.
final weightLogsProvider = FutureProvider<List<WeightLog>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];
  return ref.watch(weightDatasourceProvider).getWeightLogs(user.id);
});

/// Most recent single weight entry.
final latestWeightProvider = FutureProvider<WeightLog?>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return null;
  return ref.watch(weightDatasourceProvider).getLatestWeight(user.id);
});

// ── Log action ────────────────────────────────────────────────────────────────

enum WeightLogStatus { idle, saving, saved, error }

class WeightLogState {
  final WeightLogStatus status;
  final String? errorMessage;
  final WeightLog? saved;
  const WeightLogState({
    this.status = WeightLogStatus.idle,
    this.errorMessage,
    this.saved,
  });
}

class WeightLogNotifier extends StateNotifier<WeightLogState> {
  final SupabaseWeightDatasource _ds;
  final Ref _ref;

  WeightLogNotifier(this._ds, this._ref) : super(const WeightLogState());

  Future<bool> logWeight(double weightKg, {String? notes}) async {
    final userId = _ref.read(currentUserProvider)?.id;
    if (userId == null) {
      state = const WeightLogState(
          status: WeightLogStatus.error, errorMessage: 'Not signed in.');
      return false;
    }

    state = const WeightLogState(status: WeightLogStatus.saving);
    try {
      final log = await _ds.logWeight(
        userId: userId,
        weightKg: weightKg,
        notes: notes,
      );
      state = WeightLogState(status: WeightLogStatus.saved, saved: log);
      // Invalidate so home card + progress screen refresh
      _ref.invalidate(weightLogsProvider);
      _ref.invalidate(latestWeightProvider);
      return true;
    } catch (e) {
      state = WeightLogState(
          status: WeightLogStatus.error,
          errorMessage: 'Could not save. Check your connection.');
      return false;
    }
  }

  void reset() => state = const WeightLogState();
}

final weightLogNotifierProvider =
    StateNotifierProvider<WeightLogNotifier, WeightLogState>((ref) {
  return WeightLogNotifier(ref.watch(weightDatasourceProvider), ref);
});
