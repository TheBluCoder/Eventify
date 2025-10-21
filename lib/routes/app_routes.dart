/// Application routing configuration
class AppRoutes {
  // Route names
  static const String home = '/home';
  static const String discover = '/discover';
  static const String notifications = '/notifications';
  static const String profile = '/profile';
  static const String createEvent = '/create-event';
  
  // Route paths
  static const Map<String, String> routes = {
    'home': home,
    'discover': discover,
    'notifications': notifications,
    'profile': profile,
    'createEvent': createEvent,
  };
}
