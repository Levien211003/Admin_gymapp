import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'screens/users_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/plan_screen.dart';
import 'screens/nutri_screen.dart';


final Map<String, WidgetBuilder> routes = {
  '/': (context) => DashboardScreen(),
  '/users': (context) => UsersScreen(),
  '/plans': (context) => PlanScreen(),  // Ví dụ
  '/nutris': (context) => NutriScreen(),  // Ví dụ
  '/settings': (context) => SettingsScreen(),  // Ví dụ

};
