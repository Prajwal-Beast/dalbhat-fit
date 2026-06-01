import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/welcome/presentation/screens/welcome_screen.dart';
import '../../features/auth/presentation/screens/auth_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/dashboard/presentation/screens/home_screen.dart';
import '../../features/food/presentation/screens/meal_log_screen.dart';
import '../../features/food/presentation/screens/food_search_screen.dart';
import '../../features/food/presentation/screens/food_detail_screen.dart';
import '../../features/workouts/presentation/screens/workout_browser_screen.dart';
import '../../features/workouts/presentation/screens/active_session_screen.dart';
import '../../features/progress/presentation/screens/progress_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/onboarding/presentation/screens/calorie_goal_screen.dart';
import '../../features/workouts/presentation/screens/workout_complete_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (_, _) => const SplashScreen()),
    GoRoute(path: '/welcome', builder: (_, _) => const WelcomeScreen()),
    GoRoute(
      path: '/auth',
      builder: (_, state) =>
          AuthScreen(mode: state.uri.queryParameters['mode'] ?? 'signup'),
    ),
    GoRoute(path: '/onboarding', builder: (_, _) => const OnboardingScreen()),
    GoRoute(
      path: '/calorie-goal',
      builder: (_, state) {
        final e = state.extra as Map<String, dynamic>;
        return CalorieGoalScreen(
          name: e['name'] as String? ?? '',
          calories: e['calories'] as int,
          macros: Map<String, int>.from(e['macros'] as Map),
          bmi: e['bmi'] as double,
          bmiCategory: e['bmiCategory'] as String,
          goal: e['goal'] as String,
          weightKg: e['weightKg'] as double,
        );
      },
    ),
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(path: '/home', builder: (_, _) => const HomeScreen()),
        GoRoute(
          path: '/log',
          builder: (_, state) => MealLogScreen(
            mealType: state.uri.queryParameters['type'] ?? 'lunch',
          ),
        ),
        GoRoute(
          path: '/food/search',
          builder: (_, _) => const FoodSearchScreen(),
        ),
        GoRoute(
          path: '/food/detail/:id',
          builder: (_, state) => FoodDetailScreen(
            foodId: state.pathParameters['id']!,
            mealType: state.uri.queryParameters['mealType'],
          ),
        ),
        GoRoute(
          path: '/workouts',
          builder: (_, _) => const WorkoutBrowserScreen(),
        ),
        GoRoute(
          path: '/workouts/session',
          builder: (_, _) => const ActiveSessionScreen(),
        ),
        GoRoute(
          path: '/workouts/complete',
          builder: (_, _) => const WorkoutCompleteScreen(),
        ),
        GoRoute(path: '/progress', builder: (_, _) => const ProgressScreen()),
        GoRoute(path: '/settings', builder: (_, _) => const SettingsScreen()),
      ],
    ),
  ],
);

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  int _selectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/log') || location.startsWith('/food')) return 1;
    if (location.startsWith('/workouts')) return 2;
    if (location.startsWith('/progress')) return 3;
    if (location.startsWith('/settings')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex(context),
        onTap: (i) {
          switch (i) {
            case 0:
              context.go('/home');
            case 1:
              context.go('/log');
            case 2:
              context.go('/workouts');
            case 3:
              context.go('/progress');
            case 4:
              context.go('/settings');
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            activeIcon: Icon(Icons.add_circle),
            label: 'Log',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center_outlined),
            activeIcon: Icon(Icons.fitness_center),
            label: 'Workout',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart_outlined),
            activeIcon: Icon(Icons.show_chart),
            label: 'Progress',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
