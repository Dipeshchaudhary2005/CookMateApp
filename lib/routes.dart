import 'package:cookmate/Frontend/landingpage.dart';
import 'package:cookmate/Frontend/splashpage.dart';
import 'package:cookmate/chef/chefdashboard.dart';
import 'package:cookmate/customer/customerdashboard.dart';

class AppRoutes {
  AppRoutes._();
  static String customerDashboardRoute = "/customerDashboard";
  static String chefDashboardRoute = "/chefDashboard";
  static String splashScreenRoute = "/";
  static String landingPageRoute = '/landingPage';

  static dynamic getAppRoutes() => {
    splashScreenRoute : (context) => const SplashPage(),
    customerDashboardRoute : (context) => const CustomerDashboard(),
    chefDashboardRoute : (context) => const ChefDashboard(),
    landingPageRoute : (context) => const LandingPage()
  };
}