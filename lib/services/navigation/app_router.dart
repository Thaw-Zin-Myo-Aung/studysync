import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/route_constants.dart';
import '../../features/authentication/screens/login_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/matching/screens/discover_screen.dart';
import '../../features/groups/screens/groups_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/settings/screens/settings_screen.dart';

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
        builder: (context, state) => const GroupsScreen(),
      ),
      GoRoute(
        path: RouteConstants.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: RouteConstants.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: RouteConstants.editProfile,
        builder: (context, state) => Scaffold(
          appBar: AppBar(title: const Text('Edit Profile')),
          body: const Center(child: Text('Edit Profile - Coming Soon')),
        ),
      ),
    ],
  );
}
