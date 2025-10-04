import 'package:flutter/material.dart';
import 'package:interview/screens/intro_page.dart';
import 'package:interview/screens/profile_screen.dart';
import 'package:path/path.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/dashboard_screen.dart';

final Map<String, WidgetBuilder> routes = {
  '/login': (context) => LoginScreen(),
  '/signup': (context) => SignupScreen(),
  '/dashboard': (context) => DashboardScreen(),
  '/profile': (context) => ProfileScreen(),
  '/': (context) => IntroScreen(),
};
