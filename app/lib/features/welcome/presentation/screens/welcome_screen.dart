import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/pulse_peak_mark.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

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
                    const SizedBox(height: 8),
                    _HeroBlock(),
                    const SizedBox(height: 26),
                    Text(
                      'Fitness built for\nNepali life',
                      style: GoogleFonts.poppins(
                        fontSize: 27,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.7,
                        height: 1.18,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'तपाईंको दैनिक जीवनको लागि बनाइएको',
                      style: GoogleFonts.notoSansDevanagari(
                        fontSize: 14,
                        color: AppColors.ink2,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const _FeatureRow(
                      emoji: '🍚',
                      title: 'Understands your food',
                      subtitle: 'Dal bhat, momo, and local meals',
                    ),
                    const _FeatureRow(
                      emoji: '📊',
                      title: 'Real Nepali portions',
                      subtitle: 'Calories tracked the way you eat',
                    ),
                    const _FeatureRow(
                      emoji: '💪',
                      title: 'Workouts for your goal',
                      subtitle: 'Home or gym, beginner to advanced',
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      // Create an account first (email + password), then
                      // onboarding. The auth screen routes to /onboarding on
                      // successful sign-up.
                      onPressed: () => context.go('/auth?mode=signup'),
                      child: const Text('Get Started'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    // Mode is read from the query string by the router, not
                    // from `extra` — pass it as a query param.
                    onPressed: () => context.go('/auth?mode=signin'),
                    child: const Text('I already have an account'),
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

class _HeroBlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 188,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.green, Color(0xFF245741)],
        ),
        boxShadow: AppColors.shadowGreen,
      ),
      child: Stack(
        children: [
          Positioned(
            right: -60,
            top: -70,
            child: Container(
              width: 230,
              height: 230,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.saffron.withValues(alpha: 0.4),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          const Center(child: PulsePeakMark.onGreen(size: 92)),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;

  const _FeatureRow({
    required this.emoji,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.greenSoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 21)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 12.5,
                    color: AppColors.ink2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
