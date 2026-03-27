import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/cricket/presentation/cricket_game_page.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/leaderboard/presentation/leaderboard_page.dart';
import '../../features/setup/presentation/setup_page.dart';
import '../../features/x01/presentation/x01_game_page.dart';
import '../../shared/widgets/app_shell.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        final shellConfig = _shellConfigForLocation(state.uri.path);
        return AppShell(
          expandChild: shellConfig.expandChild,
          mobileTopTabs: shellConfig.mobileTopTabs,
          child: child,
        );
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) =>
              const HomePage(),
        ),
        GoRoute(
          path: '/setup',
          builder: (BuildContext context, GoRouterState state) =>
              const SetupScreen(),
        ),
        GoRoute(
          path: '/leaderboard',
          builder: (BuildContext context, GoRouterState state) =>
              const LeaderboardScreen(),
        ),
        GoRoute(
          path: '/match/x01',
          builder: (BuildContext context, GoRouterState state) =>
              const X01GamePage(),
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
    ),
  ],
);

_ShellConfig _shellConfigForLocation(String location) {
  switch (location) {
    case '/setup':
      return const _ShellConfig(
        expandChild: true,
        mobileTopTabs: <ShellTab>[
          ShellTab(label: 'Setup', route: '/setup'),
          ShellTab(label: 'Game', route: '/match/x01'),
          ShellTab(label: 'Scores', route: '/leaderboard'),
        ],
      );
    case '/leaderboard':
      return const _ShellConfig(
        expandChild: true,
        mobileTopTabs: <ShellTab>[
          ShellTab(label: 'Home', route: '/'),
          ShellTab(label: 'Trofies', route: '/leaderboard'),
          ShellTab(label: 'Stats', route: '/leaderboard'),
        ],
      );
    case '/match/x01':
      return const _ShellConfig(
        expandChild: true,
        mobileTopTabs: <ShellTab>[
          ShellTab(label: 'Score', route: '/match/x01'),
          ShellTab(label: 'Header', route: '/setup'),
          ShellTab(label: 'Single', route: '/match/x01'),
        ],
      );
    case '/match/cricket':
      return const _ShellConfig(
        expandChild: true,
        mobileTopTabs: <ShellTab>[
          ShellTab(label: 'Cricket', route: '/match/cricket'),
          ShellTab(label: 'Setup', route: '/setup'),
          ShellTab(label: 'Stats', route: '/leaderboard'),
        ],
      );
    case '/settings':
      return const _ShellConfig(expandChild: false);
    case '/':
    default:
      return const _ShellConfig(
        expandChild: true,
        mobileTopTabs: <ShellTab>[
          ShellTab(label: 'Home', route: '/'),
          ShellTab(label: 'Account', route: '/leaderboard'),
          ShellTab(label: 'Stats', route: '/leaderboard'),
          ShellTab(label: 'Voice', route: '/settings'),
        ],
      );
  }
}

class _ShellConfig {
  const _ShellConfig({required this.expandChild, this.mobileTopTabs});

  final bool expandChild;
  final List<ShellTab>? mobileTopTabs;
}

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
