/// Route name constants for GoRouter navigation
class RouteConstants {
  // Private constructor to prevent instantiation
  RouteConstants._();

  // Authentication routes
  static const String login = '/login';
  static const String signup = '/signup';
  static const String emailVerification = '/email-verification';

  // Main app routes (with bottom navigation)
  static const String home = '/home';
  static const String discover = '/discover';
  static const String groups = '/groups';
  static const String profile = '/profile';
  static const String settings = '/settings';

  // Nested routes
  static const String groupDetail = '/groups/:groupId';
  static const String createGroup = '/groups/create';
  static const String editProfile = '/profile/edit';
  static const String availabilityCalendar = '/profile/availability';
  static const String sessionSchedule = '/sessions/schedule';
  static const String matchDetail = '/discover/:matchId';
}
