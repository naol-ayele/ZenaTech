class ApiConstants {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.58.117.161:3000/v1',
  );
  static const String articles = '/articles';
  static const String categories = '/categories';
  static const String search = '/search';
  static const String trending = '/articles/trending';
  static const String trackInterest = '/users/track-interest';
  static const String subscribeNotifications = '/notifications/subscribe';
  static const String unsubscribeNotifications = '/notifications/unsubscribe';
  static const int defaultPageSize = 20;
  static const int connectionTimeout = 5000;
  static const int receiveTimeout = 5000;
}

class AppConstants {
  static const String appName = 'TechPulse';
  static const String appVersion = '1.0.0';
  static const String favoritesBox = 'favorites_box';
  static const String searchHistoryBox = 'search_history_box';
  static const String settingsBox = 'settings_box';
  static const int maxSearchHistory = 10;
}
