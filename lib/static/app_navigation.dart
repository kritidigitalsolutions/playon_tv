import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppNavigation {
  AppNavigation._();

  static void go(BuildContext context, String route, {Object? extra}) {
    context.go(route, extra: extra);
  }

  static Future<T?> push<T extends Object?>(
    BuildContext context,
    String route, {
    Object? extra,
  }) {
    return context.push<T>(route, extra: extra);
  }

  static void pushReplacement(
    BuildContext context,
    String route, {
    Object? extra,
  }) {
    context.pushReplacement(route, extra: extra);
  }

  static void replace(BuildContext context, String route, {Object? extra}) {
    context.replace(route, extra: extra);
  }

  static void pop(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    }
  }
}
