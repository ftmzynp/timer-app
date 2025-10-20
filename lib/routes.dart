import 'package:flutter/material.dart';
import 'package:timer/screens/general_rooms_screen.dart';
import 'package:timer/screens/pomodoro_screen.dart';
import 'package:timer/screens/profile-screen.dart';
import 'package:timer/screens/room_screen.dart';
import 'package:timer/screens/stats_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/setting_screen.dart';
import 'screens/login_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String rooms = '/rooms';
  static const String pomodoro = '/pomodoro';
  static const String room = '/room';
  static const String profile = '/profile';
  static const String stats = '/stats';
  static const String setting = '/settings';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const TimerHome());
      case pomodoro:
        return MaterialPageRoute(builder: (_) => const PomodoroScreen());
      case rooms:
        return MaterialPageRoute(builder: (_) => const GeneralRoomsScreen());
      case room:
        return MaterialPageRoute(builder: (_) => const RoomDashboardScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case stats:
        return MaterialPageRoute(builder: (_) => const StatsScreen());
      case setting:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text("Route not found")),
          ),
        );
    }
  }
}