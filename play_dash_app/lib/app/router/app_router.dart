import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/cricket/presentation/cricket_game_page.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/leaderboard/presentation/leaderboard_page.dart';
import '../../features/setup/presentation/setup_page.dart';
import '../../features/x01/presentation/x01_game_page.dart';
import '../../shared/widgets/app_shell.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _homeNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'homeBranch');
final GlobalKey<NavigatorState> _leaderboardNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'leaderboardBranch');
final GlobalKey<NavigatorState> _setupNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'setupBranch');

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: <RouteBase>[
    StatefulShellRoute.indexedStack(
      builder: (BuildContext context, GoRouterState state,
              StatefulNavigationShell navigationShell) =>
          RootAppShell(navigationShell: navigationShell),
      branches: <StatefulShellBranch>[
        StatefulShellBranch(
          navigatorKey: _homeNavigatorKey,
          routes: <RouteBase>[
            GoRoute(
              path: '/',
              builder: (BuildContext context, GoRouterState state) =>
                  const HomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _leaderboardNavigatorKey,
          routes: <RouteBase>[
            GoRoute(
              path: '/leaderboard',
              builder: (BuildContext context, GoRouterState state) =>
                  const LeaderboardScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _setupNavigatorKey,
          routes: <RouteBase>[
            GoRoute(
              path: '/setup',
              builder: (BuildContext context, GoRouterState state) =>
                  const SetupScreen(),
              routes: <RouteBase>[
                GoRoute(
                  path: 'match/x01',
                  builder: (BuildContext context, GoRouterState state) =>
                      const X01GamePage(),
                ),
                GoRoute(
                  path: 'match/cricket',
                  builder: (BuildContext context, GoRouterState state) =>
                      const CricketGamePage(),
                ),
                GoRoute(
                  path: 'settings',
                  builder: (BuildContext context, GoRouterState state) =>
                      const _PlaceholderScreen(title: 'Settings'),
                ),
              ],
            ),
            GoRoute(
              path: '/match/x01',
              redirect: (_, __) => '/setup/match/x01',
            ),
            GoRoute(
              path: '/match/cricket',
              redirect: (_, __) => '/setup/match/cricket',
            ),
            GoRoute(
              path: '/settings',
              redirect: (_, __) => '/setup/settings',
            ),
          ],
        ),
      ],
    ),
  ],
);

class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: Text(title)),
      body: const SizedBox.expand(),
    );
  }
}
