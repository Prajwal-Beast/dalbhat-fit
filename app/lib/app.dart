import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class DhalBhatFitApp extends ConsumerWidget {
  const DhalBhatFitApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Light theme only for now. Screens use a fixed light palette, so a real
    // dark mode needs a full palette migration (tracked as a follow-up). Force
    // light so the OS dark setting can't half-apply and break readability.
    return MaterialApp.router(
      title: 'DhalBhat Fit',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light,
      routerConfig: appRouter,
    );
  }
}
