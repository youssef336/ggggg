import 'package:flutter/material.dart';
import 'package:test/features/home/presentation/views/home_view.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case HomeView.routeName:
      return MaterialPageRoute(builder: (_) => const HomeView());

    default:
      return MaterialPageRoute(
        builder: (_) =>
            const Scaffold(body: Center(child: Text('404 Not Found'))),
      );
  }
}
