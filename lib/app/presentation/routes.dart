import 'package:flutter/material.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/presentation/pages/login_pages/login_page.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/presentation/pages/main_menu_pages/main_menu_page.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/presentation/pages/notification_pages/notification_page.dart';

class AppRoutes {
  static const String login = '/login';
  static const String mainMenu = '/mainMenu';
  static const String notification = '/notification';

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => SafeArea(child: LoginPage()));
      case mainMenu:
        return MaterialPageRoute(
            builder: (_) => SafeArea(child: MainMenuPage()));
      case notification:
        return MaterialPageRoute(
            builder: (_) => SafeArea(child: NotificationPage()));
      default:
        return MaterialPageRoute(
            builder: (_) => SafeArea(
                  child: Scaffold(
                    body: Center(
                      child: Text('No route defined for ${settings.name}'),
                    ),
                  ),
                ));
    }
  }
}
