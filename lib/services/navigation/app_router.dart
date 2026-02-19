import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/route_constants.dart';
import '../../features/authentication/screens/login_screen.dart';
import '../../features/home/screens/home_dashboard_screen.dart';

/// GoRouter configuration for StudySync app navigation
class AppRouter {
  // Private constructor to prevent instantiation
  AppRouter._();

  /// The main GoRouter instance
  static final GoRouter router = GoRouter(
    initialLocation: RouteConstants.login,
    debugLogDiagnostics: true, // Enable for development, disable in production
    
    // Error handling
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found: ${state.uri.path}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(RouteConstants.login),
              child: const Text('Go to Login'),
            ),
          ],
        ),
      ),
    ),

    routes: [
      // Authentication Routes
      GoRoute(
        path: RouteConstants.login,
        name: 'login',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const LoginScreen(),
        ),
      ),

      // Home Dashboard Route
      GoRoute(
        path: RouteConstants.home,
        name: 'home',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const HomeDashboardScreen(),
        ),
      ),

      // TODO: Add more routes as features are implemented
      // - Discover/Matching screen
      // - Groups list screen
      // - Group detail screen
      // - Profile screen
      // - Settings screen
    ],

    // Optional: Add redirect logic for authentication state
    // redirect: (context, state) {
    //   final isAuthenticated = false; // TODO: Get from auth provider
    //   final isAuthRoute = state.matchedLocation == RouteConstants.login ||
    //       state.matchedLocation == RouteConstants.signup;
    //
    //   if (!isAuthenticated && !isAuthRoute) {
    //     return RouteConstants.login;
    //   }
    //   if (isAuthenticated && isAuthRoute) {
    //     return RouteConstants.home;
    //   }
    //   return null; // No redirect needed
    // },
  );
}
