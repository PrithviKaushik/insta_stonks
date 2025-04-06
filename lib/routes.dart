import 'package:insta_stonks/screens/screens.dart';

var appRoutes = {
  '/': (context) => AuthWrapper(),
  '/signup': (context) => SignUpScreen(),
  '/signin': (context) => SignInScreen(),
  '/dashboard': (context) => DashboardScreen(),
  '/analytics': (context) => AnalyticsScreen(),
};
