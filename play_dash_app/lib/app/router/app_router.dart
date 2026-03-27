import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/cricket/presentation/cricket_game_page.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/x01/presentation/x01_game_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) => const HomePage(),
    ),
    GoRoute(
      path: '/setup',
      builder: (BuildContext context, GoRouterState state) =>
          const _PlaceholderScreen(title: 'Setup'),
    ),
    GoRoute(
      path: '/match/x01',
      builder: (BuildContext context, GoRouterState state) => const X01GamePage(),
    ),
    GoRoute(
      path: '/match/cricket',
      builder: (BuildContext context, GoRouterState state) =>
          const CricketGamePage(),
    ),
    GoRoute(
      path: '/settings',
      builder: (BuildContext context, GoRouterState state) =>
          const _PlaceholderScreen(title: 'Settings'),
    ),
  ],
);

class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const SizedBox.expand(),
    );
  }
}
