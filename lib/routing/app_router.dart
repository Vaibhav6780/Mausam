import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../controllers/app_state.dart';
import '../features/onboarding/screens/onboarding_wrapper.dart';
import '../features/home/screens/main_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/signup_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final appState = Provider.of<AppState>(context, listen: false);
      final isAuth = appState.isAuthenticated;
      final isAuthRoute = state.uri.path == '/login' || state.uri.path == '/signup';

      if (!isAuth && !isAuthRoute) return '/login';
      if (isAuth && isAuthRoute) return '/';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const OnboardingWrapper(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const MainScreen(),
      ),
      // Add other routes here (Forecast, Explore, Alerts, Profile)
    ],
  );
}
