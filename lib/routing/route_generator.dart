import 'package:flutter/material.dart';
import 'package:whollet/routing/routes.dart';
import 'package:whollet/ui/create_pin_screen.dart';
import 'package:whollet/ui/enter_pin_screen.dart';
import 'package:whollet/ui/home_screen/home_screen.dart';
import 'package:whollet/ui/login_screen.dart';
import 'package:whollet/ui/onboarding_screen/onboarding_screen.dart';
import 'package:whollet/ui/sign_up_screen.dart';
import 'package:whollet/ui/welcome_screen.dart';
import 'package:whollet/utils/exceptions/route_exception.dart';

class RouteGenerator {
  static RouteGenerator? _instance;

  RouteGenerator._();

  factory RouteGenerator() {
    _instance ??= RouteGenerator._();
    return _instance!;
  }

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // case Routes.homeRoute:
      //   return MaterialPageRoute(builder: (_) => MyHomePage());
      case Routes.welcomeRoute:
        return MaterialPageRoute(builder: (_) => WelcomeScreen());
      case Routes.onboardingRoute:
        return MaterialPageRoute(builder: (_) => OnboardingScreen());
      case Routes.loginRoute:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case Routes.signUpRoute:
        return MaterialPageRoute(builder: (_) => SignUpScreen());
      case Routes.enterPinRoute:
        return MaterialPageRoute(builder: (_) => EnterPinScreen());
      case Routes.createPinRoute:
        return MaterialPageRoute(builder: (_) => CreatePinScreen());
      case Routes.homeRoute:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      default:
        throw RouteException("Route not found");
    }
  }
}
