/// Route name constants for GoRouter navigation
class RouteConstants {
  // Private constructor to prevent instantiation
  RouteConstants._();

  // Authentication routes
  static const String login    = '/login';
  static const String signup   = '/signup';
  static const String onboarding      = '/onboarding';
  static const String profileComplete = '/profile-complete';
  static const String emailVerification = '/email-verification';

  // Main app routes (with bottom navigation)
  static const String home = '/home';
  static const String discover = '/discover';
  static const String groups = '/groups';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String notifications = '/notifications';

  // Nested routes
  static const String groupDetail = '/groups/:groupId';
  static const String createGroup = '/groups/create';
  static const String groupSettings = '/groups/:groupId/settings';
  static const String editProfile = '/profile/edit';
  static const String availabilityCalendar = '/profile/availability';
  static const String sessionSchedule = '/sessions/schedule';
  static const String matchDetail = '/discover/:matchId';

  // Helper methods for parameterized routes
  static String groupDetailPath(String groupId) => '/groups/$groupId';
  static String groupDetailPathWithTab(String groupId, int tab) => '/groups/$groupId?tab=$tab';
  static String groupSettingsPath(String groupId) => '/groups/$groupId/settings';
  static String matchDetailPath(String matchId) => '/discover/$matchId';
}
