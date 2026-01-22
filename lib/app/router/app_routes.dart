class AppRoutes {
  static const String splash = '/splash';
  static const String forceUpdate = '/force-update';
  static const String onboarding = '/onboarding';
  static const String home = '/';
  static const String recipes = '/recipes';
  static const String favorites = '/favorites';
  static const String kitchen = '/kitchen';
  static const String settings = '/settings';
  static const String credits = '/credits';
  static const String feedback = '/feedback';

  static String recipeById(int id) => '/recipe/$id';
}
