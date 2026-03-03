import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/route_constants.dart';
import '../../features/authentication/screens/login_screen.dart';
import '../../features/authentication/screens/signup_screen.dart';
import '../../features/onboarding/screens/profile_setup_screen.dart';
import '../../features/onboarding/screens/profile_complete_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/matching/screens/discover_screen.dart';
import '../../features/groups/screens/groups_list_screen.dart';
import '../../features/groups/screens/group_detail_screen.dart';
import '../../features/groups/screens/create_group_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/profile/screens/edit_profile_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/notifications/screens/notifications_screen.dart';
import '../../providers/auth_provider.dart';

/// GoRouter configuration for StudySync app navigation
class AppRouter {
  // Private constructor to prevent instantiation
  AppRouter._();

  static GoRouter createRouter(WidgetRef ref) {
    const protectedRoutes = [
      RouteConstants.home,
      RouteConstants.discover,
      RouteConstants.groups,
      RouteConstants.groupDetail,
      RouteConstants.profile,
      RouteConstants.settings,
      RouteConstants.notifications,
      RouteConstants.editProfile,
    ];

    final notifier = _RouterNotifier(ref);

    return GoRouter(
      initialLocation: RouteConstants.login,
      refreshListenable: notifier,
      redirect: (context, state) {
        final user = ref.read(authProvider);
        final isLoggedIn = user != null;
        final location = state.matchedLocation;
        final isProtected = protectedRoutes.any(
          (r) => location.startsWith(r.split('/:').first),
        );
        final isAuthRoute = location == RouteConstants.login ||
                            location == RouteConstants.signup;

        if (!isLoggedIn && isProtected) { return RouteConstants.login; }
        if (isLoggedIn && isAuthRoute)  { return RouteConstants.home; }
        if (location == '/') {
          return isLoggedIn ? RouteConstants.home : RouteConstants.login;
        }
        return null;
      },
      errorBuilder: (context, state) => Scaffold(
        appBar: AppBar(title: const Text('Page Not Found')),
        body: Center(child: Text('No route for: ${state.uri}')),
      ),
    routes: [
      // Authentication Route
      GoRoute(
        path: RouteConstants.login,
        builder: (context, state) => const LoginScreen(),
      ),

      // Signup Route
      GoRoute(
        path: RouteConstants.signup,
        builder: (context, state) => const SignupScreen(),
      ),

      // Onboarding Route
      GoRoute(
        path: RouteConstants.onboarding,
        builder: (context, state) => const ProfileSetupScreen(),
      ),

      // Profile Complete Route
      GoRoute(
        path: RouteConstants.profileComplete,
        builder: (context, state) => const ProfileCompleteScreen(),
      ),

      // Home Route
      GoRoute(
        path: RouteConstants.home,
        builder: (context, state) => const HomeScreen(),
      ),

      // Notifications Route
      GoRoute(
        path: RouteConstants.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),

      // Placeholder Routes
      GoRoute(
        path: RouteConstants.discover,
        builder: (context, state) => const DiscoverScreen(),
      ),
      GoRoute(
        path: RouteConstants.groups,
        builder: (context, state) => const GroupsListScreen(),
      ),
      GoRoute(
        path: RouteConstants.createGroup,
        builder: (context, state) => const CreateGroupScreen(),
      ),
      GoRoute(
        path: RouteConstants.groupDetail,
        builder: (context, state) => GroupDetailScreen(
          groupId: state.pathParameters['groupId'] ?? '',
        ),
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
        builder: (context, state) => const EditProfileScreen(),
      ),
    ],
    );
  }
}

class _RouterNotifier extends ChangeNotifier {
  _RouterNotifier(WidgetRef ref) {
    ref.listen(authProvider, (_, __) => notifyListeners());
  }
}

