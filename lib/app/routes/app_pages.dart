import 'package:get/get.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

import '../modules/welcome/bindings/welcome_binding.dart';
import '../modules/welcome/views/welcome_view.dart';
import '../modules/login/bindings/login_binding.dart'; // Import login bindings
import '../modules/login/views/login_view.dart'; // Import login view
import '../modules/registration/bindings/registration_binding.dart'; // Import registration bindings
import '../modules/registration/views/registration_view.dart'; // Import registration view


part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.WELCOME,
      page: () => const WelcomeView(),
      binding: WelcomeBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),

    GetPage(
      name: _Paths.LOGIN, 
      page: () => LoginPage(), 
      binding: LoginBinding(), 
    ),
    GetPage(
      name: _Paths.REGISTRATION, 
      page: () => RegistrationPage(), 
      binding: RegistrationBinding(), 
    ),

  ];
}
