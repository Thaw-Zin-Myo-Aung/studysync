import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart';
import '../../core/constants/route_constants.dart';
import '../../features/landing/screens/landing_screen.dart';
import '../../features/authentication/screens/login_screen.dart';
import '../../features/authentication/screens/signup_screen.dart';
import '../../features/onboarding/screens/profile_setup_screen.dart';
import '../../features/onboarding/screens/profile_complete_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/matching/screens/discover_screen.dart';
import '../../features/groups/screens/groups_list_screen.dart';
import '../../features/groups/screens/group_detail_screen.dart';
import '../../features/groups/screens/group_settings_screen.dart';
import '../../features/groups/screens/create_group_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/notifications/screens/notifications_screen.dart';
import '../../features/legal/screens/privacy_policy_screen.dart';
import '../../features/legal/screens/terms_conditions_screen.dart';
import '../../features/legal/screens/child_safety_screen.dart';
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
      RouteConstants.groupSettings,
      RouteConstants.profile,
      RouteConstants.settings,
      RouteConstants.notifications,
      RouteConstants.editProfile,
    ];

    final notifier = _RouterNotifier(ref);

    return GoRouter(
      initialLocation: kIsWeb
          ? RouteConstants.landing
          : RouteConstants.login,
      refreshListenable: notifier,
      redirect: (context, state) {
        final user = ref.read(authProvider);
        final isLoggedIn = user != null;
        final location = state.matchedLocation;
        final groupIdSegments =
            (state.pathParameters['groupId'] ?? '').split('/');
        final isProtected = protectedRoutes.any(
          (r) => location.startsWith(r.split('/:').first) ||
                 (r == RouteConstants.groupDetail && groupIdSegments.isNotEmpty),
        );
        final isAuthRoute = location == RouteConstants.login ||
                            location == RouteConstants.signup;
        final isLanding = location == RouteConstants.landing;

        // Mobile/desktop app should skip landing and go to sign in.
        if (!kIsWeb && isLanding) { return RouteConstants.login; }
        // Protected routes require login
        if (!isLoggedIn && isProtected) { return RouteConstants.login; }
        // Auth routes redirect already-logged-in users to home
        if (isLoggedIn && isAuthRoute)  { return RouteConstants.home; }
        // '/' is the public landing page on web — never redirect it
        return null;
      },
      errorBuilder: (context, state) => Scaffold(
        appBar: AppBar(title: const Text('Page Not Found')),
        body: Center(child: Text('No route for: ${state.uri}')),
      ),
    routes: [
      // Landing Route (public marketing page)
      GoRoute(
        path: RouteConstants.landing,
        builder: (context, state) => const LandingScreen(),
      ),

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
          initialTab: int.tryParse(state.uri.queryParameters['tab'] ?? '') ?? 0,
        ),
      ),
      GoRoute(
        path: RouteConstants.groupSettings,
        builder: (context, state) => GroupSettingsScreen(
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
        path: RouteConstants.privacyPolicy,
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
      GoRoute(
        path: RouteConstants.termsConditions,
        builder: (context, state) => const TermsConditionsScreen(),
      ),
      GoRoute(
        path: RouteConstants.childSafety,
        builder: (context, state) => const ChildSafetyScreen(),
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
