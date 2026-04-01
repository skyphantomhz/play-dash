import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/cricket/presentation/cricket_game_page.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/leaderboard/presentation/leaderboard_page.dart';
import '../../features/settings/presentation/settings_page.dart';
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
final GlobalKey<NavigatorState> _settingsNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'settingsBranch');

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: <RouteBase>[
    StatefulShellRoute.indexedStack(
      builder: (BuildContext context, GoRouterState state,
              StatefulNavigationShell navigationShell) =>
          RootAppShell(navigationShell: navigationShell),
      branches: <StatefulShellBranch>[
        // Branch 0 – Home
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
        // Branch 1 – Leaderboard
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
        // Branch 2 – Setup (with nested game routes)
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
          ],
        ),
        // Branch 3 – Settings
        StatefulShellBranch(
          navigatorKey: _settingsNavigatorKey,
          routes: <RouteBase>[
            GoRoute(
              path: '/settings',
              builder: (BuildContext context, GoRouterState state) =>
                  const SettingsPage(),
            ),
          ],
        ),
      ],
    ),
  ],
);
