import 'package:fixmate/core/routes/app_routes.dart';
import 'package:fixmate/modules/addComplaint/binding.dart';
import 'package:fixmate/modules/addComplaint/view/add_complaint_page.dart';
import 'package:fixmate/modules/auth/binding.dart';
import 'package:fixmate/modules/auth/view/login_screen.dart';
import 'package:fixmate/modules/home/binding.dart';
import 'package:fixmate/modules/home/view/home_screen.dart';
import 'package:fixmate/modules/onboarding/binding.dart';
import 'package:fixmate/modules/onboarding/view/onboarding.dart';
import 'package:fixmate/modules/request/binding.dart';
import 'package:fixmate/modules/request/view/request_active_page.dart';
import 'package:get/get.dart';
import 'package:fixmate/modules/splash/view/splash_screen.dart';
import 'package:fixmate/modules/splash/binding.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.onboardingScreen,
      page: () => const OnboardingScreen(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.addComplaint,
      page: () => const AddComplaintPage(),
      binding: AddComplaintBinding(),
    ),
    GetPage(
      name: AppRoutes.requestActive,
      page: () => const RequestActivePage(),
      binding: RequestBinding(),
    ),
  ];
}
