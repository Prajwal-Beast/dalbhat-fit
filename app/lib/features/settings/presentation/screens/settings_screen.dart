import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/settings/settings_provider.dart';
import '../../../../core/utils/units.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../../food/presentation/providers/food_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider);
    final name = ref.watch(profileNameProvider);
    final calorieTarget = ref.watch(dailyCalorieTargetProvider);
    final user = ref.watch(currentUserProvider);
    final settings = ref.watch(appSettingsProvider);
    final settingsCtrl = ref.read(appSettingsProvider.notifier);

    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

    final goal = profileAsync.whenOrNull(
          data: (p) => _goalLabel(p?['goal'] as String?),
        ) ??
        '—';
    final weightKg = profileAsync.whenOrNull(
          data: (p) => (p?['weight_kg'] as num?) == null
              ? null
              : formatWeight(
                  (p!['weight_kg'] as num).toDouble(), settings.useLbs),
        ) ??
        '—';
    final targetWeight = profileAsync.whenOrNull(
          data: (p) => (p?['target_weight_kg'] as num?) == null
              ? null
              : formatWeight(
                  (p!['target_weight_kg'] as num).toDouble(), settings.useLbs),
        );

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('Profile & Settings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Profile card ──────────────────────────────────────────────
            AppCard(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: const BoxDecoration(
                        color: AppColors.greenSoft, shape: BoxShape.circle),
                    child: Center(
                      child: Text(initial,
                          style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: AppColors.green)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name,
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.ink)),
                        Text('$goal · $calorieTarget kcal/day',
                            style: GoogleFonts.poppins(
                                fontSize: 13, color: AppColors.ink2)),
                        if (user?.email != null)
                          Text(user!.email,
                              style: GoogleFonts.poppins(
                                  fontSize: 12, color: AppColors.ink3)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined,
                        color: AppColors.ink3, size: 20),
                    onPressed: () => context.push('/onboarding'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Goal ──────────────────────────────────────────────────────
            _SectionLabel('Goal'),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _InfoRow(label: 'Current goal', value: goal),
                  const Divider(height: 0, indent: 16, endIndent: 16),
                  _InfoRow(
                      label: 'Daily calories',
                      value: '$calorieTarget kcal'),
                  const Divider(height: 0, indent: 16, endIndent: 16),
                  _InfoRow(
                      label: 'Current weight',
                      value: weightKg),
                  if (targetWeight != null) ...[
                    const Divider(height: 0, indent: 16, endIndent: 16),
                    _InfoRow(
                        label: 'Target weight',
                        value: targetWeight),
                  ],
                  const Divider(height: 0, indent: 16, endIndent: 16),
                  _TapRow(
                    label: 'Update goal',
                    icon: Icons.track_changes_outlined,
                    onTap: () => context.push('/onboarding'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Preferences ───────────────────────────────────────────────
            _SectionLabel('Preferences'),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _SwitchRow(
                    label: 'Nepali language',
                    sub: 'Full translation coming soon',
                    value: settings.nepaliLanguage,
                    onChanged: (v) {
                      settingsCtrl.setNepaliLanguage(v);
                      _toast(v
                          ? 'Saved. Full Nepali UI is coming in an update.'
                          : 'Using English.');
                    },
                  ),
                  const Divider(height: 0, indent: 16, endIndent: 16),
                  _SwitchRow(
                    label: 'Use lbs',
                    sub: 'Show weight in pounds',
                    value: settings.useLbs,
                    onChanged: settingsCtrl.setUseLbs,
                  ),
                  const Divider(height: 0, indent: 16, endIndent: 16),
                  _SwitchRow(
                    label: 'Dark mode',
                    sub: 'Coming soon',
                    value: settings.darkMode,
                    onChanged: (v) {
                      settingsCtrl.setDarkMode(v);
                      _toast('Dark mode is coming in an update.');
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Notifications ─────────────────────────────────────────────
            _SectionLabel('Notifications'),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _SwitchRow(
                    label: 'Meal reminders',
                    sub: 'Breakfast · Lunch · Dinner',
                    value: settings.mealReminders,
                    onChanged: settingsCtrl.setMealReminders,
                  ),
                  const Divider(height: 0, indent: 16, endIndent: 16),
                  _SwitchRow(
                    label: 'Workout reminder',
                    sub: 'Daily at 7:00 AM',
                    value: settings.workoutReminder,
                    onChanged: settingsCtrl.setWorkoutReminder,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Account ───────────────────────────────────────────────────
            _SectionLabel('Account'),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _TapRow(
                      label: 'Privacy Policy',
                      icon: Icons.privacy_tip_outlined,
                      onTap: () => _openUrl(
                          'https://prajwal-beast.github.io/dalbhat-fit/privacy-policy.html')),
                  const Divider(height: 0, indent: 16, endIndent: 16),
                  _TapRow(
                      label: 'Help & support',
                      icon: Icons.help_outline,
                      onTap: () => _openUrl(
                          'mailto:prajwalbeast22@gmail.com?subject=DhalBhat%20Fit%20Support')),
                  const Divider(height: 0, indent: 16, endIndent: 16),
                  _TapRow(
                    label: 'Sign out',
                    icon: Icons.logout,
                    color: AppColors.error,
                    onTap: () => _showSignOutDialog(context),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),
            Center(
              child: Text('DhalBhat Fit v1.0.0',
                  style: GoogleFonts.poppins(
                      fontSize: 12, color: AppColors.ink3)),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  String _goalLabel(String? goal) {
    switch (goal) {
      case 'lose':
      case 'lose_weight':
        return 'Lose weight';
      case 'gain':
      case 'gain_muscle':
        return 'Gain muscle';
      case 'maintain':
        return 'Maintain weight';
      default:
        return goal ?? '—';
    }
  }

  void _toast(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(message, style: GoogleFonts.poppins(fontSize: 13.5)),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open link.',
              style: GoogleFonts.poppins(fontSize: 13.5)),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Sign out?',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: Text("You'll need to sign in again.",
            style: GoogleFonts.poppins(fontSize: 14)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref
                  .read(authNotifierProvider.notifier)
                  .signOut();
              if (context.mounted) context.go('/welcome');
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
  }
}

// ── Reusable widgets ──────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(label.toUpperCase(),
          style: GoogleFonts.poppins(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: AppColors.ink3,
              letterSpacing: 0.8)),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: GoogleFonts.poppins(
                  fontSize: 14.5, color: AppColors.ink)),
          Text(value,
              style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppColors.ink2,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final String label;
  final String? sub;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _SwitchRow(
      {required this.label,
      this.sub,
      required this.value,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: GoogleFonts.poppins(
                        fontSize: 14.5, color: AppColors.ink)),
                if (sub != null)
                  Text(sub!,
                      style: GoogleFonts.poppins(
                          fontSize: 12.5, color: AppColors.ink3)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.green,
            activeTrackColor: AppColors.greenSoft,
          ),
        ],
      ),
    );
  }
}

class _TapRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;
  const _TapRow(
      {required this.label,
      required this.icon,
      required this.onTap,
      this.color});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Icon(icon, color: color ?? AppColors.ink2, size: 20),
      title: Text(label,
          style: GoogleFonts.poppins(
              fontSize: 14.5, color: color ?? AppColors.ink)),
      trailing: Icon(Icons.chevron_right,
          color: color ?? AppColors.ink3, size: 20),
      onTap: onTap,
    );
  }
}
