import 'package:expenses/screens/add_expenses.dart';
import 'package:flutter/material.dart';

class RoutesGenerator {
  static Route<dynamic>? routeProvider(RouteSettings settings) {
    switch (settings.name) {
      case '/addExpenses':
        return MaterialPageRoute(builder: (_) => AddExpenses());
    }
    return null;
  }
}
