import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/env.dart';
import '../../../../core/widgets/pulse_peak_mark.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<double> _scale;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fade = Tween<double>(begin: 0.4, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _scale = Tween<double>(begin: 0.86, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));

    _ctrl.forward().then((_) {
      // Try routing immediately after animation — if auth is ready, go; if not,
      // authStateProvider listener will fire when it resolves.
      Future.delayed(const Duration(milliseconds: 200), _decideRoute);
    });
  }

  /// Smart routing logic:
  ///  - Supabase not configured (dev mode) → skip straight to home
  ///  - Signed in + onboarding done       → /home
  ///  - Signed in + no profile            → /onboarding
  ///  - Not signed in                     → /welcome
  void _decideRoute() {
    if (_navigated || !mounted) return;

    if (!Env.isConfigured) {
      // Dev mode: no Supabase — skip to home so UI can be worked on
      _go('/home');
      return;
    }

    final user = ref.read(currentUserProvider);
    if (user == null) {
      _go('/welcome');
    } else if (user.hasCompletedOnboarding) {
      _go('/home');
    } else {
      _go('/onboarding');
    }
  }

  void _go(String path) {
    if (_navigated || !mounted) return;
    _navigated = true;
    context.go(path);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen to auth state — if it resolves while we're still on splash, route
    ref.listen(authStateProvider, (_, next) {
      next.whenData((_) => _decideRoute());
    });

    return Scaffold(
      backgroundColor: AppColors.green,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (_, child) => Stack(
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Transform.scale(
                      scale: _scale.value,
                      child: Opacity(
                        opacity: _fade.value,
                        child: const PulsePeakMark.onGreen(size: 92),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Opacity(
                      opacity: _fade.value,
                      child: Column(
                        children: [
                          RichText(
                            text: TextSpan(
                              style: GoogleFonts.poppins(
                                fontSize: 34,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -1.0,
                                color: Colors.white,
                              ),
                              children: const [
                                TextSpan(text: 'DhalBhat '),
                                TextSpan(
                                  text: 'Fit',
                                  style: TextStyle(color: AppColors.saffron),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'दालभात फिट',
                            style: GoogleFonts.notoSansDevanagari(
                              fontSize: 14,
                              color: AppColors.greenOnDark,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 54,
                left: 0,
                right: 0,
                child: Opacity(
                  opacity: _fade.value,
                  child: Text(
                    'Built for dal bhat and daily fitness',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.78),
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
