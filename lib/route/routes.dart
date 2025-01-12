import '../ImportAll.dart';

class AppRoutes {
  // Route Constants for easy reference throughout the app
  static const String authCheck = '/authCheck';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String verify = '/verify';
  static const String mainNavigationPage = 'mainNavigationPage';
  static const String scanCodePage = '/scanCodePage';

  // Function to get the route map
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      authCheck: (context) => AuthWrapper(),
      login: (context) => LoginPage(),
      signup: (context) => SignupPage(),
      verify: (context) => VerificationPage(),
      mainNavigationPage: (context) => NavigationPage(),
      scanCodePage: (context) => ScanCodePage(),
    };
  }
}
