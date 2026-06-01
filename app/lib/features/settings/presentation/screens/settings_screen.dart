import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/app_card.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _nepaliLanguage = false;
  bool _lbsUnits = false;
  bool _darkMode = false;
  bool _mealNotifs = true;
  bool _workoutNotif = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('Profile & Settings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile card
            AppCard(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: const BoxDecoration(color: AppColors.greenSoft, shape: BoxShape.circle),
                    child: Center(
                      child: Text('P',
                          style: GoogleFonts.poppins(
                              fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.green)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Prajnaa Sharma',
                            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.ink)),
                        Text('Lose weight · 1,800 kcal/day',
                            style: GoogleFonts.poppins(fontSize: 13, color: AppColors.ink2)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: AppColors.ink3, size: 20),
                    onPressed: () => context.push('/onboarding'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            _SectionLabel('Goal'),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _InfoRow(label: 'Current goal', value: 'Lose weight'),
                  const Divider(height: 0, indent: 16, endIndent: 16),
                  _InfoRow(label: 'Daily calories', value: '1,800 kcal'),
                  const Divider(height: 0, indent: 16, endIndent: 16),
                  _InfoRow(label: 'Target weight', value: '65 kg'),
                  const Divider(height: 0, indent: 16, endIndent: 16),
                  _TapRow(
                    label: 'Change goal',
                    icon: Icons.track_changes_outlined,
                    onTap: () => context.push('/onboarding'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            _SectionLabel('Preferences'),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _SwitchRow(
                    label: 'Nepali language',
                    sub: 'Use Devanagari UI',
                    value: _nepaliLanguage,
                    onChanged: (v) => setState(() => _nepaliLanguage = v),
                  ),
                  const Divider(height: 0, indent: 16, endIndent: 16),
                  _SwitchRow(
                    label: 'Use lbs / ft',
                    sub: 'Imperial units',
                    value: _lbsUnits,
                    onChanged: (v) => setState(() => _lbsUnits = v),
                  ),
                  const Divider(height: 0, indent: 16, endIndent: 16),
                  _SwitchRow(
                    label: 'Dark mode',
                    sub: 'Easy on the eyes',
                    value: _darkMode,
                    onChanged: (v) => setState(() => _darkMode = v),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            _SectionLabel('Notifications'),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _SwitchRow(
                    label: 'Meal reminders',
                    sub: 'Breakfast · Lunch · Dinner',
                    value: _mealNotifs,
                    onChanged: (v) => setState(() => _mealNotifs = v),
                  ),
                  const Divider(height: 0, indent: 16, endIndent: 16),
                  _SwitchRow(
                    label: 'Workout reminder',
                    sub: 'Daily at 7:00 AM',
                    value: _workoutNotif,
                    onChanged: (v) => setState(() => _workoutNotif = v),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            _SectionLabel('Account'),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _TapRow(label: 'Privacy settings', icon: Icons.privacy_tip_outlined, onTap: () {}),
                  const Divider(height: 0, indent: 16, endIndent: 16),
                  _TapRow(label: 'Help & support', icon: Icons.help_outline, onTap: () {}),
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
              child: Text(
                'DhalBhat Fit v1.0.0',
                style: GoogleFonts.poppins(fontSize: 12, color: AppColors.ink3),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Sign out?', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: Text('You\'ll need to sign in again.', style: GoogleFonts.poppins(fontSize: 14)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/welcome');
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.poppins(
            fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.ink3, letterSpacing: 0.8),
      ),
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
          Text(label, style: GoogleFonts.poppins(fontSize: 14.5, color: AppColors.ink)),
          Text(value, style: GoogleFonts.poppins(fontSize: 14, color: AppColors.ink2, fontWeight: FontWeight.w500)),
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
  const _SwitchRow({required this.label, this.sub, required this.value, required this.onChanged});

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
                Text(label, style: GoogleFonts.poppins(fontSize: 14.5, color: AppColors.ink)),
                if (sub != null)
                  Text(sub!, style: GoogleFonts.poppins(fontSize: 12.5, color: AppColors.ink3)),
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
  const _TapRow({required this.label, required this.icon, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Icon(icon, color: color ?? AppColors.ink2, size: 20),
      title: Text(label,
          style: GoogleFonts.poppins(fontSize: 14.5, color: color ?? AppColors.ink)),
      trailing: Icon(Icons.chevron_right, color: color ?? AppColors.ink3, size: 20),
      onTap: onTap,
    );
  }
}
