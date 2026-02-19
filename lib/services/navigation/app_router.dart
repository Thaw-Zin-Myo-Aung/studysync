import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/route_constants.dart';
import '../../features/authentication/screens/login_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/matching/screens/discover_screen.dart';

/// GoRouter configuration for StudySync app navigation
class AppRouter {
  // Private constructor to prevent instantiation
  AppRouter._();

  /// The main GoRouter instance
  static final GoRouter router = GoRouter(
    initialLocation: RouteConstants.login,
    redirect: (context, state) {
      if (state.matchedLocation == '/') return RouteConstants.login;
      return null;
    },
    routes: [
      // Authentication Route
      GoRoute(
        path: RouteConstants.login,
        builder: (context, state) => const LoginScreen(),
      ),

      // Home Route
      GoRoute(
        path: RouteConstants.home,
        builder: (context, state) => const HomeScreen(),
      ),

      // Placeholder Routes
      GoRoute(
        path: RouteConstants.discover,
        builder: (context, state) => const DiscoverScreen(),
      ),
      GoRoute(
        path: RouteConstants.groups,
        builder: (context, state) => Scaffold(
          appBar: AppBar(title: const Text('Groups')),
        ),
      ),
      GoRoute(
        path: RouteConstants.profile,
        builder: (context, state) => Scaffold(
          appBar: AppBar(title: const Text('Profile')),
        ),
      ),
    ],
  );
}
