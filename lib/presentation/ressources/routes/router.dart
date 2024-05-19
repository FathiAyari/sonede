import 'package:flutter/material.dart';
import 'package:umbrella/presentation/Authentication/Sign_in/sign_in.dart';
import 'package:umbrella/presentation/Authentication/Sign_up/signup.dart';
import 'package:umbrella/presentation/Splash_screen/splashscreen.dart';
import 'package:umbrella/presentation/admin/home_admin.dart';
import 'package:umbrella/presentation/client/home_client.dart';
import 'package:umbrella/presentation/deleted_account/deleted_account.dart';
import 'package:umbrella/presentation/on_boarding/on_boarding_page.dart';

class AppRouting {
  static final String splashScreen = "/";
  static final String login = "/login";
  static final String register = "/register";
  static final String onboarding = "/onboarding";
  static final String homeClient = "/home_client";
  static final String homeAdmin = "/home_admin";
  static final String deletedAccount = "/deleted_account";
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => SignInScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => SignupScreen());

      case '/onboarding':
        return MaterialPageRoute(builder: (_) => OnBoardingPage());
      case '/home_client':
        return MaterialPageRoute(builder: (_) => HomeClient());
      case '/home_admin':
        return MaterialPageRoute(builder: (_) => HomeAdmin());

      case '/deleted_account':
        return MaterialPageRoute(builder: (_) => DeletedAccount());

      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
